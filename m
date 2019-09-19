Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D5BB71F4
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 05:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfISDnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 23:43:51 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37727 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbfISDnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 23:43:51 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46YjPY2D8wz9sN1;
        Thu, 19 Sep 2019 13:43:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1568864627;
        bh=X2OjbWzwZ8jv6a5RO8CrQHGjc8Or6aTsn3lrs6r0Dm0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=elRlfrs0Ai2wqswZUvqd/1Xr+WYCir0HLFUlZldQmN4x+eNwI/S0zSfQhQBdfcqVt
         +V6LQokT0J+LSCpuJTtMUSJ0diZ3uskMGH+rb3Nn0080y0wcVIyzdU93RMP5WmCW8Z
         GJQgCCIASGoe86PhBqMaBwwpxj+uqrxq4Wvra1PKskBjXAxpc6zps6aTFGOHSRUe/S
         T0JO5GfHUCcQmeMuNmZAe55y7azFbpuVB6GigiEQ+oGUCWwEiEnnwE3Bej/mCUbeNk
         cMmak92yME5O0xvFnTw/pQfQYdMyBNB8HvjGH+xCSCazn+z6NP6+imE4A5aPThO2GM
         jQLH2eCdIHUzw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc:     stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        Nicholas Piggin <npiggin@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] powerpc: Allow flush_icache_range to work across ranges >4GB
In-Reply-To: <20190918052106.14113-2-alastair@au1.ibm.com>
References: <20190918052106.14113-1-alastair@au1.ibm.com> <20190918052106.14113-2-alastair@au1.ibm.com>
Date:   Thu, 19 Sep 2019 13:43:43 +1000
Message-ID: <87imppuf0w.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Alastair D'Silva" <alastair@au1.ibm.com> writes:
> From: Alastair D'Silva <alastair@d-silva.org>
>
> When calling flush_icache_range with a size >4GB, we were masking
> off the upper 32 bits, so we would incorrectly flush a range smaller
> than intended.
>
> __kernel_sync_dicache in the 64 bit VDSO has the same bug.

Please fix that in a separate patch.

Your subject doesn't mention __kernel_sync_dicache(), and also the two
changes backport differently, so it's better if they're done as separate
patches.

cheers

> This patch replaces the 32 bit shifts with 64 bit ones, so that
> the full size is accounted for.
>
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/powerpc/kernel/misc_64.S           | 4 ++--
>  arch/powerpc/kernel/vdso64/cacheflush.S | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index b55a7b4cb543..9bc0aa9aeb65 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -82,7 +82,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
>  	subf	r8,r6,r4		/* compute length */
>  	add	r8,r8,r5		/* ensure we get enough */
>  	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of cache block size */
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>  	beqlr				/* nothing to do? */
>  	mtctr	r8
>  1:	dcbst	0,r6
> @@ -98,7 +98,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
>  	subf	r8,r6,r4		/* compute length */
>  	add	r8,r8,r5
>  	lwz	r9,ICACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of Icache block size */
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>  	beqlr				/* nothing to do? */
>  	mtctr	r8
>  2:	icbi	0,r6
> diff --git a/arch/powerpc/kernel/vdso64/cacheflush.S b/arch/powerpc/kernel/vdso64/cacheflush.S
> index 3f92561a64c4..526f5ba2593e 100644
> --- a/arch/powerpc/kernel/vdso64/cacheflush.S
> +++ b/arch/powerpc/kernel/vdso64/cacheflush.S
> @@ -35,7 +35,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
>  	subf	r8,r6,r4		/* compute length */
>  	add	r8,r8,r5		/* ensure we get enough */
>  	lwz	r9,CFG_DCACHE_LOGBLOCKSZ(r10)
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>  	crclr	cr0*4+so
>  	beqlr				/* nothing to do? */
>  	mtctr	r8
> @@ -52,7 +52,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
>  	subf	r8,r6,r4		/* compute length */
>  	add	r8,r8,r5
>  	lwz	r9,CFG_ICACHE_LOGBLOCKSZ(r10)
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>  	crclr	cr0*4+so
>  	beqlr				/* nothing to do? */
>  	mtctr	r8
> -- 
> 2.21.0
