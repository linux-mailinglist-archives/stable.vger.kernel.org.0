Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9FA370C18
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhEBOFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232605AbhEBOFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E47613BB;
        Sun,  2 May 2021 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964257;
        bh=DhCgvxZRBbQU9zJsuWFpde+VWzm1veVAoPYphzg9vSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joM3iEiUGk4vZ5qSsNX25EpXeqxHNNg+KlM+zs6ka+Q7clHhKfqN3Z9tyc58H4h3/
         RAjetdTOfBhvyHACOISF7Ye5wMBe7nYnQe7gdFB+QybpT2TkekJw0vCv/cLEEXOGdx
         r4W+hG/WYpoZXV83HjgVT41JM9D0BCustVmUBmVXEBb2u1D2wVXqx1SRNnaKJq5uup
         I022gOt6j1mZCL5cMfJVlbrbDPyD2YCrjOBZlXTFgwoKnHh8m6YEsCRRg/JsUjpQri
         uvu8HTXHAFfOSNXf8pz8uvk2vYXdBW+E9m/sHJ9A1fxlI4pGDFxcQMRN6MC/O5DJhM
         FhbeZBKczg7VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/66] bus: mhi: core: Destroy SBL devices when moving to mission mode
Date:   Sun,  2 May 2021 10:03:10 -0400
Message-Id: <20210502140411.2719301-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140411.2719301-1-sashal@kernel.org>
References: <20210502140411.2719301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

[ Upstream commit 925089c1900f588615db5bf4e1d9064a5f2c18c7 ]

Currently, client devices are created in SBL or AMSS (mission
mode) and only destroyed after power down or SYS ERROR. When
moving between certain execution environments, such as from SBL
to AMSS, no clean-up is required. This presents an issue where
SBL-specific channels are left open and client drivers now run in
an execution environment where they cannot operate. Fix this by
expanding the mhi_destroy_device() to do an execution environment
specific clean-up if one is requested. Close the gap and destroy
devices in such scenarios that allow SBL client drivers to clean
up once device enters mission mode.

Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1614208985-20851-2-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/main.c | 29 +++++++++++++++++++++++++----
 drivers/bus/mhi/core/pm.c   |  3 +++
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 2cff5ddff225..984bcf9940fe 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -222,8 +222,10 @@ static void mhi_del_ring_element(struct mhi_controller *mhi_cntrl,
 
 int mhi_destroy_device(struct device *dev, void *data)
 {
+	struct mhi_chan *ul_chan, *dl_chan;
 	struct mhi_device *mhi_dev;
 	struct mhi_controller *mhi_cntrl;
+	enum mhi_ee_type ee = MHI_EE_MAX;
 
 	if (dev->bus != &mhi_bus_type)
 		return 0;
@@ -235,6 +237,17 @@ int mhi_destroy_device(struct device *dev, void *data)
 	if (mhi_dev->dev_type == MHI_DEVICE_CONTROLLER)
 		return 0;
 
+	ul_chan = mhi_dev->ul_chan;
+	dl_chan = mhi_dev->dl_chan;
+
+	/*
+	 * If execution environment is specified, remove only those devices that
+	 * started in them based on ee_mask for the channels as we move on to a
+	 * different execution environment
+	 */
+	if (data)
+		ee = *(enum mhi_ee_type *)data;
+
 	/*
 	 * For the suspend and resume case, this function will get called
 	 * without mhi_unregister_controller(). Hence, we need to drop the
@@ -242,11 +255,19 @@ int mhi_destroy_device(struct device *dev, void *data)
 	 * be sure that there will be no instances of mhi_dev left after
 	 * this.
 	 */
-	if (mhi_dev->ul_chan)
-		put_device(&mhi_dev->ul_chan->mhi_dev->dev);
+	if (ul_chan) {
+		if (ee != MHI_EE_MAX && !(ul_chan->ee_mask & BIT(ee)))
+			return 0;
 
-	if (mhi_dev->dl_chan)
-		put_device(&mhi_dev->dl_chan->mhi_dev->dev);
+		put_device(&ul_chan->mhi_dev->dev);
+	}
+
+	if (dl_chan) {
+		if (ee != MHI_EE_MAX && !(dl_chan->ee_mask & BIT(ee)))
+			return 0;
+
+		put_device(&dl_chan->mhi_dev->dev);
+	}
 
 	dev_dbg(&mhi_cntrl->mhi_dev->dev, "destroy device for chan:%s\n",
 		 mhi_dev->name);
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 3de7b1639ec6..f725d10325f7 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -376,6 +376,7 @@ static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
 {
 	struct mhi_event *mhi_event;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
+	enum mhi_ee_type current_ee = mhi_cntrl->ee;
 	int i, ret;
 
 	dev_dbg(dev, "Processing Mission Mode transition\n");
@@ -390,6 +391,8 @@ static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
 
 	wake_up_all(&mhi_cntrl->state_event);
 
+	device_for_each_child(&mhi_cntrl->mhi_dev->dev, &current_ee,
+			      mhi_destroy_device);
 	mhi_cntrl->status_cb(mhi_cntrl, MHI_CB_EE_MISSION_MODE);
 
 	/* Force MHI to be in M0 state before continuing */
-- 
2.30.2

