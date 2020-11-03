Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3972A4845
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgKCOfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:35:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:47278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgKCOfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:35:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604414129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9xfDQC9VA6njrT5UUyux7fh3A70PklCSZb7nYFgiRGM=;
        b=ccb7d8GgS+/C8UjqsD8DyjQo/z+VkPqmKS+vXrXHX7kKiXmXM7veWfg98z9f+E91h2Dfpf
        b49CnJtVIoCG4pDdfeOIBMpb9W4hHJXLQenZePhIaw4AxcMRGHN2i0LHgfwn6sSmcoB/gS
        ZP/+y11wDkBte2SVCLRJ8X64JWsMj7Y=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 82F41B2A9
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:35:29 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 08/13] xen/scsiback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 15:35:23 +0100
Message-Id: <20201103143528.22780-9-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103143528.22780-1-jgross@suse.com>
References: <20201103143528.22780-1-jgross@suse.com>
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
index 992cb8fa272c..3243d917651a 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -91,7 +91,6 @@ struct vscsibk_info {
 	unsigned int irq;
 
 	struct vscsiif_back_ring ring;
-	int ring_error;
 
 	spinlock_t ring_lock;
 	atomic_t nr_unreplied_reqs;
@@ -723,7 +722,8 @@ static struct vscsibk_pend *prepare_pending_reqs(struct vscsibk_info *info,
 	return pending_req;
 }
 
-static int scsiback_do_cmd_fn(struct vscsibk_info *info)
+static int scsiback_do_cmd_fn(struct vscsibk_info *info,
+			      unsigned int *eoi_flags)
 {
 	struct vscsiif_back_ring *ring = &info->ring;
 	struct vscsiif_request ring_req;
@@ -740,11 +740,12 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
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
 
@@ -803,13 +804,16 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
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
 
@@ -830,7 +834,7 @@ static int scsiback_init_sring(struct vscsibk_info *info, grant_ref_t ring_ref,
 	sring = (struct vscsiif_sring *)area;
 	BACK_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
-	err = bind_interdomain_evtchn_to_irq(info->domid, evtchn);
+	err = bind_interdomain_evtchn_to_irq_lateeoi(info->domid, evtchn);
 	if (err < 0)
 		goto unmap_page;
 
@@ -1253,7 +1257,6 @@ static int scsiback_probe(struct xenbus_device *dev,
 
 	info->domid = dev->otherend_id;
 	spin_lock_init(&info->ring_lock);
-	info->ring_error = 0;
 	atomic_set(&info->nr_unreplied_reqs, 0);
 	init_waitqueue_head(&info->waiting_to_free);
 	info->dev = dev;
-- 
2.26.2

