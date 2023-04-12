Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF56DF569
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 14:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjDLMfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 08:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjDLMfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 08:35:39 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 5FDB7173D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 05:35:28 -0700 (PDT)
Received: (qmail 209998 invoked by uid 1000); 12 Apr 2023 08:35:27 -0400
Date:   Wed, 12 Apr 2023 08:35:27 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Jimmy Hu <hhhuuu@google.com>
Cc:     gregkh@linuxfoundation.org, badhri@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: core: hub: Disable autosuspend for VIA VL813 USB3.0
 hub
Message-ID: <03d20937-5c45-4b0a-930d-44d3f7245c6e@rowland.harvard.edu>
References: <20230411083145.2214105-1-hhhuuu@google.com>
 <ce727a7b-6954-4e4d-85c7-f91011b87108@rowland.harvard.edu>
 <CAJh=zj+sVjmLAnY8pXWKbuhVsYStv3Ei5C6KqyugwURd8B-0wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJh=zj+sVjmLAnY8pXWKbuhVsYStv3Ei5C6KqyugwURd8B-0wA@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 09:55:02AM +0800, Jimmy Hu wrote:
> On Tue, Apr 11, 2023 at 9:55 PM Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > On Tue, Apr 11, 2023 at 08:31:45AM +0000, Jimmy Hu wrote:
> > > The VIA VL813 USB3.0 hub appears to have an issue with autosuspend and
> > > detecting USB3 devices. This can be reproduced by connecting a USB3
> > > device to the hub after the hub enters autosuspend mode.
> > >
> > > //connect the hub
> > > [  106.854204] usb 2-1: new SuperSpeed Gen 1 USB device number 2 using xhci-hcd
> > > [  107.084993] usb 2-1: New USB device found, idVendor=2109, idProduct=0813, bcdDevice=90.15
> > > [  107.094520] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > > [  107.111836] usb 2-1: Product: USB3.0 Hub
> > > [  107.116835] usb 2-1: Manufacturer: VIA Labs, Inc.
> > > [  107.314230] hub 2-1:1.0: USB hub found
> > > [  107.321356] hub 2-1:1.0: 4 ports detected
> > >
> > > //the hub enters autosuspend mode
> > > [  107.738873] hub 2-1:1.0: hub_suspend
> > > [  107.922097] usb 2-1: usb auto-suspend, wakeup 1
> > >
> > > //connect a USB3 device
> > > [  133.120060] usb 2-1: usb wakeup-resume
> > > [  133.160033] usb 2-1: Waited 0ms for CONNECT
> > > [  133.165423] usb 2-1: finish resume
> > > [  133.176919] hub 2-1:1.0: hub_resume
> > > [  133.188026] usb 2-1-port3: status 0263 change 0041
> > > [  133.323585] hub 2-1:1.0: state 7 ports 4 chg 0008 evt 0008
> > > [  133.342423] usb 2-1-port3: link state change
> > > [  133.358154] usb 2-1-port3: status 0263, change 0040, 5.0 Gb/s
> >
> > This status value indicates that the port is in the U3 suspend state.
> > Maybe the port needs to be put back into U0 before it can be reset.
> >
> > > [  133.875150] usb 2-1-port3: not reset yet, waiting 10ms
> > > [  133.895502] usb 2-1-port3: not reset yet, waiting 10ms
> > > [  133.918239] usb 2-1-port3: not reset yet, waiting 200ms
> > > [  134.139529] usb 2-1-port3: not reset yet, waiting 200ms
> > > [  134.365296] usb 2-1-port3: not reset yet, waiting 200ms
> > > [  134.590185] usb 2-1-port3: not reset yet, waiting 200ms
> > > [  134.641330] hub 2-1:1.0: state 7 ports 4 chg 0000 evt 0008
> > > [  134.658880] hub 2-1:1.0: hub_suspend
> > > [  134.792908] usb 2-1: usb auto-suspend, wakeup 1
> > >
> > > Disabling autosuspend for this hub resolves the issue.
> >
> > It may be possible to fix the problem.  You should try that before
> > giving up.
> >
> > Alan Stern
> 
> [  133.120060] usb 2-1: usb wakeup-resume
> [  133.160033] usb 2-1: Waited 0ms for CONNECT
> [  133.165423] usb 2-1: finish resume
> [  133.176919] hub 2-1:1.0: hub_resume
> When a USB3 device is connected to the hub,  it did finish the resume
> and should be put back into U0, but it seems to have failed.

Those messages mean the hub's upstream port (the port on the hub which 
connects to the computer) is back in U0.  But I was talking about the 
downstream port (the port on the hub which connects to the device that 
was just plugged in).  That port is in U3.

Alan Stern
