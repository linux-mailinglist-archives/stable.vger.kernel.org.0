Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101AE4A75BA
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 17:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiBBQ0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 11:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBBQ0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 11:26:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED599C061714;
        Wed,  2 Feb 2022 08:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5D82B83141;
        Wed,  2 Feb 2022 16:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E672FC004E1;
        Wed,  2 Feb 2022 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643819168;
        bh=wusIwvpAYb98F0yAZEFXYnS8gtTO5w+x8X+MClA3MHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gm2cGMr56Pfad5yvlGq7NpXnmAzGI5MgPTaIWTllBoSrlM62h724XW8dQJhz2lntv
         6rVxPnPi7O9qviKfc6sVFZX0caLBxpcGyRlEJULRpO+uMDFc7SHzztHX4+88zKEXAk
         oReL5CuoiXrzaiuHrDyYYN3YwwQZmx1/tXPfjqnmbh270BYjTAWb0AB/aWE5RIYWS/
         RBtPqt472ang7nDDigm0dFQB2XVKu1IAdofgiqpdp2fE/NvOOMexvbh9Df58obsuPJ
         uDqvHJG+sbHxcQ3qyp7wxFaqzkxBnn6tZ7WOYZUDvBAeHAJYiDk96KL5uOiwjS2lwv
         ebgorz+D9R2tA==
Date:   Wed, 2 Feb 2022 09:26:04 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] Makefile.extrawarn: Move -Wunaligned-access to W=2
Message-ID: <YfqwnMB2lLXOuahI@dev-arch.archlinux-ax161>
References: <20220201232229.2992968-1-nathan@kernel.org>
 <CAK8P3a2Y8nQ55sycxbpfN=71BNO9wuEDt=Q24ELS_u_WNRpqZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2Y8nQ55sycxbpfN=71BNO9wuEDt=Q24ELS_u_WNRpqZw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 09:12:06AM +0100, Arnd Bergmann wrote:
> On Wed, Feb 2, 2022 at 12:22 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > -Wunaligned-access is a new warning in clang that is default enabled for
> > arm and arm64 under certain circumstances within the clang frontend (see
> > LLVM commit below). Under an ARCH=arm allmodconfig, there are
> > 1284 total/70 unique instances of this warning (most of the instances
> > are in header files), which is quite noisy.
> >
> > To keep the build green through CONFIG_WERROR, only allow this warning
> > with W=2, which seems appropriate according to its description:
> > "warnings which occur quite often but may still be relevant".
> >
> > This intentionally does not use the -Wno-... + -W... pattern that the
> > rest of the Makefile does because this warning is not enabled for
> > anything other than certain arm and arm64 configurations within clang so
> > it should only be "not disabled", rather than explicitly enabled, so
> > that other architectures are not disturbed by the warning.
> >
> > Cc: stable@vger.kernel.org
> > Link: https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> The warning seems important enough to be considered for W=1 on 32-bit arm,
> otherwise the chances of anyone actually fixing drivers for it is
> relatively slim.

Fair point, I suppose barely anyone does W=2 builds, which means we
might as well just disable it outright.

> Can you point post the (sufficiently trimmed) output that you get with
> the warning
> enabled in an allmodconfig build?

Sure thing.

Here is the trimmed version:

https://gist.github.com/nathanchance/6682e6894f75790059ca698c29212c71/raw/f63d54819afeb96f3ea0bb055096849912ac0185/trimmed.log

Here is the full output of 'make ARCH=arm LLVM=1 allmodconfig':

https://gist.github.com/nathanchance/6682e6894f75790059ca698c29212c71/raw/f63d54819afeb96f3ea0bb055096849912ac0185/full.log

> I'm not sure why this is enabled by default for arm64, which does not have
> the problem with fixup handlers.

It is not enabled for arm64 for the kernel. If I am reading the commit
right, it is only enabled for arm64 when -mno-unaligned-access is passed
or building for OpenBSD, which obviously don't apply to the kernel (see
AArch64.cpp).

For ARM, we see it in the kernel because it is enabled for any version less
than 7, according to this block in clang/lib/Driver/ToolChains/Arch/ARM.cpp:

    } else if (Triple.isOSLinux() || Triple.isOSNaCl() ||
               Triple.isOSWindows()) {
      if (VersionNum < 7) {
        Features.push_back("+strict-align");
        if (!ForAS)
          CmdArgs.push_back("-Wunaligned-access");
      }

There is this comment above this block in the source code:

    // Assume pre-ARMv6 doesn't support unaligned accesses.
    //
    // ARMv6 may or may not support unaligned accesses depending on the
    // SCTLR.U bit, which is architecture-specific. We assume ARMv6
    // Darwin and NetBSD targets support unaligned accesses, and others don't.
    //
    // ARMv7 always has SCTLR.U set to 1, but it has a new SCTLR.A bit
    // which raises an alignment fault on unaligned accesses. Linux
    // defaults this bit to 0 and handles it as a system-wide (not
    // per-process) setting. It is therefore safe to assume that ARMv7+
    // Linux targets support unaligned accesses. The same goes for NaCl
    // and Windows.
    //
    // The above behavior is consistent with GCC.

I notice that CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS under certain
conditions in arch/arm/Kconfig. Would it be worth telling clang that it
can generate unaligned accesses in those cases via -munaligned-access or
would that be too expensive? If we did, these warnings would be
eliminated for configs with CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y,
then it could be safely placed under W=1.

Cheers,
Nathan
