Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D20455481
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 06:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242525AbhKRGAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 01:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241204AbhKRGAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 01:00:39 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119E1C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 21:57:40 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 200so4417986pga.1
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 21:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=we6xpES6wXLQZjtkHiuApqYOiFHYdZTHHDycpUVaqDo=;
        b=vwvR6k5C26Y/Tjw+yEQEDrhTtEXfr72d8/A+QbH8zM1NEG0KunTKPqdATHTPDYYJTx
         yHv8nxKYcsEZKYkh/C8iGvKOy7ffobDqcoCvszUKTd/SQ/tBsqjkph9bq2KTtbG12Psl
         ouZHtFnSwHhDPzeCaxorFxWg+jvoVp2o/0VuVn3RvHZMswDBMtnjVqJzohm7n1d8LK3/
         oxy1k2STpEQxWMu4aNRvME02inWx5MnpF/0CrLWju4hrrku43ApFFz+jYm+UbavfQpXJ
         xOf/yhJciOV82NlGlS5+h3rWTu49rU9Zt9WS2D1EYXL+X5HvOYS/qE92HHpAuYbO/z25
         dLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=we6xpES6wXLQZjtkHiuApqYOiFHYdZTHHDycpUVaqDo=;
        b=ueRBZhZGTxGVKk1Mugaoczh/jvy7HahaJeoYFhyyo+KWp7S9UlOl4dX1z/5zE5FXkW
         vexLui/en3/9Qha/21mHHjtFK9pC7OM9+UgdPMvXyhVlSLVg+hgkhQs4oX9xSyjZu+BU
         No1DNku5AYXEH+SgZW3fy/hsNHfwt69T6VWLUJL36uhNXMYZFyI3dmU6h8rKRrshHliM
         YJRYu5ebMASdEkkk1AzneJvNi172Ta4Z02atlY+3e4rfIg6kd0KOUH9/Aozkxv+GGHcg
         MV347HCJHTUid+0XGIXk0CF9bPf+zjK4z2FvaZvvLhzbwGFUJzDHS2Qm6KNc5fb5GNit
         3Kxg==
X-Gm-Message-State: AOAM530DSG4scZpmJyTt3OPZTEQp99UZ4HKh4dEve3fTGqJ3X7nIK3H4
        QObxJZZ087E5vJPk8hnrbYpq
X-Google-Smtp-Source: ABdhPJxk6ka9vlClZPxm/4znf/QZJ9EWVLu3wj0hRNdIiz+z9EU27HJZbc4FkYddzLd/eX8anMIieg==
X-Received: by 2002:a63:b25d:: with SMTP id t29mr9640529pgo.79.1637215059562;
        Wed, 17 Nov 2021 21:57:39 -0800 (PST)
Received: from localhost.localdomain ([117.202.188.63])
        by smtp.gmail.com with ESMTPSA id d9sm1261934pgd.40.2021.11.17.21.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 21:57:38 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     aleksander@aleksander.es, loic.poulain@linaro.org,
        thomas.perrot@bootlin.com, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, quic_jhugo@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v3] bus: mhi: Fix race while handling SYS_ERR at power up
Date:   Thu, 18 Nov 2021 11:27:26 +0530
Message-Id: <20211118055726.13107-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some devices tend to trigger SYS_ERR interrupt while the host handling
SYS_ERR state of the device during power up. This creates a race
condition and causes a failure in booting up the device.

The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
handling in mhi_async_power_up(). Once the host detects that the device
is in SYS_ERR state, it issues MHI_RESET and waits for the device to
process the reset request. During this time, the device triggers SYS_ERR
interrupt to the host and host starts handling SYS_ERR execution.

So by the time the device has completed reset, host starts SYS_ERR
handling. This causes the race condition and the modem fails to boot.

Hence, register the IRQ handler only after handling the SYS_ERR check
to avoid getting spurious IRQs from the device.

Cc: stable@vger.kernel.org
Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
Reported-by: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---

Changes in v3:

* Moved BHI_INTVEC setup after irq setup
* Used interval_us as the delay for the polling API

Changes in v2:

* Switched to "mhi_poll_reg_field" for detecting MHI reset in device.

 drivers/bus/mhi/core/pm.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index fb99e3727155..ee0515a25e46 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -1038,7 +1038,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	enum mhi_ee_type current_ee;
 	enum dev_st_transition next_state;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
-	u32 val;
+	u32 interval_us = 25000; /* poll register field every 25 milliseconds */
 	int ret;
 
 	dev_info(dev, "Requested to power ON\n");
@@ -1055,13 +1055,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	mutex_lock(&mhi_cntrl->pm_mutex);
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 
-	ret = mhi_init_irq_setup(mhi_cntrl);
-	if (ret)
-		goto error_setup_irq;
-
-	/* Setup BHI INTVEC */
 	write_lock_irq(&mhi_cntrl->pm_lock);
-	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
 	mhi_cntrl->pm_state = MHI_PM_POR;
 	mhi_cntrl->ee = MHI_EE_MAX;
 	current_ee = mhi_get_exec_env(mhi_cntrl);
@@ -1072,7 +1066,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		dev_err(dev, "%s is not a valid EE for power on\n",
 			TO_MHI_EXEC_STR(current_ee));
 		ret = -EIO;
-		goto error_async_power_up;
+		goto error_setup_irq;
 	}
 
 	state = mhi_get_mhi_state(mhi_cntrl);
@@ -1081,20 +1075,12 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
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
+			goto error_setup_irq;
 		}
 
 		/*
@@ -1104,6 +1090,13 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
 	}
 
+	ret = mhi_init_irq_setup(mhi_cntrl);
+	if (ret)
+		goto error_setup_irq;
+
+	/* Setup BHI INTVEC */
+	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
+
 	/* Transition to next state */
 	next_state = MHI_IN_PBL(current_ee) ?
 		DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
@@ -1116,9 +1109,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
 	return 0;
 
-error_async_power_up:
-	mhi_deinit_free_irq(mhi_cntrl);
-
 error_setup_irq:
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 	mutex_unlock(&mhi_cntrl->pm_mutex);
-- 
2.25.1

