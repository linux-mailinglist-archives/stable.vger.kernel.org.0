Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDD6B2A54
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 09:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfINHqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 03:46:52 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:32983 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbfINHqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Sep 2019 03:46:51 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46Vl2J21j7z9tyXt;
        Sat, 14 Sep 2019 09:46:48 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=Nl7fN5+X; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id rI72PCkwPYDU; Sat, 14 Sep 2019 09:46:48 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46Vl2J0nhYz9tyXs;
        Sat, 14 Sep 2019 09:46:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1568447208; bh=vgjgl/ZXk3ypzgWj7uawL4ecwqnUTCi67/XQrM+/afM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Nl7fN5+XZMXGON+PdaMY3DK3hYNVxGfeCYflL9Q2ssslpiv+F/1RetE0DOQhseeNy
         JQ8Qmp06olY+03UyISXLtQYClzk2V30GWUrADVHtHjVrenl0hNPTUbMKpo5EJlbMrN
         L2rhv+OW6JVaGRJ/lYrlYQGZlBL66l45VdDDMkDQ=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2165D8B783;
        Sat, 14 Sep 2019 09:46:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id S2SpEkwhlI8R; Sat, 14 Sep 2019 09:46:49 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2B28F8B756;
        Sat, 14 Sep 2019 09:46:48 +0200 (CEST)
Subject: Re: [PATCH v2 1/6] powerpc: Allow flush_icache_range to work across
 ranges >4GB
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc:     stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Qian Cai <cai@lca.pw>,
        Nicholas Piggin <npiggin@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20190903052407.16638-1-alastair@au1.ibm.com>
 <20190903052407.16638-2-alastair@au1.ibm.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <c4760639-68e8-6969-d0eb-97f12f814109@c-s.fr>
Date:   Sat, 14 Sep 2019 09:46:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190903052407.16638-2-alastair@au1.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 03/09/2019 à 07:23, Alastair D'Silva a écrit :
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> When calling flush_icache_range with a size >4GB, we were masking
> off the upper 32 bits, so we would incorrectly flush a range smaller
> than intended.
> 
> This patch replaces the 32 bit shifts with 64 bit ones, so that
> the full size is accounted for.

Isn't there the same issue in arch/powerpc/kernel/vdso64/cacheflush.S ?

Christophe

> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> Cc: stable@vger.kernel.org
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
