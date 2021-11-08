Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AA2449B17
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 18:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhKHRwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 12:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhKHRwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 12:52:50 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC544C061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 09:50:05 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x64so16784331pfd.6
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 09:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eRQf1Z1iL0SZkrNMLt9RYnFCV5P9RcLr043ZTAOoan4=;
        b=pJaxEgPVmIAaCbq0f1cTgJOC1wryIGSHFrAAjNLWptHJOQ4WeJ3fXNevlU26CEORgL
         5ISTC0N1AwDClt6UOHob1ELuXpTajCZTCmfBQmH/9tF0Ai+KHwBtCkLslmBZsqkwzctb
         idzm9LORDMZ9v7M6EbsG3ZJ+2VPHo/IB/NvZjEJm354edfHaDObE99lAn8JfRIHipZs9
         EkdtauLdeAG1cS4C3HAO0OJt2dtrrw7goXXHcZx5Y0mp0YS/NlI5xyUFcUxd+QsNjJSO
         GnghzeEkyuEPHoCz+2i0u8cKW7HV1FlwiQL9HdBZ+T67hKBktyUEcfhHdlRwQ0wzZf2M
         7ctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eRQf1Z1iL0SZkrNMLt9RYnFCV5P9RcLr043ZTAOoan4=;
        b=FrhpejQ/j6DwHB9oduiGcxVmimoBJyN92t5XJ8M8hxxisxBaTDKDi6Yvtl435vhAMD
         E7eax8p91FKjl0n+Glfswwu/QliUW4n2c2h2eFvnV0a9400jDqpklSzmUbjxhaCuVPva
         lUfoC5NzEvr+bL6rp3W/oiGti+ESGlgmof1D8o+DKUkkAFKgIe/mEdNhGHDExAg+/GjI
         g9sM11eJLuiu1ZFeb2T07DJoGE99+0WZMyB1hg9QxTa6Dc8EARFhwio4bkiiOL/Nrb1k
         f/YJYKA5PAQdLDQzoOy3COz8nTFCzVgZ+HWBt4gkCRv25zdPJj2NkllAr1d6cCUj7h1W
         vGfw==
X-Gm-Message-State: AOAM530t8tZ3HpPvegrHpnIAMbgBxz50IBVkgj0IAOYZbiAEpXW7Lnom
        vh5POY/7RQtGT2AG9IYISVh8KBJeyVVL
X-Google-Smtp-Source: ABdhPJzc8FA4o6rnqK6SPXG0uwHo+AZeAOdvu+n5kGberFP29ERlH2Rz8asBVPjFz5IPr3yZGJSbMQ==
X-Received: by 2002:a63:fe15:: with SMTP id p21mr862776pgh.477.1636393805324;
        Mon, 08 Nov 2021 09:50:05 -0800 (PST)
Received: from localhost.localdomain ([117.202.191.159])
        by smtp.gmail.com with ESMTPSA id p2sm16941pja.55.2021.11.08.09.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 09:50:04 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     aleksander@aleksander.es, loic.poulain@linaro.org,
        thomas.perrot@bootlin.com, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, quic_jhugo@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] bus: mhi: Fix race while handling SYS_ERR at power up
Date:   Mon,  8 Nov 2021 23:19:54 +0530
Message-Id: <20211108174954.60569-1-manivannan.sadhasivam@linaro.org>
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

Changes in v2:

* Switched to "mhi_poll_reg_field" for detecting MHI reset in device.

 drivers/bus/mhi/core/pm.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index fb99e3727155..3c347fe9b10d 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -1038,7 +1038,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	enum mhi_ee_type current_ee;
 	enum dev_st_transition next_state;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
-	u32 val;
 	int ret;
 
 	dev_info(dev, "Requested to power ON\n");
@@ -1055,10 +1054,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	mutex_lock(&mhi_cntrl->pm_mutex);
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 
-	ret = mhi_init_irq_setup(mhi_cntrl);
-	if (ret)
-		goto error_setup_irq;
-
 	/* Setup BHI INTVEC */
 	write_lock_irq(&mhi_cntrl->pm_lock);
 	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
@@ -1072,7 +1067,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		dev_err(dev, "%s is not a valid EE for power on\n",
 			TO_MHI_EXEC_STR(current_ee));
 		ret = -EIO;
-		goto error_async_power_up;
+		goto error_setup_irq;
 	}
 
 	state = mhi_get_mhi_state(mhi_cntrl);
@@ -1081,20 +1076,12 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
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
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+		if (ret) {
 			dev_info(dev, "Failed to reset MHI due to syserr state\n");
-			goto error_async_power_up;
+			goto error_setup_irq;
 		}
 
 		/*
@@ -1104,6 +1091,10 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
 	}
 
+	ret = mhi_init_irq_setup(mhi_cntrl);
+	if (ret)
+		goto error_setup_irq;
+
 	/* Transition to next state */
 	next_state = MHI_IN_PBL(current_ee) ?
 		DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
@@ -1116,9 +1107,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
 	return 0;
 
-error_async_power_up:
-	mhi_deinit_free_irq(mhi_cntrl);
-
 error_setup_irq:
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 	mutex_unlock(&mhi_cntrl->pm_mutex);
-- 
2.25.1

