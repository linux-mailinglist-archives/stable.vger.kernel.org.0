Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2234CFC64
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 12:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241825AbiCGLNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 06:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242222AbiCGLNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 06:13:14 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8D1EDF4A5;
        Mon,  7 Mar 2022 02:35:25 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E73AED1;
        Mon,  7 Mar 2022 02:35:25 -0800 (PST)
Received: from [10.57.39.47] (unknown [10.57.39.47])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C7C63F73D;
        Mon,  7 Mar 2022 02:35:24 -0800 (PST)
Message-ID: <34442eae-a30d-5144-0fc5-edee35bee7b9@arm.com>
Date:   Mon, 7 Mar 2022 10:35:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Patch "iommu/amd: Simplify pagetable freeing" has been added to
 the 5.15-stable tree
Content-Language: en-GB
To:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
References: <20220305210025.146536-1-sashal@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220305210025.146536-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-05 21:00, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>      iommu/amd: Simplify pagetable freeing
> 
> to the 5.15-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       iommu-amd-simplify-pagetable-freeing.patch
> and it can be found in the queue-5.15 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

I don't think this one qualifies for stable - it was just a refactoring 
to aid future development. The "fixing" of types is merely cosmetic, and 
the code size benefit was just a little bonus, hardly significant.

Thanks,
Robin.

> commit 3ccd31a933e9a08a64a803d7fda5cb64a48e5229
> Author: Robin Murphy <robin.murphy@arm.com>
> Date:   Fri Dec 17 15:30:58 2021 +0000
> 
>      iommu/amd: Simplify pagetable freeing
>      
>      [ Upstream commit 6b3106e9ba2de7320a71291cedcefdcf1195ad58 ]
>      
>      For reasons unclear, pagetable freeing is an effectively recursive
>      method implemented via an elaborate system of templated functions that
>      turns out to account for 25% of the object file size. Implementing it
>      using regular straightforward recursion makes the code simpler, and
>      seems like a good thing to do before we work on it further. As part of
>      that, also fix the types to avoid all the needless casting back and
>      forth which just gets in the way.
>      
>      Signed-off-by: Robin Murphy <robin.murphy@arm.com>
>      Link: https://lore.kernel.org/r/d3d00c9f3fa0df4756b867072c201e6e82f9ce39.1639753638.git.robin.murphy@arm.com
>      Signed-off-by: Joerg Roedel <jroedel@suse.de>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index 182c93a43efd..4165e1372b6e 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -84,49 +84,45 @@ static void free_page_list(struct page *freelist)
>   	}
>   }
>   
> -static struct page *free_pt_page(unsigned long pt, struct page *freelist)
> +static struct page *free_pt_page(u64 *pt, struct page *freelist)
>   {
> -	struct page *p = virt_to_page((void *)pt);
> +	struct page *p = virt_to_page(pt);
>   
>   	p->freelist = freelist;
>   
>   	return p;
>   }
>   
> -#define DEFINE_FREE_PT_FN(LVL, FN)						\
> -static struct page *free_pt_##LVL (unsigned long __pt, struct page *freelist)	\
> -{										\
> -	unsigned long p;							\
> -	u64 *pt;								\
> -	int i;									\
> -										\
> -	pt = (u64 *)__pt;							\
> -										\
> -	for (i = 0; i < 512; ++i) {						\
> -		/* PTE present? */						\
> -		if (!IOMMU_PTE_PRESENT(pt[i]))					\
> -			continue;						\
> -										\
> -		/* Large PTE? */						\
> -		if (PM_PTE_LEVEL(pt[i]) == 0 ||					\
> -		    PM_PTE_LEVEL(pt[i]) == 7)					\
> -			continue;						\
> -										\
> -		p = (unsigned long)IOMMU_PTE_PAGE(pt[i]);			\
> -		freelist = FN(p, freelist);					\
> -	}									\
> -										\
> -	return free_pt_page((unsigned long)pt, freelist);			\
> -}
> +static struct page *free_pt_lvl(u64 *pt, struct page *freelist, int lvl)
> +{
> +	u64 *p;
> +	int i;
> +
> +	for (i = 0; i < 512; ++i) {
> +		/* PTE present? */
> +		if (!IOMMU_PTE_PRESENT(pt[i]))
> +			continue;
>   
> -DEFINE_FREE_PT_FN(l2, free_pt_page)
> -DEFINE_FREE_PT_FN(l3, free_pt_l2)
> -DEFINE_FREE_PT_FN(l4, free_pt_l3)
> -DEFINE_FREE_PT_FN(l5, free_pt_l4)
> -DEFINE_FREE_PT_FN(l6, free_pt_l5)
> +		/* Large PTE? */
> +		if (PM_PTE_LEVEL(pt[i]) == 0 ||
> +		    PM_PTE_LEVEL(pt[i]) == 7)
> +			continue;
>   
> -static struct page *free_sub_pt(unsigned long root, int mode,
> -				struct page *freelist)
> +		/*
> +		 * Free the next level. No need to look at l1 tables here since
> +		 * they can only contain leaf PTEs; just free them directly.
> +		 */
> +		p = IOMMU_PTE_PAGE(pt[i]);
> +		if (lvl > 2)
> +			freelist = free_pt_lvl(p, freelist, lvl - 1);
> +		else
> +			freelist = free_pt_page(p, freelist);
> +	}
> +
> +	return free_pt_page(pt, freelist);
> +}
> +
> +static struct page *free_sub_pt(u64 *root, int mode, struct page *freelist)
>   {
>   	switch (mode) {
>   	case PAGE_MODE_NONE:
> @@ -136,19 +132,11 @@ static struct page *free_sub_pt(unsigned long root, int mode,
>   		freelist = free_pt_page(root, freelist);
>   		break;
>   	case PAGE_MODE_2_LEVEL:
> -		freelist = free_pt_l2(root, freelist);
> -		break;
>   	case PAGE_MODE_3_LEVEL:
> -		freelist = free_pt_l3(root, freelist);
> -		break;
>   	case PAGE_MODE_4_LEVEL:
> -		freelist = free_pt_l4(root, freelist);
> -		break;
>   	case PAGE_MODE_5_LEVEL:
> -		freelist = free_pt_l5(root, freelist);
> -		break;
>   	case PAGE_MODE_6_LEVEL:
> -		freelist = free_pt_l6(root, freelist);
> +		free_pt_lvl(root, freelist, mode);
>   		break;
>   	default:
>   		BUG();
> @@ -364,7 +352,7 @@ static u64 *fetch_pte(struct amd_io_pgtable *pgtable,
>   
>   static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
>   {
> -	unsigned long pt;
> +	u64 *pt;
>   	int mode;
>   
>   	while (cmpxchg64(pte, pteval, 0) != pteval) {
> @@ -375,7 +363,7 @@ static struct page *free_clear_pte(u64 *pte, u64 pteval, struct page *freelist)
>   	if (!IOMMU_PTE_PRESENT(pteval))
>   		return freelist;
>   
> -	pt   = (unsigned long)IOMMU_PTE_PAGE(pteval);
> +	pt   = IOMMU_PTE_PAGE(pteval);
>   	mode = IOMMU_PTE_MODE(pteval);
>   
>   	return free_sub_pt(pt, mode, freelist);
> @@ -512,7 +500,6 @@ static void v1_free_pgtable(struct io_pgtable *iop)
>   	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
>   	struct protection_domain *dom;
>   	struct page *freelist = NULL;
> -	unsigned long root;
>   
>   	if (pgtable->mode == PAGE_MODE_NONE)
>   		return;
> @@ -529,8 +516,7 @@ static void v1_free_pgtable(struct io_pgtable *iop)
>   	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
>   	       pgtable->mode > PAGE_MODE_6_LEVEL);
>   
> -	root = (unsigned long)pgtable->root;
> -	freelist = free_sub_pt(root, pgtable->mode, freelist);
> +	freelist = free_sub_pt(pgtable->root, pgtable->mode, freelist);
>   
>   	free_page_list(freelist);
>   }
