Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E73115A04
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 01:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfLGAQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 19:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfLGAQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 19:16:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7A4021835;
        Sat,  7 Dec 2019 00:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575677789;
        bh=M83TdLkpBTwNQwXYbzaY4Jz4mdPsQvfCGcyhDerP/1s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U7JJqbWrFwjdKaBLGivGCnT8Lg5KUgJwD3XG5SqDs947BxBdKACMVOvBGwWQPHtcx
         jzeCx6/wWOqRe1HwyPIRmNhPfB9rh666qJut/+AwyuXcn0/Nw3OnurA5JKzwrrV03C
         e7aSISl/7KnhSKztvWZumpvtmfWwvDTwFELZ6Y+0=
Date:   Fri, 06 Dec 2019 16:16:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, fabecassis@nvidia.com, jhubbard@nvidia.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz,
        yang.shi@linux.alibaba.com
Subject:  +
 =?US-ASCII?Q?mm-move=5Fpages-return-valid-node-id-in-status-if-the-page?=
 =?US-ASCII?Q?-is-already-on-the-target-node.patch?= added to -mm tree
Message-ID: <20191207001628.lhEFiIYiq%akpm@linux-foundation.org>
In-Reply-To: <20191204164858.fe4ed8886e34ad9f3b34ea00@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: move_pages: return valid node id in status if the page is already on the target node
has been added to the -mm tree.  Its filename is
     mm-move_pages-return-valid-node-id-in-status-if-the-page-is-already-on-the-target-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move_pages-return-valid-node-id-in-status-if-the-page-is-already-on-the-target-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move_pages-return-valid-node-id-in-status-if-the-page-is-already-on-the-target-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-vmscan-protect-shrinker-idr-replace-with-config_memcg.patch
mm-move_pages-return-valid-node-id-in-status-if-the-page-is-already-on-the-target-node.patch

