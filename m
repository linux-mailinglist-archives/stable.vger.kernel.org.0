Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E56E46B350
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhLGHEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhLGHEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 02:04:01 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50383C061748
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 23:00:31 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so1847045pjb.5
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 23:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2KD/Dfq+rnasKB8lmx/9vy0d1bpdTQ6pdlpbDm2cNY=;
        b=eWk/izWrJiBMpzVzdMAdYwo/6UxhY/+bJYF5qccMSL8poHIFm3PiGWUsyomrJ1lCFi
         7Ps6GZDPf0UTI/AykAQltm4aV9ukzLw5NBJyy0Y5LDhBBTIOQYuNIFYJoy49SlvhmzMB
         TdLOSFyDbnKFXpkGTDK8F94WJRXPNqA7WbEcCkC0rethFXdUpNil1y2aPDTHmiPiR3p0
         cBeqfiycNJvys+XfCzZd2zHyF2uRyyDZ8IEBoH0JlgPJhDhaIeAm7Zg3LmwVbusa6M1K
         NoDYFXELniTyaNNuHEYHD/182M8ZeV6ew/IrB70sooXIM/gdLSiSJ7SXfkRiuJB/3ll9
         vj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2KD/Dfq+rnasKB8lmx/9vy0d1bpdTQ6pdlpbDm2cNY=;
        b=11ATKWAYM/ESQRIaj+44VTK8b+KDNlWu9YGztypBSCdvoPK4fdJiahg4fBeiH3//1d
         G2EFz4nlLD5nenFo/g5CU2O5wPNwC7wd+68FozMHUV3K9nJCVKHx9FMKJUjUVym5SHxf
         bM0vF9xj/zi5MSl8IFCHnSSQAUpWiKKB03HEJ5YJtxkUL6eOKELCpNKejfNu5f/h/qfu
         gctsJ7KH6wV1hheSQoq+zepZ/Z4grfAHV4OeMJWblXqKle3BescpQ/MSZzN99JE3RvxK
         a25cCoqaTL6HUu8Tj9ksHhu5Pui7Y/VvwIo/9Md+iAiMCaAoLIyJRjL+c1Em7MTPRcmH
         Ymhw==
X-Gm-Message-State: AOAM530gVAv3AnMZBBv4wDwA4BY9nEdC4LTSSmL9yTGtnMOWHFIQopKO
        NsgcIpW7jnluMNQxlGNniTz1
X-Google-Smtp-Source: ABdhPJwkH2+F982zkzFbH3pqOLJ9QtawrtTVzIPRPRDf5DaQaZMX9AZVzN3QtPe9mTr5KSKs4UZL1A==
X-Received: by 2002:a17:902:ab47:b0:141:95b2:7eaf with SMTP id ij7-20020a170902ab4700b0014195b27eafmr48733066plb.40.1638860430704;
        Mon, 06 Dec 2021 23:00:30 -0800 (PST)
Received: from localhost.localdomain ([117.217.176.38])
        by smtp.gmail.com with ESMTPSA id d6sm11825211pgv.48.2021.12.06.23.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 23:00:30 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     aleksander@aleksander.es, loic.poulain@linaro.org,
        thomas.perrot@bootlin.com, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, quic_jhugo@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v5] bus: mhi: Fix race while handling SYS_ERR at power up
Date:   Tue,  7 Dec 2021 12:30:18 +0530
Message-Id: <20211207070018.115219-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
Reported-by: Aleksander Morgado <aleksander@aleksander.es>
Tested-by: Aleksander Morgado <aleksander@aleksander.es>
Tested-by: Thomas Perrot <thomas.perrot@bootlin.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---

Changes in v5:

* Rewored the commit message and used "error_exit" goto label for error
  path

Changes in v4:

* Reverted the change that moved BHI_INTVEC as that was causing issue as
  reported by Aleksander.

Changes in v3:

* Moved BHI_INTVEC setup after irq setup
* Used interval_us as the delay for the polling API

Changes in v2:

* Switched to "mhi_poll_reg_field" for detecting MHI reset in device.

 drivers/bus/mhi/core/pm.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 7464f5d09973..9ae8532df5a3 100644
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
@@ -1055,10 +1055,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	mutex_lock(&mhi_cntrl->pm_mutex);
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 
-	ret = mhi_init_irq_setup(mhi_cntrl);
-	if (ret)
-		goto error_setup_irq;
-
 	/* Setup BHI INTVEC */
 	write_lock_irq(&mhi_cntrl->pm_lock);
 	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
@@ -1072,7 +1068,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		dev_err(dev, "%s is not a valid EE for power on\n",
 			TO_MHI_EXEC_STR(current_ee));
 		ret = -EIO;
-		goto error_async_power_up;
+		goto error_exit;
 	}
 
 	state = mhi_get_mhi_state(mhi_cntrl);
@@ -1081,20 +1077,12 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
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
@@ -1104,6 +1092,10 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
 	}
 
+	ret = mhi_init_irq_setup(mhi_cntrl);
+	if (ret)
+		goto error_exit;
+
 	/* Transition to next state */
 	next_state = MHI_IN_PBL(current_ee) ?
 		DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
@@ -1116,10 +1108,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
 	return 0;
 
-error_async_power_up:
-	mhi_deinit_free_irq(mhi_cntrl);
-
-error_setup_irq:
+error_exit:
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 	mutex_unlock(&mhi_cntrl->pm_mutex);
 
-- 
2.25.1

