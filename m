Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB40868A623
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjBCW0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbjBCW00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:26:26 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DAA991EA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 14:26:25 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so10170561pjq.0
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 14:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opWL1eWdVQ2VhNLEIBeNIDgEIiIkBXU/WYBvPsvy/Sg=;
        b=X9hsiVQ54J+dqELB4u7nfOl9MCcw1fHszhwo+qTsvhbfZiwCWP0iBVTFh7MxNaJUzz
         tlZW9fyMF0rZjpcB3LesF/rzTDr7OZjt5bh35VrDZpcy//a8evFgHaBLvi+2yAE6PmZY
         yDOkpiwq/LZJdlhbAQoUOCfTNbde3HBntVVG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=opWL1eWdVQ2VhNLEIBeNIDgEIiIkBXU/WYBvPsvy/Sg=;
        b=WXSNyAR6kqqChKo+KKZ8eNpz1CmqHGeFtE99XMcXtfGg2jHlYfYBOYpZBwWFJS8Rbj
         ByUT/v/kjnte3vq8cb6wKsrhE6TGFoJevBv8XeiLFqeWBI6xBJu/m/IsEPqVHzPLjn8F
         Mnwl7vSBoyeC7xSaH5zypTPJwtoSQfv9m+JUqDt7G0FNSQKVF0XRwZ9gXOAd2496Ud5O
         pY5uKYA79G0Rkzy9py4ehqMRmyvtLDN/otrQWA3qlW+78R6JVchgPtvY9b5rQSjm3D7a
         yl+pyOJsiUbh65XOnyeSytgyecX6hIUP/PoGFpsNxujzBmYzYojY5bV+ORUe1Y+NSATY
         Iplg==
X-Gm-Message-State: AO0yUKVf0WdNxCjq0Z97tzfYOpkNMPGOANFrYFVPRM4L18DHUgRoJmLW
        KHsXTBcsmwhkJOQ/lmrzm8t8FXkk9Q76BsIH
X-Google-Smtp-Source: AK7set+x2gCgupSM4F2YG4Pq2c7GGibNTwddBSpORabfV5DijAonGFo69FytXidmw8ejkBndVaduiQ==
X-Received: by 2002:a17:902:d510:b0:198:b945:4108 with SMTP id b16-20020a170902d51000b00198b9454108mr10494136plg.0.1675463185011;
        Fri, 03 Feb 2023 14:26:25 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:24 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 4/5] phy: qcom-qmp-combo: fix broken power on
Date:   Fri,  3 Feb 2023 14:26:15 -0800
Message-Id: <20230203222616.2935268-5-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230203222616.2935268-1-swboyd@chromium.org>
References: <20230203222616.2935268-1-swboyd@chromium.org>
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

commit 7a7d86d14d073dfa3429c550667a8e78b99edbd4 upstream.

The PHY is powered on during phy-init by setting the SW_PWRDN bit in the
COM_POWER_DOWN_CTRL register and then setting the same bit in the in the
PCS_POWER_DOWN_CONTROL register that belongs to the USB part of the
PHY.

Currently, whether power on succeeds depends on probe order and having
the USB part of the PHY be initialised first. In case the DP part of the
PHY is instead initialised first, the intended power on of the USB block
results in a corrupted DP_PHY register (e.g. DP_PHY_AUX_CFG8).

Add a pointer to the USB part of the PHY to the driver data and use that
to power on the PHY also if the DP part of the PHY is initialised first.

Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
Cc: stable@vger.kernel.org	# 5.10
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-5-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[swboyd@chromium.org: Backport to pre-split driver, also set usb_phy for
pcie/ufs]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index ee4fd7afcea2..b8646eaf1767 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -2919,6 +2919,7 @@ struct qcom_qmp {
 	struct regulator_bulk_data *vregs;
 
 	struct qmp_phy **phys;
+	struct qmp_phy *usb_phy;
 
 	struct mutex phy_mutex;
 	int init_count;
@@ -4554,7 +4555,7 @@ static int qcom_qmp_phy_com_init(struct qmp_phy *qphy)
 	struct qcom_qmp *qmp = qphy->qmp;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	void __iomem *serdes = qphy->serdes;
-	void __iomem *pcs = qphy->pcs;
+	struct qmp_phy *usb_phy = qmp->usb_phy;
 	void __iomem *dp_com = qmp->dp_com;
 	int ret, i;
 
@@ -4620,13 +4621,13 @@ static int qcom_qmp_phy_com_init(struct qmp_phy *qphy)
 		qphy_setbits(serdes, cfg->regs[QPHY_COM_POWER_DOWN_CONTROL],
 			     SW_PWRDN);
 	} else {
-		if (cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
-			qphy_setbits(pcs,
-					cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
-					cfg->pwrdn_ctrl);
+		if (usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
+			qphy_setbits(usb_phy->pcs,
+					usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
+					usb_phy->cfg->pwrdn_ctrl);
 		else
-			qphy_setbits(pcs, QPHY_POWER_DOWN_CONTROL,
-					cfg->pwrdn_ctrl);
+			qphy_setbits(usb_phy->pcs, QPHY_POWER_DOWN_CONTROL,
+					usb_phy->cfg->pwrdn_ctrl);
 	}
 
 	mutex_unlock(&qmp->phy_mutex);
@@ -5794,6 +5795,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
 			goto err_node_put;
 		}
 
+		if (cfg->type != PHY_TYPE_DP)
+			qmp->usb_phy = qmp->phys[id];
+
 		/*
 		 * Register the pipe clock provided by phy.
 		 * See function description to see details of this pipe clock.
@@ -5816,6 +5820,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
 		id++;
 	}
 
+	if (!qmp->usb_phy)
+		return -EINVAL;
+
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 	if (!IS_ERR(phy_provider))
 		dev_info(dev, "Registered Qcom-QMP phy\n");
-- 
https://chromeos.dev

