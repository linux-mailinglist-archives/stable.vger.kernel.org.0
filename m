Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAD913333A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgAGVFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729048AbgAGVFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B392080A;
        Tue,  7 Jan 2020 21:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431148;
        bh=2zWao8QSzVN06CQem+gqpC3IhhdH24iP16vJ5U0VeVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dq+/nZPQHakqnDXVY80/RKtQKax2dok69cn0k3igfBDgPRj6lkiQFHgNybpoTaDh9
         b/tmGhUWLHHR6wQMl0xciXvlciPW853M3N6jkf2i+Skrqy1zJJBywunbva0prT9Q2V
         qUvg2EXWeUKlMjypgdxlXIn6BtagHmSFbD9vA784=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Felix Abecassis <fabecassis@nvidia.com>,
        Michal Hocko <mhocko@suse.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Lameter <cl@linux.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 054/115] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Tue,  7 Jan 2020 21:54:24 +0100
Message-Id: <20200107205302.756204728@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit e0153fc2c7606f101392b682e720a7a456d6c766 upstream.

Felix Abecassis reports move_pages() would return random status if the
pages are already on the target node by the below test program:

  int main(void)
  {
	const long node_id = 1;
	const long page_size = sysconf(_SC_PAGESIZE);
	const int64_t num_pages = 8;

	unsigned long nodemask =  1 << node_id;
	long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
	if (ret < 0)
		return (EXIT_FAILURE);

	void **pages = malloc(sizeof(void*) * num_pages);
	for (int i = 0; i < num_pages; ++i) {
		pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
				MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
				-1, 0);
		if (pages[i] == MAP_FAILED)
			return (EXIT_FAILURE);
	}

	ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
	if (ret < 0)
		return (EXIT_FAILURE);

	int *nodes = malloc(sizeof(int) * num_pages);
	int *status = malloc(sizeof(int) * num_pages);
	for (int i = 0; i < num_pages; ++i) {
		nodes[i] = node_id;
		status[i] = 0xd0; /* simulate garbage values */
	}

	ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
	printf("move_pages: %ld\n", ret);
	for (int i = 0; i < num_pages; ++i)
		printf("status[%d] = %d\n", i, status[i]);
  }

Then running the program would return nonsense status values:

  $ ./move_pages_bug
  move_pages: 0
  status[0] = 208
  status[1] = 208
  status[2] = 208
  status[3] = 208
  status[4] = 208
  status[5] = 208
  status[6] = 208
  status[7] = 208

This is because the status is not set if the page is already on the
target node, but move_pages() should return valid status as long as it
succeeds.  The valid status may be errno or node id.

We can't simply initialize status array to zero since the pages may be
not on node 0.  Fix it by updating status with node id which the page is
already on.

Link: http://lkml.kernel.org/r/1575584353-125392-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Felix Abecassis <fabecassis@nvidia.com>
Tested-by: Felix Abecassis <fabecassis@nvidia.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1508,9 +1508,11 @@ static int do_move_pages_to_node(struct
 /*
  * Resolves the given address to a struct page, isolates it from the LRU and
  * puts it to the given pagelist.
- * Returns -errno if the page cannot be found/isolated or 0 when it has been
- * queued or the page doesn't need to be migrated because it is already on
- * the target node
+ * Returns:
+ *     errno - if the page cannot be found/isolated
+ *     0 - when it doesn't have to be migrated because it is already on the
+ *         target node
+ *     1 - when it has been queued
  */
 static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 		int node, struct list_head *pagelist, bool migrate_all)
@@ -1549,7 +1551,7 @@ static int add_page_for_migration(struct
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
 			isolate_huge_page(page, pagelist);
-			err = 0;
+			err = 1;
 		}
 	} else {
 		struct page *head;
@@ -1559,7 +1561,7 @@ static int add_page_for_migration(struct
 		if (err)
 			goto out_putpage;
 
-		err = 0;
+		err = 1;
 		list_add_tail(&head->lru, pagelist);
 		mod_node_page_state(page_pgdat(head),
 			NR_ISOLATED_ANON + page_is_file_cache(head),
@@ -1636,8 +1638,17 @@ static int do_pages_move(struct mm_struc
 		 */
 		err = add_page_for_migration(mm, addr, current_node,
 				&pagelist, flags & MPOL_MF_MOVE_ALL);
-		if (!err)
+
+		if (!err) {
+			/* The page is already on the target node */
+			err = store_status(status, i, current_node, 1);
+			if (err)
+				goto out_flush;
 			continue;
+		} else if (err > 0) {
+			/* The page is successfully queued for migration */
+			continue;
+		}
 
 		err = store_status(status, i, err, 1);
 		if (err)


