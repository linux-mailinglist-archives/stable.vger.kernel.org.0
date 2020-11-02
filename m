Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8485D2A2A86
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 13:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgKBMR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 07:17:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:48126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbgKBMR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 07:17:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604319444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6srHEdc7K9ItGRZ8SPqZ63pI0fKJQUiatFahMjHcQpI=;
        b=qmzq7zZvRajipPVcDCVZqfaFzVzzZRwBVKPYmKos8fF5XuX5VddldihmwnNvHBuSw7+nG2
        SMlyBK1JS7dX1L6zaT2URmWvGTdcDcep0jxJ/v4Lp9XNUoPN8dWMMzRlAcon/VyBNwUGRO
        7NFJUltTgrhTL0DFwGrXtrFsNZHLzfk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E74DFAFDB
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 12:17:23 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 06/14] xen/blkback: use lateeoi irq binding
Date:   Mon,  2 Nov 2020 13:17:14 +0100
Message-Id: <20201102121722.10940-7-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102121722.10940-1-jgross@suse.com>
References: <20201102121722.10940-1-jgross@suse.com>
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
index 3666afa639d1..b18f0162cb9c 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -202,7 +202,7 @@ static inline void shrink_free_pagepool(struct xen_blkif_ring *ring, int num)
 
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
 
-static int do_block_io_op(struct xen_blkif_ring *ring);
+static int do_block_io_op(struct xen_blkif_ring *ring, unsigned int *eoi_flags);
 static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 				struct blkif_request *req,
 				struct pending_req *pending_req);
@@ -615,6 +615,8 @@ int xen_blkif_schedule(void *arg)
 	struct xen_vbd *vbd = &blkif->vbd;
 	unsigned long timeout;
 	int ret;
+	bool do_eoi;
+	unsigned int eoi_flags = XEN_EOI_FLAG_SPURIOUS;
 
 	set_freezable();
 	while (!kthread_should_stop()) {
@@ -639,16 +641,23 @@ int xen_blkif_schedule(void *arg)
 		if (timeout == 0)
 			goto purge_gnt_list;
 
+		do_eoi = ring->waiting_reqs;
+
 		ring->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
 
-		ret = do_block_io_op(ring);
+		ret = do_block_io_op(ring, &eoi_flags);
 		if (ret > 0)
 			ring->waiting_reqs = 1;
 		if (ret == -EACCES)
 			wait_event_interruptible(ring->shutdown_wq,
 						 kthread_should_stop());
 
+		if (do_eoi && !ring->waiting_reqs) {
+			xen_irq_lateeoi(ring->irq, eoi_flags);
+			eoi_flags |= XEN_EOI_FLAG_SPURIOUS;
+		}
+
 purge_gnt_list:
 		if (blkif->vbd.feature_gnt_persistent &&
 		    time_after(jiffies, ring->next_lru)) {
@@ -1121,7 +1130,7 @@ static void end_block_io_op(struct bio *bio)
  * and transmute  it to the block API to hand it over to the proper block disk.
  */
 static int
-__do_block_io_op(struct xen_blkif_ring *ring)
+__do_block_io_op(struct xen_blkif_ring *ring, unsigned int *eoi_flags)
 {
 	union blkif_back_rings *blk_rings = &ring->blk_rings;
 	struct blkif_request req;
@@ -1144,6 +1153,9 @@ __do_block_io_op(struct xen_blkif_ring *ring)
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
 			break;
 
+		/* We've seen a request, so clear spurious eoi flag. */
+		*eoi_flags &= ~XEN_EOI_FLAG_SPURIOUS;
+
 		if (kthread_should_stop()) {
 			more_to_do = 1;
 			break;
@@ -1202,13 +1214,13 @@ __do_block_io_op(struct xen_blkif_ring *ring)
 }
 
 static int
-do_block_io_op(struct xen_blkif_ring *ring)
+do_block_io_op(struct xen_blkif_ring *ring, unsigned int *eoi_flags)
 {
 	union blkif_back_rings *blk_rings = &ring->blk_rings;
 	int more_to_do;
 
 	do {
-		more_to_do = __do_block_io_op(ring);
+		more_to_do = __do_block_io_op(ring, eoi_flags);
 		if (more_to_do)
 			break;
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 25c41ce070a7..93896c992245 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -237,9 +237,8 @@ static int xen_blkif_map(struct xen_blkif_ring *ring, grant_ref_t *gref,
 		BUG();
 	}
 
-	err = bind_interdomain_evtchn_to_irqhandler(blkif->domid, evtchn,
-						    xen_blkif_be_int, 0,
-						    "blkif-backend", ring);
+	err = bind_interdomain_evtchn_to_irqhandler_lateeoi(blkif->domid,
+			evtchn, xen_blkif_be_int, 0, "blkif-backend", ring);
 	if (err < 0) {
 		xenbus_unmap_ring_vfree(blkif->be->dev, ring->blk_ring);
 		ring->blk_rings.common.sring = NULL;
-- 
2.26.2

