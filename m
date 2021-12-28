Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B1B480DC8
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 23:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhL1Wp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 17:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhL1Wp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 17:45:57 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F32EC061574;
        Tue, 28 Dec 2021 14:45:57 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JNqPq3Hplz4xgY;
        Wed, 29 Dec 2021 09:45:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1640731552;
        bh=qljWZbGI1apBrOJgjHe30U4ij1VSVO919oknE97+iHQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=F3ek6iwWIBiBhsWe3OP0jJps5GD6L/20yTHI/laLt8I/rf28G/oNlmGekUPpPdZ7b
         6n7My31upouYpmhUha3XH4uD1jXAUirYKKROigV5cOaJ5UDW6d0YNp0/vj3GKBFo+5
         blWmm2QF2qlPQbgb/yRvISQ5fxcup4hztkOnchqJyDA9QQqrWhSdcfw5BxWrLetH3R
         e/MgyNxVMRuYKkVvTGtXhMPuwLEE6RynP7tLN2uQgPGwLpZdda4fOFv4F4nc3F1Z6a
         2+E58iycqZZLi/c71z0OCCU/S01jdY/BA5uzNhC+ZRcmpG7S7fmM94KZG1uePk/3Uv
         ggNN6h07PNuUw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] powerpc/32s: Fix kasan_init_region() for KASAN
In-Reply-To: <90826d123e3e28b840f284412b150a1e13ed62fb.1638799954.git.christophe.leroy@csgroup.eu>
References: <90826d123e3e28b840f284412b150a1e13ed62fb.1638799954.git.christophe.leroy@csgroup.eu>
Date:   Wed, 29 Dec 2021 09:45:51 +1100
Message-ID: <87pmpg1h7k.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:
> It has been reported some configuration where the kernel doesn't
> boot with KASAN enabled.
>
> This is due to wrong BAT allocation for the KASAN area:
>
> 	---[ Data Block Address Translation ]---
> 	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw      m
> 	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw      m
> 	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw      m
> 	3: 0xf8000000-0xf9ffffff 0x2a000000        32M Kernel rw      m
> 	4: 0xfa000000-0xfdffffff 0x2c000000        64M Kernel rw      m
>
> A BAT must have both virtual and physical addresses alignment matching
> the size of the BAT. This is not the case for BAT 4 above.
>
> Fix kasan_init_region() by using block_size() function that is in
> book3s32/mmu.c. To be able to reuse it here, make it non static and
> change its name to bat_block_size() in order to avoid name conflict
> with block_size() defined in <linux/blkdev.h>
>
> Also reuse find_free_bat() to avoid an error message from setbat()
> when no BAT is available.
>
> And allocate memory outside of linear memory mapping to avoid
> wasting that precious space.
>
> With this change we get correct alignment for BATs and KASAN shadow
> memory is allocated outside the linear memory space.
>
> 	---[ Data Block Address Translation ]---
> 	0: 0xc0000000-0xcfffffff 0x00000000       256M Kernel rw
> 	1: 0xd0000000-0xdfffffff 0x10000000       256M Kernel rw
> 	2: 0xe0000000-0xefffffff 0x20000000       256M Kernel rw
> 	3: 0xf8000000-0xfbffffff 0x7c000000        64M Kernel rw
> 	4: 0xfc000000-0xfdffffff 0x7a000000        32M Kernel rw
>
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Fixes: 7974c4732642 ("powerpc/32s: Implement dedicated kasan_init_region()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
> v2:
> - Allocate kasan shadow memory outside precious kernel linear memory
> - Properly zeroise kasan shadow memory
> ---
>  arch/powerpc/include/asm/book3s/32/mmu-hash.h |  2 +
>  arch/powerpc/mm/book3s32/mmu.c                | 10 ++--
>  arch/powerpc/mm/kasan/book3s_32.c             | 58 ++++++++++---------
>  3 files changed, 38 insertions(+), 32 deletions(-)

Sorry this now conflicts with other changes in next. Can you rebase it please?

cheers
