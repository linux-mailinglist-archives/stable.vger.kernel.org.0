Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E112EFC37
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 01:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbhAIAcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 19:32:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbhAIAcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 19:32:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20C7223AAA;
        Sat,  9 Jan 2021 00:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610152283;
        bh=cBUyTnHLmnfYrsQg3vIOTZjAL66Lwzy4oAkcu/n9V1Y=;
        h=Date:From:To:Subject:From;
        b=UZPL5FSRPpcu1cZtXTds27phN4T+5d1I3XSWfTRFRyC85cJ4RD4bspnB54NzgJPLt
         SmBCa3EEDVcDZKGguEKj8Julx3lTazfaOlC88joqKZ7Q7mwBDtENvOjuLZmJs8i1SR
         nmaVoZ203dTgZHSFinmTy3uxk87Jz4oudLy0VCyI=
Date:   Fri, 08 Jan 2021 16:31:21 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject:  + mm-fix-numa-stats-for-thp-migration.patch added to -mm
 tree
Message-ID: <20210109003121.Pbq8-UMfV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix numa stats for thp migration
has been added to the -mm tree.  Its filename is
     mm-fix-numa-stats-for-thp-migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-numa-stats-for-thp-migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-numa-stats-for-thp-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: fix numa stats for thp migration

Currently the kernel is not correctly updating the numa stats for
NR_FILE_PAGES and NR_SHMEM on THP migration.  Fix that.  For NR_FILE_DIRTY
and NR_ZONE_WRITE_PENDING, although at the moment there is no need to
handle THP migration as kernel still does not have write support for file
THP but to be more future proof, this patch adds the THP support for those
stats as well.

Link: https://lkml.kernel.org/r/20210108155813.2914586-2-shakeelb@google.com
Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/migrate.c~mm-fix-numa-stats-for-thp-migration
+++ a/mm/migrate.c
@@ -402,6 +402,7 @@ int migrate_page_move_mapping(struct add
 	struct zone *oldzone, *newzone;
 	int dirty;
 	int expected_count = expected_page_refs(mapping, page) + extra_count;
+	int nr = thp_nr_pages(page);
 
 	if (!mapping) {
 		/* Anonymous page without mapping */
@@ -437,7 +438,7 @@ int migrate_page_move_mapping(struct add
 	 */
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
-	page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
+	page_ref_add(newpage, nr); /* add cache reference */
 	if (PageSwapBacked(page)) {
 		__SetPageSwapBacked(newpage);
 		if (PageSwapCache(page)) {
@@ -459,7 +460,7 @@ int migrate_page_move_mapping(struct add
 	if (PageTransHuge(page)) {
 		int i;
 
-		for (i = 1; i < HPAGE_PMD_NR; i++) {
+		for (i = 1; i < nr; i++) {
 			xas_next(&xas);
 			xas_store(&xas, newpage);
 		}
@@ -470,7 +471,7 @@ int migrate_page_move_mapping(struct add
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
+	page_ref_unfreeze(page, expected_count - nr);
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -493,17 +494,17 @@ int migrate_page_move_mapping(struct add
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
 
-		__dec_lruvec_state(old_lruvec, NR_FILE_PAGES);
-		__inc_lruvec_state(new_lruvec, NR_FILE_PAGES);
+		__mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
+		__mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
 		if (PageSwapBacked(page) && !PageSwapCache(page)) {
-			__dec_lruvec_state(old_lruvec, NR_SHMEM);
-			__inc_lruvec_state(new_lruvec, NR_SHMEM);
+			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
+			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 		}
 		if (dirty && mapping_can_writeback(mapping)) {
-			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
-			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
-			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
-			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
+			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
+			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
+			__mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
+			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
 	}
 	local_irq_enable();
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-memcg-fix-memcg-file_dirty-numa-stat.patch
mm-fix-numa-stats-for-thp-migration.patch
mm-memcg-add-swapcache-stat-for-memcg-v2.patch

