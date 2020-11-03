Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BCB2A5795
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732504AbgKCUx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732500AbgKCUx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:53:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A95B22226;
        Tue,  3 Nov 2020 20:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436836;
        bh=Zm9qkC2dHdQaGhe1HFL456FzcRb3htH+NmybWllhnUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5dsg6DfpCmDRVN76zZiGZgP5d4UPnZ+Rxi+hT1vw5VdKwfHCyZ7YJWsyHzDDRfB/
         z5v3BQJheB8G7F9Q73l9gNFTAvraFuY6WmerRtjdNUFisLnQL03w/giJVBx4R0XxY9
         z4LoV2TOtOUfFo7D101uE0qvmArtsZlQCT7Qlr3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 5.4 005/214] xen/blkback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 21:34:13 +0100
Message-Id: <20201103203250.053115009@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 01263a1fabe30b4d542f34c7e2364a22587ddaf2 upstream.

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving blkfront use the lateeoi
irq binding for blkback and unmask the event channel only after
processing all pending requests.

As the thread processing requests is used to do purging work in regular
intervals an EOI may be sent only after having received an event. If
there was no pending I/O request flag the EOI as spurious.

This is part of XSA-332.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/block/xen-blkback/blkback.c |   22 +++++++++++++++++-----
 drivers/block/xen-blkback/xenbus.c  |    5 ++---
 2 files changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -202,7 +202,7 @@ static inline void shrink_free_pagepool(
 
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
@@ -1121,7 +1130,7 @@ static void end_block_io_op(struct bio *
  * and transmute  it to the block API to hand it over to the proper block disk.
  */
 static int
-__do_block_io_op(struct xen_blkif_ring *ring)
+__do_block_io_op(struct xen_blkif_ring *ring, unsigned int *eoi_flags)
 {
 	union blkif_back_rings *blk_rings = &ring->blk_rings;
 	struct blkif_request req;
@@ -1144,6 +1153,9 @@ __do_block_io_op(struct xen_blkif_ring *
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
 			break;
 
+		/* We've seen a request, so clear spurious eoi flag. */
+		*eoi_flags &= ~XEN_EOI_FLAG_SPURIOUS;
+
 		if (kthread_should_stop()) {
 			more_to_do = 1;
 			break;
@@ -1202,13 +1214,13 @@ done:
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
 
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -229,9 +229,8 @@ static int xen_blkif_map(struct xen_blki
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


