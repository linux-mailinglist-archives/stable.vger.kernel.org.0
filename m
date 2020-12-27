Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BC32E3260
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgL0SP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 13:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgL0SP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 13:15:28 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D355AC061794
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 10:14:47 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 26so6384758pgl.2
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 10:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=j7pGoESECcJnUn1Gu4iB96Pgr1MQxVnZ8zJqEnq7HhA=;
        b=sFDh5UzBKicLvJ1rSvNdm19dsKKLr4qDzDc2quHExqawNylMQw803yweRQFCUTSA6B
         zkEHZCeLxdGapg3YdeQSa7zcEDjrsTveFxq5Ar/jFCWzE02orSCJjp9Q4tpbDs8rpbjq
         6apVzkZSw+TEoTnVlvQeVhExp9/wDOsHaKEHjtM/SPLGYqiFar5nDkFqZnnWPiVg1RLA
         uibFRgBA0mylKxp45uLlgHmoN+8JLwf9jS20MXiRvVm0rAJfNDeNiQjDv1StQk1UfqnI
         egYPPypITj5p0P395GPrvEiykeuEVFGezdUk/TnMIskRfivMft2/Rh3nxUyw4ekoJi5B
         YcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=j7pGoESECcJnUn1Gu4iB96Pgr1MQxVnZ8zJqEnq7HhA=;
        b=XoFAdgWz8IMvbGgDuhp8WM3pGpx8p4qbkOWwlswBKPvZuQ5+ANPE3JhgCC6tslZ1Q2
         WTUWtQoOeW6uvXcM8ga2ZVnCsu/9UcYEVXw6j4tyEQrR3HmPAH5EH4JzcpavxHJo4SkX
         TwZjkeh3lDG8oq3+Gm90SjL7c8TaYwvj4Rz1mqAs4xDBwIKO9WNPKqpWCy/ptW4fLKJJ
         tr4TCsu+fom6HTk/zUCh6jlNg/P6QsTcxsWr598/9hjzus1+uzCJgg9nZSeRfznFLlaX
         5bF91J5zJgpm9vjB7VfBZsKXb7xPjbdtNFywV6W5RoLhXP8CMDatSirKUkzcpWqd5wFM
         iElw==
X-Gm-Message-State: AOAM533YXsceDNWM8FIRbZW90k6C90jXNPSI1ktVO2njOU2yKIUDa7Ac
        zDlkWdLEd56WVmI6mduUJkQIUct1c3ieZw==
X-Google-Smtp-Source: ABdhPJzsu2GMZ3nq9u+5UxlkP6yw+NThbECM2O1F1tSgQsuPPOYyWET44oBQto8y6MVqwlFc4X7GD1LkLhwGyg==
Sender: "shakeelb via sendgmr" <shakeelb@shakeelb.svl.corp.google.com>
X-Received: from shakeelb.svl.corp.google.com ([100.116.77.44]) (user=shakeelb
 job=sendgmr) by 2002:a17:90a:f0c1:: with SMTP id fa1mr17159731pjb.148.1609092887354;
 Sun, 27 Dec 2020 10:14:47 -0800 (PST)
Date:   Sun, 27 Dec 2020 10:13:10 -0800
In-Reply-To: <20201227181310.3235210-1-shakeelb@google.com>
Message-Id: <20201227181310.3235210-2-shakeelb@google.com>
Mime-Version: 1.0
References: <20201227181310.3235210-1-shakeelb@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 2/2] mm: fix numa stats for thp migration
From:   Shakeel Butt <shakeelb@google.com>
To:     Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently the kernel is not correctly updating the numa stats for
NR_FILE_PAGES and NR_SHMEM on THP migration. Fix that. For NR_FILE_DIRTY
and NR_ZONE_WRITE_PENDING, although at the moment there is no need to
handle THP migration as kernel still does not have write support for
file THP but to be more future proof, this patch adds the THP support
for those stats as well.

Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/migrate.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 613794f6a433..ade163c6ecdf 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -402,6 +402,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	struct zone *oldzone, *newzone;
 	int dirty;
 	int expected_count = expected_page_refs(mapping, page) + extra_count;
+	int nr = thp_nr_pages(page);
 
 	if (!mapping) {
 		/* Anonymous page without mapping */
@@ -437,7 +438,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
-	page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
+	page_ref_add(newpage, nr); /* add cache reference */
 	if (PageSwapBacked(page)) {
 		__SetPageSwapBacked(newpage);
 		if (PageSwapCache(page)) {
@@ -459,7 +460,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (PageTransHuge(page)) {
 		int i;
 
-		for (i = 1; i < HPAGE_PMD_NR; i++) {
+		for (i = 1; i < nr; i++) {
 			xas_next(&xas);
 			xas_store(&xas, newpage);
 		}
@@ -470,7 +471,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
+	page_ref_unfreeze(page, expected_count - nr);
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -493,17 +494,17 @@ int migrate_page_move_mapping(struct address_space *mapping,
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
+			__mod_zone_page_tate(oldzone, NR_ZONE_WRITE_PENDING, -nr);
+			__mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
+			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
 	}
 	local_irq_enable();
-- 
2.29.2.729.g45daf8777d-goog

