Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE73B66A455
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjAMUp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjAMUp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:45:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B30752C59
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:57 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k18so568398pll.5
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=kPo2syja8pG1+b5fwu1HFrYc0YBxgk1lwktiuerWs0WfGaXdeLnjXrILaXommkZmiN
         TNBvxVRka/G4k3yCvinez3F8Bzk4brPFy8QhoNbLVetuVfBrlSlnYa0C3aXzmsvfwa5V
         Ysjwnxm0/E6NRaQCLqdmbPkkFx3cDNhZQSeZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=dNf1nO1+REUVH6bR5aZK9LwfUUvTbOh75RcXKTuhPJySp4EMz/jt94xdFhy/YmFBdI
         jpN/F11BXWADtrn27qS4fT8z1XDO01+jOVWvsDWD2V4iPBbw+2FVgviwyXsVTmfXnJU5
         2YEDPDUDqnCKnSF7KXtDKXyLLEV2STbWqbrHs9ObP5vbfmOQWgMfR5Tvt4t6F+cV/wCC
         kTYEHPqfSQN5/8u9cB+3PnsTQ1e1qb7PxGD9UOnDRw+wPXdM7/51+CWfuw5KPuuJq2IJ
         +QjVQlAOiCamofqX2d2eh7WJHep7kGup9cA/7pw+rTDj7Ni3Q1E+OjRZqPOXdTCvIfp6
         2J1A==
X-Gm-Message-State: AFqh2kpJ6wFcJU+1VY6jPbWLcpZcR5jYM53qbSsmwmbpXKsA+Mgp/emz
        RMxCd/ErxdAcblEUqmB30e92CYkuP5xNKWjm
X-Google-Smtp-Source: AMrXdXsXdacwL++OIjYQp4TVRlwKJ9pcnP7TMzzFIV+6SC3sDKY6D9lpghENazU7xbdyht7Mn8htWg==
X-Received: by 2002:a17:902:854b:b0:192:903c:3726 with SMTP id d11-20020a170902854b00b00192903c3726mr58947252plo.28.1673642756623;
        Fri, 13 Jan 2023 12:45:56 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:55 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 3/5] phy: qcom-qmp-usb: fix memleak on probe deferral
Date:   Fri, 13 Jan 2023 12:45:46 -0800
Message-Id: <20230113204548.578798-4-swboyd@chromium.org>
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

commit a5d6b1ac56cbd6b5850a3a54e35f1cb71e8e8cdd upstream.

Switch to using the device-managed of_iomap helper to avoid leaking
memory on probe deferral and driver unbind.

Note that this helper checks for already reserved regions and may fail
if there are multiple devices claiming the same memory.

Two bindings currently rely on overlapping mappings for the PCS region
so fallback to non-exclusive mappings for those for now.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220916102340.11520-7-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[swboyd@chromium.org: Backport to pre-split driver]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index c6f860ce3d99..ee4fd7afcea2 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5387,6 +5387,21 @@ static void qcom_qmp_reset_control_put(void *data)
 	reset_control_put(data);
 }
 
+static void __iomem *qmp_usb_iomap(struct device *dev, struct device_node *np,
+		int index, bool exclusive)
+{
+	struct resource res;
+
+	if (!exclusive) {
+		if (of_address_to_resource(np, index, &res))
+			return IOMEM_ERR_PTR(-EINVAL);
+
+		return devm_ioremap(dev, res.start, resource_size(&res));
+	}
+
+	return devm_of_iomap(dev, np, index, NULL);
+}
+
 static
 int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 			void __iomem *serdes, const struct qmp_phy_cfg *cfg)
@@ -5396,8 +5411,18 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	struct qmp_phy *qphy;
 	const struct phy_ops *ops;
 	char prop_name[MAX_PROP_NAME];
+	bool exclusive = true;
 	int ret;
 
+	/*
+	 * FIXME: These bindings should be fixed to not rely on overlapping
+	 *        mappings for PCS.
+	 */
+	if (of_device_is_compatible(dev->of_node, "qcom,sdx65-qmp-usb3-uni-phy"))
+		exclusive = false;
+	if (of_device_is_compatible(dev->of_node, "qcom,sm8350-qmp-usb3-uni-phy"))
+		exclusive = false;
+
 	qphy = devm_kzalloc(dev, sizeof(*qphy), GFP_KERNEL);
 	if (!qphy)
 		return -ENOMEM;
@@ -5418,7 +5443,7 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	if (IS_ERR(qphy->rx))
 		return PTR_ERR(qphy->rx);
 
-	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
+	qphy->pcs = qmp_usb_iomap(dev, np, 2, exclusive);
 	if (IS_ERR(qphy->pcs))
 		return PTR_ERR(qphy->pcs);
 
-- 
https://chromeos.dev

