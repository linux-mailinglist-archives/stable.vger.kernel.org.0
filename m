Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE31A20E72F
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404348AbgF2VyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgF2Sfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AEB324732;
        Mon, 29 Jun 2020 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444052;
        bh=sTZhejpHNdPTk4/qHgVwZSgCKGun0MCFQds5tLxB0K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ubc8ycbNfVqA4+LQMTlAvJF7GFl7QZSTX5xx3Ln/F28G8QAl2ZEws7P0UxxDCw39v
         s4sKSAJkrsxSTssd9M5oqBCMF4kwcKuigKK2W8V4ep8HJ2A4PcK+VlhhKi9hCh88OJ
         qD9eMt/a7QrrzPcTTfuvwx1qpqatOZ5jZ9TOyh3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Hien Dang <hien.dang.eb@renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 160/265] usb: renesas_usbhs: getting residue from callback_result
Date:   Mon, 29 Jun 2020 11:16:33 -0400
Message-Id: <20200629151818.2493727-161-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit ea0efd687b01355cd799c8643d0c636ba4859ffc ]

This driver assumed that dmaengine_tx_status() could return
the residue even if the transfer was completed. However,
this was not correct usage [1] and this caused to break getting
the residue after the commit 24461d9792c2 ("dmaengine:
virt-dma: Fix access after free in vchan_complete()") actually.
So, this is possible to get wrong received size if the usb
controller gets a short packet. For example, g_zero driver
causes "bad OUT byte" errors.

The usb-dmac driver will support the callback_result, so this
driver can use it to get residue correctly. Note that even if
the usb-dmac driver has not supported the callback_result yet,
this patch doesn't cause any side-effects.

[1]
https://lore.kernel.org/dmaengine/20200616165550.GP2324254@vkoul-mobl/

Reported-by: Hien Dang <hien.dang.eb@renesas.com>
Fixes: 24461d9792c2 ("dmaengine: virt-dma: Fix access after free in vchan_complete()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1592482277-19563-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/renesas_usbhs/fifo.c | 23 +++++++++++++----------
 drivers/usb/renesas_usbhs/fifo.h |  2 +-
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 01c6a48c41bc9..ac9a81ae82164 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -803,7 +803,8 @@ static int __usbhsf_dma_map_ctrl(struct usbhs_pkt *pkt, int map)
 	return info->dma_map_ctrl(chan->device->dev, pkt, map);
 }
 
-static void usbhsf_dma_complete(void *arg);
+static void usbhsf_dma_complete(void *arg,
+				const struct dmaengine_result *result);
 static void usbhsf_dma_xfer_preparing(struct usbhs_pkt *pkt)
 {
 	struct usbhs_pipe *pipe = pkt->pipe;
@@ -813,6 +814,7 @@ static void usbhsf_dma_xfer_preparing(struct usbhs_pkt *pkt)
 	struct dma_chan *chan;
 	struct device *dev = usbhs_priv_to_dev(priv);
 	enum dma_transfer_direction dir;
+	dma_cookie_t cookie;
 
 	fifo = usbhs_pipe_to_fifo(pipe);
 	if (!fifo)
@@ -827,11 +829,11 @@ static void usbhsf_dma_xfer_preparing(struct usbhs_pkt *pkt)
 	if (!desc)
 		return;
 
-	desc->callback		= usbhsf_dma_complete;
-	desc->callback_param	= pipe;
+	desc->callback_result	= usbhsf_dma_complete;
+	desc->callback_param	= pkt;
 
-	pkt->cookie = dmaengine_submit(desc);
-	if (pkt->cookie < 0) {
+	cookie = dmaengine_submit(desc);
+	if (cookie < 0) {
 		dev_err(dev, "Failed to submit dma descriptor\n");
 		return;
 	}
@@ -1152,12 +1154,10 @@ static size_t usbhs_dma_calc_received_size(struct usbhs_pkt *pkt,
 					   struct dma_chan *chan, int dtln)
 {
 	struct usbhs_pipe *pipe = pkt->pipe;
-	struct dma_tx_state state;
 	size_t received_size;
 	int maxp = usbhs_pipe_get_maxpacket(pipe);
 
-	dmaengine_tx_status(chan, pkt->cookie, &state);
-	received_size = pkt->length - state.residue;
+	received_size = pkt->length - pkt->dma_result->residue;
 
 	if (dtln) {
 		received_size -= USBHS_USB_DMAC_XFER_SIZE;
@@ -1363,13 +1363,16 @@ static int usbhsf_irq_ready(struct usbhs_priv *priv,
 	return 0;
 }
 
-static void usbhsf_dma_complete(void *arg)
+static void usbhsf_dma_complete(void *arg,
+				const struct dmaengine_result *result)
 {
-	struct usbhs_pipe *pipe = arg;
+	struct usbhs_pkt *pkt = arg;
+	struct usbhs_pipe *pipe = pkt->pipe;
 	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
 	struct device *dev = usbhs_priv_to_dev(priv);
 	int ret;
 
+	pkt->dma_result = result;
 	ret = usbhsf_pkt_handler(pipe, USBHSF_PKT_DMA_DONE);
 	if (ret < 0)
 		dev_err(dev, "dma_complete run_error %d : %d\n",
diff --git a/drivers/usb/renesas_usbhs/fifo.h b/drivers/usb/renesas_usbhs/fifo.h
index c3d3cc35cee0f..4a7dc23ce3d35 100644
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -50,7 +50,7 @@ struct usbhs_pkt {
 		     struct usbhs_pkt *pkt);
 	struct work_struct work;
 	dma_addr_t dma;
-	dma_cookie_t cookie;
+	const struct dmaengine_result *dma_result;
 	void *buf;
 	int length;
 	int trans;
-- 
2.25.1

