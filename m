Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB989D256
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbfHZPLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:11:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:42904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730583AbfHZPLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 11:11:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4C73AEF6;
        Mon, 26 Aug 2019 15:11:01 +0000 (UTC)
Subject: Re: [PATCH] mm/migrate: initialize pud_entry in migrate_vma()
To:     Ralph Campbell <rcampbell@nvidia.com>, linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20190719233225.12243-1-rcampbell@nvidia.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <0d639edf-9f96-c170-4920-d64c2891d35d@suse.cz>
Date:   Mon, 26 Aug 2019 17:11:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719233225.12243-1-rcampbell@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/20/19 1:32 AM, Ralph Campbell wrote:
> When CONFIG_MIGRATE_VMA_HELPER is enabled, migrate_vma() calls
> migrate_vma_collect() which initializes a struct mm_walk but
> didn't initialize mm_walk.pud_entry. (Found by code inspection)
> Use a C structure initialization to make sure it is set to NULL.
> 
> Fixes: 8763cb45ab967 ("mm/migrate: new memory migration helper for use with
> device memory")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Cc: "Jérôme Glisse" <jglisse@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

So this bug can manifest by some garbage address on stack being called, right? I
wonder, how comes it didn't actually happen yet?

> ---
>  mm/migrate.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 515718392b24..a42858d8e00b 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2340,16 +2340,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  static void migrate_vma_collect(struct migrate_vma *migrate)
>  {
>  	struct mmu_notifier_range range;
> -	struct mm_walk mm_walk;
> -
> -	mm_walk.pmd_entry = migrate_vma_collect_pmd;
> -	mm_walk.pte_entry = NULL;
> -	mm_walk.pte_hole = migrate_vma_collect_hole;
> -	mm_walk.hugetlb_entry = NULL;
> -	mm_walk.test_walk = NULL;
> -	mm_walk.vma = migrate->vma;
> -	mm_walk.mm = migrate->vma->vm_mm;
> -	mm_walk.private = migrate;
> +	struct mm_walk mm_walk = {
> +		.pmd_entry = migrate_vma_collect_pmd,
> +		.pte_hole = migrate_vma_collect_hole,
> +		.vma = migrate->vma,
> +		.mm = migrate->vma->vm_mm,
> +		.private = migrate,
> +	};
>  
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm_walk.mm,
>  				migrate->start,
> 

