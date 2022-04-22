Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E3950AF5F
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 07:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444052AbiDVFKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 01:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444081AbiDVFKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 01:10:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB534EF7D;
        Thu, 21 Apr 2022 22:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E5F61D5C;
        Fri, 22 Apr 2022 05:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4E4C385A0;
        Fri, 22 Apr 2022 05:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650604073;
        bh=vzfRtV+6HmzAXkT9LkEyK6PRF7OjBvpXGEf/vM7UJSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GAHDADhNIu3VnJP6g4TTNtQ0FfdlnND7LMl7VptMN7R2INA3nx+7WA3NECywDHWfz
         9xRCC1kbenIolxN8xv5PXbDuDllk5jVcic/bI0v57FQ2gD1ke30Pv26tm4A1632yzY
         EotT7UrnlRuw81WHUt0RlJ3vSyFl4RvWfdpXq/+g=
Date:   Fri, 22 Apr 2022 07:07:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hongyu Xie <xy521521@gmail.com>
Cc:     johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hongyu Xie <xiehongyu1@kylinos.cn>,
        stable@vger.kernel.org, "sheng . huang" <sheng.huang@ecastech.com>,
        wangqi@kylinos.cn, xiongxin@kylinos.cn
Subject: Re: [RESEND PATCH -next] USB: serial: pl2303: implement reset_resume
 member
Message-ID: <YmI4I9MCLBheMyvr@kroah.com>
References: <20220419065408.2461091-1-xy521521@gmail.com>
 <YmGKL05dnA+q/HAM@kroah.com>
 <f3f6ea7d-2051-7a7f-61e0-8a5bba8ca8f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3f6ea7d-2051-7a7f-61e0-8a5bba8ca8f2@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 22, 2022 at 10:35:59AM +0800, Hongyu Xie wrote:
> 
> Hi greg,
> On 2022/4/22 00:45, Greg KH wrote:
> > On Tue, Apr 19, 2022 at 02:54:08PM +0800, Hongyu Xie wrote:
> > > From: Hongyu Xie <xiehongyu1@kylinos.cn>
> > > 
> > > pl2303.c doesn't have reset_resume for hibernation.
> > > So needs_binding will be set to 1 duiring hibernation.
> > > usb_forced_unbind_intf will be called, and the port minor
> > > will be released (x in ttyUSBx).
> > 
> > Please use the full 72 columns that you are allowed in a changelog text.
> > 
> > 
> > > It works fine if you have only one USB-to-serial device.
> > > Assume you have 2 USB-to-serial device, nameing A and B.
> > > A gets a smaller minor(ttyUSB0), B gets a bigger one.
> > > And start to hibernate. When your PC is in hibernation,
> > > unplug device A. Then wake up your PC by pressing the
> > > power button. After waking up the whole system, device
> > > B gets ttyUSB0. This will casuse a problem if you were
> > > using those to ports(like opened two minicom process)
> > > before hibernation.
> > > So member reset_resume is needed in usb_serial_driver
> > > pl2303_device.
> > 
> > If you want persistent device naming, use the symlinks that udev creates
> > for your for all your serial devices.  Never rely on the number of a USB
> > to serial device.
> Let me put it this way. Assume you need to record messages output from two
> machines using 2 USB-to-serial devices(naming A and B, and A is on
> USB1-port3, B is on USB1-port4) opened by two minicom process.
> The setting for A in minicom would be like:
> 	"A -    Serial Device      : /dev/ttyUSB0"
> The setting for B in minicom would be like:
> 	"A -    Serial Device      : /dev/ttyUSB1"
> Then start to hibernate on your computer. When your PC is in
> hibernation, unplug A. After waking up your computer, "/dev/ttyUSB0"
> would be released first, then allocated to B. The minicom process used
> to record outputs from A is now recording B's outputs. The minicom
> process used to record outputs from B is now recording nothing, because
> "/dev/ttyUSB1" is not exist anymore. That's the problem I've been
> talking about. And I don't think using symlinks will solve this problem.

Yes, symlinks will solve the issue, that is what they are there for.
Look in /dev/serial/ for a persistent name for them that allows you to
uniquely open the correct device if they can be described.  Using
/dev/ttyUSBX is almost never the correct thing to do.

> > > Codes in pl2303_reset_resume are borrowed from pl2303_open.
> > > 
> > > As a matter of fact, all driver under drivers/usb/serial
> > > has the same problem except ch341.c.
> > > 
> > > Cc: stable@vger.kernel.org
> > 
> > How does this meet the stable kernel rule requirements?  It would be a
> > new feature if it were accepted, right?
> It's not a new feature at all. struct usb_serial_driver already has a
> member name reset_resume, there is no implementation in pl2303.c yet.
> And ch341.c has one(ch341_reset_resume()), that why I said "all driver
> under drivers/usb/serial has the same problem except ch341.c"

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for what is valid stable kernel changes.

thanks,

greg k-h
