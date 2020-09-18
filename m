Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9CD26F154
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgIRCuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgIRCIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A3123770;
        Fri, 18 Sep 2020 02:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394921;
        bh=96g2gQvYCQ7N+F/W7kbIkBrVEDMbwRt19XM5k1Ibeew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKboQFso78phzJCGNGyFfFw/ZVNsOO+CCEHF6fv2/BQ8+8d70vMgBfeF9soNjhQaG
         0BpwMtaWaJ/aTE98R/VkLlJlyidD6RYD/y2nGcDAVNeAhpP+IFmcSR18UCS3vqYLvi
         hdIy9rMuqnWIvC6OdsXjdCrPaiQycOomxFMzFKUA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 033/206] ubi: Fix producing anchor PEBs
Date:   Thu, 17 Sep 2020 22:05:09 -0400
Message-Id: <20200918020802.2065198-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit f9c34bb529975fe9f85b870a80c53a83a3c5a182 ]

When a new fastmap is about to be written UBI must make sure it has a
free block for a fastmap anchor available. For this ubi_update_fastmap()
calls ubi_ensure_anchor_pebs(). This stopped working with 2e8f08deabbc
("ubi: Fix races around ubi_refill_pools()"), with this commit the wear
leveling code is blocked and can no longer produce free PEBs. UBI then
more often than not falls back to write the new fastmap anchor to the
same block it was already on which means the same erase block gets
erased during each fastmap write and wears out quite fast.

As the locking prevents us from producing the anchor PEB when we
actually need it, this patch changes the strategy for creating the
anchor PEB. We no longer create it on demand right before we want to
write a fastmap, but instead we create an anchor PEB right after we have
written a fastmap. This gives us enough time to produce a new anchor PEB
before it is needed. To make sure we have an anchor PEB for the very
first fastmap write we call ubi_ensure_anchor_pebs() during
initialisation as well.

Fixes: 2e8f08deabbc ("ubi: Fix races around ubi_refill_pools()")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap-wl.c | 31 ++++++++++++++++++-------------
 drivers/mtd/ubi/fastmap.c    | 14 +++++---------
 drivers/mtd/ubi/ubi.h        |  6 ++++--
 drivers/mtd/ubi/wl.c         | 32 ++++++++++++++------------------
 drivers/mtd/ubi/wl.h         |  1 -
 5 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 98f7d6be8d1fc..13efebb400225 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -66,18 +66,6 @@ static void return_unused_pool_pebs(struct ubi_device *ubi,
 	}
 }
 
-static int anchor_pebs_available(struct rb_root *root)
-{
-	struct rb_node *p;
-	struct ubi_wl_entry *e;
-
-	ubi_rb_for_each_entry(p, e, root, u.rb)
-		if (e->pnum < UBI_FM_MAX_START)
-			return 1;
-
-	return 0;
-}
-
 /**
  * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
  * @ubi: UBI device description object
@@ -286,8 +274,26 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
 int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
 {
 	struct ubi_work *wrk;
+	struct ubi_wl_entry *anchor;
 
 	spin_lock(&ubi->wl_lock);
+
+	/* Do we already have an anchor? */
+	if (ubi->fm_anchor) {
+		spin_unlock(&ubi->wl_lock);
+		return 0;
+	}
+
+	/* See if we can find an anchor PEB on the list of free PEBs */
+	anchor = ubi_wl_get_fm_peb(ubi, 1);
+	if (anchor) {
+		ubi->fm_anchor = anchor;
+		spin_unlock(&ubi->wl_lock);
+		return 0;
+	}
+
+	/* No luck, trigger wear leveling to produce a new anchor PEB */
+	ubi->fm_do_produce_anchor = 1;
 	if (ubi->wl_scheduled) {
 		spin_unlock(&ubi->wl_lock);
 		return 0;
@@ -303,7 +309,6 @@ int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
 		return -ENOMEM;
 	}
 
-	wrk->anchor = 1;
 	wrk->func = &wear_leveling_worker;
 	__schedule_ubi_work(ubi, wrk);
 	return 0;
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 8e292992f84c7..b88ef875236cc 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1552,14 +1552,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		return 0;
 	}
 
-	ret = ubi_ensure_anchor_pebs(ubi);
-	if (ret) {
-		up_write(&ubi->fm_eba_sem);
-		up_write(&ubi->work_sem);
-		up_write(&ubi->fm_protect);
-		return ret;
-	}
-
 	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
 	if (!new_fm) {
 		up_write(&ubi->fm_eba_sem);
@@ -1630,7 +1622,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	}
 
 	spin_lock(&ubi->wl_lock);
-	tmp_e = ubi_wl_get_fm_peb(ubi, 1);
+	tmp_e = ubi->fm_anchor;
+	ubi->fm_anchor = NULL;
 	spin_unlock(&ubi->wl_lock);
 
 	if (old_fm) {
@@ -1682,6 +1675,9 @@ out_unlock:
 	up_write(&ubi->work_sem);
 	up_write(&ubi->fm_protect);
 	kfree(old_fm);
+
+	ubi_ensure_anchor_pebs(ubi);
+
 	return ret;
 
 err:
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index d47b9e436e673..d248ec371cc17 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -504,6 +504,8 @@ struct ubi_debug_info {
  * @fm_work: fastmap work queue
  * @fm_work_scheduled: non-zero if fastmap work was scheduled
  * @fast_attach: non-zero if UBI was attached by fastmap
+ * @fm_anchor: The next anchor PEB to use for fastmap
+ * @fm_do_produce_anchor: If true produce an anchor PEB in wl
  *
  * @used: RB-tree of used physical eraseblocks
  * @erroneous: RB-tree of erroneous used physical eraseblocks
@@ -612,6 +614,8 @@ struct ubi_device {
 	struct work_struct fm_work;
 	int fm_work_scheduled;
 	int fast_attach;
+	struct ubi_wl_entry *fm_anchor;
+	int fm_do_produce_anchor;
 
 	/* Wear-leveling sub-system's stuff */
 	struct rb_root used;
@@ -802,7 +806,6 @@ struct ubi_attach_info {
  * @vol_id: the volume ID on which this erasure is being performed
  * @lnum: the logical eraseblock number
  * @torture: if the physical eraseblock has to be tortured
- * @anchor: produce a anchor PEB to by used by fastmap
  *
  * The @func pointer points to the worker function. If the @shutdown argument is
  * not zero, the worker has to free the resources and exit immediately as the
@@ -818,7 +821,6 @@ struct ubi_work {
 	int vol_id;
 	int lnum;
 	int torture;
-	int anchor;
 };
 
 #include "debug.h"
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 6f2ac865ff05e..80d64d7e7a8be 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -331,13 +331,6 @@ static struct ubi_wl_entry *find_wl_entry(struct ubi_device *ubi,
 		}
 	}
 
-	/* If no fastmap has been written and this WL entry can be used
-	 * as anchor PEB, hold it back and return the second best WL entry
-	 * such that fastmap can use the anchor PEB later. */
-	if (prev_e && !ubi->fm_disabled &&
-	    !ubi->fm && e->pnum < UBI_FM_MAX_START)
-		return prev_e;
-
 	return e;
 }
 
@@ -648,9 +641,6 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 {
 	int err, scrubbing = 0, torture = 0, protect = 0, erroneous = 0;
 	int erase = 0, keep = 0, vol_id = -1, lnum = -1;
-#ifdef CONFIG_MTD_UBI_FASTMAP
-	int anchor = wrk->anchor;
-#endif
 	struct ubi_wl_entry *e1, *e2;
 	struct ubi_vid_io_buf *vidb;
 	struct ubi_vid_hdr *vid_hdr;
@@ -690,11 +680,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	}
 
 #ifdef CONFIG_MTD_UBI_FASTMAP
-	/* Check whether we need to produce an anchor PEB */
-	if (!anchor)
-		anchor = !anchor_pebs_available(&ubi->free);
-
-	if (anchor) {
+	if (ubi->fm_do_produce_anchor) {
 		e1 = find_anchor_wl_entry(&ubi->used);
 		if (!e1)
 			goto out_cancel;
@@ -705,6 +691,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		self_check_in_wl_tree(ubi, e1, &ubi->used);
 		rb_erase(&e1->u.rb, &ubi->used);
 		dbg_wl("anchor-move PEB %d to PEB %d", e1->pnum, e2->pnum);
+		ubi->fm_do_produce_anchor = 0;
 	} else if (!ubi->scrub.rb_node) {
 #else
 	if (!ubi->scrub.rb_node) {
@@ -1037,7 +1024,6 @@ static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
 		goto out_cancel;
 	}
 
-	wrk->anchor = 0;
 	wrk->func = &wear_leveling_worker;
 	if (nested)
 		__schedule_ubi_work(ubi, wrk);
@@ -1079,8 +1065,15 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
 		spin_lock(&ubi->wl_lock);
-		wl_tree_add(e, &ubi->free);
-		ubi->free_count++;
+
+		if (!ubi->fm_anchor && e->pnum < UBI_FM_MAX_START) {
+			ubi->fm_anchor = e;
+			ubi->fm_do_produce_anchor = 0;
+		} else {
+			wl_tree_add(e, &ubi->free);
+			ubi->free_count++;
+		}
+
 		spin_unlock(&ubi->wl_lock);
 
 		/*
@@ -1724,6 +1717,9 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (err)
 		goto out_free;
 
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	ubi_ensure_anchor_pebs(ubi);
+#endif
 	return 0;
 
 out_free:
diff --git a/drivers/mtd/ubi/wl.h b/drivers/mtd/ubi/wl.h
index a9e2d669acd81..c93a532937863 100644
--- a/drivers/mtd/ubi/wl.h
+++ b/drivers/mtd/ubi/wl.h
@@ -2,7 +2,6 @@
 #ifndef UBI_WL_H
 #define UBI_WL_H
 #ifdef CONFIG_MTD_UBI_FASTMAP
-static int anchor_pebs_available(struct rb_root *root);
 static void update_fastmap_work_fn(struct work_struct *wrk);
 static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root);
 static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
-- 
2.25.1

