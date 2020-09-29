Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3355B27C805
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgI2L6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729703AbgI2LmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8136020702;
        Tue, 29 Sep 2020 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379741;
        bh=fR/UbDId/TZwo11/kGB43MSUf1Nix4TokHJyS1Bx8Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=es9T5LDYpRwJ0zHpfLJwab6/brsALbUEFiuY/ZYhLCikLG/2sscf7rAgfblpyVP1O
         vZ6dldZKgmX9lAbBymElv3ange9EbZ4HBPKZvb9MTpXflQaqa0f61xOlzRb5F/aTuy
         8/+xIdKllW467myJh6kYerh8Z51FA5GrKj0mL+VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Shakeel Butt <shakeelb@google.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/388] mm: memcontrol: fix stat-corrupting race in charge moving
Date:   Tue, 29 Sep 2020 13:00:29 +0200
Message-Id: <20200929110024.889485433@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



