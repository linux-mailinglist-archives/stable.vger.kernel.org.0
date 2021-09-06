Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEB0401345
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240220AbhIFBY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238675AbhIFBX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34976113D;
        Mon,  6 Sep 2021 01:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891309;
        bh=OWFul2QIC/gLurCpgBqET3is9T8/yc+YEFTbi6n4yJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sy000u95D4h9tY7N6ljoVa6qRwthndDcptPP42W1ElYIX5KJ8152PtSC+BOB/xma8
         /lNB5BdiX/K9PfeKdAxSqQp0PBJhjSiBYfvI+P5E3hSKwb+a32wk5oned6GYruNe2c
         E1g0cidlpnqW7LRlZjZdXq0CD9HW3K2vVs3z69jT/ng11/BjkcokvwtgpAwK5qzTMI
         9txzxnxyCEke+4eBg3YXYAVt/Sa0ddABOB1Uz+W5z0XRhQKUOOPM/JlYA6EnHv4AG3
         mUmTceAEpVZSxgFwCnrEyLpDtJwvAkSBlzxdcfYOEVun8mZnWgLAHm/74jgFYCTRbg
         /Cv5R69faW7ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 44/46] s390/debug: keep debug data on resize
Date:   Sun,  5 Sep 2021 21:20:49 -0400
Message-Id: <20210906012052.929174-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 1204777867e8486a88dbb4793fe256b31ea05eeb ]

Any previously recorded s390dbf debug data is reset when a debug area
is resized using the 'pages' sysfs attribute. This can make
live-debugging unnecessarily complex.

Fix this by copying existing debug data to the newly allocated debug
area when resizing.

Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 74 ++++++++++++++++++++++++++++------------
 1 file changed, 53 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index bb958d32bd81..7d3649dbaa8c 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/minmax.h>
 #include <linux/debugfs.h>
 
 #include <asm/debug.h>
@@ -92,6 +93,8 @@ static int debug_hex_ascii_format_fn(debug_info_t *id, struct debug_view *view,
 				     char *out_buf, const char *in_buf);
 static int debug_sprintf_format_fn(debug_info_t *id, struct debug_view *view,
 				   char *out_buf, debug_sprintf_entry_t *curr_event);
+static void debug_areas_swap(debug_info_t *a, debug_info_t *b);
+static void debug_events_append(debug_info_t *dest, debug_info_t *src);
 
 /* globals */
 
@@ -726,35 +729,28 @@ EXPORT_SYMBOL(debug_unregister);
  */
 static int debug_set_size(debug_info_t *id, int nr_areas, int pages_per_area)
 {
-	debug_entry_t ***new_areas;
+	debug_info_t *new_id;
 	unsigned long flags;
-	int rc = 0;
 
 	if (!id || (nr_areas <= 0) || (pages_per_area < 0))
 		return -EINVAL;
-	if (pages_per_area > 0) {
-		new_areas = debug_areas_alloc(pages_per_area, nr_areas);
-		if (!new_areas) {
-			pr_info("Allocating memory for %i pages failed\n",
-				pages_per_area);
-			rc = -ENOMEM;
-			goto out;
-		}
-	} else {
-		new_areas = NULL;
+
+	new_id = debug_info_alloc("", pages_per_area, nr_areas, id->buf_size,
+				  id->level, ALL_AREAS);
+	if (!new_id) {
+		pr_info("Allocating memory for %i pages failed\n",
+			pages_per_area);
+		return -ENOMEM;
 	}
+
 	spin_lock_irqsave(&id->lock, flags);
-	debug_areas_free(id);
-	id->areas = new_areas;
-	id->nr_areas = nr_areas;
-	id->pages_per_area = pages_per_area;
-	id->active_area = 0;
-	memset(id->active_entries, 0, sizeof(int)*id->nr_areas);
-	memset(id->active_pages, 0, sizeof(int)*id->nr_areas);
+	debug_events_append(new_id, id);
+	debug_areas_swap(new_id, id);
+	debug_info_free(new_id);
 	spin_unlock_irqrestore(&id->lock, flags);
 	pr_info("%s: set new size (%i pages)\n", id->name, pages_per_area);
-out:
-	return rc;
+
+	return 0;
 }
 
 /**
@@ -821,6 +817,42 @@ static inline debug_entry_t *get_active_entry(debug_info_t *id)
 				  id->active_entries[id->active_area]);
 }
 
+/* Swap debug areas of a and b. */
+static void debug_areas_swap(debug_info_t *a, debug_info_t *b)
+{
+	swap(a->nr_areas, b->nr_areas);
+	swap(a->pages_per_area, b->pages_per_area);
+	swap(a->areas, b->areas);
+	swap(a->active_area, b->active_area);
+	swap(a->active_pages, b->active_pages);
+	swap(a->active_entries, b->active_entries);
+}
+
+/* Append all debug events in active area from source to destination log. */
+static void debug_events_append(debug_info_t *dest, debug_info_t *src)
+{
+	debug_entry_t *from, *to, *last;
+
+	if (!src->areas || !dest->areas)
+		return;
+
+	/* Loop over all entries in src, starting with oldest. */
+	from = get_active_entry(src);
+	last = from;
+	do {
+		if (from->clock != 0LL) {
+			to = get_active_entry(dest);
+			memset(to, 0, dest->entry_size);
+			memcpy(to, from, min(src->entry_size,
+					     dest->entry_size));
+			proceed_active_entry(dest);
+		}
+
+		proceed_active_entry(src);
+		from = get_active_entry(src);
+	} while (from != last);
+}
+
 /*
  * debug_finish_entry:
  * - set timestamp, caller address, cpu number etc.
-- 
2.30.2

