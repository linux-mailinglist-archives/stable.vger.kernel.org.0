Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B43481B64
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 11:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbhL3KhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 05:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhL3KhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 05:37:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DF3C061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 02:37:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00148B81AA6
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 10:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C570C36AEA;
        Thu, 30 Dec 2021 10:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640860619;
        bh=I3XoWlXkbiB4h5ISlkd4rA8+M8v6JGGNkCKBSr0PagE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mj48+K1HDAAxIDCc7r3RLrmtzJ2yBZd5UEOcpBtUwd/1amGJQh9KRr9TWDV4bEAcp
         AjRPRxPL3TcCVDgLuAYl+qSEvv+GljSnmrZUQj4HN1qmf8ctHoEianRR82ZhpYEr7N
         DvES8STHmqsYoPCWOlJJCuUycvpehffTqWULPxt4=
Date:   Thu, 30 Dec 2021 11:36:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Will Deacon <will@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Bernhard Rosenkraenzer <bero@lindev.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: AS_IS_LLVM=y v5.10.y patches
Message-ID: <Yc2LyGw951rCGsO6@kroah.com>
References: <CAKwvOdkrNMED1-3QUL4YfhHbA8dnEn+Ws3-uhH6nedG4J1sQBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkrNMED1-3QUL4YfhHbA8dnEn+Ws3-uhH6nedG4J1sQBg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 29, 2021 at 01:55:34PM -0800, Nick Desaulniers wrote:
> Dear Stable Kernel Maintainers,
> Please consider applying the attached mbox file to v5.10.y.
> 
> For Android's T release in 2022, I'd like to verify whether clang's
> integrated assembler was used. For the compiler and linker, they both
> embed a string in object file that can be read via:
> 
> $ llvm-readelf -p .comment <object file>
> String dump of section '.comment':
>   [     0]  Linker: LLD 14.0.0
>   [    13]  clang version 14.0.0 (git@github.com:llvm/llvm-project.git
> 2ff26d0e794ab7300d94051f91be7da274cc348e)
> 
> Unfortunately, the assembler version is not also embedded. Instead,
> I'd like to check for the presence of AS_IS_LLVM in .config.  This
> series helps move some toolchain version checking from build time to
> configure time, though that's only a modest improvement and I don't
> _have_ to check this config.
> 
> The mbox contains the following 7 commits:
> 
> 1. commit 052c805a1851 ("kbuild: LD_VERSION redenomination")
> 2. commit aec6c60a01d3 ("kbuild: check the minimum compiler version in Kconfig")
> 3. commit 02aff8592204 ("kbuild: check the minimum linker version in Kconfig")
> 4. commit 1f09af062556 ("kbuild: Fix ld-version.sh script if LLD was
> built with LLD_VENDOR")
> 5. commit bcbcf50f5218 ("kbuild: fix ld-version.sh to not be affected
> by locale")
> 6. commit e24b3ffcf421 ("kbuild: collect minimum tool versions into
> scripts/min-tool-version.sh")
> 7. commit ba64beb17493 ("kbuild: check the minimum assembler version
> in Kconfig")
> 
> They landed respectively upstream in:
> 1. v5.12-rc1
> 2. v5.12-rc1
> 3. v5.12-rc1
> 4. v5.12-rc3
> 5. v5.12-rc3
> 6. v5.13-rc1
> 7. v5.13-rc1
> 
> I needed to manually resolve conflicts in the respective patches:
> 1. N/A
> 2. N/A
> 3. scripts/lld-version.sh due to df58fb431aa3
> ("scripts/lld-version.sh: Rewrite based on upstream ld-version.sh")
> being 5.10 only. This file is removed regardless of what it looks
> like.
> 4. N/A
> 5. N/A
> 6. N/A
> 7. arch/Kconfig due to missing dc5723b02e523 ("kbuild: add support for
> Clang LTO") which landed in v5.12-rc1.

While I can appreciate your quest to make your Android kernel trees
smaller, this really looks like a "new feature".  What bug/issue is this
fixing that is currently present in 5.10 that people are hitting today?

thanks,

greg k-h
