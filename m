Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065FB50B1B7
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 09:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345405AbiDVHjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbiDVHjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 03:39:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9EC5133A;
        Fri, 22 Apr 2022 00:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E136BB82ABF;
        Fri, 22 Apr 2022 07:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D39C385A0;
        Fri, 22 Apr 2022 07:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650613019;
        bh=/UjuOtx9fL0nf2WxyJQGshyyvuSlNPOux43de6wbbNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/9iyE+zfp6xwVYLA485y+zz3vvb9m50NtEtqvvOHdtmk1Nk/oLzPt5Tu1nAaO7xD
         zPD+jz0GmkAb+Lh1EpAapRE0hegNBpuNBiLIVk2dimikjwyGoovqOxUaQgPO0UsTON
         fWf0GM8AEFXXoMW77Y8pvYmMwEJC67FjKMBXKK84=
Date:   Fri, 22 Apr 2022 09:36:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hongyu Xie <xy521521@gmail.com>
Cc:     johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hongyu Xie <xiehongyu1@kylinos.cn>,
        stable@vger.kernel.org, "sheng . huang" <sheng.huang@ecastech.com>,
        wangqi@kylinos.cn, xiongxin@kylinos.cn
Subject: Re: [RESEND PATCH -next] USB: serial: pl2303: implement reset_resume
 member
Message-ID: <YmJbGDpon91iQol2@kroah.com>
References: <20220419065408.2461091-1-xy521521@gmail.com>
 <YmGKL05dnA+q/HAM@kroah.com>
 <f3f6ea7d-2051-7a7f-61e0-8a5bba8ca8f2@gmail.com>
 <YmI4I9MCLBheMyvr@kroah.com>
 <99546b13-44f1-3dbf-aeb4-86c76ce74626@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99546b13-44f1-3dbf-aeb4-86c76ce74626@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 22, 2022 at 02:42:41PM +0800, Hongyu Xie wrote:
> 
> Hi greg
> On 2022/4/22 13:07, Greg KH wrote:
> > On Fri, Apr 22, 2022 at 10:35:59AM +0800, Hongyu Xie wrote:
> > > 
> > > Hi greg,
> > > On 2022/4/22 00:45, Greg KH wrote:
> > > > On Tue, Apr 19, 2022 at 02:54:08PM +0800, Hongyu Xie wrote:
> > > > > From: Hongyu Xie <xiehongyu1@kylinos.cn>
> > > > > 
> > > > > pl2303.c doesn't have reset_resume for hibernation.
> > > > > So needs_binding will be set to 1 duiring hibernation.
> > > > > usb_forced_unbind_intf will be called, and the port minor
> > > > > will be released (x in ttyUSBx).
> > > > 
> > > > Please use the full 72 columns that you are allowed in a changelog text.
> > > > 
> > > > 
> > > > > It works fine if you have only one USB-to-serial device.
> > > > > Assume you have 2 USB-to-serial device, nameing A and B.
> > > > > A gets a smaller minor(ttyUSB0), B gets a bigger one.
> > > > > And start to hibernate. When your PC is in hibernation,
> > > > > unplug device A. Then wake up your PC by pressing the
> > > > > power button. After waking up the whole system, device
> > > > > B gets ttyUSB0. This will casuse a problem if you were
> > > > > using those to ports(like opened two minicom process)
> > > > > before hibernation.
> > > > > So member reset_resume is needed in usb_serial_driver
> > > > > pl2303_device.
> > > > 
> > > > If you want persistent device naming, use the symlinks that udev creates
> > > > for your for all your serial devices.  Never rely on the number of a USB
> > > > to serial device.
> > > Let me put it this way. Assume you need to record messages output from two
> > > machines using 2 USB-to-serial devices(naming A and B, and A is on
> > > USB1-port3, B is on USB1-port4) opened by two minicom process.
> > > The setting for A in minicom would be like:
> > > 	"A -    Serial Device      : /dev/ttyUSB0"
> > > The setting for B in minicom would be like:
> > > 	"A -    Serial Device      : /dev/ttyUSB1"
> > > Then start to hibernate on your computer. When your PC is in
> > > hibernation, unplug A. After waking up your computer, "/dev/ttyUSB0"
> > > would be released first, then allocated to B. The minicom process used
> > > to record outputs from A is now recording B's outputs. The minicom
> > > process used to record outputs from B is now recording nothing, because
> > > "/dev/ttyUSB1" is not exist anymore. That's the problem I've been
> > > talking about. And I don't think using symlinks will solve this problem.
> > 
> > Yes, symlinks will solve the issue, that is what they are there for.
> > Look in /dev/serial/ for a persistent name for them that allows you to
> > uniquely open the correct device if they can be described.  Using
> > /dev/ttyUSBX is almost never the correct thing to do.
> Thanks for letting me know this. This patch is useless.

It's not useless, I'm just saying that you should not be relying on
ttyUSBX nodes to ever be persistent.

> I still have one
> more question though, since using /dev/ttyUSBX is almost never the correct
> thing to do, what is /dev/ttyUSBx used for then?

That is the name that the kernel gives them, as it has to pick
something.  Same for all kernel device names, the persistence rules live
in userspace, not in the kernel.

Now if this is a valid feature or not for the driver that's a totally
different question that I will let Johan review.  I was just pointing
out a way for you to resolve your issue today without any kernel changes
needed at all.

thanks,

greg k-h
