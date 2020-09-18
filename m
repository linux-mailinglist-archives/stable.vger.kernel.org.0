Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC126F1D6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgIRCyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgIRCHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48F762389E;
        Fri, 18 Sep 2020 02:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394851;
        bh=fR/UbDId/TZwo11/kGB43MSUf1Nix4TokHJyS1Bx8Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnjEOA0ewTwgH0jpeoKeykIQcyHCRtLwQih1PvTXg2rCDqVwTyUn4J1zSNPptg8Kw
         nLshbpbZ+eMBeSJjc+4sZ2xWo10ZdDV1dQMyJgkOgJ8ZF6QX1nBvWZP71y4XGxq4B8
         E6SrEyWRCepAiGsCHtk4WarmDYqf0xGN1h5kn2nM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Shakeel Butt <shakeelb@google.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 307/330] mm: memcontrol: fix stat-corrupting race in charge moving
Date:   Thu, 17 Sep 2020 22:00:47 -0400
Message-Id: <20200918020110.2063155-307-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit abb242f57196dbaa108271575353a0453f6834ef ]

The move_lock is a per-memcg lock, but the VM accounting code that needs
to acquire it comes from the page and follows page->mem_cgroup under RCU
protection.  That means that the page becomes unlocked not when we drop
the move_lock, but when we update page->mem_cgroup.  And that assignment
doesn't imply any memory ordering.  If that pointer write gets reordered
against the reads of the page state - page_mapped, PageDirty etc.  the
state may change while we rely on it being stable and we can end up
corrupting the counters.

Place an SMP memory barrier to make sure we're done with all page state by
the time the new page->mem_cgroup becomes visible.

Also replace the open-coded move_lock with a lock_page_memcg() to make it
more obvious what we're serializing against.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Link: http://lkml.kernel.org/r/20200508183105.225460-3-hannes@cmpxchg.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 402c8bc65e08d..ca1632850fb76 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5489,7 +5489,6 @@ static int mem_cgroup_move_account(struct page *page,
 {
 	struct lruvec *from_vec, *to_vec;
 	struct pglist_data *pgdat;
-	unsigned long flags;
 	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 	int ret;
 	bool anon;
@@ -5516,18 +5515,13 @@ static int mem_cgroup_move_account(struct page *page,
 	from_vec = mem_cgroup_lruvec(pgdat, from);
 	to_vec = mem_cgroup_lruvec(pgdat, to);
 
-	spin_lock_irqsave(&from->move_lock, flags);
+	lock_page_memcg(page);
 
 	if (!anon && page_mapped(page)) {
 		__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
 		__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
 	}
 
-	/*
-	 * move_lock grabbed above and caller set from->moving_account, so
-	 * mod_memcg_page_state will serialize updates to PageDirty.
-	 * So mapping should be stable for dirty pages.
-	 */
 	if (!anon && PageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 
@@ -5543,15 +5537,23 @@ static int mem_cgroup_move_account(struct page *page,
 	}
 
 	/*
+	 * All state has been migrated, let's switch to the new memcg.
+	 *
 	 * It is safe to change page->mem_cgroup here because the page
-	 * is referenced, charged, and isolated - we can't race with
-	 * uncharging, charging, migration, or LRU putback.
+	 * is referenced, charged, isolated, and locked: we can't race
+	 * with (un)charging, migration, LRU putback, or anything else
+	 * that would rely on a stable page->mem_cgroup.
+	 *
+	 * Note that lock_page_memcg is a memcg lock, not a page lock,
+	 * to save space. As soon as we switch page->mem_cgroup to a
+	 * new memcg that isn't locked, the above state can change
+	 * concurrently again. Make sure we're truly done with it.
 	 */
+	smp_mb();
 
-	/* caller should have done css_get */
-	page->mem_cgroup = to;
+	page->mem_cgroup = to; 	/* caller should have done css_get */
 
-	spin_unlock_irqrestore(&from->move_lock, flags);
+	__unlock_page_memcg(from);
 
 	ret = 0;
 
-- 
2.25.1

