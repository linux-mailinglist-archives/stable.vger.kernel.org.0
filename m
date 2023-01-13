Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF2A6688C0
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 01:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjAMAyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 19:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240129AbjAMAyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 19:54:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B72B9584
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:54:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b17so14400029pld.7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wTahgPOn0LySuA1i9bASDFyi3Ueigx8xRo8Xbilw4I=;
        b=U+sQqif0/Muwdc6NYnuRVJ/j6zAussnLylJFzP3+XGWl1klHVC4kb2atu717aEslzA
         NqVodkM/ROdq5D0SYpKOyR74tTv0KKYlk+jtzkRmuOtN353d1p2bmajYiizRUFMhI13H
         JeyHme9Xr/xYbipOCXs3Fmvj0rBMaCC5vHuhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wTahgPOn0LySuA1i9bASDFyi3Ueigx8xRo8Xbilw4I=;
        b=tjaaS9u5h9SETYBGOt4ShoDFw4Wmye5yWUVPIaNITuYMrysUKj0t+oUbT2DOIv4In1
         kq0xJTuVvGsrroE5f7EYk1dz6o6DhcGX4M7VkaYPRL2eOvDne/3p++H/w/gS8FrKViEN
         RaPJ3dyGPrjcQpRhDz1LgLa98yyvSVECDXxMuc4xJLD8ZqXMWp77iEC5mcAj7bizmJLZ
         N8NoxZ30HuRKHlmLNaJplweocA0diMgrKcpll6XUcRjZ5Y881jtPKRvToDvceS/+RIrM
         N4DDYS4wCdKZDPAreJWB3B5QYZZyGvRhtLLnHJD7i0cI34YOxhL86dcGsYFCUxqs4r12
         5Epw==
X-Gm-Message-State: AFqh2kobEND8ZM1K6eGku+jba7Vp72R4qHTPjSA0dGr5+yp0rZPStEtF
        te/zDB0gefKimv89GOhPZAjOyUaPaicdyw8i
X-Google-Smtp-Source: AMrXdXuFP3bnEy2rZYHKu3/UtPStVpANsmmC7JzX1z4v5Zlv4YYFYFbBwTG8gZF1b7urQ8yQc5GpUw==
X-Received: by 2002:a05:6a20:548e:b0:9d:efd3:66ca with SMTP id i14-20020a056a20548e00b0009defd366camr110139183pzk.17.1673571253651;
        Thu, 12 Jan 2023 16:54:13 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm10676614pgp.71.2023.01.12.16.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:54:13 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y 4/4] phy: qcom-qmp-combo: fix runtime suspend
Date:   Thu, 12 Jan 2023 16:54:05 -0800
Message-Id: <20230113005405.3992011-5-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113005405.3992011-1-swboyd@chromium.org>
References: <20230113005405.3992011-1-swboyd@chromium.org>
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
[swboyd@chromium.org: Backport to pre-split driver]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 9fda6d283f20..d928afe2ebba 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -4985,15 +4985,11 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
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
@@ -5010,16 +5006,12 @@ static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 static int __maybe_unused qcom_qmp_phy_runtime_resume(struct device *dev)
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
-- 
https://chromeos.dev

