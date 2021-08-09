Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0383E4187
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 10:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhHIIZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 04:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbhHIIZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 04:25:05 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82FAC06179A
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 01:24:44 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so13910408wms.2
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 01:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P17OeSiwNU27tPgzIXbVaCeJQjA2Rn8XgRVpE6+nR8Q=;
        b=FfNaBNHtenFz64h3TEkWwoH4t4gtVDyUsXq6bYM5JzZsupGRdA4O02JGELm1/pC33f
         cR6SswkNuCn+rTBtMGi1wH1JWVkA9U8vx8p7lJme69+B3Q5FEs3MAzADYPWDRAeh4J0G
         xIG+1Lf1m5RxobQ6EIhoqBznLHx0QyQpJIABoxTfJecQ72CFrStJjpwpKf+uX4nNNir9
         f/zdA/J7Z0kVMo9eZnEt+CZhazZ+s2HARiGtB5YKDX3zueUf9SNj5seWG281oXr+Tbz+
         voxm58rgi2nElKh++Xa3aw3zOCZeheCi1WV+sk61M7JbFc32EFpGDIGDow87LWlBX5Y7
         8xYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P17OeSiwNU27tPgzIXbVaCeJQjA2Rn8XgRVpE6+nR8Q=;
        b=WkOMWRsJ5BxGjoVfN8FhesvHYS+Cv2fRpYV52VSwAsp/Me6FRnY0AOCxcAQSnVC8lY
         RH6zwb1oQkbU0x18K2M3keAxbVawGr3dVr8ZE6MoO4pATnJw2v3cIUZBeQW3J77buokN
         o4gGWPEQXxlVsOaBbHbEfMH/fCoAMFC2EMrbmT0AnoYMBOx3AOMVchFcLLEpc+wxQ5qu
         CTu/OYdjaserrqDlccyPMuHT9SFc7kq/OivDKCFgkbSyMAACme3XCDMfUGDQoWKPOVfr
         j6jmd8x2tEQbG0R6imhqs8OyFSw50jTypMq3Q2YC6JtQ6bmdNYdqSQLMxtUomPBPH9cm
         BN7w==
X-Gm-Message-State: AOAM531xFL/M5XBbMN4/pLLGTcjwpbcrISJn5GGltdUWTAfCNk1jWMjM
        W4m3FHmZdoE93wyS+3lMcIN3MPVKFI5tTA==
X-Google-Smtp-Source: ABdhPJzKLg6QTg0nUa59LyZszA+hMhSYzJN/HFARGXgCbUgirIgEmxVvcyVt8Jkn8g8LD99NCVftdQ==
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr32650946wmb.5.1628497483634;
        Mon, 09 Aug 2021 01:24:43 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id t15sm18036371wrw.48.2021.08.09.01.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 01:24:43 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 4/4] slimbus: ngd: reset dma setup during runtime pm
Date:   Mon,  9 Aug 2021 09:24:28 +0100
Message-Id: <20210809082428.11236-5-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210809082428.11236-1-srinivas.kandagatla@linaro.org>
References: <20210809082428.11236-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During suspend/resume NGD remote instance is power cycled along
with remotely controlled bam dma engine.
So Reset the dma configuration during this suspend resume path
so that we are not dealing with any stale dma setup.

Without this transactions timeout after first suspend resume path.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index f3ee8e036372..7040293c2ee8 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1080,7 +1080,8 @@ static void qcom_slim_ngd_setup(struct qcom_slim_ngd_ctrl *ctrl)
 {
 	u32 cfg = readl_relaxed(ctrl->ngd->base);
 
-	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN)
+	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN ||
+		ctrl->state == QCOM_SLIM_NGD_CTRL_ASLEEP)
 		qcom_slim_ngd_init_dma(ctrl);
 
 	/* By default enable message queues */
@@ -1131,6 +1132,7 @@ static int qcom_slim_ngd_power_up(struct qcom_slim_ngd_ctrl *ctrl)
 			dev_info(ctrl->dev, "Subsys restart: ADSP active framer\n");
 			return 0;
 		}
+		qcom_slim_ngd_setup(ctrl);
 		return 0;
 	}
 
@@ -1618,6 +1620,7 @@ static int __maybe_unused qcom_slim_ngd_runtime_suspend(struct device *dev)
 	struct qcom_slim_ngd_ctrl *ctrl = dev_get_drvdata(dev);
 	int ret = 0;
 
+	qcom_slim_ngd_exit_dma(ctrl);
 	if (!ctrl->qmi.handle)
 		return 0;
 
-- 
2.21.0

