Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DA71414DD
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 00:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgAQXi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 18:38:29 -0500
Received: from mga14.intel.com ([192.55.52.115]:62782 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbgAQXi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 18:38:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 15:38:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,332,1574150400"; 
   d="scan'208";a="249407880"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jan 2020 15:38:26 -0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        rientjes@google.com, Wei Yang <richardw.yang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [Patch v4] mm: thp: remove the defer list related code since this will not happen
Date:   Sat, 18 Jan 2020 07:38:36 +0800
Message-Id: <20200117233836.3434-1-richardw.yang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If compound is true, this means it is a PMD mapped THP. Which implies
the page is not linked to any defer list. So the first code chunk will
not be executed.

Also with this reason, it would not be proper to add this page to a
defer list. So the second code chunk is not correct.

Based on this, we should remove the defer list related code.

Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>    [5.4+]

---
v4:
  * finally we identified the related code is not necessary and not
    correct, just remove it
  * thanks to Kirill T first spot some problem
v3:
  * remove all review/ack tag since rewrite the changelog
  * use deferred_split_huge_page as the example of race
  * add cc stable 5.4+ tag as suggested by David Rientjes

v2:
  * move check on compound outside suggested by Alexander
  * an example of the race condition, suggested by Michal
---
 mm/memcontrol.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c83cf4ed970..27c231bf4565 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5340,14 +5340,6 @@ static int mem_cgroup_move_account(struct page *page,
 		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
-		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
-		spin_unlock(&from->deferred_split_queue.split_queue_lock);
-	}
-#endif
 	/*
 	 * It is safe to change page->mem_cgroup here because the page
 	 * is referenced, charged, and isolated - we can't race with
@@ -5357,16 +5349,6 @@ static int mem_cgroup_move_account(struct page *page,
 	/* caller should have done css_get */
 	page->mem_cgroup = to;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
-		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
-		spin_unlock(&to->deferred_split_queue.split_queue_lock);
-	}
-#endif
-
 	spin_unlock_irqrestore(&from->move_lock, flags);
 
 	ret = 0;
-- 
2.17.1

