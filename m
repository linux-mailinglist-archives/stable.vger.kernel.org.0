Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116005522BB
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 19:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiFTR2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 13:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242488AbiFTR14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 13:27:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDA3384;
        Mon, 20 Jun 2022 10:27:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC48C60ABA;
        Mon, 20 Jun 2022 17:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CB1C3411B;
        Mon, 20 Jun 2022 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655746070;
        bh=G5GtmLDra6Mj3BFy+b9Vvm7SvXbbbJSxaIQXBk1cDAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+EiA5KkFCe1Sr4egatDOyVsNe3RL7c+F91ZXFwhvRjmLyif12dAtV8wozFeolfw6
         pdvqIMIhuN3NQaLBGskji+x9/JP9kTFmCJgFm1NovISDvUlpnMJVO0e8hRiS56CG95
         fv3kgo8fmdjlWLNJlHwdQRWE2YZG1emH0kCvivButPjGoxTslZk8azvrOfkbZrLvEC
         iL/NiILWy0zfSNJhhRUNQ9sSocCTbADvJVC4tIEUoweGOe5LEyPOC9efCqg4G93cWk
         hMNhuJojWmMvN8QObiUlkGM9WGtr+NHfPLi/m1G2GrwrVnlNMdjqrLu3vcLHTgEjLK
         5ITAO/4gGhkbw==
From:   SeongJae Park <sj@kernel.org>
To:     Baolin Wang <baolin.wang@linux.alibaba.com>
Cc:     sj@kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon: Use set_huge_pte_at() to make huge pte old
Date:   Mon, 20 Jun 2022 17:27:42 +0000
Message-Id: <20220620172742.48766-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1655692482-28797-1-git-send-email-baolin.wang@linux.alibaba.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Baolin,

On Mon, 20 Jun 2022 10:34:42 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> The huge_ptep_set_access_flags() can not make the huge pte old according
> to the discussion [1], that means we will always mornitor the young state
> of the hugetlb though we stopped accessing the hugetlb, as a result DAMON
> will get inaccurate accessing statistics.
> 
> So changing to use set_huge_pte_at() to make the huge pte old to fix this
> issue.
> 
> [1] https://lore.kernel.org/all/Yqy97gXI4Nqb7dYo@arm.com/
> 
> Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")

As the commit has merged in from v5.17, I guess it would be better to do below?

Cc: <stable@vger.kernel.org>

> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Other than that,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

> ---
>  mm/damon/vaddr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 5767be72c181..d24148a8149f 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -337,8 +337,7 @@ static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
>  	if (pte_young(entry)) {
>  		referenced = true;
>  		entry = pte_mkold(entry);
> -		huge_ptep_set_access_flags(vma, addr, pte, entry,
> -					   vma->vm_flags & VM_WRITE);
> +		set_huge_pte_at(mm, addr, pte, entry);
>  	}
>  
>  #ifdef CONFIG_MMU_NOTIFIER
> -- 
> 2.27.0
