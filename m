Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5216468A625
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjBCW0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjBCW0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:26:31 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A5299D58
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 14:26:27 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z1so6705152plg.6
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 14:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KePV/9Oxn0f9htud4yGfd4rggKhHt9AicxQ1AYSJFwo=;
        b=ZHWC20inawdmelGm4NlDtU399ZfvbXefioQhUrWd5Q+qfVPIQUKtvgnrrfxLg879+P
         8il8E/HB+5LeP4sKZIt2LXRo25mlB5XBwcIJ/ODUR6/r7CvuxhhTGwvpoUjy03ve5C2g
         MxfDWziaIi/xtAjkJktzmbMcGtXO62+2W0hSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KePV/9Oxn0f9htud4yGfd4rggKhHt9AicxQ1AYSJFwo=;
        b=FUu7Lf0k4T6vGtJM3uafFZgoAVGALb/CJ0AkfWsBqGgvq8VH6DcNH2GR6/54J3VCNz
         BGTSgeX5rfMbYFIQxvC1s78vQLYESfTVNYAezpGi/3oD7qJGUJHpAcj+W2APsNpqz4zT
         khi+y3T+0YieHGbitDDDHCEV8tymX8jiAaP3T+THnDNoZM6k1s8dvV1umOyceg0G3AH6
         Og4lRIjkl/Pz8pV9K5ee1nRFt0QbCZnMl7RYXTSZAd7U88z1lxin0fvjC7HqwG+uR3Tn
         D3x1Gj2+iOtxatyPuSnbxL8obR8erpbN5GiAfPLp3Cecx1WBvpko6ML8nKLgEvRzxuNw
         RlMg==
X-Gm-Message-State: AO0yUKUuQMVyK0gZY40DR5In8whZMCE2kHkpJpE34lLbZ5JRsx4dSI3j
        1WWtB78mbjEvl91SZcDw1ydiUmr32AA1s8mh
X-Google-Smtp-Source: AK7set9T4bFRy1d8Z5JNN3pXQdT9Rrj/0PYJ44cwkNDUGsof+Ui9Dt3kOILGULjF3EUuVAF0BrJC7w==
X-Received: by 2002:a17:903:2285:b0:194:3dc2:5c29 with SMTP id b5-20020a170903228500b001943dc25c29mr14158082plh.38.1675463186341;
        Fri, 03 Feb 2023 14:26:26 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:25 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 5/5] phy: qcom-qmp-combo: fix runtime suspend
Date:   Fri,  3 Feb 2023 14:26:16 -0800
Message-Id: <20230203222616.2935268-6-swboyd@chromium.org>
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
[swboyd@chromium.org: Backport to pre-split driver. Note that the
condition is kept so that ufs and pcie don't do anything as before]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index b8646eaf1767..eef863108bfe 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -4985,7 +4985,7 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
@@ -5010,7 +5010,7 @@ static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 static int __maybe_unused qcom_qmp_phy_runtime_resume(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	int ret = 0;
 
-- 
https://chromeos.dev

