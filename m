Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C052F3AED40
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhFUQSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbhFUQSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 12:18:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E71CC061766
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 09:16:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so335543pji.0
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 09:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7LBMmECFFSW8LKo0Z6mYB/q0IYHCWA9jmYx2xIVnOU=;
        b=icEvD/Xm7mIt2f74nwT+ZHu6MKsdzMyLiVsH7dBywgGt8gTcMIft6SRt3H0EWEzaFK
         24fdKXB8XJcvHl6pfLkga+21EVBdM253Y6PlVZBDKFk5Ou1y3N8pofFg6Zys5PN3P2bo
         mFl+03t20ExY5k1jfzwgCZlZgPOPaLv5R5Gl7+Rf/IOZgZhgMidbfvwBhabA/W0ZCz5r
         uL6AIAmHmrfSe8siqZbzO4iYo3OYgmWY1XNOpRbp94bI4papIVrg2f5J/gZGLNmnavUB
         HwcSU1sz5Hj+fbb30rmduyqP/fiFrVw73EHS/5qXGzZjFXEMClMLMFTZLAPs9gdVdXwz
         pv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7LBMmECFFSW8LKo0Z6mYB/q0IYHCWA9jmYx2xIVnOU=;
        b=Ooyq+D6p3cIidpEtaSoLoF70REDIh+lwhdS3k8QfYT0tkV0ToUYCdjKI9kPW/bU+70
         afzHy8X4QeynrmUywpWBZYBerjxIxm/mVVh25IV2QSSljfSphTcnN+9+jdS42482fxCP
         7xEmac2bPF+c0kf/ycfPrRQvt0Ro+kWDrengOA+eH2dAPyT8MK28dganrrsAE/dqsijO
         ZD6tA/iNbRnInxZl9teh6rdkHgyABfrF4U6obYC0vtArr9hF1YSMZFwHKDtwvEq5eEPj
         DWHuBkRAG+/SToT1xlPLFI+5LyFVK19bJEw5lmyHi2VRP+mldytoK6BlnS+mWfwViXeK
         PRyg==
X-Gm-Message-State: AOAM530U3e4JwKCGYK1Tu3rV4dwmZWo5GTbAB8xSkSAWHiwe2MVH5k36
        MD3zL7WKJW8Mlp38yEy7KHQT
X-Google-Smtp-Source: ABdhPJz+MXbPsg/Z0Rh36BcGXjEh74e5H//Y9GVkPYcmg565LmC9pwkcwTSgh6vUohBWG7D0rz7PvA==
X-Received: by 2002:a17:902:a70c:b029:118:7b47:e5bf with SMTP id w12-20020a170902a70cb02901187b47e5bfmr18726450plq.9.1624292197969;
        Mon, 21 Jun 2021 09:16:37 -0700 (PDT)
Received: from localhost.localdomain ([120.138.13.116])
        by smtp.gmail.com with ESMTPSA id k88sm10734730pjk.15.2021.06.21.09.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:16:37 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 2/8] bus: mhi: core: Fix power down latency
Date:   Mon, 21 Jun 2021 21:46:10 +0530
Message-Id: <20210621161616.77524-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
References: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

On graceful power-down/disable transition, when an MHI reset is
performed, the MHI device loses its context, including interrupt
configuration. However, the current implementation is waiting for
event(irq) driven state change to confirm reset has been completed,
which never happens, and causes reset timeout, leading to unexpected
high latency of the mhi_power_down procedure (up to 45 seconds).

Fix that by moving to the recently introduced poll_reg_field method,
waiting for the reset bit to be cleared, in the same way as the
power_on procedure.

Cc: stable@vger.kernel.org
Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Link: https://lore.kernel.org/r/1620029090-8975-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/pm.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index e2e59a341fef..704a5e225097 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -465,23 +465,15 @@ static void mhi_pm_disable_transition(struct mhi_controller *mhi_cntrl)
 
 	/* Trigger MHI RESET so that the device will not access host memory */
 	if (!MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state)) {
-		u32 in_reset = -1;
-		unsigned long timeout = msecs_to_jiffies(mhi_cntrl->timeout_ms);
-
 		dev_dbg(dev, "Triggering MHI Reset in device\n");
 		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
 
 		/* Wait for the reset bit to be cleared by the device */
-		ret = wait_event_timeout(mhi_cntrl->state_event,
-					 mhi_read_reg_field(mhi_cntrl,
-							    mhi_cntrl->regs,
-							    MHICTRL,
-							    MHICTRL_RESET_MASK,
-							    MHICTRL_RESET_SHIFT,
-							    &in_reset) ||
-					!in_reset, timeout);
-		if (!ret || in_reset)
-			dev_err(dev, "Device failed to exit MHI Reset state\n");
+		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				 MHICTRL_RESET_MASK, MHICTRL_RESET_SHIFT, 0,
+				 25000);
+		if (ret)
+			dev_err(dev, "Device failed to clear MHI Reset\n");
 
 		/*
 		 * Device will clear BHI_INTVEC as a part of RESET processing,
-- 
2.25.1

