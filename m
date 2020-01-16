Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED5513D186
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 02:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgAPBbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 20:31:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:37250 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729043AbgAPBbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 20:31:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 17:31:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,323,1574150400"; 
   d="scan'208";a="213906940"
Received: from unknown (HELO localhost) ([10.239.159.54])
  by orsmga007.jf.intel.com with ESMTP; 15 Jan 2020 17:31:13 -0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        rientjes@google.com, Wei Yang <richardw.yang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [Patch v3] mm: thp: grab the lock before manipulation defer list
Date:   Thu, 16 Jan 2020 09:31:00 +0800
Message-Id: <20200116013100.7679-1-richardw.yang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As all the other places, we grab the lock before manipulate the defer list.
Current implementation may face a race condition.

For example, the potential race would be:

    CPU1                      CPU2
    mem_cgroup_move_account   deferred_split_huge_page
      list_empty
                                lock
                                list_empty
                                list_add_tail
                                unlock
      lock
      # list_empty might not hold anymore
      list_add_tail
      unlock

When this sequence happens, the list_add_tail() in
mem_cgroup_move_account() corrupt the list since which is already been
added to some split_queue in split_huge_page_to_list().

Besides this, David Rientjes points out the split_queue_len would be in
a wrong state, which would be a significant issue for shrinkers.

Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [5.4+]

---
v3:
  * remove all review/ack tag since rewrite the changelog
  * use deferred_split_huge_page as the example of race
  * add cc stable 5.4+ tag as suggested by David Rientjes

v2:
  * move check on compound outside suggested by Alexander
  * an example of the race condition, suggested by Michal
---
 mm/memcontrol.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5b5f74cfd4d..6450bbe394e2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
 	}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
+	if (compound) {
 		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
+		if (!list_empty(page_deferred_list(page))) {
+			list_del_init(page_deferred_list(page));
+			from->deferred_split_queue.split_queue_len--;
+		}
 		spin_unlock(&from->deferred_split_queue.split_queue_lock);
 	}
 #endif
@@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
 	page->mem_cgroup = to;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
+	if (compound) {
 		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
+		if (list_empty(page_deferred_list(page))) {
+			list_add_tail(page_deferred_list(page),
+				      &to->deferred_split_queue.split_queue);
+			to->deferred_split_queue.split_queue_len++;
+		}
 		spin_unlock(&to->deferred_split_queue.split_queue_lock);
 	}
 #endif
-- 
2.17.1

