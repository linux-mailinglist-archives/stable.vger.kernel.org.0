Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2DECD73B
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfJFRgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbfJFRgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:36:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C352053B;
        Sun,  6 Oct 2019 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383403;
        bh=ENY7C6ndhTKXioNw1tKj1SAOP8oceyqR21UUp1PZOIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2nnw3UKRV11KAT6e4Lod03SlmZqEDtQ7dy9CogfJO5FQkWlnp7k+MUzQeV3+y+kY
         GZyjZplRgAmzbt6iKTXg+IKjORffqxjRxL18rvhW/ZRTduPFNrW3J7gge9Q3ierkDC
         ZOjyL9vgMI2IvEH2nw7qB1COaNoDd93S/tL8RzNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 084/137] mbox: qcom: add APCS child device for QCS404
Date:   Sun,  6 Oct 2019 19:21:08 +0200
Message-Id: <20191006171215.842936745@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
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
index 705e17a5479cc..d3676fd3cf945 100644
--- a/drivers/mailbox/qcom-apcs-ipc-mailbox.c
+++ b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
@@ -47,7 +47,6 @@ static const struct mbox_chan_ops qcom_apcs_ipc_ops = {
 
 static int qcom_apcs_ipc_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct qcom_apcs_ipc *apcs;
 	struct regmap *regmap;
 	struct resource *res;
@@ -55,6 +54,11 @@ static int qcom_apcs_ipc_probe(struct platform_device *pdev)
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
@@ -89,7 +93,7 @@ static int qcom_apcs_ipc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (of_device_is_compatible(np, "qcom,msm8916-apcs-kpss-global")) {
+	if (of_match_device(apcs_clk_match_table, &pdev->dev)) {
 		apcs->clk = platform_device_register_data(&pdev->dev,
 							  "qcom-apcs-msm8916-clk",
 							  -1, NULL, 0);
-- 
2.20.1



