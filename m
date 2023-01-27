Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0265767F1F4
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 00:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjA0XET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 18:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjA0XES (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 18:04:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0AE8BB80;
        Fri, 27 Jan 2023 15:04:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35CF861DC4;
        Fri, 27 Jan 2023 23:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E7AC433D2;
        Fri, 27 Jan 2023 23:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674860652;
        bh=vXb6OGR3jjuhguEAysSQHpLS55ZCH4lzC8q7qrmExC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GeXLPEFPnmXnybEa25WwdFpTpr2nhYU8dLL7E2sH4CFNOzfVOkdnfEsFzv+w1P77i
         ZFHD1cIyfbt01v+7INXSaQrNBZu9xQCzZVaHHdD09PqZPS918tHEKQ7Y1NXN0O362B
         SeJxlYCZqBX14TKSM/4XPHIjm5y0xIrxE6v2kSgs=
Date:   Fri, 27 Jan 2023 15:04:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-Id: <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
In-Reply-To: <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
        <20230126222721.222195-2-mike.kravetz@oracle.com>
        <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 Jan 2023 17:23:39 +0100 David Hildenbrand <david@redhat.com> wrote:

> On 26.01.23 23:27, Mike Kravetz wrote:
> > A hugetlb page will have a mapcount of 1 if mapped by multiple processes
> > via a shared PMD.  This is because only the first process increases the
> > map count, and subsequent processes just add the shared PMD page to
> > their page table.
> > 
> > page_mapcount is being used to decide if a hugetlb page is shared or
> > private in /proc/PID/smaps.  Pages referenced via a shared PMD were
> > incorrectly being counted as private.
> > 
> > To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is
> > found count the hugetlb page as shared.  A new helper to check for a
> > shared PMD is added.
> > 
> ...
>
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -749,8 +749,14 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
> >   
> >   		if (mapcount >= 2)
> >   			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> > -		else
> > -			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> > +		else {
> 
> Better:
> 
> if (mapcount >= 2 || hugetlb_pmd_shared(pte))
> 	mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> else
> 	mss->private_hugetlb += huge_page_size(hstate_vma(vma));

Yup.  And that local doesn't add any value?

--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
+++ a/fs/proc/task_mmu.c
@@ -745,18 +745,10 @@ static int smaps_hugetlb_range(pte_t *pt
 			page = pfn_swap_entry_to_page(swpent);
 	}
 	if (page) {
-		int mapcount = page_mapcount(page);
-
-		if (mapcount >= 2)
+		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
-		else {
-			if (hugetlb_pmd_shared(pte))
-				mss->shared_hugetlb +=
-						huge_page_size(hstate_vma(vma));
-			else
-				mss->private_hugetlb +=
-						huge_page_size(hstate_vma(vma));
-		}
+		else
+			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
 	return 0;
 }
_

