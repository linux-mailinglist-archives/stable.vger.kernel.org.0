Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE2F569FE
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFZNHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:07:12 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:20322 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726157AbfFZNHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:07:12 -0400
X-IronPort-AV: E=Sophos;i="5.62,419,1554735600"; 
   d="scan'208";a="19770037"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 26 Jun 2019 22:07:09 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 0357041145A0;
        Wed, 26 Jun 2019 22:07:09 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "# v4 . 1+" <stable@vger.kernel.org>
Subject: [PATCH] usb: renesas_usbhs: add a workaround for a race condition of workqueue
Date:   Wed, 26 Jun 2019 22:06:33 +0900
Message-Id: <1561554393-6027-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The old commit 6e4b74e4690d ("usb: renesas: fix scheduling in atomic
context bug") fixed an atomic issue by using workqueue for the shdmac
dmaengine driver. However, this has a potential race condition issue
between the work pending and usbhsg_ep_free_request() in gadget mode.
When usbhsg_ep_free_request() is called while pending the queue,
since the work_struct will be freed and then the work handler is
called, kernel panic happens on process_one_work().

To fix the issue, if we could call cancel_work_sync() at somewhere
before the free request, it could be easy. However,
the usbhsg_ep_free_request() is called on atomic (e.g. f_ncm driver
calls free request via gether_disconnect()).

For now, almost all users are having "USB-DMAC" and the DMAengine
driver can be used on atomic. So, this patch adds a workaround for
a race condition to call the DMAengine APIs without the workqueue.

This means we still have TODO on shdmac environment (SH7724), but
since it doesn't have SMP, the race condition might not happen.

Fixes: ab330cf3888d ("usb: renesas_usbhs: add support for USB-DMAC")
Cc: <stable@vger.kernel.org> # v4.1+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 This patch is based on Greg's usb.git / usb-linus branch.

 I have no idea why this issue doesn't happen on previous kernel versions
 though, but this issue happens on v5.2-rc6 + g_ncm + R-Car H3. So,
 if possible, I'd like to apply this patch on v5.2-stable.

 drivers/usb/renesas_usbhs/fifo.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 39fa2fc..6036cba 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -802,9 +802,8 @@ static int __usbhsf_dma_map_ctrl(struct usbhs_pkt *pkt, int map)
 }
 
 static void usbhsf_dma_complete(void *arg);
-static void xfer_work(struct work_struct *work)
+static void usbhsf_dma_xfer_preparing(struct usbhs_pkt *pkt)
 {
-	struct usbhs_pkt *pkt = container_of(work, struct usbhs_pkt, work);
 	struct usbhs_pipe *pipe = pkt->pipe;
 	struct usbhs_fifo *fifo;
 	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
@@ -812,12 +811,10 @@ static void xfer_work(struct work_struct *work)
 	struct dma_chan *chan;
 	struct device *dev = usbhs_priv_to_dev(priv);
 	enum dma_transfer_direction dir;
-	unsigned long flags;
 
-	usbhs_lock(priv, flags);
 	fifo = usbhs_pipe_to_fifo(pipe);
 	if (!fifo)
-		goto xfer_work_end;
+		return;
 
 	chan = usbhsf_dma_chan_get(fifo, pkt);
 	dir = usbhs_pipe_is_dir_in(pipe) ? DMA_DEV_TO_MEM : DMA_MEM_TO_DEV;
@@ -826,7 +823,7 @@ static void xfer_work(struct work_struct *work)
 					pkt->trans, dir,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc)
-		goto xfer_work_end;
+		return;
 
 	desc->callback		= usbhsf_dma_complete;
 	desc->callback_param	= pipe;
@@ -834,7 +831,7 @@ static void xfer_work(struct work_struct *work)
 	pkt->cookie = dmaengine_submit(desc);
 	if (pkt->cookie < 0) {
 		dev_err(dev, "Failed to submit dma descriptor\n");
-		goto xfer_work_end;
+		return;
 	}
 
 	dev_dbg(dev, "  %s %d (%d/ %d)\n",
@@ -845,8 +842,17 @@ static void xfer_work(struct work_struct *work)
 	dma_async_issue_pending(chan);
 	usbhsf_dma_start(pipe, fifo);
 	usbhs_pipe_enable(pipe);
+}
+
+static void xfer_work(struct work_struct *work)
+{
+	struct usbhs_pkt *pkt = container_of(work, struct usbhs_pkt, work);
+	struct usbhs_pipe *pipe = pkt->pipe;
+	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
+	unsigned long flags;
 
-xfer_work_end:
+	usbhs_lock(priv, flags);
+	usbhsf_dma_xfer_preparing(pkt);
 	usbhs_unlock(priv, flags);
 }
 
@@ -899,8 +905,13 @@ static int usbhsf_dma_prepare_push(struct usbhs_pkt *pkt, int *is_done)
 	pkt->trans = len;
 
 	usbhsf_tx_irq_ctrl(pipe, 0);
-	INIT_WORK(&pkt->work, xfer_work);
-	schedule_work(&pkt->work);
+	/* FIXME: Workaound for usb dmac that driver can be used in atomic */
+	if (usbhs_get_dparam(priv, has_usb_dmac)) {
+		usbhsf_dma_xfer_preparing(pkt);
+	} else {
+		INIT_WORK(&pkt->work, xfer_work);
+		schedule_work(&pkt->work);
+	}
 
 	return 0;
 
@@ -1006,8 +1017,7 @@ static int usbhsf_dma_prepare_pop_with_usb_dmac(struct usbhs_pkt *pkt,
 
 	pkt->trans = pkt->length;
 
-	INIT_WORK(&pkt->work, xfer_work);
-	schedule_work(&pkt->work);
+	usbhsf_dma_xfer_preparing(pkt);
 
 	return 0;
 
-- 
2.7.4

