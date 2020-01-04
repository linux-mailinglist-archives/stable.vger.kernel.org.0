Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D85130474
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 21:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgADU7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 15:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgADU7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 15:59:47 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56C624650;
        Sat,  4 Jan 2020 20:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578171587;
        bh=/ZlR/E1jn0C9hBj0oLMKeaDnKIQNPLBFqwsD/W5qyKg=;
        h=Date:From:To:Subject:From;
        b=gqYps4jMlTQf2fLQpruLOM4N9yDRoYs89ER1PLGSjqV3S/PxlayZqrik5M0oSZaU/
         qPGMU8gyVB5JO7M9Sq1SvPEf4mlkwRr+Myfh278K997+BblSINZXy2GjcXPG8xCgNh
         zL/PxnlpE4fpmmQ3AvqwfFmvc12HxgpdhhBTbv0k=
Date:   Sat, 04 Jan 2020 12:59:46 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cl@linux.com, fabecassis@nvidia.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        yang.shi@linux.alibaba.com
Subject:  [patch 05/17] mm: move_pages: return valid node id in
 status if the page is already on the target node
Message-ID: <20200104205946.bXLvlabMj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: move_pages: return valid node id in status if the page is already on the target node

Felix Abecassis reports move_pages() would return random status if the
pages are already on the target node by the below test program:

---8<---

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
	printf("move_pages: %ld
", ret);
	for (int i = 0; i < num_pages; ++i)
		printf("status[%d] = %d
", i, status[i]);
}
---8<---

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

This is because the status is not set if the page is already on the target
node, but move_pages() should return valid status as long as it succeeds. 
The valid status may be errno or node id.

We can't simply initialize status array to zero since the pages may be not
on node 0.  Fix it by updating status with node id which the page is
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
---

 mm/migrate.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-move_pages-return-valid-node-id-in-status-if-the-page-is-already-on-the-target-node
+++ a/mm/migrate.c
@@ -1512,9 +1512,11 @@ static int do_move_pages_to_node(struct
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
@@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
 			isolate_huge_page(page, pagelist);
-			err = 0;
+			err = 1;
 		}
 	} else {
 		struct page *head;
@@ -1563,7 +1565,7 @@ static int add_page_for_migration(struct
 		if (err)
 			goto out_putpage;
 
-		err = 0;
+		err = 1;
 		list_add_tail(&head->lru, pagelist);
 		mod_node_page_state(page_pgdat(head),
 			NR_ISOLATED_ANON + page_is_file_cache(head),
@@ -1640,8 +1642,17 @@ static int do_pages_move(struct mm_struc
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
_
