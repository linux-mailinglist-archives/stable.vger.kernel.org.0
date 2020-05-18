Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D331D84BE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbgERSBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732362AbgERSBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F76C20826;
        Mon, 18 May 2020 18:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824869;
        bh=q+c7ReZyw8cKraevnY75es7TAUo/GWn3VMPlGiTmqps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSjr0OPQA2vXkmQfdd/U4FqLql0ZS+9DX/LmYYY6Rmx+FBfx0ZWwoKil+j0YEikbe
         5w8GjePkpsGu0Z4LKkxvlOUAUSbJF1A3nLv8UEcFbxVRYtIXBGv84VrU7hdCbEqEeK
         DfDS2+R7usVtnd2hjXWRZ10HJjdEsJlq6kU1y3kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Ankushrao Kawadgave <rahulak@qti.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 035/194] net: stmmac: fix num_por initialization
Date:   Mon, 18 May 2020 19:35:25 +0200
Message-Id: <20200518173534.557926933@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit fd4a5177382230d39e0d95632d98103fb2938383 ]

Driver missed initializing num_por which is one of the por values that
driver configures to hardware. In order to get these values, add a new
structure ethqos_emac_driver_data which holds por and num_por values
and populate that in driver probe.

Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")
Reported-by: Rahul Ankushrao Kawadgave <rahulak@qti.qualcomm.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c |   17 ++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -75,6 +75,11 @@ struct ethqos_emac_por {
 	unsigned int value;
 };
 
+struct ethqos_emac_driver_data {
+	const struct ethqos_emac_por *por;
+	unsigned int num_por;
+};
+
 struct qcom_ethqos {
 	struct platform_device *pdev;
 	void __iomem *rgmii_base;
@@ -171,6 +176,11 @@ static const struct ethqos_emac_por emac
 	{ .offset = RGMII_IO_MACRO_CONFIG2,	.value = 0x00002060 },
 };
 
+static const struct ethqos_emac_driver_data emac_v2_3_0_data = {
+	.por = emac_v2_3_0_por,
+	.num_por = ARRAY_SIZE(emac_v2_3_0_por),
+};
+
 static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 {
 	unsigned int val;
@@ -442,6 +452,7 @@ static int qcom_ethqos_probe(struct plat
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
+	const struct ethqos_emac_driver_data *data;
 	struct qcom_ethqos *ethqos;
 	struct resource *res;
 	int ret;
@@ -471,7 +482,9 @@ static int qcom_ethqos_probe(struct plat
 		goto err_mem;
 	}
 
-	ethqos->por = of_device_get_match_data(&pdev->dev);
+	data = of_device_get_match_data(&pdev->dev);
+	ethqos->por = data->por;
+	ethqos->num_por = data->num_por;
 
 	ethqos->rgmii_clk = devm_clk_get(&pdev->dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
@@ -526,7 +539,7 @@ static int qcom_ethqos_remove(struct pla
 }
 
 static const struct of_device_id qcom_ethqos_match[] = {
-	{ .compatible = "qcom,qcs404-ethqos", .data = &emac_v2_3_0_por},
+	{ .compatible = "qcom,qcs404-ethqos", .data = &emac_v2_3_0_data},
 	{ }
 };
 MODULE_DEVICE_TABLE(of, qcom_ethqos_match);


