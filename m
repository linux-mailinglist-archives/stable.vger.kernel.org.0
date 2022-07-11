Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33DC56FD36
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiGKJwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiGKJu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8D631DE1;
        Mon, 11 Jul 2022 02:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A726112E;
        Mon, 11 Jul 2022 09:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B370C34115;
        Mon, 11 Jul 2022 09:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531505;
        bh=GIfK8Byv40Doke3jciY44/Uks9FgkwxfoZqJmMCfspU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cI2eFNrPH3CA4sUoiUMUW61Q+zvoj7YK4UCO3XbZ+gXo6egVOQfaIfgjucDoiJ6hk
         +z1UJ+cF9ZtvKDhKRRhcpXj6q8vmF35/vbJu5miAHJ2Snn3XXQC/+eeC4Bloqe8sEu
         WxQhDf309dO7q854jXxDYgDzCDO6wWiGpoSX9e8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Yang Shi <shy828301@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Ding Hui <dinghui@sangfor.com.cn>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/230] mm/hwpoison: mf_mutex for soft offline and unpoison
Date:   Mon, 11 Jul 2022 11:06:23 +0200
Message-Id: <20220711090607.668206816@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

[ Upstream commit 91d005479e06392617bacc114509d611b705eaac ]

Patch series "mm/hwpoison: fix unpoison_memory()", v4.

The main purpose of this series is to sync unpoison code to recent
changes around how hwpoison code takes page refcount.  Unpoison should
work or simply fail (without crash) if impossible.

The recent works of keeping hwpoison pages in shmem pagecache introduce
a new state of hwpoisoned pages, but unpoison for such pages is not
supported yet with this series.

It seems that soft-offline and unpoison can be used as general purpose
page offline/online mechanism (not in the context of memory error).  I
think that we need some additional works to realize it because currently
soft-offline and unpoison are assumed not to happen so frequently (print
out too many messages for aggressive usecases).  But anyway this could
be another interesting next topic.

v1: https://lore.kernel.org/linux-mm/20210614021212.223326-1-nao.horiguchi@gmail.com/
v2: https://lore.kernel.org/linux-mm/20211025230503.2650970-1-naoya.horiguchi@linux.dev/
v3: https://lore.kernel.org/linux-mm/20211105055058.3152564-1-naoya.horiguchi@linux.dev/

This patch (of 3):

Originally mf_mutex is introduced to serialize multiple MCE events, but
it is not that useful to allow unpoison to run in parallel with
memory_failure() and soft offline.  So apply mf_mutex to soft offline
and unpoison.  The memory failure handler and soft offline handler get
simpler with this.

Link: https://lkml.kernel.org/r/20211115084006.3728254-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20211115084006.3728254-2-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ding Hui <dinghui@sangfor.com.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 62 +++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 44 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c3ceb7436933..e6425d959fa9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1463,14 +1463,6 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 	lock_page(head);
 	page_flags = head->flags;
 
-	if (!PageHWPoison(head)) {
-		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_dec();
-		unlock_page(head);
-		put_page(head);
-		return 0;
-	}
-
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
@@ -1584,6 +1576,8 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	return rc;
 }
 
+static DEFINE_MUTEX(mf_mutex);
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1610,7 +1604,6 @@ int memory_failure(unsigned long pfn, int flags)
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
-	static DEFINE_MUTEX(mf_mutex);
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1744,16 +1737,6 @@ int memory_failure(unsigned long pfn, int flags)
 	 */
 	page_flags = p->flags;
 
-	/*
-	 * unpoison always clear PG_hwpoison inside page lock
-	 */
-	if (!PageHWPoison(p)) {
-		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_dec();
-		unlock_page(p);
-		put_page(p);
-		goto unlock_mutex;
-	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
@@ -1934,6 +1917,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
+	int ret = 0;
 	unsigned long flags = 0;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
@@ -1944,39 +1928,30 @@ int unpoison_memory(unsigned long pfn)
 	p = pfn_to_page(pfn);
 	page = compound_head(p);
 
+	mutex_lock(&mf_mutex);
+
 	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_count(page) > 1) {
 		unpoison_pr_info("Unpoison: Someone grabs the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_mapped(page)) {
 		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_mapping(page)) {
 		unpoison_pr_info("Unpoison: the hwpoison page has non-NULL mapping %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
-	}
-
-	/*
-	 * unpoison_memory() can encounter thp only when the thp is being
-	 * worked by memory_failure() and the page lock is not held yet.
-	 * In such case, we yield to memory_failure() and make unpoison fail.
-	 */
-	if (!PageHuge(page) && PageTransHuge(page)) {
-		unpoison_pr_info("Unpoison: Memory failure is now running on %#lx\n",
-				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (!get_hwpoison_page(p, flags)) {
@@ -1984,29 +1959,23 @@ int unpoison_memory(unsigned long pfn)
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
-	lock_page(page);
-	/*
-	 * This test is racy because PG_hwpoison is set outside of page lock.
-	 * That's acceptable because that won't trigger kernel panic. Instead,
-	 * the PG_hwpoison page will be caught and isolated on the entrance to
-	 * the free buddy page pool.
-	 */
 	if (TestClearPageHWPoison(page)) {
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 pfn, &unpoison_rs);
 		num_poisoned_pages_dec();
 		freeit = 1;
 	}
-	unlock_page(page);
 
 	put_page(page);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
 		put_page(page);
 
-	return 0;
+unlock_mutex:
+	mutex_unlock(&mf_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(unpoison_memory);
 
@@ -2187,9 +2156,12 @@ int soft_offline_page(unsigned long pfn, int flags)
 		return -EIO;
 	}
 
+	mutex_lock(&mf_mutex);
+
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
 		put_ref_page(ref_page);
+		mutex_unlock(&mf_mutex);
 		return 0;
 	}
 
@@ -2208,5 +2180,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 		}
 	}
 
+	mutex_unlock(&mf_mutex);
+
 	return ret;
 }
-- 
2.35.1



