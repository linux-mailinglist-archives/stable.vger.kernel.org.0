Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD62B6664
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgKQOCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbgKQNMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:12:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC08221EB;
        Tue, 17 Nov 2020 13:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618766;
        bh=hTYVv2DCEexw7RTDxYmsisHAF7e6nQtYOueqm6EneUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qI5v/X9AsHtfTLja3y9uIwmF3hVDV3UuwXfz6O7x6feXQ+RGgyUhsgmF0tIgeqeGn
         Ypx6a2ilkT/ax817uKOarG3M+uZngMfr9PV6SPQAzq1S6lP/VFlACASeg41tIQX4Cw
         ngVLg+hK/kW8JbPcbn/H8fI4d0in+d7we2KI9N0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Grall <julien@xen.org>, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 4.9 68/78] xen/scsiback: use lateeoi irq binding
Date:   Tue, 17 Nov 2020 14:05:34 +0100
Message-Id: <20201117122112.437992382@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 86991b6e7ea6c613b7692f65106076943449b6b7 upstream.

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

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-scsiback.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -91,7 +91,6 @@ struct vscsibk_info {
 	unsigned int irq;
 
 	struct vscsiif_back_ring ring;
-	int ring_error;
 
 	spinlock_t ring_lock;
 	atomic_t nr_unreplied_reqs;
@@ -723,7 +722,8 @@ static struct vscsibk_pend *prepare_pend
 	return pending_req;
 }
 
-static int scsiback_do_cmd_fn(struct vscsibk_info *info)
+static int scsiback_do_cmd_fn(struct vscsibk_info *info,
+			      unsigned int *eoi_flags)
 {
 	struct vscsiif_back_ring *ring = &info->ring;
 	struct vscsiif_request ring_req;
@@ -740,11 +740,12 @@ static int scsiback_do_cmd_fn(struct vsc
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
 
@@ -803,13 +804,16 @@ static int scsiback_do_cmd_fn(struct vsc
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
 
@@ -830,7 +834,7 @@ static int scsiback_init_sring(struct vs
 	sring = (struct vscsiif_sring *)area;
 	BACK_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
-	err = bind_interdomain_evtchn_to_irq(info->domid, evtchn);
+	err = bind_interdomain_evtchn_to_irq_lateeoi(info->domid, evtchn);
 	if (err < 0)
 		goto unmap_page;
 
@@ -1253,7 +1257,6 @@ static int scsiback_probe(struct xenbus_
 
 	info->domid = dev->otherend_id;
 	spin_lock_init(&info->ring_lock);
-	info->ring_error = 0;
 	atomic_set(&info->nr_unreplied_reqs, 0);
 	init_waitqueue_head(&info->waiting_to_free);
 	info->dev = dev;


