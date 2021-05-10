Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630E3378322
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhEJKmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhEJKku (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:40:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB25961876;
        Mon, 10 May 2021 10:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642687;
        bh=rDeV4pD5ot8q4zhQBP6w7BmQ58bXAPMEj/Lcf5TNEnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt0dBZTtBGxygNNcj3fE+nZfqCQwsywW8avcL/Lr+fLudMWvfiCao9yxib3q0HNlz
         v5FmyxM6uv6aKyqDA7VtYYkoPHWP8gpYQhEU4TgekjOYnyt5CxtzDJ2We6b25QvpF3
         +wMf6HFuZCe412RoGfPNfG5oAyzj0Qe87Lnzs+rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH 5.10 003/299] bus: mhi: core: Sanity check values from remote device before use
Date:   Mon, 10 May 2021 12:16:40 +0200
Message-Id: <20210510102004.938603379@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jhugo@codeaurora.org>

commit ec32332df7645e0ba463a08d483fe97665167071 upstream.

When parsing the structures in the shared memory, there are values which
come from the remote device.  For example, a transfer completion event
will have a pointer to the tre in the relevant channel's transfer ring.
As another example, event ring elements may specify a channel in which
the event occurred, however the specified channel value may not be valid
as no channel is defined at that index even though the index may be less
than the maximum allowed index.  Such values should be considered to be
untrusted, and validated before use.  If we blindly use such values, we
may access invalid data or crash if the values are corrupted.

If validation fails, drop the relevant event.

Signed-off-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Link: https://lore.kernel.org/r/1615411855-15053-1-git-send-email-jhugo@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/main.c |   81 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 7 deletions(-)

--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -220,6 +220,11 @@ static void mhi_del_ring_element(struct
 	smp_wmb();
 }
 
+static bool is_valid_ring_ptr(struct mhi_ring *ring, dma_addr_t addr)
+{
+	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len;
+}
+
 int mhi_destroy_device(struct device *dev, void *data)
 {
 	struct mhi_device *mhi_dev;
@@ -349,7 +354,16 @@ irqreturn_t mhi_irq_handler(int irq_numb
 	struct mhi_event_ctxt *er_ctxt =
 		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
 	struct mhi_ring *ev_ring = &mhi_event->ring;
-	void *dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+	dma_addr_t ptr = er_ctxt->rp;
+	void *dev_rp;
+
+	if (!is_valid_ring_ptr(ev_ring, ptr)) {
+		dev_err(&mhi_cntrl->mhi_dev->dev,
+			"Event ring rp points outside of the event ring\n");
+		return IRQ_HANDLED;
+	}
+
+	dev_rp = mhi_to_virtual(ev_ring, ptr);
 
 	/* Only proceed if event ring has pending events */
 	if (ev_ring->rp == dev_rp)
@@ -498,6 +512,11 @@ static int parse_xfer_event(struct mhi_c
 		struct mhi_buf_info *buf_info;
 		u16 xfer_len;
 
+		if (!is_valid_ring_ptr(tre_ring, ptr)) {
+			dev_err(&mhi_cntrl->mhi_dev->dev,
+				"Event element points outside of the tre ring\n");
+			break;
+		}
 		/* Get the TRB this event points to */
 		ev_tre = mhi_to_virtual(tre_ring, ptr);
 
@@ -657,6 +676,12 @@ static void mhi_process_cmd_completion(s
 	struct mhi_chan *mhi_chan;
 	u32 chan;
 
+	if (!is_valid_ring_ptr(mhi_ring, ptr)) {
+		dev_err(&mhi_cntrl->mhi_dev->dev,
+			"Event element points outside of the cmd ring\n");
+		return;
+	}
+
 	cmd_pkt = mhi_to_virtual(mhi_ring, ptr);
 
 	chan = MHI_TRE_GET_CMD_CHID(cmd_pkt);
@@ -681,6 +706,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	u32 chan;
 	int count = 0;
+	dma_addr_t ptr = er_ctxt->rp;
 
 	/*
 	 * This is a quick check to avoid unnecessary event processing
@@ -690,7 +716,13 @@ int mhi_process_ctrl_ev_ring(struct mhi_
 	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state)))
 		return -EIO;
 
-	dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+	if (!is_valid_ring_ptr(ev_ring, ptr)) {
+		dev_err(&mhi_cntrl->mhi_dev->dev,
+			"Event ring rp points outside of the event ring\n");
+		return -EIO;
+	}
+
+	dev_rp = mhi_to_virtual(ev_ring, ptr);
 	local_rp = ev_ring->rp;
 
 	while (dev_rp != local_rp) {
@@ -801,6 +833,8 @@ int mhi_process_ctrl_ev_ring(struct mhi_
 			 */
 			if (chan < mhi_cntrl->max_chan) {
 				mhi_chan = &mhi_cntrl->mhi_chan[chan];
+				if (!mhi_chan->configured)
+					break;
 				parse_xfer_event(mhi_cntrl, local_rp, mhi_chan);
 				event_quota--;
 			}
@@ -812,7 +846,15 @@ int mhi_process_ctrl_ev_ring(struct mhi_
 
 		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
 		local_rp = ev_ring->rp;
-		dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+
+		ptr = er_ctxt->rp;
+		if (!is_valid_ring_ptr(ev_ring, ptr)) {
+			dev_err(&mhi_cntrl->mhi_dev->dev,
+				"Event ring rp points outside of the event ring\n");
+			return -EIO;
+		}
+
+		dev_rp = mhi_to_virtual(ev_ring, ptr);
 		count++;
 	}
 
@@ -835,11 +877,18 @@ int mhi_process_data_event_ring(struct m
 	int count = 0;
 	u32 chan;
 	struct mhi_chan *mhi_chan;
+	dma_addr_t ptr = er_ctxt->rp;
 
 	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state)))
 		return -EIO;
 
-	dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+	if (!is_valid_ring_ptr(ev_ring, ptr)) {
+		dev_err(&mhi_cntrl->mhi_dev->dev,
+			"Event ring rp points outside of the event ring\n");
+		return -EIO;
+	}
+
+	dev_rp = mhi_to_virtual(ev_ring, ptr);
 	local_rp = ev_ring->rp;
 
 	while (dev_rp != local_rp && event_quota > 0) {
@@ -853,7 +902,8 @@ int mhi_process_data_event_ring(struct m
 		 * Only process the event ring elements whose channel
 		 * ID is within the maximum supported range.
 		 */
-		if (chan < mhi_cntrl->max_chan) {
+		if (chan < mhi_cntrl->max_chan &&
+		    mhi_cntrl->mhi_chan[chan].configured) {
 			mhi_chan = &mhi_cntrl->mhi_chan[chan];
 
 			if (likely(type == MHI_PKT_TYPE_TX_EVENT)) {
@@ -867,7 +917,15 @@ int mhi_process_data_event_ring(struct m
 
 		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
 		local_rp = ev_ring->rp;
-		dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+
+		ptr = er_ctxt->rp;
+		if (!is_valid_ring_ptr(ev_ring, ptr)) {
+			dev_err(&mhi_cntrl->mhi_dev->dev,
+				"Event ring rp points outside of the event ring\n");
+			return -EIO;
+		}
+
+		dev_rp = mhi_to_virtual(ev_ring, ptr);
 		count++;
 	}
 	read_lock_bh(&mhi_cntrl->pm_lock);
@@ -1394,6 +1452,7 @@ static void mhi_mark_stale_events(struct
 	struct mhi_ring *ev_ring;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	unsigned long flags;
+	dma_addr_t ptr;
 
 	dev_dbg(dev, "Marking all events for chan: %d as stale\n", chan);
 
@@ -1401,7 +1460,15 @@ static void mhi_mark_stale_events(struct
 
 	/* mark all stale events related to channel as STALE event */
 	spin_lock_irqsave(&mhi_event->lock, flags);
-	dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+
+	ptr = er_ctxt->rp;
+	if (!is_valid_ring_ptr(ev_ring, ptr)) {
+		dev_err(&mhi_cntrl->mhi_dev->dev,
+			"Event ring rp points outside of the event ring\n");
+		dev_rp = ev_ring->rp;
+	} else {
+		dev_rp = mhi_to_virtual(ev_ring, ptr);
+	}
 
 	local_rp = ev_ring->rp;
 	while (dev_rp != local_rp) {


