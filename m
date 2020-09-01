Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E25E2598DD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgIAPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbgIAPbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:31:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54AC72078B;
        Tue,  1 Sep 2020 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974270;
        bh=fSPWza8l+zESXd86vjXQT1c6kprk0xJPXAcbNaimApE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+IYwjENkjwOT06XQGYS5QKCP9J3SzYawsoLfCADOduyPHRLq9iTVUERrKcmWSyS5
         rOcbVsqn5gaNd3lGrGEj5pswYhwxRSanw96OV1gqwrXWesi7Zeo0VzTZU7hPjld90V
         rIuQKbkPezF85WD69WPB7yB3OGTH5fLAM9m+kpIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <absahu@codeaurora.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/214] PCI: qcom: Change duplicate PCI reset to phy reset
Date:   Tue,  1 Sep 2020 17:09:34 +0200
Message-Id: <20200901150957.496498826@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Sahu <absahu@codeaurora.org>

[ Upstream commit dd58318c019f10bc94db36df66af6c55d4c0cbba ]

The deinit issues reset_control_assert for PCI twice and does not contain
phy reset.

Link: https://lore.kernel.org/r/20200615210608.21469-4-ansuelsmth@gmail.com
Signed-off-by: Abhishek Sahu <absahu@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 380a77a914fa0..9cf7599a198c4 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -287,14 +287,14 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 {
 	struct qcom_pcie_resources_2_1_0 *res = &pcie->res.v2_1_0;
 
+	clk_disable_unprepare(res->phy_clk);
 	reset_control_assert(res->pci_reset);
 	reset_control_assert(res->axi_reset);
 	reset_control_assert(res->ahb_reset);
 	reset_control_assert(res->por_reset);
-	reset_control_assert(res->pci_reset);
+	reset_control_assert(res->phy_reset);
 	clk_disable_unprepare(res->iface_clk);
 	clk_disable_unprepare(res->core_clk);
-	clk_disable_unprepare(res->phy_clk);
 	clk_disable_unprepare(res->aux_clk);
 	clk_disable_unprepare(res->ref_clk);
 	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
@@ -333,12 +333,6 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		goto err_clk_core;
 	}
 
-	ret = clk_prepare_enable(res->phy_clk);
-	if (ret) {
-		dev_err(dev, "cannot prepare/enable phy clock\n");
-		goto err_clk_phy;
-	}
-
 	ret = clk_prepare_enable(res->aux_clk);
 	if (ret) {
 		dev_err(dev, "cannot prepare/enable aux clock\n");
@@ -411,6 +405,12 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		return ret;
 	}
 
+	ret = clk_prepare_enable(res->phy_clk);
+	if (ret) {
+		dev_err(dev, "cannot prepare/enable phy clock\n");
+		goto err_deassert_ahb;
+	}
+
 	/* wait for clock acquisition */
 	usleep_range(1000, 1500);
 
@@ -428,8 +428,6 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 err_clk_ref:
 	clk_disable_unprepare(res->aux_clk);
 err_clk_aux:
-	clk_disable_unprepare(res->phy_clk);
-err_clk_phy:
 	clk_disable_unprepare(res->core_clk);
 err_clk_core:
 	clk_disable_unprepare(res->iface_clk);
-- 
2.25.1



