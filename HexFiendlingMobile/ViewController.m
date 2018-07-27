//
//  ViewController.m
//  HexFiendlingMobile
//
//  Created by Kevin Wojniak on 7/8/18.
//  Copyright © 2018 ridiculous_fish. All rights reserved.
//

#import "ViewController.h"
#import <HexFiend/HexFiend.h>

@interface ViewController ()

@property HFController *inMemoryController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpInMemoryHexView];
}

- (void)setUpInMemoryHexView {
    /* Get some random data to display */
    const unsigned int dataSize = 1024;
    NSMutableData *data = [NSMutableData dataWithLength:dataSize];
    int fd = open("/dev/random", O_RDONLY);
    read(fd, [data mutableBytes], dataSize);
    close(fd);
    
    /* Make a controller to hook everything up, and then configure it a bit. */
    self.inMemoryController = [[HFController alloc] init];
    [self.inMemoryController setBytesPerColumn:4];
    
    /* Put that data in a byte slice.  Here we use initWithData:, which causes the byte slice to take ownership of the data (and may modify it).  If we want to prevent our data from being modified, we would use initWithUnsharedData: */
    HFSharedMemoryByteSlice *byteSlice = [[HFSharedMemoryByteSlice alloc] initWithData:data];
    HFByteArray *byteArray = [[HFBTreeByteArray alloc] init];
    [byteArray insertByteSlice:byteSlice inRange:HFRangeMake(0, 0)];
    [self.inMemoryController setByteArray:byteArray];
    
    /* Make an HFHexTextRepresenter. */
    HFHexTextRepresenter *hexRep = [[HFHexTextRepresenter alloc] init];
    [self.inMemoryController addRepresenter:hexRep];
    
    /* Grab its view and stick it into our container. */
    UIView *containerView = self.view;
    UIView *hexView = [hexRep view];
    //hexView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    hexView.frame = CGRectInset(containerView.bounds, 20, 20);
    hexView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    hexView.translatesAutoresizingMaskIntoConstraints = YES;
    [containerView addSubview:hexView];
}

@end
