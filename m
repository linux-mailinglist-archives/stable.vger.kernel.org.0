Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3B52A4B26
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgKCQWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:22:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:58810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgKCQWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 11:22:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604420560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAmYX98dmW3wYtg5427iW5nwfXobMeZjwJMunTezB4g=;
        b=YnHc2yapJynqL8d9uGGUhdmR5FWA8IG37Jq8A/Pj8q3FuaFpzCQW+myeu0V9ssGME2TXd+
        M/EZcbD/LFK8U0nI6ink52/Q/kVJ1mYUmBDa+S9wpF5QtK/fM+yfyTixzWyWrNibJflsu6
        DuLRk2sO1vgU2aFoP7JDt68nrZKKI+I=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DFF0FAD6D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:22:39 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 06/13] xen/blkback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 17:22:31 +0100
Message-Id: <20201103162238.30264-7-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103162238.30264-1-jgross@suse.com>
References: <20201103162238.30264-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving blkfront use the lateeoi
irq binding for blkback and unmask the event channel only after
processing all pending requests.

As the thread processing requests is used to do purging work in regular
intervals an EOI may be sent only after having received an event. If
there was no pending I/O request flag the EOI as spurious.

This is part of XSA-332.

This is upstream commit 01263a1fabe30b4d542f34c7e2364a22587ddaf2

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/block/xen-blkback/blkback.c | 22 +++++++++++++++++-----
 drivers/block/xen-blkback/xenbus.c  |  5 ++---
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index a295ad6a1674..8dbdd156e0d3 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -173,7 +173,7 @@ static inline void shrink_free_pagepool(struct xen_blkif *blkif, int num)
 
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
 
-static int do_block_io_op(struct xen_blkif *blkif);
+static int do_block_io_op(struct xen_blkif *blkif, unsigned int *eoi_flags);
 static int dispatch_rw_block_io(struct xen_blkif *blkif,
 				struct blkif_request *req,
 				struct pending_req *pending_req);
@@ -594,6 +594,8 @@ int xen_blkif_schedule(void *arg)
 	struct xen_vbd *vbd = &blkif->vbd;
 	unsigned long timeout;
 	int ret;
+	bool do_eoi;
+	unsigned int eoi_flags = XEN_EOI_FLAG_SPURIOUS;
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
@@ -617,16 +619,23 @@ int xen_blkif_schedule(void *arg)
 		if (timeout == 0)
 			goto purge_gnt_list;
 
+		do_eoi = blkif->waiting_reqs;
+
 		blkif->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
 
-		ret = do_block_io_op(blkif);
+		ret = do_block_io_op(blkif, &eoi_flags);
 		if (ret > 0)
 			blkif->waiting_reqs = 1;
 		if (ret == -EACCES)
 			wait_event_interruptible(blkif->shutdown_wq,
 						 kthread_should_stop());
 
+		if (do_eoi && !blkif->waiting_reqs) {
+			xen_irq_lateeoi(blkif->irq, eoi_flags);
+			eoi_flags |= XEN_EOI_FLAG_SPURIOUS;
+		}
+
 purge_gnt_list:
 		if (blkif->vbd.feature_gnt_persistent &&
 		    time_after(jiffies, blkif->next_lru)) {
@@ -1094,7 +1103,7 @@ static void end_block_io_op(struct bio *bio)
  * and transmute  it to the block API to hand it over to the proper block disk.
  */
 static int
-__do_block_io_op(struct xen_blkif *blkif)
+__do_block_io_op(struct xen_blkif *blkif, unsigned int *eoi_flags)
 {
 	union blkif_back_rings *blk_rings = &blkif->blk_rings;
 	struct blkif_request req;
@@ -1117,6 +1126,9 @@ __do_block_io_op(struct xen_blkif *blkif)
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
 			break;
 
+		/* We've seen a request, so clear spurious eoi flag. */
+		*eoi_flags &= ~XEN_EOI_FLAG_SPURIOUS;
+
 		if (kthread_should_stop()) {
 			more_to_do = 1;
 			break;
@@ -1175,13 +1187,13 @@ done:
 }
 
 static int
-do_block_io_op(struct xen_blkif *blkif)
+do_block_io_op(struct xen_blkif *blkif, unsigned int *eoi_flags)
 {
 	union blkif_back_rings *blk_rings = &blkif->blk_rings;
 	int more_to_do;
 
 	do {
-		more_to_do = __do_block_io_op(blkif);
+		more_to_do = __do_block_io_op(blkif, eoi_flags);
 		if (more_to_do)
 			break;
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 923308201375..0ec257e69e95 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -200,9 +200,8 @@ static int xen_blkif_map(struct xen_blkif *blkif, grant_ref_t *gref,
 		BUG();
 	}
 
-	err = bind_interdomain_evtchn_to_irqhandler(blkif->domid, evtchn,
-						    xen_blkif_be_int, 0,
-						    "blkif-backend", blkif);
+	err = bind_interdomain_evtchn_to_irqhandler_lateeoi(blkif->domid,
+			evtchn, xen_blkif_be_int, 0, "blkif-backend", blkif);
 	if (err < 0) {
 		xenbus_unmap_ring_vfree(blkif->be->dev, blkif->blk_ring);
 		blkif->blk_rings.common.sring = NULL;
-- 
2.26.2

