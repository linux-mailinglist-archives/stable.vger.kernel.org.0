Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE78378390
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhEJKqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232495AbhEJKoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5BBE61956;
        Mon, 10 May 2021 10:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642795;
        bh=DCkM3i8YW6SLbfZvq2H8pQMp56zEseL8FwD46XbIR5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edjAGXOd686x3sCTzo+WJddra7ne+cYyQUJX6vGQdkWOhnq/PDrw9QOsKzLU3qBji
         P4e1ujqFBQZrWralMmMLCTvv+koKgbGotsXfd+A6D9vh2A6IUlEYB/S10BvgKscO9S
         y2xgq3aM8QMBL/1wokhcrkKnDEXBQLiIMkk3MzVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/299] bus: mhi: core: Destroy SBL devices when moving to mission mode
Date:   Mon, 10 May 2021 12:17:32 +0200
Message-Id: <20210510102006.696560199@linuxfoundation.org>
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
index f46f772e2557..d86ce1a06b75 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -227,8 +227,10 @@ static bool is_valid_ring_ptr(struct mhi_ring *ring, dma_addr_t addr)
 
 int mhi_destroy_device(struct device *dev, void *data)
 {
+	struct mhi_chan *ul_chan, *dl_chan;
 	struct mhi_device *mhi_dev;
 	struct mhi_controller *mhi_cntrl;
+	enum mhi_ee_type ee = MHI_EE_MAX;
 
 	if (dev->bus != &mhi_bus_type)
 		return 0;
@@ -240,6 +242,17 @@ int mhi_destroy_device(struct device *dev, void *data)
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
@@ -247,11 +260,19 @@ int mhi_destroy_device(struct device *dev, void *data)
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
index ce2aafe33d53..aeb895c08460 100644
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



