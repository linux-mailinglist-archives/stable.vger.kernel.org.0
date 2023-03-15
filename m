Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5CF6BB23D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjCOMeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjCOMeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:34:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2499FE4B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14D4AB81DFD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DB7C433EF;
        Wed, 15 Mar 2023 12:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883556;
        bh=qN3fJUsoNzYjLflSLNLstEh1VbdCveVv5vBVl9NrLnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvRQgQyRnKO2N3UsosEPI5sODJ+68GOLiyTifVSMbhxTWEyWrb2w5xd82gGpmM4KD
         EPGJr5Wxc3KdmiGmJgxswpVbxeqU5mqldlugVPzbbSGrxEtRKdAoYck0nu+MdHIku5
         lYcOzTka80h8Ri20JGvh2VXjW3X5y5+0vx5Ada2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/143] bus: mhi: ep: Change state_lock to mutex
Date:   Wed, 15 Mar 2023 13:12:08 +0100
Message-Id: <20230315115741.790954597@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 1ddc7618294084fff8d673217a9479550990ee84 ]

state_lock, the spinlock type is meant to protect race against concurrent
MHI state transitions. In mhi_ep_set_m0_state(), while the state_lock is
being held, the channels are resumed in mhi_ep_resume_channels() if the
previous state was M3. This causes sleeping in atomic bug, since
mhi_ep_resume_channels() use mutex internally.

Since the state_lock is supposed to be held throughout the state change,
it is not ideal to drop the lock before calling mhi_ep_resume_channels().
So to fix this issue, let's change the type of state_lock to mutex. This
would also allow holding the lock throughout all state transitions thereby
avoiding any potential race.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: e4b7b5f0f30a ("bus: mhi: ep: Add support for suspending and resuming channels")
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c |  8 +++++---
 drivers/bus/mhi/ep/sm.c   | 42 ++++++++++++++++++++++-----------------
 include/linux/mhi_ep.h    |  4 ++--
 3 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index b06548005985c..edd153dda40c0 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -994,11 +994,11 @@ static void mhi_ep_reset_worker(struct work_struct *work)
 
 	mhi_ep_power_down(mhi_cntrl);
 
-	spin_lock_bh(&mhi_cntrl->state_lock);
+	mutex_lock(&mhi_cntrl->state_lock);
+
 	/* Reset MMIO to signal host that the MHI_RESET is completed in endpoint */
 	mhi_ep_mmio_reset(mhi_cntrl);
 	cur_state = mhi_cntrl->mhi_state;
-	spin_unlock_bh(&mhi_cntrl->state_lock);
 
 	/*
 	 * Only proceed further if the reset is due to SYS_ERR. The host will
@@ -1007,6 +1007,8 @@ static void mhi_ep_reset_worker(struct work_struct *work)
 	 */
 	if (cur_state == MHI_STATE_SYS_ERR)
 		mhi_ep_power_up(mhi_cntrl);
+
+	mutex_unlock(&mhi_cntrl->state_lock);
 }
 
 /*
@@ -1379,8 +1381,8 @@ int mhi_ep_register_controller(struct mhi_ep_cntrl *mhi_cntrl,
 
 	INIT_LIST_HEAD(&mhi_cntrl->st_transition_list);
 	INIT_LIST_HEAD(&mhi_cntrl->ch_db_list);
-	spin_lock_init(&mhi_cntrl->state_lock);
 	spin_lock_init(&mhi_cntrl->list_lock);
+	mutex_init(&mhi_cntrl->state_lock);
 	mutex_init(&mhi_cntrl->event_lock);
 
 	/* Set MHI version and AMSS EE before enumeration */
diff --git a/drivers/bus/mhi/ep/sm.c b/drivers/bus/mhi/ep/sm.c
index 3655c19e23c7b..fd200b2ac0bb2 100644
--- a/drivers/bus/mhi/ep/sm.c
+++ b/drivers/bus/mhi/ep/sm.c
@@ -63,24 +63,23 @@ int mhi_ep_set_m0_state(struct mhi_ep_cntrl *mhi_cntrl)
 	int ret;
 
 	/* If MHI is in M3, resume suspended channels */
-	spin_lock_bh(&mhi_cntrl->state_lock);
+	mutex_lock(&mhi_cntrl->state_lock);
+
 	old_state = mhi_cntrl->mhi_state;
 	if (old_state == MHI_STATE_M3)
 		mhi_ep_resume_channels(mhi_cntrl);
 
 	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_M0);
-	spin_unlock_bh(&mhi_cntrl->state_lock);
-
 	if (ret) {
 		mhi_ep_handle_syserr(mhi_cntrl);
-		return ret;
+		goto err_unlock;
 	}
 
 	/* Signal host that the device moved to M0 */
 	ret = mhi_ep_send_state_change_event(mhi_cntrl, MHI_STATE_M0);
 	if (ret) {
 		dev_err(dev, "Failed sending M0 state change event\n");
-		return ret;
+		goto err_unlock;
 	}
 
 	if (old_state == MHI_STATE_READY) {
@@ -88,11 +87,14 @@ int mhi_ep_set_m0_state(struct mhi_ep_cntrl *mhi_cntrl)
 		ret = mhi_ep_send_ee_event(mhi_cntrl, MHI_EE_AMSS);
 		if (ret) {
 			dev_err(dev, "Failed sending AMSS EE event\n");
-			return ret;
+			goto err_unlock;
 		}
 	}
 
-	return 0;
+err_unlock:
+	mutex_unlock(&mhi_cntrl->state_lock);
+
+	return ret;
 }
 
 int mhi_ep_set_m3_state(struct mhi_ep_cntrl *mhi_cntrl)
@@ -100,13 +102,12 @@ int mhi_ep_set_m3_state(struct mhi_ep_cntrl *mhi_cntrl)
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	int ret;
 
-	spin_lock_bh(&mhi_cntrl->state_lock);
-	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_M3);
-	spin_unlock_bh(&mhi_cntrl->state_lock);
+	mutex_lock(&mhi_cntrl->state_lock);
 
+	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_M3);
 	if (ret) {
 		mhi_ep_handle_syserr(mhi_cntrl);
-		return ret;
+		goto err_unlock;
 	}
 
 	mhi_ep_suspend_channels(mhi_cntrl);
@@ -115,10 +116,13 @@ int mhi_ep_set_m3_state(struct mhi_ep_cntrl *mhi_cntrl)
 	ret = mhi_ep_send_state_change_event(mhi_cntrl, MHI_STATE_M3);
 	if (ret) {
 		dev_err(dev, "Failed sending M3 state change event\n");
-		return ret;
+		goto err_unlock;
 	}
 
-	return 0;
+err_unlock:
+	mutex_unlock(&mhi_cntrl->state_lock);
+
+	return ret;
 }
 
 int mhi_ep_set_ready_state(struct mhi_ep_cntrl *mhi_cntrl)
@@ -127,22 +131,24 @@ int mhi_ep_set_ready_state(struct mhi_ep_cntrl *mhi_cntrl)
 	enum mhi_state mhi_state;
 	int ret, is_ready;
 
-	spin_lock_bh(&mhi_cntrl->state_lock);
+	mutex_lock(&mhi_cntrl->state_lock);
+
 	/* Ensure that the MHISTATUS is set to RESET by host */
 	mhi_state = mhi_ep_mmio_masked_read(mhi_cntrl, EP_MHISTATUS, MHISTATUS_MHISTATE_MASK);
 	is_ready = mhi_ep_mmio_masked_read(mhi_cntrl, EP_MHISTATUS, MHISTATUS_READY_MASK);
 
 	if (mhi_state != MHI_STATE_RESET || is_ready) {
 		dev_err(dev, "READY state transition failed. MHI host not in RESET state\n");
-		spin_unlock_bh(&mhi_cntrl->state_lock);
-		return -EIO;
+		ret = -EIO;
+		goto err_unlock;
 	}
 
 	ret = mhi_ep_set_mhi_state(mhi_cntrl, MHI_STATE_READY);
-	spin_unlock_bh(&mhi_cntrl->state_lock);
-
 	if (ret)
 		mhi_ep_handle_syserr(mhi_cntrl);
 
+err_unlock:
+	mutex_unlock(&mhi_cntrl->state_lock);
+
 	return ret;
 }
diff --git a/include/linux/mhi_ep.h b/include/linux/mhi_ep.h
index 478aece170462..f198a8ac7ee72 100644
--- a/include/linux/mhi_ep.h
+++ b/include/linux/mhi_ep.h
@@ -70,8 +70,8 @@ struct mhi_ep_db_info {
  * @cmd_ctx_cache_phys: Physical address of the host command context cache
  * @chdb: Array of channel doorbell interrupt info
  * @event_lock: Lock for protecting event rings
- * @list_lock: Lock for protecting state transition and channel doorbell lists
  * @state_lock: Lock for protecting state transitions
+ * @list_lock: Lock for protecting state transition and channel doorbell lists
  * @st_transition_list: List of state transitions
  * @ch_db_list: List of queued channel doorbells
  * @wq: Dedicated workqueue for handling rings and state changes
@@ -117,8 +117,8 @@ struct mhi_ep_cntrl {
 
 	struct mhi_ep_db_info chdb[4];
 	struct mutex event_lock;
+	struct mutex state_lock;
 	spinlock_t list_lock;
-	spinlock_t state_lock;
 
 	struct list_head st_transition_list;
 	struct list_head ch_db_list;
-- 
2.39.2



