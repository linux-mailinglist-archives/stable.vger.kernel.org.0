Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7593066A453
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjAMUp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjAMUp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:45:57 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE4712AE2
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:55 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so25541087pjj.4
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EKfzPUpjx2o77cFgSD1szOPFx9p7F1YloFu6dux5jE=;
        b=c5MePPcQOxolySSTkYSFqcPzoRQgD2LAbFsfAgCFEXRR5kITKtrkGnUohoWrokrKUT
         CdCF4317T73BZ7ZBB2dZrNcFuCEAxsQCZiuyKT3961Ixuk2FDLmSVE22o4HrSsoB+h37
         srCCiUIppMFQOc6qmDfbRqbAeNTu5AdXBK/JI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EKfzPUpjx2o77cFgSD1szOPFx9p7F1YloFu6dux5jE=;
        b=4k5vYjbujYDD3yok0c3X5xu4guV8q5LCbMGgb0GQSkj+M8qwbGKtPrzcD3oOtr0ipV
         2rYQvDUnfsZ0N+gqT73Na4CCtgJvKdeJDJmNTSYAOnjHiJbR1I8n60grKp3VDkjeOj3q
         B8IuKdQmgvtlPtQYimNBY3VbNPmRIgWdd6WgLIEmRqaxLGiXTeWVoJ3ri2WMHIkQdjQ7
         DDV3vtfokrkrELxDxVoYTvETi0qixL4LvdWu5Pwsf/+ks5cDreDKAtiN9QHJ6CpiV65o
         pCaVgIybkAlM3Yak6SV0K3k8/F7x29zV1rENRZrKUY6tVVEvOjNiidWYdNjNmS8LXftM
         n0VQ==
X-Gm-Message-State: AFqh2koKp2KhUfqcLQ+a4sVvBZdcNAqkK87RVPKy0O7928FvsfNqkh+f
        +fMAU9lQKttoOLEItbPJpiASTnPlOMp9nAOG
X-Google-Smtp-Source: AMrXdXuE9cOXm90YkFyK4/RVNwZqACeHvqf8UZLKFFGHDWZFnI801i6GdNVrYPO0HSgS8Bdu/QiDcg==
X-Received: by 2002:a17:902:bf01:b0:189:c47b:af27 with SMTP id bi1-20020a170902bf0100b00189c47baf27mr77998697plb.10.1673642754855;
        Fri, 13 Jan 2023 12:45:54 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:54 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 2/5] phy: qcom-qmp-combo: fix memleak on probe deferral
Date:   Fri, 13 Jan 2023 12:45:45 -0800
Message-Id: <20230113204548.578798-3-swboyd@chromium.org>
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

commit 2de8a325b1084330ae500380cc27edc39f488c30 upstream.

Switch to using the device-managed of_iomap helper to avoid leaking
memory on probe deferral and driver unbind.

Note that this helper checks for already reserved regions and may fail
if there are multiple devices claiming the same memory.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220916102340.11520-5-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 32 +++++++++++++++--------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 7b7557c35af6..c6f860ce3d99 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5410,17 +5410,17 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	 * For dual lane PHYs: tx2 -> 3, rx2 -> 4, pcs_misc (optional) -> 5
 	 * For single lane PHYs: pcs_misc (optional) -> 3.
 	 */
-	qphy->tx = of_iomap(np, 0);
-	if (!qphy->tx)
-		return -ENOMEM;
+	qphy->tx = devm_of_iomap(dev, np, 0, NULL);
+	if (IS_ERR(qphy->tx))
+		return PTR_ERR(qphy->tx);
 
-	qphy->rx = of_iomap(np, 1);
-	if (!qphy->rx)
-		return -ENOMEM;
+	qphy->rx = devm_of_iomap(dev, np, 1, NULL);
+	if (IS_ERR(qphy->rx))
+		return PTR_ERR(qphy->rx);
 
-	qphy->pcs = of_iomap(np, 2);
-	if (!qphy->pcs)
-		return -ENOMEM;
+	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
+	if (IS_ERR(qphy->pcs))
+		return PTR_ERR(qphy->pcs);
 
 	/*
 	 * If this is a dual-lane PHY, then there should be registers for the
@@ -5429,9 +5429,9 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	 * offset from the first lane.
 	 */
 	if (cfg->is_dual_lane_phy) {
-		qphy->tx2 = of_iomap(np, 3);
-		qphy->rx2 = of_iomap(np, 4);
-		if (!qphy->tx2 || !qphy->rx2) {
+		qphy->tx2 = devm_of_iomap(dev, np, 3, NULL);
+		qphy->rx2 = devm_of_iomap(dev, np, 4, NULL);
+		if (IS_ERR(qphy->tx2) || IS_ERR(qphy->rx2)) {
 			dev_warn(dev,
 				 "Underspecified device tree, falling back to legacy register regions\n");
 
@@ -5441,15 +5441,17 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 			qphy->rx2 = qphy->rx + QMP_PHY_LEGACY_LANE_STRIDE;
 
 		} else {
-			qphy->pcs_misc = of_iomap(np, 5);
+			qphy->pcs_misc = devm_of_iomap(dev, np, 5, NULL);
 		}
 
 	} else {
-		qphy->pcs_misc = of_iomap(np, 3);
+		qphy->pcs_misc = devm_of_iomap(dev, np, 3, NULL);
 	}
 
-	if (!qphy->pcs_misc)
+	if (IS_ERR(qphy->pcs_misc)) {
 		dev_vdbg(dev, "PHY pcs_misc-reg not used\n");
+		qphy->pcs_misc = NULL;
+	}
 
 	/*
 	 * Get PHY's Pipe clock, if any. USB3 and PCIe are PIPE3
-- 
https://chromeos.dev

