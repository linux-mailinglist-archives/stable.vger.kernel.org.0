Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232FB34D385
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC2PP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:15:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230522AbhC2PPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:15:06 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TF8Ko6033215;
        Mon, 29 Mar 2021 11:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Qzl69RWSsQpw7qoJaRGGwitm7/1W1WrYNJ89NcVGCr8=;
 b=Y2yTRkgwqNoHg35bb4twG5d2AkHQe+KkdrzRrvb7fTrH1uaQFSVsc8grBDhezBvqTBsE
 9JL8vUXonkuc6nkSAVuZfEfQiDrD/+xAM7QaX72u8A5IoERcInycdhyK2aQFA7iZKQce
 Sn174BJ3X0BhCe2oP/RM49Vr6zfUTxVSiHQrCaNTn9GUMS9p7xjFNFDufNLWMEFBqJJn
 z+NnW+lFWrEETlHORVa2VfTmvXN3SP/b1GRZ5B7lK4vqFo1KBKAC2IXg6PKqyDTmHsHC
 Kd+cqEh4mR3Xqjs52mW481HqO5mOf1Bv6tG3Ct6sWKJ46w94c61oG/jBm/k43c5csJFC jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jjb52xfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 11:14:35 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TF8SOs033764;
        Mon, 29 Mar 2021 11:14:34 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jjb52xeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 11:14:34 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TFBvrZ017006;
        Mon, 29 Mar 2021 15:14:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 37hvb890ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 15:14:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TFEUuM37355876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 15:14:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73AA0AE057;
        Mon, 29 Mar 2021 15:14:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A973AE053;
        Mon, 29 Mar 2021 15:14:27 +0000 (GMT)
Received: from pomme.local (unknown [9.211.151.38])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 15:14:26 +0000 (GMT)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20210326191720.138155-1-dima@arista.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <f97f3ff9-6ae2-64cc-fada-49fcac34ae47@linux.ibm.com>
Date:   Mon, 29 Mar 2021 17:14:25 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210326191720.138155-1-dima@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0ZeD3mOYIDQjEyPyLNH0Jsh3tCMfaCbN
X-Proofpoint-ORIG-GUID: rdkF4NXxczH2_K7j2msf9U-x8Io73J8c
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_10:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290114
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

I run the CRIU's test suite and except the usual suspects, all the tests passed.

Tested-by: Laurent Dufour <ldufour@linux.ibm.com>

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
>   
> -	current->mm->context.vdso = (void __user *)new_vma->vm_start + PAGE_SIZE;
> +	current->mm->context.vdso = (void __user *)new_vma->vm_start;
>   
>   	return 0;
>   }
> @@ -73,6 +73,10 @@ static int vdso64_mremap(const struct vm_special_mapping *sm, struct vm_area_str
>   	return vdso_mremap(sm, new_vma, &vdso64_end - &vdso64_start);
>   }
>   
> +static struct vm_special_mapping vvar_spec __ro_after_init = {
> +	.name = "[vvar]",
> +};
> +
>   static struct vm_special_mapping vdso32_spec __ro_after_init = {
>   	.name = "[vdso]",
>   	.mremap = vdso32_mremap,
> @@ -89,11 +93,11 @@ static struct vm_special_mapping vdso64_spec __ro_after_init = {
>    */
>   static int __arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
>   {
> -	struct mm_struct *mm = current->mm;
> +	unsigned long vdso_size, vdso_base, mappings_size;
>   	struct vm_special_mapping *vdso_spec;
> +	unsigned long vvar_size = PAGE_SIZE;
> +	struct mm_struct *mm = current->mm;
>   	struct vm_area_struct *vma;
> -	unsigned long vdso_size;
> -	unsigned long vdso_base;
>   
>   	if (is_32bit_task()) {
>   		vdso_spec = &vdso32_spec;
> @@ -110,8 +114,8 @@ static int __arch_setup_additional_pages(struct linux_binprm *bprm, int uses_int
>   		vdso_base = 0;
>   	}
>   
> -	/* Add a page to the vdso size for the data page */
> -	vdso_size += PAGE_SIZE;
> +	mappings_size = vdso_size + vvar_size;
> +	mappings_size += (VDSO_ALIGNMENT - 1) & PAGE_MASK;
>   
>   	/*
>   	 * pick a base address for the vDSO in process space. We try to put it
> @@ -119,9 +123,7 @@ static int __arch_setup_additional_pages(struct linux_binprm *bprm, int uses_int
>   	 * and end up putting it elsewhere.
>   	 * Add enough to the size so that the result can be aligned.
>   	 */
> -	vdso_base = get_unmapped_area(NULL, vdso_base,
> -				      vdso_size + ((VDSO_ALIGNMENT - 1) & PAGE_MASK),
> -				      0, 0);
> +	vdso_base = get_unmapped_area(NULL, vdso_base, mappings_size, 0, 0);
>   	if (IS_ERR_VALUE(vdso_base))
>   		return vdso_base;
>   
> @@ -133,7 +135,13 @@ static int __arch_setup_additional_pages(struct linux_binprm *bprm, int uses_int
>   	 * install_special_mapping or the perf counter mmap tracking code
>   	 * will fail to recognise it as a vDSO.
>   	 */
> -	mm->context.vdso = (void __user *)vdso_base + PAGE_SIZE;
> +	mm->context.vdso = (void __user *)vdso_base + vvar_size;
> +
> +	vma = _install_special_mapping(mm, vdso_base, vvar_size,
> +				       VM_READ | VM_MAYREAD | VM_IO |
> +				       VM_DONTDUMP | VM_PFNMAP, &vvar_spec);
> +	if (IS_ERR(vma))
> +		return PTR_ERR(vma);
>   
>   	/*
>   	 * our vma flags don't have VM_WRITE so by default, the process isn't
> @@ -145,9 +153,12 @@ static int __arch_setup_additional_pages(struct linux_binprm *bprm, int uses_int
>   	 * It's fine to use that for setting breakpoints in the vDSO code
>   	 * pages though.
>   	 */
> -	vma = _install_special_mapping(mm, vdso_base, vdso_size,
> +	vma = _install_special_mapping(mm, vdso_base + vvar_size, vdso_size,
>   				       VM_READ | VM_EXEC | VM_MAYREAD |
>   				       VM_MAYWRITE | VM_MAYEXEC, vdso_spec);
> +	if (IS_ERR(vma))
> +		do_munmap(mm, vdso_base, vvar_size, NULL);
> +
>   	return PTR_ERR_OR_ZERO(vma);
>   }
>   
> @@ -249,11 +260,22 @@ static struct page ** __init vdso_setup_pages(void *start, void *end)
>   	if (!pagelist)
>   		panic("%s: Cannot allocate page list for VDSO", __func__);
>   
> -	pagelist[0] = virt_to_page(vdso_data);
> -
>   	for (i = 0; i < pages; i++)
> -		pagelist[i + 1] = virt_to_page(start + i * PAGE_SIZE);
> +		pagelist[i] = virt_to_page(start + i * PAGE_SIZE);
> +
> +	return pagelist;
> +}
> +
> +static struct page ** __init vvar_setup_pages(void)
> +{
> +	struct page **pagelist;
>   
> +	/* .pages is NULL-terminated */
> +	pagelist = kcalloc(2, sizeof(struct page *), GFP_KERNEL);
> +	if (!pagelist)
> +		panic("%s: Cannot allocate page list for VVAR", __func__);
> +
> +	pagelist[0] = virt_to_page(vdso_data);
>   	return pagelist;
>   }
>   
> @@ -295,6 +317,8 @@ static int __init vdso_init(void)
>   	if (IS_ENABLED(CONFIG_PPC64))
>   		vdso64_spec.pages = vdso_setup_pages(&vdso64_start, &vdso64_end);
>   
> +	vvar_spec.pages = vvar_setup_pages();
> +
>   	smp_wmb();
>   
>   	return 0;
> 

