Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2D81AAFB2
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 19:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411067AbgDOR3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 13:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411089AbgDOR3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 13:29:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F41820784;
        Wed, 15 Apr 2020 17:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586971739;
        bh=4YZMqjC3YWCeWBCjLEsBJGMguA8y1P/t7eYRQcpsXhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yTlfgIkkcpGAYUvWRGW7hh6UWFRBGACNVesSAnovSpHOf+iMqO37TrHml2qnBL7sO
         jmFY4D+tlysUnwCmvTTkd/3BcoQ2gAVapfKOafcNmJcvETO11A9e8L+3cN2yb2jusO
         ttj5JBnFIv0MogGREuwVyaTVUz+WaUmT/tG8dYFo=
Date:   Wed, 15 Apr 2020 19:28:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     courbet@google.com, mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc: Make setjmp/longjmp signature
 standard" failed to apply to 4.14-stable tree
Message-ID: <20200415172850.GA3664694@kroah.com>
References: <15869565461129@kroah.com>
 <20200415161259.GA44996@ubuntu-s3-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415161259.GA44996@ubuntu-s3-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 09:12:59AM -0700, Nathan Chancellor wrote:
> On Wed, Apr 15, 2020 at 03:15:46PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
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
> > From c17eb4dca5a353a9dbbb8ad6934fe57af7165e91 Mon Sep 17 00:00:00 2001
> > From: Clement Courbet <courbet@google.com>
> > Date: Mon, 30 Mar 2020 10:03:56 +0200
> > Subject: [PATCH] powerpc: Make setjmp/longjmp signature standard
> > 
> > Declaring setjmp()/longjmp() as taking longs makes the signature
> > non-standard, and makes clang complain. In the past, this has been
> > worked around by adding -ffreestanding to the compile flags.
> > 
> > The implementation looks like it only ever propagates the value
> > (in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
> > with integer parameters.
> > 
> > This allows removing -ffreestanding from the compilation flags.
> > 
> > Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")
> > Cc: stable@vger.kernel.org # v4.14+
> > Signed-off-by: Clement Courbet <courbet@google.com>
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > Link: https://lore.kernel.org/r/20200330080400.124803-1-courbet@google.com
> > 
> > diff --git a/arch/powerpc/include/asm/setjmp.h b/arch/powerpc/include/asm/setjmp.h
> > index e9f81bb3f83b..f798e80e4106 100644
> > --- a/arch/powerpc/include/asm/setjmp.h
> > +++ b/arch/powerpc/include/asm/setjmp.h
> > @@ -7,7 +7,9 @@
> >  
> >  #define JMP_BUF_LEN    23
> >  
> > -extern long setjmp(long *) __attribute__((returns_twice));
> > -extern void longjmp(long *, long) __attribute__((noreturn));
> > +typedef long jmp_buf[JMP_BUF_LEN];
> > +
> > +extern int setjmp(jmp_buf env) __attribute__((returns_twice));
> > +extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));
> >  
> >  #endif /* _ASM_POWERPC_SETJMP_H */
> > diff --git a/arch/powerpc/kexec/Makefile b/arch/powerpc/kexec/Makefile
> > index 378f6108a414..86380c69f5ce 100644
> > --- a/arch/powerpc/kexec/Makefile
> > +++ b/arch/powerpc/kexec/Makefile
> > @@ -3,9 +3,6 @@
> >  # Makefile for the linux kernel.
> >  #
> >  
> > -# Avoid clang warnings around longjmp/setjmp declarations
> > -CFLAGS_crash.o += -ffreestanding
> > -
> >  obj-y				+= core.o crash.o core_$(BITS).o
> >  
> >  obj-$(CONFIG_PPC32)		+= relocate_32.o
> > diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
> > index c3842dbeb1b7..6f9cccea54f3 100644
> > --- a/arch/powerpc/xmon/Makefile
> > +++ b/arch/powerpc/xmon/Makefile
> > @@ -1,9 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  # Makefile for xmon
> >  
> > -# Avoid clang warnings around longjmp/setjmp declarations
> > -subdir-ccflags-y := -ffreestanding
> > -
> >  GCOV_PROFILE := n
> >  KCOV_INSTRUMENT := n
> >  UBSAN_SANITIZE := n
> > 
> 
> Attached is a backport for 4.14 (that patch plus a prerequisite one).

Thanks for all 3 backports, now queued up.

greg k-h
