Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30316231DB1
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 13:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgG2Lxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 07:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgG2Lxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 07:53:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E277720809;
        Wed, 29 Jul 2020 11:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596023622;
        bh=x+y3RA7FKL0tdCDXaEu4l6gkUVbPRcNsooAJYXPnvlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ox71tKqza7CWJKSVHMcflqQknoE/vdu3epDhYUknXnxyVgWquM6yG1qM2UwfRkAA5
         SPCy4TET5WZq+VmakLoAnWVbkOgEmgEjpw8rLf0YwTrJ3QwHWTudMRzg8iUBv4CUjl
         LNGjCT2naVUC1DLa8hZ8/WuKRDGMfJwjClG2oxQg=
Date:   Wed, 29 Jul 2020 13:53:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     maskray@google.com, masahiroy@kernel.org, ndesaulniers@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Makefile: Fix GCC_TOOLCHAIN_DIR prefix
 for Clang cross" failed to apply to 4.4-stable tree
Message-ID: <20200729115333.GD2674635@kroah.com>
References: <159585527713469@kroah.com>
 <20200727160559.GA1386610@ubuntu-n2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727160559.GA1386610@ubuntu-n2-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 09:05:59AM -0700, Nathan Chancellor wrote:
> On Mon, Jul 27, 2020 at 03:07:57PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
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
> > From ca9b31f6bb9c6aa9b4e5f0792f39a97bbffb8c51 Mon Sep 17 00:00:00 2001
> > From: Fangrui Song <maskray@google.com>
> > Date: Tue, 21 Jul 2020 10:31:23 -0700
> > Subject: [PATCH] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross
> >  compilation
> > 
> > When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
> > $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
> > GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
> > /usr/bin/ and Clang as of 11 will search for both
> > $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
> > 
> > GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
> > $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
> > $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
> > 
> > To better model how GCC's -B/--prefix takes in effect in practice, newer
> > Clang (since
> > https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
> > only searches for $(prefix)$needle. Currently it will find /usr/bin/as
> > instead of /usr/bin/aarch64-linux-gnu-as.
> > 
> > Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
> > (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
> > appropriate cross compiling GNU as (when -no-integrated-as is in
> > effect).
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > Signed-off-by: Fangrui Song <maskray@google.com>
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > 
> > diff --git a/Makefile b/Makefile
> > index 676f1cfb1d56..9d9d4166c0be 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
> >  ifneq ($(CROSS_COMPILE),)
> >  CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
> >  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
> > -CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)
> > +CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
> >  GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)
> >  endif
> >  ifneq ($(GCC_TOOLCHAIN),)
> > 
> 
> Patch attached.

Now queued up, thanks!

greg k-h
