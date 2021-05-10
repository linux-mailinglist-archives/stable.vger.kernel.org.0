Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC937873E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbhEJLOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236181AbhEJLHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D4936193A;
        Mon, 10 May 2021 10:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644327;
        bh=Kv21liz6kGlRfMPdOLsKA+J6Fros0SuGVrZIwFWt+sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LII8cGmsIUx+bnlPFkX+QrLrVjae5QaMT0lLqx6yQp5gaiZx0ko6+Q3NsWe7M4y0Q
         OKA2sT6p1rE0MBHpkcKmMwCLZxXAe30bnrOl+JiSlc1gEFfkLz0bEu6NczDduqeGdT
         cMNkQCNPaiIH6lm02XQ0+Il6p2HxN1XRBOTCpMhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.12 006/384] bus: mhi: core: Fix MHI runtime_pm behavior
Date:   Mon, 10 May 2021 12:16:35 +0200
Message-Id: <20210510102015.083891508@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit 4547a749be997eb12ea7edcf361ec2a5329f7aec upstream.

This change ensures that PM reference is always get during packet
queueing and released either after queuing completion (RX) or once
the buffer has been consumed (TX). This guarantees proper update for
underlying MHI controller runtime status (e.g. last_busy timestamp)
and prevents suspend to be triggered while TX packets are flying,
or before we completed update of the RX ring.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1617700315-12492-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/main.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -589,8 +589,11 @@ static int parse_xfer_event(struct mhi_c
 			/* notify client */
 			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
 
-			if (mhi_chan->dir == DMA_TO_DEVICE)
+			if (mhi_chan->dir == DMA_TO_DEVICE) {
 				atomic_dec(&mhi_cntrl->pending_pkts);
+				/* Release the reference got from mhi_queue() */
+				mhi_cntrl->runtime_put(mhi_cntrl);
+			}
 
 			/*
 			 * Recycle the buffer if buffer is pre-allocated,
@@ -1062,9 +1065,11 @@ static int mhi_queue(struct mhi_device *
 	if (unlikely(ret))
 		goto exit_unlock;
 
-	/* trigger M3 exit if necessary */
-	if (MHI_PM_IN_SUSPEND_STATE(mhi_cntrl->pm_state))
-		mhi_trigger_resume(mhi_cntrl);
+	/* Packet is queued, take a usage ref to exit M3 if necessary
+	 * for host->device buffer, balanced put is done on buffer completion
+	 * for device->host buffer, balanced put is after ringing the DB
+	 */
+	mhi_cntrl->runtime_get(mhi_cntrl);
 
 	/* Assert dev_wake (to exit/prevent M1/M2)*/
 	mhi_cntrl->wake_toggle(mhi_cntrl);
@@ -1079,6 +1084,9 @@ static int mhi_queue(struct mhi_device *
 
 	mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 
+	if (dir == DMA_FROM_DEVICE)
+		mhi_cntrl->runtime_put(mhi_cntrl);
+
 exit_unlock:
 	read_unlock_irqrestore(&mhi_cntrl->pm_lock, flags);
 
@@ -1470,8 +1478,11 @@ static void mhi_reset_data_chan(struct m
 	while (tre_ring->rp != tre_ring->wp) {
 		struct mhi_buf_info *buf_info = buf_ring->rp;
 
-		if (mhi_chan->dir == DMA_TO_DEVICE)
+		if (mhi_chan->dir == DMA_TO_DEVICE) {
 			atomic_dec(&mhi_cntrl->pending_pkts);
+			/* Release the reference got from mhi_queue() */
+			mhi_cntrl->runtime_put(mhi_cntrl);
+		}
 
 		if (!buf_info->pre_mapped)
 			mhi_cntrl->unmap_single(mhi_cntrl, buf_info);


