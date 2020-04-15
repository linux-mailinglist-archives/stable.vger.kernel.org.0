Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835741AA1F6
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370239AbgDOMsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408957AbgDOLnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A90214AF;
        Wed, 15 Apr 2020 11:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950986;
        bh=G7KxnwoLgLdPJXOkgOpWzhaL/rwPD/wpMyKVXu5Bt9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULb1wmvB/kXcy0Wk4dJSWiA82rRcYa1DYYs36KkqYWbSZD759gltPYpaWsFD7QxTR
         grDha1sr+2okBedBMsii4giAN8OWEXvDWCfbtmfQ9iA4S0foBVZD5demAHhdQzsMlW
         WAcLhVOC/qyLKcuECPuWesos8XKtZIyzQamOx7Sg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Kucheria <amit.kucheria@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 033/106] drivers: thermal: tsens: Release device in success path
Date:   Wed, 15 Apr 2020 07:41:13 -0400
Message-Id: <20200415114226.13103-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Kucheria <amit.kucheria@linaro.org>

[ Upstream commit f22a3bf0d2225fba438c46a25d3ab8823585a5e0 ]

We don't currently call put_device in case of successfully initialising
the device. So we hold the reference and keep the device pinned forever.

Allow control to fall through so we can use same code for success and
error paths to put_device.

As a part of this fixup, change devm_ioremap_resource to act on the same
device pointer as that used to allocate regmap memory. That ensures that
we are free to release op->dev after examining its resources.

Signed-off-by: Amit Kucheria <amit.kucheria@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/d3996667e9f976bb30e97e301585cb1023be422e.1584015867.git.amit.kucheria@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-common.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/qcom/tsens-common.c b/drivers/thermal/qcom/tsens-common.c
index c8d57ee0a5bb2..2cc276cdfcdb1 100644
--- a/drivers/thermal/qcom/tsens-common.c
+++ b/drivers/thermal/qcom/tsens-common.c
@@ -602,7 +602,7 @@ int __init init_common(struct tsens_priv *priv)
 		/* DT with separate SROT and TM address space */
 		priv->tm_offset = 0;
 		res = platform_get_resource(op, IORESOURCE_MEM, 1);
-		srot_base = devm_ioremap_resource(&op->dev, res);
+		srot_base = devm_ioremap_resource(dev, res);
 		if (IS_ERR(srot_base)) {
 			ret = PTR_ERR(srot_base);
 			goto err_put_device;
@@ -620,7 +620,7 @@ int __init init_common(struct tsens_priv *priv)
 	}
 
 	res = platform_get_resource(op, IORESOURCE_MEM, 0);
-	tm_base = devm_ioremap_resource(&op->dev, res);
+	tm_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(tm_base)) {
 		ret = PTR_ERR(tm_base);
 		goto err_put_device;
@@ -687,8 +687,6 @@ int __init init_common(struct tsens_priv *priv)
 	tsens_enable_irq(priv);
 	tsens_debug_init(op);
 
-	return 0;
-
 err_put_device:
 	put_device(&op->dev);
 	return ret;
-- 
2.20.1

