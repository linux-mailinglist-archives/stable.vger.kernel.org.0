Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68BA68D8E0
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjBGNNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjBGNNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:13:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545865FFD
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:13:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35F1561446
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D4EC433EF;
        Tue,  7 Feb 2023 13:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775584;
        bh=Mgg3cAJRFDSoru45/u6M+MdN6f72SHrtzogyhFeWw/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhD7/9rQD9vX+a37EqM0AukdwlbTPGAKX6H/g5VVsywRT8ASwZaCkjn8fjG/0IHj0
         x/CcyRJRioHlxUg+Y1aIXof0Qqma/CQXC7lM9lqTBPCbxGnJOqAI0IfDbd7RH997xD
         ODfqlu9gLGAsuRQNwN6gFMqoiTS6/cfG0VSIQlE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 090/120] mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
Date:   Tue,  7 Feb 2023 13:57:41 +0100
Message-Id: <20230207125622.585794692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 3489dbb696d25602aea8c3e669a6d43b76bd5358 upstream.

Patch series "Fixes for hugetlb mapcount at most 1 for shared PMDs".

This issue of mapcount in hugetlb pages referenced by shared PMDs was
discussed in [1].  The following two patches address user visible behavior
caused by this issue.

[1] https://lore.kernel.org/linux-mm/Y9BF+OCdWnCSilEu@monkey/


This patch (of 2):

A hugetlb page will have a mapcount of 1 if mapped by multiple processes
via a shared PMD.  This is because only the first process increases the
map count, and subsequent processes just add the shared PMD page to their
page table.

page_mapcount is being used to decide if a hugetlb page is shared or
private in /proc/PID/smaps.  Pages referenced via a shared PMD were
incorrectly being counted as private.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is found
count the hugetlb page as shared.  A new helper to check for a shared PMD
is added.

[akpm@linux-foundation.org: simplification, per David]
[akpm@linux-foundation.org: hugetlb.h: include page_ref.h for page_count()]
Link: https://lkml.kernel.org/r/20230126222721.222195-2-mike.kravetz@oracle.com
Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c      |    4 +---
 include/linux/hugetlb.h |   13 +++++++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -714,9 +714,7 @@ static int smaps_hugetlb_range(pte_t *pt
 			page = pfn_swap_entry_to_page(swpent);
 	}
 	if (page) {
-		int mapcount = page_mapcount(page);
-
-		if (mapcount >= 2)
+		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
+#include <linux/page_ref.h>
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/pgtable.h>
@@ -1099,6 +1100,18 @@ static inline __init void hugetlb_cma_ch
 }
 #endif
 
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return page_count(virt_to_page(pte)) > 1;
+}
+#else
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return false;
+}
+#endif
+
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
 
 #ifndef __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE


