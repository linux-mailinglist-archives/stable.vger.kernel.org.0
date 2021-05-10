Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02A378558
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhEJLAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234121AbhEJKz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954AD61424;
        Mon, 10 May 2021 10:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643444;
        bh=TT8Vr5DyT6OjzxA8s84RhRT35w+F2fgYN9mwIDXVCjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7be7Jg9iGkWW/0PqTBKuvwlXQtmw2cdsm89U2Fe4yj/6x1x+HslidsjwN5hkUOE7
         O2Q/tGpPCfPztzzxFfNg9KKNdG+JOHe57Iu+9nrOXGpD3FsAOo4yKFxWfbj9NLMM4v
         CxDLKp2mGDGbYjBwqdA8Q5D0Y17Y61JUyHJBWDsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH 5.11 003/342] bus: mhi: core: Sanity check values from remote device before use
Date:   Mon, 10 May 2021 12:16:33 +0200
Message-Id: <20210510102010.211934444@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -222,6 +222,11 @@ static void mhi_del_ring_element(struct
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
@@ -351,7 +356,16 @@ irqreturn_t mhi_irq_handler(int irq_numb
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
@@ -504,6 +518,11 @@ static int parse_xfer_event(struct mhi_c
 		struct mhi_buf_info *buf_info;
 		u16 xfer_len;
 
+		if (!is_valid_ring_ptr(tre_ring, ptr)) {
+			dev_err(&mhi_cntrl->mhi_dev->dev,
+				"Event element points outside of the tre ring\n");
+			break;
+		}
 		/* Get the TRB this event points to */
 		ev_tre = mhi_to_virtual(tre_ring, ptr);
 
@@ -663,6 +682,12 @@ static void mhi_process_cmd_completion(s
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
@@ -687,6 +712,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	u32 chan;
 	int count = 0;
+	dma_addr_t ptr = er_ctxt->rp;
 
 	/*
 	 * This is a quick check to avoid unnecessary event processing
@@ -696,7 +722,13 @@ int mhi_process_ctrl_ev_ring(struct mhi_
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
@@ -802,6 +834,8 @@ int mhi_process_ctrl_ev_ring(struct mhi_
 			 */
 			if (chan < mhi_cntrl->max_chan) {
 				mhi_chan = &mhi_cntrl->mhi_chan[chan];
+				if (!mhi_chan->configured)
+					break;
 				parse_xfer_event(mhi_cntrl, local_rp, mhi_chan);
 				event_quota--;
 			}
@@ -813,7 +847,15 @@ int mhi_process_ctrl_ev_ring(struct mhi_
 
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
 
@@ -836,11 +878,18 @@ int mhi_process_data_event_ring(struct m
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
@@ -854,7 +903,8 @@ int mhi_process_data_event_ring(struct m
 		 * Only process the event ring elements whose channel
 		 * ID is within the maximum supported range.
 		 */
-		if (chan < mhi_cntrl->max_chan) {
+		if (chan < mhi_cntrl->max_chan &&
+		    mhi_cntrl->mhi_chan[chan].configured) {
 			mhi_chan = &mhi_cntrl->mhi_chan[chan];
 
 			if (likely(type == MHI_PKT_TYPE_TX_EVENT)) {
@@ -868,7 +918,15 @@ int mhi_process_data_event_ring(struct m
 
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
@@ -1407,6 +1465,7 @@ static void mhi_mark_stale_events(struct
 	struct mhi_ring *ev_ring;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	unsigned long flags;
+	dma_addr_t ptr;
 
 	dev_dbg(dev, "Marking all events for chan: %d as stale\n", chan);
 
@@ -1414,7 +1473,15 @@ static void mhi_mark_stale_events(struct
 
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


