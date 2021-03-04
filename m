Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA5732D4A2
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241636AbhCDNwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:52:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241635AbhCDNwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:52:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE4A64E5F;
        Thu,  4 Mar 2021 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614865905;
        bh=8KP7mUXHOdCEbP0sYZbziXYJAfr6N6ujWE/9ZROFZq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N+mP+AWQUxD1iNdFOgNGyFLnY+jsxYaFCfEiI2DUnh7mk2PVlK/xE5psnHg5z9jNQ
         JGp1/ON2cwEkAgWFOEqnWUpvF2F5aAxLgwIHAaz3Ml27SQtSagB4p+bn+e9DYFp+It
         zhU0SNhIZn3Zlr8s6izvx0N7ZUf02EDk8SsiZWug=
Date:   Thu, 4 Mar 2021 14:51:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     anders.roxell@linaro.org, natechancellor@gmail.com,
        tsbogend@alpha.franken.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of
 filtering out" failed to apply to 5.4-stable tree
Message-ID: <YEDl7qlbeWjGfoL+@kroah.com>
References: <1614592687119110@kroah.com>
 <20210301162116.hx5vjaeldfvgtieq@24bbad8f3778>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301162116.hx5vjaeldfvgtieq@24bbad8f3778>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 09:21:16AM -0700, Nathan Chancellor wrote:
> On Mon, Mar 01, 2021 at 10:58:07AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 76d7fff22be3e4185ee5f9da2eecbd8188e76b2c Mon Sep 17 00:00:00 2001
> > From: Nathan Chancellor <nathan@kernel.org>
> > Date: Fri, 15 Jan 2021 12:26:22 -0700
> > Subject: [PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out
> >  '--target='
> > 
> > Commit ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO
> > cflags") allowed the '--target=' flag from the main Makefile to filter
> > through to the vDSO. However, it did not bring any of the other clang
> > specific flags for controlling the integrated assembler and the GNU
> > tools locations (--prefix=, --gcc-toolchain=, and -no-integrated-as).
> > Without these, we will get a warning (visible with tinyconfig):
> > 
> > arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per
> > compilation unit
> > .pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long
> > 4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
> > ^
> > arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per
> > compilation unit
> >  .section .mips_abiflags, "a"
> >  ^
> > 
> > All of these flags are bundled up under CLANG_FLAGS in the main Makefile
> > and exported so that they can be added to Makefiles that set their own
> > CFLAGS. Use this value instead of filtering out '--target=' so there is
> > no warning and all of the tools are properly used.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1256
> > Reported-by: Anders Roxell <anders.roxell@linaro.org>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > Tested-by: Anders Roxell <anders.roxell@linaro.org>
> > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > 
> > diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
> > index 5810cc12bc1d..2131d3fd7333 100644
> > --- a/arch/mips/vdso/Makefile
> > +++ b/arch/mips/vdso/Makefile
> > @@ -16,16 +16,13 @@ ccflags-vdso := \
> >  	$(filter -march=%,$(KBUILD_CFLAGS)) \
> >  	$(filter -m%-float,$(KBUILD_CFLAGS)) \
> >  	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
> > +	$(CLANG_FLAGS) \
> >  	-D__VDSO__
> >  
> >  ifndef CONFIG_64BIT
> >  ccflags-vdso += -DBUILD_VDSO32
> >  endif
> >  
> > -ifdef CONFIG_CC_IS_CLANG
> > -ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
> > -endif
> > -
> >  #
> >  # The -fno-jump-tables flag only prevents the compiler from generating
> >  # jump tables but does not prevent the compiler from emitting absolute
> > 
> 
> Attached are the 4.19 and 5.4 backports.

Both now queued up, thanks.

greg k-h
