Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C244668A634
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjBCW3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbjBCW3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:29:02 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E320E4218
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 14:28:28 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e6so6693685plg.12
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 14:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gMyHt710tobXZzqB4RVOXm/lfSphZfIQDyw8A1rvqM8=;
        b=KJQTCWhAd7IPsSxTwSEdEe5ccYd6PTpm9gQe4BkQOs0WlNmdWxAQxrM8F0aHiu25In
         0386XN/L0AG/jmBhyONVoBbYBvi5VNUa6YG27G3cZnsLDOCeubj2Fjew82Ab9wI5dFm9
         1JfI/nmp3tNTYA0zPEKeDUbvR5uVXlIKAwp+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMyHt710tobXZzqB4RVOXm/lfSphZfIQDyw8A1rvqM8=;
        b=6HIt+OE9tYXjTtt0vNTHUE2QZ1fhB+QLwJaP41e0GPKK6w9yxI/m55GBioA8mjOFsb
         Ybkot+BMk1amWLgDOZUIMiEwwTajEh3LYo22xiah4+vd/Um+LaxaLV9QoQ2UltBeAOyu
         81PSEkNrZE2xioLl4EpiGg2TEw3IkRQFKveUkepsHKq4otKnSvgKCVSKlanZRAhdc4dt
         HlUc2mGc5ZMtbJMW2vJ3nmRx67d+Glg/NGY9xdIuzaATbZYVrJwauzN+Auf7LdWbkNt8
         K4+qiKnvMec6+wgbmLgLMjF+D9nkfaklneNtOd7DNVDaVwjOdS4DfW589cmY2Htuwxjt
         etxw==
X-Gm-Message-State: AO0yUKX2ZUgVqZFc2+QWq3HJNimvndPUXx/Z3OJVlQpaOyE/VAOuAEfx
        +C3TeVFKg2tKoY1XoFhd2hHbXz1MQ13sRndl
X-Google-Smtp-Source: AK7set//yln2V1DGJdDa8X2Q3rBGRrmvfMdT9UHoD5EABS+sltirE42ArLrbAQz68gi6qCTk07lZkQ==
X-Received: by 2002:a17:903:30d2:b0:195:efa7:d54e with SMTP id s18-20020a17090330d200b00195efa7d54emr4510904plc.12.1675463303088;
        Fri, 03 Feb 2023 14:28:23 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id u65-20020a627944000000b0058da56167b7sm2333853pfc.127.2023.02.03.14.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:28:22 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1.y] phy: qcom-qmp-combo: fix runtime suspend
Date:   Fri,  3 Feb 2023 14:28:20 -0800
Message-Id: <20230203222820.2958983-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit c7b98de745cffdceefc077ad5cf9cda032ef8959 upstream.

Drop the confused runtime-suspend type check which effectively broke
runtime PM if the DP child node happens to be parsed before the USB
child node during probe (e.g. due to order of child nodes in the
devicetree).

Instead use the new driver data USB PHY pointer to access the USB
configuration and resources.

Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-6-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index adcda7762acf..816829105135 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2296,15 +2296,11 @@ static void qmp_combo_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qmp_combo_runtime_suspend(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
@@ -2321,16 +2317,12 @@ static int __maybe_unused qmp_combo_runtime_suspend(struct device *dev)
 static int __maybe_unused qmp_combo_runtime_resume(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	int ret = 0;
 
 	dev_vdbg(dev, "Resuming QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;

base-commit: 68a95455c153f8adc513e5b688f4b348daa7c1b1
-- 
https://chromeos.dev

