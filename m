Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E1165C27
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 11:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgBTKwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 05:52:23 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43634 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgBTKwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 05:52:23 -0500
Received: by mail-qv1-f68.google.com with SMTP id p2so1644823qvo.10
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 02:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oJbikfzhAeZeIr3j879hienH3oUb6eekhjWJuA1oGb0=;
        b=VQrjwIR/LW8QTzYKHkDhvE2oHc2F+oZlNX7DIFtYsfZwT60aRCXZc2ypOic5IKew2g
         mE7ePT8rZFNHvP6UJgl0LtL/tYumWFAzdpjkXvKiiGzp0XZYlFD50EhI+cNkQmaRl2i+
         9fqh53aALfg5jEn+cIXR0/kggR2ckPn0SKdI7mPzkErsBulak1ir2SlpGnxvYgGAu9Ji
         IkvXrPEc8g4MurmKyYE98CAvCT8iNieu24Ewi3fq7xM4Px1K7AYVAkYV5XGOm3dyrSao
         buXPU/BN9Mgw8h02BgrMcpMgttjCjLeh6aK2rjjLiiuxz+7vh+H9erIrnzNvFSww4mq8
         puwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oJbikfzhAeZeIr3j879hienH3oUb6eekhjWJuA1oGb0=;
        b=gOg4XuCKTI4Sshr24XjwsdEyT9qlbwdzioPha1J5DUiLBbx5lYotYWhRMi+kufBWBS
         6J36NU3FogjtoCiyRU9ingnfTyI7l1YRM6VRqh3Csr4O5ta0BsDmpNtCn77rdRKarLet
         V3ITdPOLS+qDKY2XkDL1c21B1v2rJiCUQV8DSa0dIRzzTaSJIoqnfuCtDliYQvEW4ssb
         64a/xlEYo9X3uVVOGi3uxUYPvOsDZ3FiaJHFjlE7l5mkdYDvQzxrXty5o0nZtEKNw8M8
         BpNTREgesn030J2MVEisvle7vcaJ8cJrv+iz3uId+8x8FRmigiZ/RYMgL0CfKYIg/Fg5
         +eRw==
X-Gm-Message-State: APjAAAVI7ZLhKenxr0+OMqWrY4WUKyoAAvaJxLmlVIs1EGluGRyhUpwt
        eWMGjW8aJ+LV6H3ek94FhOCvozS3
X-Google-Smtp-Source: APXvYqwzHYqe8gqfuSNkX/u/J0iXQZ0J6Fh5dRrMWFMXDdCoHzSJkchFrfoWHxZM9VMQjlpzzoosHg==
X-Received: by 2002:ad4:46ce:: with SMTP id g14mr25049252qvw.67.1582195940031;
        Thu, 20 Feb 2020 02:52:20 -0800 (PST)
Received: from fabio-Latitude-E5450.nxp.com ([2804:14c:482:5bb::1])
        by smtp.gmail.com with ESMTPSA id a198sm1396256qkg.41.2020.02.20.02.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 02:52:19 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     stable@vger.kernel.org
Cc:     peter.chen@nxp.com, mathias.nyman@linux.intel.com,
        gregkh@linuxfoundation.org, Fabio Estevam <festevam@gmail.com>
Subject: usb: host: xhci: update event ring dequeue pointer on purpose
Date:   Thu, 20 Feb 2020 07:52:09 -0300
Message-Id: <20200220105209.27506-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit dc0ffbea5729a3abafa577ebfce87f18b79e294b ]

On some situations, the software handles TRB events slower
than adding TRBs, then xhci_handle_event can't return zero
long time, the xHC will consider the event ring is full,
and trigger "Event Ring Full" error, but in fact, the software
has already finished lots of events, just no chance to
update ERDP (event ring dequeue pointer).

In this commit, we force update ERDP if half of TRBS_PER_SEGMENT
events have handled to avoid "Event Ring Full" error.

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1573836603-10871-2-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Hi,

One of our customer running 4.14 reported that this upstream patch
fixes USB issues, so I am sending it to the stable trees.

 drivers/usb/host/xhci-ring.c | 60 +++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index e7aab31fd9a5..55084adf1faf 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2740,6 +2740,42 @@ static int xhci_handle_event(struct xhci_hcd *xhci)
 	return 1;
 }
 
+/*
+ * Update Event Ring Dequeue Pointer:
+ * - When all events have finished
+ * - To avoid "Event Ring Full Error" condition
+ */
+static void xhci_update_erst_dequeue(struct xhci_hcd *xhci,
+		union xhci_trb *event_ring_deq)
+{
+	u64 temp_64;
+	dma_addr_t deq;
+
+	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
+	/* If necessary, update the HW's version of the event ring deq ptr. */
+	if (event_ring_deq != xhci->event_ring->dequeue) {
+		deq = xhci_trb_virt_to_dma(xhci->event_ring->deq_seg,
+				xhci->event_ring->dequeue);
+		if (deq == 0)
+			xhci_warn(xhci, "WARN something wrong with SW event ring dequeue ptr\n");
+		/*
+		 * Per 4.9.4, Software writes to the ERDP register shall
+		 * always advance the Event Ring Dequeue Pointer value.
+		 */
+		if ((temp_64 & (u64) ~ERST_PTR_MASK) ==
+				((u64) deq & (u64) ~ERST_PTR_MASK))
+			return;
+
+		/* Update HC event ring dequeue pointer */
+		temp_64 &= ERST_PTR_MASK;
+		temp_64 |= ((u64) deq & (u64) ~ERST_PTR_MASK);
+	}
+
+	/* Clear the event handler busy flag (RW1C) */
+	temp_64 |= ERST_EHB;
+	xhci_write_64(xhci, temp_64, &xhci->ir_set->erst_dequeue);
+}
+
 /*
  * xHCI spec says we can get an interrupt, and if the HC has an error condition,
  * we might get bad data out of the event ring.  Section 4.10.2.7 has a list of
@@ -2751,9 +2787,9 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 	union xhci_trb *event_ring_deq;
 	irqreturn_t ret = IRQ_NONE;
 	unsigned long flags;
-	dma_addr_t deq;
 	u64 temp_64;
 	u32 status;
+	int event_loop = 0;
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	/* Check if the xHC generated the interrupt, or the irq is shared */
@@ -2807,24 +2843,14 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 	/* FIXME this should be a delayed service routine
 	 * that clears the EHB.
 	 */
-	while (xhci_handle_event(xhci) > 0) {}
-
-	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
-	/* If necessary, update the HW's version of the event ring deq ptr. */
-	if (event_ring_deq != xhci->event_ring->dequeue) {
-		deq = xhci_trb_virt_to_dma(xhci->event_ring->deq_seg,
-				xhci->event_ring->dequeue);
-		if (deq == 0)
-			xhci_warn(xhci, "WARN something wrong with SW event "
-					"ring dequeue ptr.\n");
-		/* Update HC event ring dequeue pointer */
-		temp_64 &= ERST_PTR_MASK;
-		temp_64 |= ((u64) deq & (u64) ~ERST_PTR_MASK);
+	while (xhci_handle_event(xhci) > 0) {
+		if (event_loop++ < TRBS_PER_SEGMENT / 2)
+			continue;
+		xhci_update_erst_dequeue(xhci, event_ring_deq);
+		event_loop = 0;
 	}
 
-	/* Clear the event handler busy flag (RW1C); event ring is empty. */
-	temp_64 |= ERST_EHB;
-	xhci_write_64(xhci, temp_64, &xhci->ir_set->erst_dequeue);
+	xhci_update_erst_dequeue(xhci, event_ring_deq);
 	ret = IRQ_HANDLED;
 
 out:
-- 
cgit 1.2-0.3.lf.el7
