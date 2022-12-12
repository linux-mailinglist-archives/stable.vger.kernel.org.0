Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457C4649FA2
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiLLNNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiLLNNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59072C0E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:12:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5F0F61042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2C3C433EF;
        Mon, 12 Dec 2022 13:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850765;
        bh=lO1ixzgRFUac6AKRZ+5jJqszzrvsSRrCpMAdiKxkg8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVevHU+gsxyTTPkvlNNqtltyu163mBGF0kqmqHVafFcdM8pQ0zmgJAZGCz8JZF096
         jcgIl1xEKDM4VBpDe7iUc5sWZm/MiDBQWsrG9VtlHN9w4ONHDDItUGinfqsr4EeUf4
         j/A3NzSFaQ5Ce0+dzgjL6GzucKA9xp8hB7Zte0v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Hugh Dickins <hughd@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Huang, Ying" <ying.huang@intel.com>, Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/106] mm/lru: introduce TestClearPageLRU()
Date:   Mon, 12 Dec 2022 14:09:06 +0100
Message-Id: <20221212130925.017073911@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit d25b5bd8a8f420b15517c19c4626c0c009f72a63 ]

Currently lru_lock still guards both lru list and page's lru bit, that's
ok.  but if we want to use specific lruvec lock on the page, we need to
pin down the page's lruvec/memcg during locking.  Just taking lruvec lock
first may be undermined by the page's memcg charge/migration.  To fix this
problem, we will clear the lru bit out of locking and use it as pin down
action to block the page isolation in memcg changing.

So now a standard steps of page isolation is following:
	1, get_page(); 	       #pin the page avoid to be free
	2, TestClearPageLRU(); #block other isolation like memcg change
	3, spin_lock on lru_lock; #serialize lru list access
	4, delete page from lru list;

This patch start with the first part: TestClearPageLRU, which combines
PageLRU check and ClearPageLRU into a macro func TestClearPageLRU.  This
function will be used as page isolation precondition to prevent other
isolations some where else.  Then there are may !PageLRU page on lru list,
need to remove BUG() checking accordingly.

There 2 rules for lru bit now:
1, the lru bit still indicate if a page on lru list, just in some
   temporary moment(isolating), the page may have no lru bit when
   it's on lru list.  but the page still must be on lru list when the
   lru bit set.
2, have to remove lru bit before delete it from lru list.

As Andrew Morton mentioned this change would dirty cacheline for a page
which isn't on the LRU.  But the loss would be acceptable in Rong Chen
<rong.a.chen@intel.com> report:
https://lore.kernel.org/lkml/20200304090301.GB5972@shao2-debian/

Link: https://lkml.kernel.org/r/1604566549-62481-15-git-send-email-alex.shi@linux.alibaba.com
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttilä <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/page-flags.h |  1 +
 mm/mlock.c                 |  3 +--
 mm/vmscan.c                | 39 +++++++++++++++++++-------------------
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4f6ba9379112..14a0cac9e099 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -335,6 +335,7 @@ PAGEFLAG(Referenced, referenced, PF_HEAD)
 PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
+	TESTCLEARFLAG(LRU, lru, PF_HEAD)
 PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
 	TESTCLEARFLAG(Active, active, PF_HEAD)
 PAGEFLAG(Workingset, workingset, PF_HEAD)
diff --git a/mm/mlock.c b/mm/mlock.c
index d487aa864e86..7b0e6334be6f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -276,10 +276,9 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 			 * We already have pin from follow_page_mask()
 			 * so we can spare the get_page() here.
 			 */
-			if (PageLRU(page)) {
+			if (TestClearPageLRU(page)) {
 				struct lruvec *lruvec;
 
-				ClearPageLRU(page);
 				lruvec = mem_cgroup_page_lruvec(page,
 							page_pgdat(page));
 				del_page_from_lru_list(page, lruvec,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 51ccd80e70b6..8d62eedfc794 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1547,7 +1547,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
  */
 int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 {
-	int ret = -EINVAL;
+	int ret = -EBUSY;
 
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
@@ -1557,8 +1557,6 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
 
-	ret = -EBUSY;
-
 	/*
 	 * To minimise LRU disruption, the caller can indicate that it only
 	 * wants to isolate pages it will be able to operate on without
@@ -1605,8 +1603,10 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 		 * sure the page is not being freed elsewhere -- the
 		 * page release code relies on it.
 		 */
-		ClearPageLRU(page);
-		ret = 0;
+		if (TestClearPageLRU(page))
+			ret = 0;
+		else
+			put_page(page);
 	}
 
 	return ret;
@@ -1672,8 +1672,6 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
 
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
-
 		nr_pages = compound_nr(page);
 		total_scan += nr_pages;
 
@@ -1770,21 +1768,18 @@ int isolate_lru_page(struct page *page)
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
 
-	if (PageLRU(page)) {
+	if (TestClearPageLRU(page)) {
 		pg_data_t *pgdat = page_pgdat(page);
 		struct lruvec *lruvec;
 
-		spin_lock_irq(&pgdat->lru_lock);
+		get_page(page);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		if (PageLRU(page)) {
-			int lru = page_lru(page);
-			get_page(page);
-			ClearPageLRU(page);
-			del_page_from_lru_list(page, lruvec, lru);
-			ret = 0;
-		}
+		spin_lock_irq(&pgdat->lru_lock);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
 		spin_unlock_irq(&pgdat->lru_lock);
+		ret = 0;
 	}
+
 	return ret;
 }
 
@@ -4291,6 +4286,10 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 		nr_pages = thp_nr_pages(page);
 		pgscanned += nr_pages;
 
+		/* block memcg migration during page moving between lru */
+		if (!TestClearPageLRU(page))
+			continue;
+
 		if (pagepgdat != pgdat) {
 			if (pgdat)
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -4299,10 +4298,7 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 		}
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-		if (!PageLRU(page) || !PageUnevictable(page))
-			continue;
-
-		if (page_evictable(page)) {
+		if (page_evictable(page) && PageUnevictable(page)) {
 			enum lru_list lru = page_lru_base_type(page);
 
 			VM_BUG_ON_PAGE(PageActive(page), page);
@@ -4311,12 +4307,15 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 			add_page_to_lru_list(page, lruvec, lru);
 			pgrescued += nr_pages;
 		}
+		SetPageLRU(page);
 	}
 
 	if (pgdat) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 		spin_unlock_irq(&pgdat->lru_lock);
+	} else if (pgscanned) {
+		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 	}
 }
 EXPORT_SYMBOL_GPL(check_move_unevictable_pages);
-- 
2.35.1



