Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61CD55E3DE
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGCM1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbfGCM1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A57218A3;
        Wed,  3 Jul 2019 12:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156830;
        bh=Y4mMMo8SIvIZF9q6dM4s9/ft5PAlwy7ZaXgmPNpzy3s=;
        h=Subject:To:From:Date:From;
        b=idR7ArB+TIWqnDql8gQtttL+olnlspzjhvjVfxnBvFbbcntPmiFtHCsfQbhDYBz6O
         J8FXHlNwpjQEanj+/PVeEcwkJP4nDKh+bQRG1QszxxnHUq4SBc8KBg769diQbrYY4p
         1ojLTPEXVcKeHT93hewBUGsD2D9ketqK90NNY6c0=
Subject: patch "usb: renesas_usbhs: add a workaround for a race condition of" added to usb-next
To:     yoshihiro.shimoda.uh@renesas.com, felipe.balbi@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Jul 2019 14:26:41 +0200
Message-ID: <156215680105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: renesas_usbhs: add a workaround for a race condition of

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b2357839c56ab7d06bcd4e866ebc2d0e2b7997f3 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Wed, 26 Jun 2019 22:06:33 +0900
Subject: usb: renesas_usbhs: add a workaround for a race condition of
 workqueue

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
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/renesas_usbhs/fifo.c | 34 +++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index e84d2ac2a30a..1a0ab639dd22 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -803,9 +803,8 @@ static int __usbhsf_dma_map_ctrl(struct usbhs_pkt *pkt, int map)
 }
 
 static void usbhsf_dma_complete(void *arg);
-static void xfer_work(struct work_struct *work)
+static void usbhsf_dma_xfer_preparing(struct usbhs_pkt *pkt)
 {
-	struct usbhs_pkt *pkt = container_of(work, struct usbhs_pkt, work);
 	struct usbhs_pipe *pipe = pkt->pipe;
 	struct usbhs_fifo *fifo;
 	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
@@ -813,12 +812,10 @@ static void xfer_work(struct work_struct *work)
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
@@ -827,7 +824,7 @@ static void xfer_work(struct work_struct *work)
 					pkt->trans, dir,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc)
-		goto xfer_work_end;
+		return;
 
 	desc->callback		= usbhsf_dma_complete;
 	desc->callback_param	= pipe;
@@ -835,7 +832,7 @@ static void xfer_work(struct work_struct *work)
 	pkt->cookie = dmaengine_submit(desc);
 	if (pkt->cookie < 0) {
 		dev_err(dev, "Failed to submit dma descriptor\n");
-		goto xfer_work_end;
+		return;
 	}
 
 	dev_dbg(dev, "  %s %d (%d/ %d)\n",
@@ -846,8 +843,17 @@ static void xfer_work(struct work_struct *work)
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
 
@@ -900,8 +906,13 @@ static int usbhsf_dma_prepare_push(struct usbhs_pkt *pkt, int *is_done)
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
 
@@ -1007,8 +1018,7 @@ static int usbhsf_dma_prepare_pop_with_usb_dmac(struct usbhs_pkt *pkt,
 
 	pkt->trans = pkt->length;
 
-	INIT_WORK(&pkt->work, xfer_work);
-	schedule_work(&pkt->work);
+	usbhsf_dma_xfer_preparing(pkt);
 
 	return 0;
 
-- 
2.22.0


