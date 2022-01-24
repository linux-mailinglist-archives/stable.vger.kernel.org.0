Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0CC499A66
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353364AbiAXVnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51444 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454311AbiAXVcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C70B614F3;
        Mon, 24 Jan 2022 21:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4479C340E4;
        Mon, 24 Jan 2022 21:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059932;
        bh=2hF7BRGsfHYFsaSCRg8aq1TO5nuw7n7HAXgR4OfbIJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Jq46nqN8oFpfSpVXfRX+s7uUVyEd9MnQ5aq7rsyezgei3CeP19hQ7vQSg5k6qblc
         +R9miQW+4yLNyOmMIdOYzUp6uLuzoyvmB2S1+4OkJXU3uIfwLguk61KB85fsHUbVN+
         RaX+85UgSTdICtPQkhVCPiij3Da2/AS7CXtA00y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0783/1039] PCI: qcom: Fix an error handling path in qcom_pcie_probe()
Date:   Mon, 24 Jan 2022 19:42:52 +0100
Message-Id: <20220124184151.607878649@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4e0e90539bb0e6c0ca3768c642df9eed2118a8bb ]

If 'of_device_get_match_data()' fails, previous 'pm_runtime_get_sync()/
pm_runtime_enable()' should be undone.

To fix it, the easiest is to move this block of code before the memory
allocations and the pm_runtime_xxx calls.

Link: https://lore.kernel.org/r/4d03c636193f64907c8dacb17fa71ed05fd5f60c.1636220582.git.christophe.jaillet@wanadoo.fr
Fixes: b89ff410253d ("PCI: qcom: Replace ops with struct pcie_cfg in pcie match data")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 1c3d1116bb60c..baae67f71ba82 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1534,6 +1534,12 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	const struct qcom_pcie_cfg *pcie_cfg;
 	int ret;
 
+	pcie_cfg = of_device_get_match_data(dev);
+	if (!pcie_cfg || !pcie_cfg->ops) {
+		dev_err(dev, "Invalid platform data\n");
+		return -EINVAL;
+	}
+
 	pcie = devm_kzalloc(dev, sizeof(*pcie), GFP_KERNEL);
 	if (!pcie)
 		return -ENOMEM;
@@ -1553,12 +1559,6 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 
 	pcie->pci = pci;
 
-	pcie_cfg = of_device_get_match_data(dev);
-	if (!pcie_cfg || !pcie_cfg->ops) {
-		dev_err(dev, "Invalid platform data\n");
-		return -EINVAL;
-	}
-
 	pcie->ops = pcie_cfg->ops;
 	pcie->pipe_clk_need_muxing = pcie_cfg->pipe_clk_need_muxing;
 
-- 
2.34.1



