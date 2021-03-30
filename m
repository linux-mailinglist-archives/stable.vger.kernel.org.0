Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1388E34E541
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 12:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhC3KS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 06:18:27 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:39010 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhC3KSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 06:18:04 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F8lky0Skxz9ty55;
        Tue, 30 Mar 2021 12:18:02 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id ps5lNHgb8olB; Tue, 30 Mar 2021 12:18:01 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F8lkx5tzKz9ty52;
        Tue, 30 Mar 2021 12:18:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DEAD38B7F0;
        Tue, 30 Mar 2021 12:18:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 0dt7KnvUNDCa; Tue, 30 Mar 2021 12:18:01 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EF9C88B7EE;
        Tue, 30 Mar 2021 12:18:00 +0200 (CEST)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20210326191720.138155-1-dima@arista.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <47623d02-eb29-0fcb-0cfd-a9c11c9fab02@csgroup.eu>
Date:   Tue, 30 Mar 2021 12:17:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210326191720.138155-1-dima@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 26/03/2021 à 20:17, Dmitry Safonov a écrit :
> Since commit 511157ab641e ("powerpc/vdso: Move vdso datapage up front")
> VVAR page is in front of the VDSO area. In result it breaks CRIU
> (Checkpoint Restore In Userspace) [1], where CRIU expects that "[vdso]"
> from /proc/../maps points at ELF/vdso image, rather than at VVAR data page.
> Laurent made a patch to keep CRIU working (by reading aux vector).
> But I think it still makes sence to separate two mappings into different
> VMAs. It will also make ppc64 less "special" for userspace and as
> a side-bonus will make VVAR page un-writable by debugger (which previously
> would COW page and can be unexpected).
> 
> I opportunistically Cc stable on it: I understand that usually such
> stuff isn't a stable material, but that will allow us in CRIU have
> one workaround less that is needed just for one release (v5.11) on
> one platform (ppc64), which we otherwise have to maintain.
> I wouldn't go as far as to say that the commit 511157ab641e is ABI
> regression as no other userspace got broken, but I'd really appreciate
> if it gets backported to v5.11 after v5.12 is released, so as not
> to complicate already non-simple CRIU-vdso code. Thanks!
> 
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: stable@vger.kernel.org # v5.11
> [1]: https://github.com/checkpoint-restore/criu/issues/1417
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>   arch/powerpc/include/asm/mmu_context.h |  2 +-
>   arch/powerpc/kernel/vdso.c             | 54 +++++++++++++++++++-------
>   2 files changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
> index 652ce85f9410..4bc45d3ed8b0 100644
> --- a/arch/powerpc/include/asm/mmu_context.h
> +++ b/arch/powerpc/include/asm/mmu_context.h
> @@ -263,7 +263,7 @@ extern void arch_exit_mmap(struct mm_struct *mm);
>   static inline void arch_unmap(struct mm_struct *mm,
>   			      unsigned long start, unsigned long end)
>   {
> -	unsigned long vdso_base = (unsigned long)mm->context.vdso - PAGE_SIZE;
> +	unsigned long vdso_base = (unsigned long)mm->context.vdso;
>   
>   	if (start <= vdso_base && vdso_base < end)
>   		mm->context.vdso = NULL;
> diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
> index e839a906fdf2..b14907209822 100644
> --- a/arch/powerpc/kernel/vdso.c
> +++ b/arch/powerpc/kernel/vdso.c
> @@ -55,10 +55,10 @@ static int vdso_mremap(const struct vm_special_mapping *sm, struct vm_area_struc
>   {
>   	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
>   
> -	if (new_size != text_size + PAGE_SIZE)
> +	if (new_size != text_size)
>   		return -EINVAL;

In ARM64 you have removed the above test in commit 871402e05b24cb56 ("mm: forbid splitting special 
mappings"). Do we need to keep it here ?

>   
> -	current->mm->context.vdso = (void __user *)new_vma->vm_start + PAGE_SIZE;
> +	current->mm->context.vdso = (void __user *)new_vma->vm_start;
>   
>   	return 0;
>   }

