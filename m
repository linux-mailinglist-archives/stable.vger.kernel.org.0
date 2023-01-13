Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB1666A45A
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjAMUqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjAMUqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:46:09 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBF371494
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:46:00 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v23so23548578pju.3
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBi2/qyUC845LFRzXkZZ02iiz+01kFcIC3Wu67immxs=;
        b=kRx8bFUPs6e81RW6/OJxTlgFo1g1CRAgsbMtDsiYYz1TT8RfZ5L10WQk0D1yMzb6oz
         1SPZhnB2GsQ9u9XBeFaUxrlxcIU6mAsuURwLUKKIkirlrAt5lGd7cOQJUibEOaodzeu2
         douiBjk0yrxsKBHiaoNilKGx0iiaJybztmtqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HBi2/qyUC845LFRzXkZZ02iiz+01kFcIC3Wu67immxs=;
        b=uuUFafSXODC6mOPLLqNQrgn02pdjtqUs4zUysRQ6CJbLYzkLyWeENrF/xrQNV428df
         oTi0Z2jAu7wlB5i8xsTRBAjghawiclzpitzwt2b/rHJmSM6qn7jFjyYGCRZmJfWj/JSj
         3T05Nq4ZWWu7cIZYO20tRtxCfocCKwDr+U5y9fne0IXE/ifDY3wPnnJyWVgL2ecPySFG
         bG5/8pL988vpW0OqLWvlBBY4Xo2JcDB/jbux72RA7pfkduBnBKZnCqjEogwPnKN5KPJX
         L9QWpWoWxhfUP+OvEoZ4InIMp6z3o0pUMIy75vAYr0s8fdIr9KseoM8AZYscvev0aOJO
         lGNQ==
X-Gm-Message-State: AFqh2ko3c3gM7OR3YXaKM9rCemWHqyEa8t26UYeIlQIu3LUnneOM9HLV
        q9/U75vaXkiGawnNzX+5TaYH7bDkiMbRBq8U
X-Google-Smtp-Source: AMrXdXsf6LhytMMpI9hgTdoKV3tVJYPmL/AlUKNgDNZqknFWYgZVH1aN/OnaJq2PKABVv+k5Fo8pIQ==
X-Received: by 2002:a17:902:c454:b0:192:b52f:33bb with SMTP id m20-20020a170902c45400b00192b52f33bbmr9843370plm.45.1673642759860;
        Fri, 13 Jan 2023 12:45:59 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:59 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 5/5] phy: qcom-qmp-combo: fix runtime suspend
Date:   Fri, 13 Jan 2023 12:45:48 -0800
Message-Id: <20230113204548.578798-6-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113204548.578798-1-swboyd@chromium.org>
References: <20230113204548.578798-1-swboyd@chromium.org>
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
index b8646eaf1767..64a42e28e99f 100644
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

