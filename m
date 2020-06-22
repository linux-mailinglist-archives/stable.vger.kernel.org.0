Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B302042FF
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgFVVvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVVvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 17:51:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77B482073E;
        Mon, 22 Jun 2020 21:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592862711;
        bh=j2fwXXFNXxd0O2/Te+mvzzRijkWCgZELdMQ9j30NiIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uu67yW6QPeVYpg2If0pVdOQDjfOtqU4klqohMCxm3mju/hwahvOj/7Go857+yeddv
         FKSgZiURXGrYgW5jwldGckTlVJU4SJmIxJlb18ADUWZtpYECDF9SRRhtJ9be4l+EtM
         EJx+zIthynrKYKjMV20LB0NwZUN5y+pPVwe4yzBA=
Date:   Mon, 22 Jun 2020 17:51:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 5.4] x86/boot/compressed: Relax sed symbol type regex for
 LLVM ld.lld
Message-ID: <20200622215150.GM1931@sasha-vm>
References: <20200622195639.2670308-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200622195639.2670308-1-natechancellor@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 07:56:39PM +0000, Nathan Chancellor wrote:
>From: Ard Biesheuvel <ardb@kernel.org>
>
>commit bc310baf2ba381c648983c7f4748327f17324562 upstream.
>
>The final build stage of the x86 kernel captures some symbol
>addresses from the decompressor binary and copies them into zoffset.h.
>It uses sed with a regular expression that matches the address, symbol
>type and symbol name, and mangles the captured addresses and the names
>of symbols of interest into #define directives that are added to
>zoffset.h
>
>The symbol type is indicated by a single letter, which we match
>strictly: only letters in the set 'ABCDGRSTVW' are matched, even
>though the actual symbol type is relevant and therefore ignored.
>
>Commit bc7c9d620 ("efi/libstub/x86: Force 'hidden' visibility for
>extern declarations") made a change to the way external symbol
>references are classified, resulting in 'startup_32' now being
>emitted as a hidden symbol. This prevents the use of GOT entries to
>refer to this symbol via its absolute address, which recent toolchains
>(including Clang based ones) already avoid by default, making this
>change a no-op in the majority of cases.
>
>However, as it turns out, the LLVM linker classifies such hidden
>symbols as symbols with static linkage in fully linked ELF binaries,
>causing tools such as NM to output a lowercase 't' rather than an upper
>case 'T' for the type of such symbols. Since our sed expression only
>matches upper case letters for the symbol type, the line describing
>startup_32 is disregarded, resulting in a build error like the following
>
>  arch/x86/boot/header.S:568:18: error: symbol 'ZO_startup_32' can not be
>                                        undefined in a subtraction expression
>  init_size: .long (0x00000000008fd000 - ZO_startup_32 +
>                    (((0x0000000001f6361c + ((0x0000000001f6361c >> 8) + 65536)
>                     - 0x00000000008c32e5) + 4095) & ~4095)) # kernel initialization size
>
>Given that we are only interested in the value of the symbol, let's match
>any character in the set 'a-zA-Z' instead.
>
>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>Signed-off-by: Ingo Molnar <mingo@kernel.org>
>Tested-by: Nathan Chancellor <natechancellor@gmail.com>
>Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>---
>
>Hi all,
>
>Please apply this patch to 5.4 (and older releases if you feel it
>necessary), as it fixes a build error that I see when linking with
>ld.lld on certain distribution configurations after upstream commit
>5214028dd89e ("x86/boot: Correct relocation destination on old linkers")
>was applied in 5.4.48.
>
>$ make -skj"$(nproc)" CC=clang LD=ld.lld O=out/x86_64 olddefconfig bzImage
>...
>ld.lld: error: undefined symbol: ZO__end
>>>> referenced by arch/x86/boot/header.o:(.header+0x71)
>...
>
>While the commit message references bc7c9d620 as the first problematic
>commit, I see the same behavior of capital versus lowercase letters from
>nm here too. I assume this is not seen in mainline because this commit
>was already in the tree when 5214028dd89e was applied.

I've queued this for 5.4-4.9, thanks!

-- 
Thanks,
Sasha
