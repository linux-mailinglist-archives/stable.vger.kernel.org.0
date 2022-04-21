Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E5B50A618
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiDUQsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiDUQsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4494D286E0;
        Thu, 21 Apr 2022 09:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEE29B8277F;
        Thu, 21 Apr 2022 16:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B34C385A1;
        Thu, 21 Apr 2022 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650559538;
        bh=iJit4IZbsdLEoDo/5VF9pWmAB4FyRHiRZ/6OCKLI55U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=McKkPBDYwMTVmBlisTWJhJEh6+NmGKke8WENkF2FvuD8fqbTs5RkhwKHJRBVCeZbH
         LcbVuTLrtbb/4YQ6xGZg7HWboiCa32Mnrp7cmhjxDKrL3fqhuNT0qkViEAlu54bEox
         2oqkt3x7eDcC+4lBg622olUQQyFCHthDRmB27obU=
Date:   Thu, 21 Apr 2022 18:45:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hongyu Xie <xy521521@gmail.com>
Cc:     johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hongyu Xie <xiehongyu1@kylinos.cn>,
        stable@vger.kernel.org, "sheng . huang" <sheng.huang@ecastech.com>
Subject: Re: [RESEND PATCH -next] USB: serial: pl2303: implement reset_resume
 member
Message-ID: <YmGKL05dnA+q/HAM@kroah.com>
References: <20220419065408.2461091-1-xy521521@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419065408.2461091-1-xy521521@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 02:54:08PM +0800, Hongyu Xie wrote:
> From: Hongyu Xie <xiehongyu1@kylinos.cn>
> 
> pl2303.c doesn't have reset_resume for hibernation.
> So needs_binding will be set to 1 duiring hibernation.
> usb_forced_unbind_intf will be called, and the port minor
> will be released (x in ttyUSBx).

Please use the full 72 columns that you are allowed in a changelog text.


> It works fine if you have only one USB-to-serial device.
> Assume you have 2 USB-to-serial device, nameing A and B.
> A gets a smaller minor(ttyUSB0), B gets a bigger one.
> And start to hibernate. When your PC is in hibernation,
> unplug device A. Then wake up your PC by pressing the
> power button. After waking up the whole system, device
> B gets ttyUSB0. This will casuse a problem if you were
> using those to ports(like opened two minicom process)
> before hibernation.
> So member reset_resume is needed in usb_serial_driver
> pl2303_device.

If you want persistent device naming, use the symlinks that udev creates
for your for all your serial devices.  Never rely on the number of a USB
to serial device.

> Codes in pl2303_reset_resume are borrowed from pl2303_open.
> 
> As a matter of fact, all driver under drivers/usb/serial
> has the same problem except ch341.c.
> 
> Cc: stable@vger.kernel.org

How does this meet the stable kernel rule requirements?  It would be a
new feature if it were accepted, right?


thanks,

greg k-h
