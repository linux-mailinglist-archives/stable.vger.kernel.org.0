Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1159408EA7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhIMNgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242570AbhIMN3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C8566135E;
        Mon, 13 Sep 2021 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539468;
        bh=ICotKW+gJE6MViGFxSX6mbjWVs8hAtWnUFrAfhMIh7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgCLqmnWpUJkLm+qZF8bP4Z3y+tAvbnYJmKKlN+RmKb9eeXxO2MaNy01Ct8MZ4Bw5
         06d9nn/W0AH0UQm5o4bgzr2o+zgOGW3RlKmgMDEZcHljAGCiweJvLZ61xN3xZGDDDM
         wgrO/VtRmEC/tAnqeD4gpqSStGEkFw3AJbw+MElk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/236] s390/debug: keep debug data on resize
Date:   Mon, 13 Sep 2021 15:12:22 +0200
Message-Id: <20210913131101.604037016@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b6619ae9a3e0..e392d3e42b1d 100644
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



