Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F00F42393D
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 09:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbhJFH5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 03:57:07 -0400
Received: from foss.arm.com ([217.140.110.172]:54532 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhJFH5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 03:57:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70974D6E;
        Wed,  6 Oct 2021 00:55:15 -0700 (PDT)
Received: from [10.163.75.2] (unknown [10.163.75.2])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E85353F766;
        Wed,  6 Oct 2021 00:55:12 -0700 (PDT)
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] arm64/hugetlb: fix CMA gigantic page order for non-4K
 PAGE_SIZE
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20211005202529.213812-1-mike.kravetz@oracle.com>
Message-ID: <18a86369-7ee2-0bc9-98f1-84fa595a1ee0@arm.com>
Date:   Wed, 6 Oct 2021 13:25:09 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211005202529.213812-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/6/21 1:55 AM, Mike Kravetz wrote:
> For non-4K PAGE_SIZE configs, the largest gigantic huge page size is
> CONT_PMD_SHIFT order.
> 
> Fixes: abb7962adc80 ("arm64/hugetlb: Reserve CMA areas for gigantic
> pages on 16K and 64K configs")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/mm/hugetlbpage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 23505fc35324..a8158c948966 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -43,7 +43,7 @@ void __init arm64_hugetlb_cma_reserve(void)
>  #ifdef CONFIG_ARM64_4K_PAGES
>  	order = PUD_SHIFT - PAGE_SHIFT;
>  #else
> -	order = CONT_PMD_SHIFT + PMD_SHIFT - PAGE_SHIFT;
> +	order = CONT_PMD_SHIFT - PAGE_SHIFT;
>  #endif
>  	/*
>  	 * HugeTLB CMA reservation is required for gigantic
> 

The commit a1634a542f74 ("arm64/mm: Redefine CONT_{PTE, PMD}_SHIFT")
which got merged during the exact same week, broke the above commit
as both were in flight. The commit here updated hugetlbpage_init()
but did not update the new incoming arm64_hugetlb_cma_reserve().
