Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349D52D557
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 08:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbfE2GFd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 02:05:33 -0400
Received: from tyo162.gate.nec.co.jp ([114.179.232.162]:58297 "EHLO
        tyo162.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfE2GFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 02:05:33 -0400
Received: from mailgate01.nec.co.jp ([114.179.233.122])
        by tyo162.gate.nec.co.jp (8.15.1/8.15.1) with ESMTPS id x4T65LwP005817
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 29 May 2019 15:05:21 +0900
Received: from mailsv01.nec.co.jp (mailgate-v.nec.co.jp [10.204.236.94])
        by mailgate01.nec.co.jp (8.15.1/8.15.1) with ESMTP id x4T65LgN021929;
        Wed, 29 May 2019 15:05:21 +0900
Received: from mail03.kamome.nec.co.jp (mail03.kamome.nec.co.jp [10.25.43.7])
        by mailsv01.nec.co.jp (8.15.1/8.15.1) with ESMTP id x4T62hCB021341;
        Wed, 29 May 2019 15:05:20 +0900
Received: from bpxc99gp.gisp.nec.co.jp ([10.38.151.149] [10.38.151.149]) by mail03.kamome.nec.co.jp with ESMTP id BT-MMP-819150; Wed, 29 May 2019 15:03:56 +0900
Received: from BPXM23GP.gisp.nec.co.jp ([10.38.151.215]) by
 BPXC21GP.gisp.nec.co.jp ([10.38.151.149]) with mapi id 14.03.0319.002; Wed,
 29 May 2019 15:03:55 +0900
From:   Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC:     "jerry.t.chen@intel.com" <jerry.t.chen@intel.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "qiuxu.zhuo@intel.com" <qiuxu.zhuo@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: +
 mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch added
 to -mm tree
Thread-Topic: +
 mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch added
 to -mm tree
Thread-Index: AQHVFdTagkS4/daLmkCfD8Rm4Htjs6aBBhQA
Date:   Wed, 29 May 2019 06:03:54 +0000
Message-ID: <20190529060400.GA5006@hori.linux.bs1.fc.nec.co.jp>
References: <20190529041317.8AArwlzU1%akpm@linux-foundation.org>
In-Reply-To: <20190529041317.8AArwlzU1%akpm@linux-foundation.org>
Accept-Language: en-US, ja-JP
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.34.125.150]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <2ECF3E738B36334DA3F253135AAF2D4D@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

Jerry found that current version crash with null pointer access,
so could you drop this patch from -mm for a while?
I'll try to understand the situation, and repost more robust one.

Thanks,
Naoya Horiguchi

On Tue, May 28, 2019 at 09:13:17PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: hugetlb: soft-offline: fix wrong return value of soft offline
> has been added to the -mm tree.  Its filename is
>      mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Subject: mm: hugetlb: soft-offline: fix wrong return value of soft offline
> 
> Soft offline events for hugetlb pages return -EBUSY when page migration
> succeeded and dissolve_free_huge_page() failed, which can happen when
> there're surplus hugepages.  We should judge pass/fail of soft offline by
> checking whether the raw error page was finally contained or not (i.e. 
> the result of set_hwpoison_free_buddy_page()), so this behavior is wrong.
> 
> This problem was introduced by the following change of commit 6bc9b56433b76
> ("mm: fix race on soft-offlining"):
> 
>                     if (ret > 0)
>                             ret = -EIO;
>             } else {
>     -               if (PageHuge(page))
>     -                       dissolve_free_huge_page(page);
>     +               /*
>     +                * We set PG_hwpoison only when the migration source hugepage
>     +                * was successfully dissolved, because otherwise hwpoisoned
>     +                * hugepage remains on free hugepage list, then userspace will
>     +                * find it as SIGBUS by allocation failure. That's not expected
>     +                * in soft-offlining.
>     +                */
>     +               ret = dissolve_free_huge_page(page);
>     +               if (!ret) {
>     +                       if (set_hwpoison_free_buddy_page(page))
>     +                               num_poisoned_pages_inc();
>     +               }
>             }
>             return ret;
>      }
> 
> so a simple fix is to restore the PageHuge precheck, but my code reading
> shows that we already have PageHuge check in dissolve_free_huge_page()
> with hugetlb_lock, which is better place to check it.  And currently
> dissolve_free_huge_page() returns -EBUSY for !PageHuge but that's simply
> wrong because that that case should be considered as success (meaning that
> "the given hugetlb was already dissolved.")
> 
> This change affects other callers of dissolve_free_huge_page(), which are
> also cleaned up by this patch.
> 
> Link: http://lkml.kernel.org/r/1558937200-18544-1-git-send-email-n-horiguchi@ah.jp.nec.com
> Fixes: 6bc9b56433b76 ("mm: fix race on soft-offlining")
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reported-by: Chen, Jerry T <jerry.t.chen@intel.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
> Cc: <stable@vger.kernel.org>	[4.19+]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/hugetlb.c        |   15 +++++++++------
>  mm/memory-failure.c |    7 +++----
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> --- a/mm/hugetlb.c~mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline
> +++ a/mm/hugetlb.c
> @@ -1519,7 +1519,12 @@ int dissolve_free_huge_page(struct page
>  	int rc = -EBUSY;
>  
>  	spin_lock(&hugetlb_lock);
> -	if (PageHuge(page) && !page_count(page)) {
> +	if (!PageHuge(page)) {
> +		rc = 0;
> +		goto out;
> +	}
> +
> +	if (!page_count(page)) {
>  		struct page *head = compound_head(page);
>  		struct hstate *h = page_hstate(head);
>  		int nid = page_to_nid(head);
> @@ -1564,11 +1569,9 @@ int dissolve_free_huge_pages(unsigned lo
>  
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order) {
>  		page = pfn_to_page(pfn);
> -		if (PageHuge(page) && !page_count(page)) {
> -			rc = dissolve_free_huge_page(page);
> -			if (rc)
> -				break;
> -		}
> +		rc = dissolve_free_huge_page(page);
> +		if (rc)
> +			break;
>  	}
>  
>  	return rc;
> --- a/mm/memory-failure.c~mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline
> +++ a/mm/memory-failure.c
> @@ -1733,6 +1733,8 @@ static int soft_offline_huge_page(struct
>  		if (!ret) {
>  			if (set_hwpoison_free_buddy_page(page))
>  				num_poisoned_pages_inc();
> +			else
> +				ret = -EBUSY;
>  		}
>  	}
>  	return ret;
> @@ -1857,11 +1859,8 @@ static int soft_offline_in_use_page(stru
>  
>  static int soft_offline_free_page(struct page *page)
>  {
> -	int rc = 0;
> -	struct page *head = compound_head(page);
> +	int rc = dissolve_free_huge_page(page);
>  
> -	if (PageHuge(head))
> -		rc = dissolve_free_huge_page(page);
>  	if (!rc) {
>  		if (set_hwpoison_free_buddy_page(page))
>  			num_poisoned_pages_inc();
> _
> 
> Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are
> 
> mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch
> 
> 
