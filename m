Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C3B874AD
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 10:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405888AbfHII7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 04:59:04 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:35525 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbfHII7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 04:59:03 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 464fLD5lq8z9v0hl;
        Fri,  9 Aug 2019 10:59:00 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=ldApItJf; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id ysu8ZTG-4UXw; Fri,  9 Aug 2019 10:59:00 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 464fLD4h0Qz9v0hj;
        Fri,  9 Aug 2019 10:59:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1565341140; bh=v9a6CunqkztcWhEahCiUv20a19QATmRm8swNBF4mU4o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ldApItJf3Z3ekgov7QP6o8AuQtiTl6eP4FvdFirhNkFnWjxjoW5euJ3XJ2BFzpmc4
         nrqok56fz4+jVeKILC5UYoAss+g6BrHZ/xGP1de/uYy89moaD3Bwacr/xYPGLlXhN2
         BYlvKI9Ijdgy3jGpuZUS2+HhoHvyAKdGfhVCQbgE=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CD8378B881;
        Fri,  9 Aug 2019 10:59:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id VKVLaEo4TvUq; Fri,  9 Aug 2019 10:59:01 +0200 (CEST)
Received: from [172.25.230.101] (po15451.idsi0.si.c-s.fr [172.25.230.101])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8A8D08B7A1;
        Fri,  9 Aug 2019 10:59:01 +0200 (CEST)
Subject: Re: [PATCH 1/2] powerpc: Allow flush_icache_range to work across
 ranges >4GB
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc:     stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20190809004548.22445-1-alastair@au1.ibm.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <a9bcc457-9f9b-7010-6796-fb263135f8bc@c-s.fr>
Date:   Fri, 9 Aug 2019 10:59:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809004548.22445-1-alastair@au1.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 09/08/2019 à 02:45, Alastair D'Silva a écrit :
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> When calling flush_icache_range with a size >4GB, we were masking
> off the upper 32 bits, so we would incorrectly flush a range smaller
> than intended.
> 
> This patch replaces the 32 bit shifts with 64 bit ones, so that
> the full size is accounted for.
> 
> Heads-up for backporters: the old version of flush_dcache_range is
> subject to a similar bug (this has since been replaced with a C
> implementation).

Can you submit a patch to stable, explaining this ?

> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

Should add:

Cc: stable@vger.kernel.org

Christophe

> ---
>   arch/powerpc/kernel/misc_64.S | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index b55a7b4cb543..9bc0aa9aeb65 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -82,7 +82,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
>   	subf	r8,r6,r4		/* compute length */
>   	add	r8,r8,r5		/* ensure we get enough */
>   	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of cache block size */
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>   	beqlr				/* nothing to do? */
>   	mtctr	r8
>   1:	dcbst	0,r6
> @@ -98,7 +98,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
>   	subf	r8,r6,r4		/* compute length */
>   	add	r8,r8,r5
>   	lwz	r9,ICACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of Icache block size */
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>   	beqlr				/* nothing to do? */
>   	mtctr	r8
>   2:	icbi	0,r6
> 
