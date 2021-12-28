Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C524808FB
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 13:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhL1MLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 07:11:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58290 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhL1MLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 07:11:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 058AF611CA
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 12:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52DCC36AE7;
        Tue, 28 Dec 2021 12:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640693504;
        bh=4bwd16o50NPnijm6vEgnLq16LhP1YtIdnMMSJIuM1jI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PYNy8nxPoyMS3C5BrwAK7ude/XHOw/+hAOpgRMDQru/KElnD4yjDJysCdAE/W/FUq
         badJyZoD90rcGSHTxfDtaxheN4sXYTVykjn9Zf2RNDwMd+ahnrCzKt9hHbbloztkR/
         Pt9AnwrE16yjxx0owhEC0+xXLY/dsy8F24WHTEww=
Date:   Tue, 28 Dec 2021 13:11:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Self <jason@bluehome.net>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert HID: add hid_is_usb() function to make it simpler
 for USB detection
Message-ID: <Ycr+/UJZ18e2o4go@kroah.com>
References: <20211227172618.6c3eb077@valencia>
 <YcrBraOFiQN6ZiXC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcrBraOFiQN6ZiXC@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 28, 2021 at 08:50:05AM +0100, Greg KH wrote:
> On Mon, Dec 27, 2021 at 05:26:18PM -0800, Jason Self wrote:
> > While compiling 5.4.168 for m68k with the attached config I encountered
> > a compile error doing make -j$(nproc) bindeb-pkg.
> > 
> > I see that it is also affecting all older current releases too. In
> > addition to the 5.4 series this also affects 4.19, 4.14, 4.9 and 4.4.
> > 
> > awk '!x[$0]++' init/modules.order usr/modules.order
> > arch/m68k/kernel/modules.order arch/m68k/mm/modules.order
> > arch/m68k/q40/modules.order arch/m68k/amiga/modules.order
> > arch/m68k/atari/modules.order arch/m68k/mac/modules.order
> > arch/m68k/apollo/modules.order arch/m68k/mvme147/modules.order
> > arch/m68k/mvme16x/modules.order arch/m68k/bvme6000/modules.order
> > arch/m68k/emu/modules.order arch/m68k/fpsp040/modules.order
> > arch/m68k/ifpsp060/modules.order arch/m68k/math-emu/modules.order
> > kernel/modules.order certs/modules.order mm/modules.order
> > fs/modules.order ipc/modules.order security/modules.order
> > crypto/modules.order block/modules.order drivers/modules.order
> > sound/modules.order net/modules.order lib/modules.order
> > arch/m68k/lib/modules.order virt/modules.order > modules.order awk
> > '!x[$0]++' init/modules.builtin usr/modules.builtin
> > arch/m68k/kernel/modules.builtin arch/m68k/mm/modules.builtin
> > arch/m68k/q40/modules.builtin arch/m68k/amiga/modules.builtin
> > arch/m68k/atari/modules.builtin arch/m68k/mac/modules.builtin
> > arch/m68k/apollo/modules.builtin arch/m68k/mvme147/modules.builtin
> > arch/m68k/mvme16x/modules.builtin arch/m68k/bvme6000/modules.builtin
> > arch/m68k/emu/modules.builtin arch/m68k/fpsp040/modules.builtin
> > arch/m68k/ifpsp060/modules.builtin arch/m68k/math-emu/modules.builtin
> > kernel/modules.builtin certs/modules.builtin mm/modules.builtin
> > fs/modules.builtin ipc/modules.builtin security/modules.builtin
> > crypto/modules.builtin block/modules.builtin drivers/modules.builtin
> > sound/modules.builtin net/modules.builtin lib/modules.builtin
> > arch/m68k/lib/modules.builtin virt/modules.builtin > modules.builtin
> > make -f ./scripts/Makefile.modpost sed 's/ko$/o/' modules.order |
> > scripts/mod/modpost -m  -o ./Module.symvers        -s -T - vmlinux
> > ERROR: "usb_hid_driver" [drivers/hid/hid-asus.ko] undefined!
> > scripts/Makefile.modpost:93: recipe for target '__modpost' failed
> > make[1]: *** [__modpost] Error 1 Makefile:1324: recipe for target
> > 'modules' failed make: *** [modules] Error 2
> > 
> > Version 5.4.164 was the last good version. Doing git bisect on the
> > stable kernel tree has given me this:
> > 
> > 6e1e0a01425810494ce00d7b800b69482790b198 is the first bad commit
> > commit 6e1e0a01425810494ce00d7b800b69482790b198
> > Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Date:   Wed Dec 1 19:35:01 2021 +0100
> > 
> >     HID: add hid_is_usb() function to make it simpler for USB detection
> >     
> >     commit f83baa0cb6cfc92ebaf7f9d3a99d7e34f2e77a8a upstream.
> >     
> >     A number of HID drivers already call hid_is_using_ll_driver() but
> >     only for the detection of if this is a USB device or not.  Make
> >     this more obvious by creating hid_is_usb() and calling the function
> >     that way. 
> >     Also converts the existing hid_is_using_ll_driver() functions to
> >     use the new call.
> >     
> >     Cc: Jiri Kosina <jikos@kernel.org>
> >     Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >     Cc: linux-input@vger.kernel.org
> >     Cc: stable@vger.kernel.org
> >     Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >     Link:
> >     https://lore.kernel.org/r/20211201183503.2373082-1-gregkh@linuxfoundation.org
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> >  drivers/hid/hid-asus.c           | 2 +-
> >  drivers/hid/hid-logitech-dj.c    | 2 +-
> >  drivers/hid/hid-u2fzero.c        | 2 +-
> >  drivers/hid/hid-uclogic-params.c | 3 +--
> >  drivers/hid/wacom_sys.c          | 2 +-
> >  include/linux/hid.h              | 5 +++++
> >  6 files changed, 10 insertions(+), 6 deletions(-)
> 
> 
> There were follow-on patches to prevent modules from being built if the
> right options were not enabled, so bisection might fail with your config
> at this point.  I'll check to see if those were added properly after my
> morning coffee...

Looks like f237d9028f84 ("HID: add USB_HID dependancy on some USB HID
drivers") was properly backported.  But maybe the dependancy needs to
also be added for a few more drivers as well, like c4f0126d487f ("HID:
asus: Add depends on USB_HID to HID_ASUS Kconfig option"), right?

If you backport that commit, does that solve this issue?

thanks,

greg k-h
