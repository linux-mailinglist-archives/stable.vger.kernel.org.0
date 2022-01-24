Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302E2499628
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443897AbiAXU7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:59:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442867AbiAXUzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B015612C3;
        Mon, 24 Jan 2022 20:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A18C340EA;
        Mon, 24 Jan 2022 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057733;
        bh=XmunwkHp3uSTDer0TGSDoR8vFkcsn6YyKg9JSHU7/wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aqaz7oDnQ3K3IcyldeYn7nz7Wt7W87rLKQjeBJ0h10gdNDmQE5VK/xpQdztjTB0DB
         wRPnGJbH31wmkcjTLTO9RFJJgvmz0E9f45hxtd9tkyk3UhAfjPm15cVqfNWbwDm6D/
         CV87PIsZWxXRI7mjrR85aYKAQPiQyrRjr7kxVn64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Thomas Perrot <thomas.perrot@bootlin.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.16 0062/1039] bus: mhi: core: Fix race while handling SYS_ERR at power up
Date:   Mon, 24 Jan 2022 19:30:51 +0100
Message-Id: <20220124184127.234835641@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit d651ce8e917fa1bf6cfab8dca74c512edffc35d3 upstream.

During SYS_ERR condition, as a response to the MHI_RESET from host, some
devices tend to issue BHI interrupt without clearing the SYS_ERR state in
the device. This creates a race condition and causes a failure in booting
up the device.

The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
handling in mhi_async_power_up(). Once the host detects that the device
is in SYS_ERR state, it issues MHI_RESET and waits for the device to
process the reset request. During this time, the device triggers the BHI
interrupt to the host without clearing SYS_ERR condition. So the host
starts handling the SYS_ERR condition again.

To fix this issue, let's register the IRQ handler only after handling the
SYS_ERR check to avoid getting spurious IRQs from the device.

Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
Cc: stable@vger.kernel.org
Reported-by: Aleksander Morgado <aleksander@aleksander.es>
Tested-by: Aleksander Morgado <aleksander@aleksander.es>
Tested-by: Thomas Perrot <thomas.perrot@bootlin.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211216081227.237749-8-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/pm.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -1053,7 +1053,7 @@ int mhi_async_power_up(struct mhi_contro
 	enum mhi_ee_type current_ee;
 	enum dev_st_transition next_state;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
-	u32 val;
+	u32 interval_us = 25000; /* poll register field every 25 milliseconds */
 	int ret;
 
 	dev_info(dev, "Requested to power ON\n");
@@ -1070,10 +1070,6 @@ int mhi_async_power_up(struct mhi_contro
 	mutex_lock(&mhi_cntrl->pm_mutex);
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 
-	ret = mhi_init_irq_setup(mhi_cntrl);
-	if (ret)
-		goto error_setup_irq;
-
 	/* Setup BHI INTVEC */
 	write_lock_irq(&mhi_cntrl->pm_lock);
 	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
@@ -1087,7 +1083,7 @@ int mhi_async_power_up(struct mhi_contro
 		dev_err(dev, "%s is not a valid EE for power on\n",
 			TO_MHI_EXEC_STR(current_ee));
 		ret = -EIO;
-		goto error_async_power_up;
+		goto error_exit;
 	}
 
 	state = mhi_get_mhi_state(mhi_cntrl);
@@ -1096,20 +1092,12 @@ int mhi_async_power_up(struct mhi_contro
 
 	if (state == MHI_STATE_SYS_ERR) {
 		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
-		ret = wait_event_timeout(mhi_cntrl->state_event,
-				MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state) ||
-					mhi_read_reg_field(mhi_cntrl,
-							   mhi_cntrl->regs,
-							   MHICTRL,
-							   MHICTRL_RESET_MASK,
-							   MHICTRL_RESET_SHIFT,
-							   &val) ||
-					!val,
-				msecs_to_jiffies(mhi_cntrl->timeout_ms));
-		if (!ret) {
-			ret = -EIO;
+		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				 MHICTRL_RESET_MASK, MHICTRL_RESET_SHIFT, 0,
+				 interval_us);
+		if (ret) {
 			dev_info(dev, "Failed to reset MHI due to syserr state\n");
-			goto error_async_power_up;
+			goto error_exit;
 		}
 
 		/*
@@ -1119,6 +1107,10 @@ int mhi_async_power_up(struct mhi_contro
 		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
 	}
 
+	ret = mhi_init_irq_setup(mhi_cntrl);
+	if (ret)
+		goto error_exit;
+
 	/* Transition to next state */
 	next_state = MHI_IN_PBL(current_ee) ?
 		DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
@@ -1131,10 +1123,7 @@ int mhi_async_power_up(struct mhi_contro
 
 	return 0;
 
-error_async_power_up:
-	mhi_deinit_free_irq(mhi_cntrl);
-
-error_setup_irq:
+error_exit:
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 	mutex_unlock(&mhi_cntrl->pm_mutex);
 


