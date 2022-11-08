Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FA962158C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiKHONE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiKHOMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B528069DE3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5255F615C6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B94C433C1;
        Tue,  8 Nov 2022 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916764;
        bh=y+MxSHXsr7av6A/HoM6KYeH/eO4KJr2onYGBCpe7MxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XM9oCAIbjaPS5EZFU7yhKV3zoSJu5Cq3FxofMbhoyEb0P2Tk8H8EqLebHHhJFAga
         FZZ7wmPfgpiZihOW/+BurBoPK3GaZknDe6clZH3YfsDnXpxm6QIKnj4ixTvC6E48Jr
         UFqd7uic9sKfh3QPljOxewoy+M52Xkm7VXEVMc7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 119/197] firmware: arm_scmi: Fix deferred_tx_wq release on error paths
Date:   Tue,  8 Nov 2022 14:39:17 +0100
Message-Id: <20221108133400.389332332@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 1eff6929aff594fba3182660f7b6213ec0ceda0c ]

Use devres to allocate the dedicated deferred_tx_wq polling workqueue so
as to automatically trigger the proper resource release on error path.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 5a3b7185c47c ("firmware: arm_scmi: Add atomic mode support to virtio transport")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-6-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/virtio.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index 36b7686843a4..33c9b81a55cd 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -148,7 +148,6 @@ static void scmi_vio_channel_cleanup_sync(struct scmi_vio_channel *vioch)
 {
 	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(vioch_shutdown_done);
-	void *deferred_wq = NULL;
 
 	/*
 	 * Prepare to wait for the last release if not already released
@@ -162,16 +161,11 @@ static void scmi_vio_channel_cleanup_sync(struct scmi_vio_channel *vioch)
 
 	vioch->shutdown_done = &vioch_shutdown_done;
 	virtio_break_device(vioch->vqueue->vdev);
-	if (!vioch->is_rx && vioch->deferred_tx_wq) {
-		deferred_wq = vioch->deferred_tx_wq;
+	if (!vioch->is_rx && vioch->deferred_tx_wq)
 		/* Cannot be kicked anymore after this...*/
 		vioch->deferred_tx_wq = NULL;
-	}
 	spin_unlock_irqrestore(&vioch->lock, flags);
 
-	if (deferred_wq)
-		destroy_workqueue(deferred_wq);
-
 	scmi_vio_channel_release(vioch);
 
 	/* Let any possibly concurrent RX path release the channel */
@@ -416,6 +410,11 @@ static bool virtio_chan_available(struct device *dev, int idx)
 	return vioch && !vioch->cinfo;
 }
 
+static void scmi_destroy_tx_workqueue(void *deferred_tx_wq)
+{
+	destroy_workqueue(deferred_tx_wq);
+}
+
 static int virtio_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 			     bool tx)
 {
@@ -430,6 +429,8 @@ static int virtio_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 
 	/* Setup a deferred worker for polling. */
 	if (tx && !vioch->deferred_tx_wq) {
+		int ret;
+
 		vioch->deferred_tx_wq =
 			alloc_workqueue(dev_name(&scmi_vdev->dev),
 					WQ_UNBOUND | WQ_FREEZABLE | WQ_SYSFS,
@@ -437,6 +438,11 @@ static int virtio_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		if (!vioch->deferred_tx_wq)
 			return -ENOMEM;
 
+		ret = devm_add_action_or_reset(dev, scmi_destroy_tx_workqueue,
+					       vioch->deferred_tx_wq);
+		if (ret)
+			return ret;
+
 		INIT_WORK(&vioch->deferred_tx_work,
 			  scmi_vio_deferred_tx_worker);
 	}
-- 
2.35.1



