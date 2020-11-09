Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F59C2AC21A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbgKIRXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:23:47 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:57492 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731290AbgKIRXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 12:23:47 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CVHs56PXTz9tyRh;
        Mon,  9 Nov 2020 18:23:37 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 4ePLM5wTEiVr; Mon,  9 Nov 2020 18:23:37 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CVHs557KHz9tyRD;
        Mon,  9 Nov 2020 18:23:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5768C8B7C3;
        Mon,  9 Nov 2020 18:23:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id dEAEUXC_H1PK; Mon,  9 Nov 2020 18:23:43 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id ED5F78B78A;
        Mon,  9 Nov 2020 18:23:42 +0100 (CET)
Subject: Re: FAILED: patch "[PATCH] powerpc/603: Always fault when
 _PAGE_ACCESSED is not set" failed to apply to 5.9-stable tree
To:     gregkh@linuxfoundation.org, mpe@ellerman.id.au
Cc:     stable@vger.kernel.org
References: <1604916596142143@kroah.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <e53550ea-761f-14b1-f74f-627b77f7caf9@csgroup.eu>
Date:   Mon, 9 Nov 2020 18:23:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <1604916596142143@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

It does apply, but you have to increase your merge.renamelimit, that's because the file name changed 
recently.

Thanks
Christophe

Le 09/11/2020 à 11:09, gregkh@linuxfoundation.org a écrit :
> 
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 11522448e641e8f1690c9db06e01985e8e19b401 Mon Sep 17 00:00:00 2001
> From: Christophe Leroy <christophe.leroy@csgroup.eu>
> Date: Sat, 10 Oct 2020 15:14:30 +0000
> Subject: [PATCH] powerpc/603: Always fault when _PAGE_ACCESSED is not set
> 
> The kernel expects pte_young() to work regardless of CONFIG_SWAP.
> 
> Make sure a minor fault is taken to set _PAGE_ACCESSED when it
> is not already set, regardless of the selection of CONFIG_SWAP.
> 
> Fixes: 84de6ab0e904 ("powerpc/603: don't handle PAGE_ACCESSED in TLB miss handlers.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/a44367744de54e2315b2f1a8cbbd7f88488072e0.1602342806.git.christophe.leroy@csgroup.eu
> 
> diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
> index 5eb9eedac920..2aa16d5368e1 100644
> --- a/arch/powerpc/kernel/head_book3s_32.S
> +++ b/arch/powerpc/kernel/head_book3s_32.S
> @@ -457,11 +457,7 @@ InstructionTLBMiss:
>   	cmplw	0,r1,r3
>   #endif
>   	mfspr	r2, SPRN_SPRG_PGDIR
> -#ifdef CONFIG_SWAP
>   	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
> -#else
> -	li	r1,_PAGE_PRESENT | _PAGE_EXEC
> -#endif
>   #if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC)
>   	bgt-	112f
>   	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
> @@ -523,11 +519,7 @@ DataLoadTLBMiss:
>   	lis	r1, TASK_SIZE@h		/* check if kernel address */
>   	cmplw	0,r1,r3
>   	mfspr	r2, SPRN_SPRG_PGDIR
> -#ifdef CONFIG_SWAP
>   	li	r1, _PAGE_PRESENT | _PAGE_ACCESSED
> -#else
> -	li	r1, _PAGE_PRESENT
> -#endif
>   	bgt-	112f
>   	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
>   	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
> @@ -603,11 +595,7 @@ DataStoreTLBMiss:
>   	lis	r1, TASK_SIZE@h		/* check if kernel address */
>   	cmplw	0,r1,r3
>   	mfspr	r2, SPRN_SPRG_PGDIR
> -#ifdef CONFIG_SWAP
>   	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED
> -#else
> -	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT
> -#endif
>   	bgt-	112f
>   	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
>   	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
> 
