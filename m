Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410EB3E4188
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 10:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhHIIZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 04:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhHIIZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 04:25:04 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07520C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 01:24:44 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k4so9979499wms.3
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 01:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MMllCfmYFnjcwZk6yJ9SVZujM0OJeGztI30MGIz0Avw=;
        b=hN2Aw1lF5hQbakvLyby19k7M45wABivNCeDHhtq1VuNjrwu0cjHqIf1XiVB07lWqgI
         BdmDpWx+vR46Zx46h/GvjbciWePm5uSPWTxvOzYzTK+4WOcEBm4DHFRcyXLuJRF2JXmJ
         ee8Mhr3YE2I8fF8SDBt8sd/oHh40NnxpJDhZh+gizS3RqiWJyofoL3VKI+bSFSf238Jf
         ihB4xp2do2OSoylH9VOKIMF27FfvoyTjAy77F6s7nUX4UiaLwfR0RFKfDxKQQaD6vKfe
         yfvxmctk3s4wpQKHci/Q9uEN/cQHtGXmj2o5WgbDNA5WH+7dm4EZLC4bnuRqvgnrGyEB
         JQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMllCfmYFnjcwZk6yJ9SVZujM0OJeGztI30MGIz0Avw=;
        b=fPywa3wDAUm+VFc/PeuCoUSpGeI5uZqLX6be/NWvPd3V8RsBTHe9TAI+rPQ9CNV+yw
         U3qM0fygbidj+7V0p0HJtct6DGj7coXRcgI9gTWLlSCrNNY3PBcmlsuIw1vz50TB5ez+
         VBYHkFxSWUAGxoGji/cMxFhkLVxs0egdtFKuHTg79lhZU9gd1kuk87maLUBPEs2BGhLq
         Byh8N2s3LpGb+SQN2oj5IXS+IozJRmpu94UcRkk3TlNhaBpU2UW9/Jh8AyT9vEUEv/Xl
         Fo7JSvxRAA4hWnSHxbohG0X4FxhuW9WyVQPgU2scr/hD+xEMVsqoYJXr9skBXfqjULa8
         HQMQ==
X-Gm-Message-State: AOAM530X9z+0PydqlkMf925S86/e4xfwxGrTsnqvZqdUo7ZqejXJVSv6
        8Xi2d4mr5TKai2UisI/tLwVOWg==
X-Google-Smtp-Source: ABdhPJwKHs9itAxe4QJDChgZZLF3srZ1JVyHdOkrrhEfkeTbsizblb860SjyHA9vUqYaJL3FSM0Jag==
X-Received: by 2002:a7b:c114:: with SMTP id w20mr15727927wmi.85.1628497482667;
        Mon, 09 Aug 2021 01:24:42 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id t15sm18036371wrw.48.2021.08.09.01.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 01:24:42 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 3/4] slimbus: ngd: set correct device for pm
Date:   Mon,  9 Aug 2021 09:24:27 +0100
Message-Id: <20210809082428.11236-4-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210809082428.11236-1-srinivas.kandagatla@linaro.org>
References: <20210809082428.11236-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For some reason we ended up using wrong device in some places for pm_runtime calls.
Fix this so that NGG driver can do runtime pm correctly.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index c054e83ab636..f3ee8e036372 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -618,7 +618,7 @@ static void qcom_slim_ngd_rx(struct qcom_slim_ngd_ctrl *ctrl, u8 *buf)
 		(mc == SLIM_USR_MC_GENERIC_ACK &&
 		 mt == SLIM_MSG_MT_SRC_REFERRED_USER)) {
 		slim_msg_response(&ctrl->ctrl, &buf[4], buf[3], len - 4);
-		pm_runtime_mark_last_busy(ctrl->dev);
+		pm_runtime_mark_last_busy(ctrl->ctrl.dev);
 	}
 }
 
@@ -1257,13 +1257,14 @@ static int qcom_slim_ngd_enable(struct qcom_slim_ngd_ctrl *ctrl, bool enable)
 		}
 		/* controller state should be in sync with framework state */
 		complete(&ctrl->qmi.qmi_comp);
-		if (!pm_runtime_enabled(ctrl->dev) ||
-				!pm_runtime_suspended(ctrl->dev))
-			qcom_slim_ngd_runtime_resume(ctrl->dev);
+		if (!pm_runtime_enabled(ctrl->ctrl.dev) ||
+			 !pm_runtime_suspended(ctrl->ctrl.dev))
+			qcom_slim_ngd_runtime_resume(ctrl->ctrl.dev);
 		else
-			pm_runtime_resume(ctrl->dev);
-		pm_runtime_mark_last_busy(ctrl->dev);
-		pm_runtime_put(ctrl->dev);
+			pm_runtime_resume(ctrl->ctrl.dev);
+
+		pm_runtime_mark_last_busy(ctrl->ctrl.dev);
+		pm_runtime_put(ctrl->ctrl.dev);
 
 		ret = slim_register_controller(&ctrl->ctrl);
 		if (ret) {
@@ -1389,7 +1390,7 @@ static int qcom_slim_ngd_ssr_pdr_notify(struct qcom_slim_ngd_ctrl *ctrl,
 		/* Make sure the last dma xfer is finished */
 		mutex_lock(&ctrl->tx_lock);
 		if (ctrl->state != QCOM_SLIM_NGD_CTRL_DOWN) {
-			pm_runtime_get_noresume(ctrl->dev);
+			pm_runtime_get_noresume(ctrl->ctrl.dev);
 			ctrl->state = QCOM_SLIM_NGD_CTRL_DOWN;
 			qcom_slim_ngd_down(ctrl);
 			qcom_slim_ngd_exit_dma(ctrl);
-- 
2.21.0

