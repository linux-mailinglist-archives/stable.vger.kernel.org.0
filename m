Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8C348071B
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 08:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhL1HuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 02:50:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57466 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhL1HuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 02:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 851C6B81199
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 07:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91908C36AE8;
        Tue, 28 Dec 2021 07:50:10 +0000 (UTC)
Date:   Tue, 28 Dec 2021 08:50:05 +0100
From:   Greg KH <greg@kroah.com>
To:     Jason Self <jason@bluehome.net>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert HID: add hid_is_usb() function to make it simpler
 for USB detection
Message-ID: <YcrBraOFiQN6ZiXC@kroah.com>
References: <20211227172618.6c3eb077@valencia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227172618.6c3eb077@valencia>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 05:26:18PM -0800, Jason Self wrote:
> While compiling 5.4.168 for m68k with the attached config I encountered
> a compile error doing make -j$(nproc) bindeb-pkg.
> 
> I see that it is also affecting all older current releases too. In
> addition to the 5.4 series this also affects 4.19, 4.14, 4.9 and 4.4.
> 
> awk '!x[$0]++' init/modules.order usr/modules.order
> arch/m68k/kernel/modules.order arch/m68k/mm/modules.order
> arch/m68k/q40/modules.order arch/m68k/amiga/modules.order
> arch/m68k/atari/modules.order arch/m68k/mac/modules.order
> arch/m68k/apollo/modules.order arch/m68k/mvme147/modules.order
> arch/m68k/mvme16x/modules.order arch/m68k/bvme6000/modules.order
> arch/m68k/emu/modules.order arch/m68k/fpsp040/modules.order
> arch/m68k/ifpsp060/modules.order arch/m68k/math-emu/modules.order
> kernel/modules.order certs/modules.order mm/modules.order
> fs/modules.order ipc/modules.order security/modules.order
> crypto/modules.order block/modules.order drivers/modules.order
> sound/modules.order net/modules.order lib/modules.order
> arch/m68k/lib/modules.order virt/modules.order > modules.order awk
> '!x[$0]++' init/modules.builtin usr/modules.builtin
> arch/m68k/kernel/modules.builtin arch/m68k/mm/modules.builtin
> arch/m68k/q40/modules.builtin arch/m68k/amiga/modules.builtin
> arch/m68k/atari/modules.builtin arch/m68k/mac/modules.builtin
> arch/m68k/apollo/modules.builtin arch/m68k/mvme147/modules.builtin
> arch/m68k/mvme16x/modules.builtin arch/m68k/bvme6000/modules.builtin
> arch/m68k/emu/modules.builtin arch/m68k/fpsp040/modules.builtin
> arch/m68k/ifpsp060/modules.builtin arch/m68k/math-emu/modules.builtin
> kernel/modules.builtin certs/modules.builtin mm/modules.builtin
> fs/modules.builtin ipc/modules.builtin security/modules.builtin
> crypto/modules.builtin block/modules.builtin drivers/modules.builtin
> sound/modules.builtin net/modules.builtin lib/modules.builtin
> arch/m68k/lib/modules.builtin virt/modules.builtin > modules.builtin
> make -f ./scripts/Makefile.modpost sed 's/ko$/o/' modules.order |
> scripts/mod/modpost -m  -o ./Module.symvers        -s -T - vmlinux
> ERROR: "usb_hid_driver" [drivers/hid/hid-asus.ko] undefined!
> scripts/Makefile.modpost:93: recipe for target '__modpost' failed
> make[1]: *** [__modpost] Error 1 Makefile:1324: recipe for target
> 'modules' failed make: *** [modules] Error 2
> 
> Version 5.4.164 was the last good version. Doing git bisect on the
> stable kernel tree has given me this:
> 
> 6e1e0a01425810494ce00d7b800b69482790b198 is the first bad commit
> commit 6e1e0a01425810494ce00d7b800b69482790b198
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Wed Dec 1 19:35:01 2021 +0100
> 
>     HID: add hid_is_usb() function to make it simpler for USB detection
>     
>     commit f83baa0cb6cfc92ebaf7f9d3a99d7e34f2e77a8a upstream.
>     
>     A number of HID drivers already call hid_is_using_ll_driver() but
>     only for the detection of if this is a USB device or not.  Make
>     this more obvious by creating hid_is_usb() and calling the function
>     that way. 
>     Also converts the existing hid_is_using_ll_driver() functions to
>     use the new call.
>     
>     Cc: Jiri Kosina <jikos@kernel.org>
>     Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Cc: linux-input@vger.kernel.org
>     Cc: stable@vger.kernel.org
>     Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Link:
>     https://lore.kernel.org/r/20211201183503.2373082-1-gregkh@linuxfoundation.org
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
>  drivers/hid/hid-asus.c           | 2 +-
>  drivers/hid/hid-logitech-dj.c    | 2 +-
>  drivers/hid/hid-u2fzero.c        | 2 +-
>  drivers/hid/hid-uclogic-params.c | 3 +--
>  drivers/hid/wacom_sys.c          | 2 +-
>  include/linux/hid.h              | 5 +++++
>  6 files changed, 10 insertions(+), 6 deletions(-)


There were follow-on patches to prevent modules from being built if the
right options were not enabled, so bisection might fail with your config
at this point.  I'll check to see if those were added properly after my
morning coffee...

thanks,

greg k-h
