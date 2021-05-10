Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894D637859E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbhEJLBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhEJK4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D133B61363;
        Mon, 10 May 2021 10:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643568;
        bh=OejycISGXCcApNekc6oWPG2LiVCPYiITq9gGZiDh8uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwkpuQjpKwRlnmc3/aL/qqY+LHAFOSlu3Z+k4AJ8rlAAdWHyCLFV4u2EzI5LzL5+8
         eIdmo5GDKN3AmwqIrhyUp4WoPXXABvgEIkTG/OiBcyU7+RIvi9CGbsYpYEj7TwOGbX
         lKQ/NwEClS6yS7k8JDkpfbQQKBtYt4AATeK+MiTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 068/342] bus: mhi: core: Process execution environment changes serially
Date:   Mon, 10 May 2021 12:17:38 +0200
Message-Id: <20210510102012.366029283@linuxfoundation.org>
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

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

[ Upstream commit ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ]

In current design, whenever the BHI interrupt is fired, the
execution environment is updated. This can cause race conditions
and impede ongoing power up/down processing. For example, if a
power down is in progress, MHI host updates to a local "disabled"
execution environment. If a BHI interrupt fires later, that value
gets replaced with one from the BHI EE register. This impacts the
controller as it does not expect multiple RDDM execution
environment change status callbacks as an example. Another issue
would be that the device can enter mission mode and the execution
environment is updated, while device creation for SBL channels is
still going on due to slower PM state worker thread run, leading
to multiple attempts at opening the same channel.

Ensure that EE changes are handled only from appropriate places
and occur one after another and handle only PBL modes or RDDM EE
changes as critical events directly from the interrupt handler.
Simplify handling by waiting for SYS ERROR before handling RDDM.
This also makes sure that we use the correct execution environment
to notify the controller driver when the device resets to one of
the PBL execution environments.

Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1614208985-20851-4-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/main.c | 40 +++++++++++++++++++------------------
 drivers/bus/mhi/core/pm.c   |  7 ++++---
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index fb51b2a47095..da495f68f70e 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -412,7 +412,7 @@ irqreturn_t mhi_intvec_threaded_handler(int irq_number, void *priv)
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	enum mhi_state state = MHI_STATE_MAX;
 	enum mhi_pm_state pm_state = 0;
-	enum mhi_ee_type ee = 0;
+	enum mhi_ee_type ee = MHI_EE_MAX;
 
 	write_lock_irq(&mhi_cntrl->pm_lock);
 	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
@@ -421,8 +421,7 @@ irqreturn_t mhi_intvec_threaded_handler(int irq_number, void *priv)
 	}
 
 	state = mhi_get_mhi_state(mhi_cntrl);
-	ee = mhi_cntrl->ee;
-	mhi_cntrl->ee = mhi_get_exec_env(mhi_cntrl);
+	ee = mhi_get_exec_env(mhi_cntrl);
 	dev_dbg(dev, "local ee:%s device ee:%s dev_state:%s\n",
 		TO_MHI_EXEC_STR(mhi_cntrl->ee), TO_MHI_EXEC_STR(ee),
 		TO_MHI_STATE_STR(state));
@@ -434,27 +433,30 @@ irqreturn_t mhi_intvec_threaded_handler(int irq_number, void *priv)
 	}
 	write_unlock_irq(&mhi_cntrl->pm_lock);
 
-	 /* If device supports RDDM don't bother processing SYS error */
-	if (mhi_cntrl->rddm_image) {
-		/* host may be performing a device power down already */
-		if (!mhi_is_active(mhi_cntrl))
-			goto exit_intvec;
+	if (pm_state != MHI_PM_SYS_ERR_DETECT || ee == mhi_cntrl->ee)
+		goto exit_intvec;
 
-		if (mhi_cntrl->ee == MHI_EE_RDDM && mhi_cntrl->ee != ee) {
+	switch (ee) {
+	case MHI_EE_RDDM:
+		/* proceed if power down is not already in progress */
+		if (mhi_cntrl->rddm_image && mhi_is_active(mhi_cntrl)) {
 			mhi_cntrl->status_cb(mhi_cntrl, MHI_CB_EE_RDDM);
+			mhi_cntrl->ee = ee;
 			wake_up_all(&mhi_cntrl->state_event);
 		}
-		goto exit_intvec;
-	}
-
-	if (pm_state == MHI_PM_SYS_ERR_DETECT) {
+		break;
+	case MHI_EE_PBL:
+	case MHI_EE_EDL:
+	case MHI_EE_PTHRU:
+		mhi_cntrl->status_cb(mhi_cntrl, MHI_CB_FATAL_ERROR);
+		mhi_cntrl->ee = ee;
 		wake_up_all(&mhi_cntrl->state_event);
-
-		/* For fatal errors, we let controller decide next step */
-		if (MHI_IN_PBL(ee))
-			mhi_cntrl->status_cb(mhi_cntrl, MHI_CB_FATAL_ERROR);
-		else
-			mhi_pm_sys_err_handler(mhi_cntrl);
+		mhi_pm_sys_err_handler(mhi_cntrl);
+		break;
+	default:
+		wake_up_all(&mhi_cntrl->state_event);
+		mhi_pm_sys_err_handler(mhi_cntrl);
+		break;
 	}
 
 exit_intvec:
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 1edce7917b6b..277704af7eb6 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -377,21 +377,22 @@ static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
 {
 	struct mhi_event *mhi_event;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
-	enum mhi_ee_type current_ee = mhi_cntrl->ee;
+	enum mhi_ee_type ee = MHI_EE_MAX, current_ee = mhi_cntrl->ee;
 	int i, ret;
 
 	dev_dbg(dev, "Processing Mission Mode transition\n");
 
 	write_lock_irq(&mhi_cntrl->pm_lock);
 	if (MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state))
-		mhi_cntrl->ee = mhi_get_exec_env(mhi_cntrl);
+		ee = mhi_get_exec_env(mhi_cntrl);
 
-	if (!MHI_IN_MISSION_MODE(mhi_cntrl->ee)) {
+	if (!MHI_IN_MISSION_MODE(ee)) {
 		mhi_cntrl->pm_state = MHI_PM_LD_ERR_FATAL_DETECT;
 		write_unlock_irq(&mhi_cntrl->pm_lock);
 		wake_up_all(&mhi_cntrl->state_event);
 		return -EIO;
 	}
+	mhi_cntrl->ee = ee;
 	write_unlock_irq(&mhi_cntrl->pm_lock);
 
 	wake_up_all(&mhi_cntrl->state_event);
-- 
2.30.2



