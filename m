Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113B4CD794
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfJFRbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbfJFRbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:31:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F0A2087E;
        Sun,  6 Oct 2019 17:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383100;
        bh=JpYnaaRnpqG1IJ9LpF43Ky4t2CfiGETqsYi76zPHC88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7O6W5dSXPbSKfiMKeR3+zfkflS/yMdEay4OqQgANHpm3mXZALn+OaWLt8svpVNqq
         Glv7nW/04fevPgKOFfu2ylanIcrGTNa6IySFX3ShXYrWZ08A74iMSWcLV4YUDzj1KF
         GTx1T9iZyVTgbNooJNoEXPNwRKwNvLuMIX38yIz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/106] mbox: qcom: add APCS child device for QCS404
Date:   Sun,  6 Oct 2019 19:20:49 +0200
Message-Id: <20191006171142.875607212@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>

[ Upstream commit 78c86458a440ff356073c21b568cb58ddb67b82b ]

There is clock controller functionality in the APCS hardware block of
qcs404 devices similar to msm8916.

Co-developed-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-apcs-ipc-mailbox.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/qcom-apcs-ipc-mailbox.c b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
index 333ed4a9d4b8f..5255dcb551a78 100644
--- a/drivers/mailbox/qcom-apcs-ipc-mailbox.c
+++ b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
@@ -55,7 +55,6 @@ static const struct mbox_chan_ops qcom_apcs_ipc_ops = {
 
 static int qcom_apcs_ipc_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct qcom_apcs_ipc *apcs;
 	struct regmap *regmap;
 	struct resource *res;
@@ -63,6 +62,11 @@ static int qcom_apcs_ipc_probe(struct platform_device *pdev)
 	void __iomem *base;
 	unsigned long i;
 	int ret;
+	const struct of_device_id apcs_clk_match_table[] = {
+		{ .compatible = "qcom,msm8916-apcs-kpss-global", },
+		{ .compatible = "qcom,qcs404-apcs-apps-global", },
+		{}
+	};
 
 	apcs = devm_kzalloc(&pdev->dev, sizeof(*apcs), GFP_KERNEL);
 	if (!apcs)
@@ -97,7 +101,7 @@ static int qcom_apcs_ipc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (of_device_is_compatible(np, "qcom,msm8916-apcs-kpss-global")) {
+	if (of_match_device(apcs_clk_match_table, &pdev->dev)) {
 		apcs->clk = platform_device_register_data(&pdev->dev,
 							  "qcom-apcs-msm8916-clk",
 							  -1, NULL, 0);
-- 
2.20.1



