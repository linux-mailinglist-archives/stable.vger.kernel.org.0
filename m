Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A412A2EC0
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgKBP5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:57:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:39128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgKBP5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 10:57:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604332627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fOanx2XfE5wgJkn/7HNosY0pCVGN6SMoYqp8C5GE4i8=;
        b=WHTEePVSLKkzBhgqbFnUwztIdqMsGxWBXlr//t6AhjuJD6nfdFhGiGmcY/vKi9aHCTFQSm
        1f4lVeQJPipTApn8eG8TOcJ6543k75WWXuZgHfb8CGBNnZnwzDuEp3hHAEsqvTy1+03BoD
        CWDvoy31Mrrt5RLYMCVxQ0GIwu+CmPk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EEAA0B0BF
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 15:57:06 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 08/14] xen/scsiback: use lateeoi irq binding
Date:   Mon,  2 Nov 2020 16:56:59 +0100
Message-Id: <20201102155705.8578-9-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102155705.8578-1-jgross@suse.com>
References: <20201102155705.8578-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving scsifront use the lateeoi
irq binding for scsiback and unmask the event channel only just before
leaving the event handling function.

In case of a ring protocol error don't issue an EOI in order to avoid
the possibility to use that for producing an event storm. This at once
will result in no further call of scsiback_irq_fn(), so the ring_error
struct member can be dropped and scsiback_do_cmd_fn() can signal the
protocol error via a negative return value.

This is part of XSA-332.

This is upstream commit 86991b6e7ea6c613b7692f65106076943449b6b7

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/xen-scsiback.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index e2f3e8b0fba9..fd32c3459b66 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -91,7 +91,6 @@ struct vscsibk_info {
 	unsigned int irq;
 
 	struct vscsiif_back_ring ring;
-	int ring_error;
 
 	spinlock_t ring_lock;
 	atomic_t nr_unreplied_reqs;
@@ -721,7 +720,8 @@ static struct vscsibk_pend *prepare_pending_reqs(struct vscsibk_info *info,
 	return pending_req;
 }
 
-static int scsiback_do_cmd_fn(struct vscsibk_info *info)
+static int scsiback_do_cmd_fn(struct vscsibk_info *info,
+			      unsigned int *eoi_flags)
 {
 	struct vscsiif_back_ring *ring = &info->ring;
 	struct vscsiif_request ring_req;
@@ -738,11 +738,12 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 		rc = ring->rsp_prod_pvt;
 		pr_warn("Dom%d provided bogus ring requests (%#x - %#x = %u). Halting ring processing\n",
 			   info->domid, rp, rc, rp - rc);
-		info->ring_error = 1;
-		return 0;
+		return -EINVAL;
 	}
 
 	while ((rc != rp)) {
+		*eoi_flags &= ~XEN_EOI_FLAG_SPURIOUS;
+
 		if (RING_REQUEST_CONS_OVERFLOW(ring, rc))
 			break;
 
@@ -801,13 +802,16 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 static irqreturn_t scsiback_irq_fn(int irq, void *dev_id)
 {
 	struct vscsibk_info *info = dev_id;
+	int rc;
+	unsigned int eoi_flags = XEN_EOI_FLAG_SPURIOUS;
 
-	if (info->ring_error)
-		return IRQ_HANDLED;
-
-	while (scsiback_do_cmd_fn(info))
+	while ((rc = scsiback_do_cmd_fn(info, &eoi_flags)) > 0)
 		cond_resched();
 
+	/* In case of a ring error we keep the event channel masked. */
+	if (!rc)
+		xen_irq_lateeoi(irq, eoi_flags);
+
 	return IRQ_HANDLED;
 }
 
@@ -828,7 +832,7 @@ static int scsiback_init_sring(struct vscsibk_info *info, grant_ref_t ring_ref,
 	sring = (struct vscsiif_sring *)area;
 	BACK_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
-	err = bind_interdomain_evtchn_to_irq(info->domid, evtchn);
+	err = bind_interdomain_evtchn_to_irq_lateeoi(info->domid, evtchn);
 	if (err < 0)
 		goto unmap_page;
 
@@ -1251,7 +1255,6 @@ static int scsiback_probe(struct xenbus_device *dev,
 
 	info->domid = dev->otherend_id;
 	spin_lock_init(&info->ring_lock);
-	info->ring_error = 0;
 	atomic_set(&info->nr_unreplied_reqs, 0);
 	init_waitqueue_head(&info->waiting_to_free);
 	info->dev = dev;
-- 
2.26.2

