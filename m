Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403CC68A622
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbjBCW0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbjBCW0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:26:25 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D74A93AF4
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 14:26:24 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d2so2748000pjd.5
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 14:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=j+2EDjk6kXsfu96EGsq9W+a4ZlMfTkNoxCSWsme1zPjSw/07v/aPaxFBfKkUeWIlJJ
         frEK4jPLIUPilY0mgh1v0EfxN4jn3oHDXdXnblPtxTYy5n6BrGtYflOWzjvWvzPmp7MQ
         7+NG8U0AC2axMf8ia4UXvb3GdGJuppA6uN4Gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=vflfYvfTsYtrlhAbQaAGBZy1q4a8IskkoERxn044/3hHfTclDu71cypFKBCLkFkvzf
         6BeMA/00T4D+apXGErVPzbC2AKrD2+hVaDa022vZeMyG87+rDoXUQPNJIyMrSY3ie4Nx
         ulRB6NSoDW73A/icvVN/3LJlK7zZSdLzUyUtH5f7BFT1L+T6biVwvNYj94p++cMpV7Hw
         AobeZRoJkF1PQGuEQ16/GD18l34mAmBEgRvdzZlSGvteOQa66jNfDrQaYQutSEJIJ4bH
         w2riRDBew9Rc361ye+T3bXSzzmLt7N7mU1rtWf5H7Jvo4EPOx9eX+vI3XtGqTcrJjWFt
         Rhpw==
X-Gm-Message-State: AO0yUKUbntHHs6+DOAphhsF96QrMcKAwZv83edlqrUyUWJ2Kz+mLyUmO
        Wdvd0kQooNMnOK+CnVyfS9f91WCkC9uzNXxt
X-Google-Smtp-Source: AK7set8xw5KZ9uOUvAjUBByLgqTGwpE4XDEpcQ5xQS029vfEQhIMNo0rU4JvOgGlvGXBqrEqqLApaA==
X-Received: by 2002:a17:903:230d:b0:196:4fe3:21b1 with SMTP id d13-20020a170903230d00b001964fe321b1mr13352508plh.27.1675463183645;
        Fri, 03 Feb 2023 14:26:23 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:23 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 3/5] phy: qcom-qmp-usb: fix memleak on probe deferral
Date:   Fri,  3 Feb 2023 14:26:14 -0800
Message-Id: <20230203222616.2935268-4-swboyd@chromium.org>
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

