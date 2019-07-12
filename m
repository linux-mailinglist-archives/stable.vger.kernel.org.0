Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6821366E11
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfGLMgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbfGLMdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:33:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E9E21019;
        Fri, 12 Jul 2019 12:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934792;
        bh=xLLWYA5NAIUr7JRKRwe5NogndUShvfwkFmPHLncTvl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJV4oWyhVj0I99ecYqVG+n+88YUOp2ENLQsoK7k3wpfsv/PjvZMgyBpHDgJPHMNQk
         kc/xWfiF+bPNdPly2nmdTUnavfKKg4YQTdZ/1AOLYVcgPmx4Q09f2d6p/Po+5uteRr
         EFhY6CJ0lGyX0JzGEAR2HY+1kT2Xs7wMKsiA/ZcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.2 31/61] usb: renesas_usbhs: add a workaround for a race condition of workqueue
Date:   Fri, 12 Jul 2019 14:19:44 +0200
Message-Id: <20190712121622.275461655@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit b2357839c56ab7d06bcd4e866ebc2d0e2b7997f3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/renesas_usbhs/fifo.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -802,9 +802,8 @@ static int __usbhsf_dma_map_ctrl(struct
 }
 
 static void usbhsf_dma_complete(void *arg);
-static void xfer_work(struct work_struct *work)
+static void usbhsf_dma_xfer_preparing(struct usbhs_pkt *pkt)
 {
-	struct usbhs_pkt *pkt = container_of(work, struct usbhs_pkt, work);
 	struct usbhs_pipe *pipe = pkt->pipe;
 	struct usbhs_fifo *fifo;
 	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
@@ -812,12 +811,10 @@ static void xfer_work(struct work_struct
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
@@ -826,7 +823,7 @@ static void xfer_work(struct work_struct
 					pkt->trans, dir,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc)
-		goto xfer_work_end;
+		return;
 
 	desc->callback		= usbhsf_dma_complete;
 	desc->callback_param	= pipe;
@@ -834,7 +831,7 @@ static void xfer_work(struct work_struct
 	pkt->cookie = dmaengine_submit(desc);
 	if (pkt->cookie < 0) {
 		dev_err(dev, "Failed to submit dma descriptor\n");
-		goto xfer_work_end;
+		return;
 	}
 
 	dev_dbg(dev, "  %s %d (%d/ %d)\n",
@@ -845,8 +842,17 @@ static void xfer_work(struct work_struct
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
 
@@ -899,8 +905,13 @@ static int usbhsf_dma_prepare_push(struc
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
 
@@ -1006,8 +1017,7 @@ static int usbhsf_dma_prepare_pop_with_u
 
 	pkt->trans = pkt->length;
 
-	INIT_WORK(&pkt->work, xfer_work);
-	schedule_work(&pkt->work);
+	usbhsf_dma_xfer_preparing(pkt);
 
 	return 0;
 


