Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D543E270B
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 11:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244468AbhHFJRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 05:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244402AbhHFJRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 05:17:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703ACC06179A
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 02:16:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b13so10198520wrs.3
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 02:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MMllCfmYFnjcwZk6yJ9SVZujM0OJeGztI30MGIz0Avw=;
        b=C+M+wamIDYBLchdf5EIbEUE8eIQaJfS6Ld5016M5g/s/yPTVB3y5mDTqOxxcK9eP0L
         z3z/DR9Ch2hZP9i1WpJel5qKzCUcFndM/FWQY0mIuRgCw/7S8y5FkcSa1hCvKVchrFDY
         6aBHrEjtzc87Kgm6jEgYTJsfbQrKPs0gUup76RHeNhmpkynWKUEsFfuK66D95OvCxHof
         Nhi/ofrwV0XlWJyIB24+ounrK8+1sR2HyZFH8+cL4I4js9xTyzFJoHjEDUoaDq7F5OUd
         N/t8fLofeAZbTOVciTk16cd5sjxII1ZiosngcYeqDGnFXcQpPBwC4z2pAxOROfvld0oT
         lKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMllCfmYFnjcwZk6yJ9SVZujM0OJeGztI30MGIz0Avw=;
        b=ocW3fUwPIpEhnInwIlzoHhu4I2BhgC7R25vvDsZn0Py5cI8p8n4Pr0kQBLSLIW7hmh
         s/2dd48nuHefDwqrGtVg0h1BhrdpEO5kdNDSiDWNpx0EqxwHF5KeShUSWIG4mmj9AbB2
         g+J9ZhiRhqMiimEcW3wjivwtGnLrHrNXs+4LzrO+aN+/oY5zG46uQGhfz2MpVaNrvv7P
         gHJrHafU1z1G14oa9/o1bdXJ6qTrV7vnAVAZPdc0jZXHTL7FOX42hTTSGvuZ2gHuvu+n
         fViHzodY0ows0N1qzqdMxdgddBtOijLvC2qLQQCU/RVIH5RuT7Hfth97YhT136Ts+quc
         fr9Q==
X-Gm-Message-State: AOAM532135hbrJCFXkn+34ocjbBaqOv3+dveURXSHXvSTdand0Bnx9tX
        AJNTgpuMH7awmLEZFrTWGJwJaw==
X-Google-Smtp-Source: ABdhPJzpSfk17ch22EthJioz9PJM6HJUDeVNRIEL70ssHBWebrapApTWmQKOeLwNLINIpJRh9ZkHVg==
X-Received: by 2002:a5d:6b8f:: with SMTP id n15mr9496103wrx.103.1628241408108;
        Fri, 06 Aug 2021 02:16:48 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id w3sm7811760wmi.44.2021.08.06.02.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 02:16:47 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] slimbus: ngd: set correct device for pm
Date:   Fri,  6 Aug 2021 10:16:38 +0100
Message-Id: <20210806091639.532-4-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210806091639.532-1-srinivas.kandagatla@linaro.org>
References: <20210806091639.532-1-srinivas.kandagatla@linaro.org>
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

