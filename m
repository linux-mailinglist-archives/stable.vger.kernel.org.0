Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1668A6FD2
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbfICQfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbfICQ1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D09B23789;
        Tue,  3 Sep 2019 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528068;
        bh=j6ahewoxJK4BYyuBALFxGPGvZ7IjzlhY2rPpaa/CAvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ijo06llXVgpPjhyFtepr0bFmv5Ueu9zbKL/7BJkSwe2OHpOnP0jYVu7Y8dtRWSN9u
         XG57Lytv6OsaVlgrcn9OrJzjgpw8zSpdiTZokyNMkZb4WwLi7tvedIFzmbG9RiwDDy
         xpy5iVA4e+u/4aI0KF9u07s8Qx0zB/TXLLUCH4tY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 082/167] PCI: qcom: Don't deassert reset GPIO during probe
Date:   Tue,  3 Sep 2019 12:23:54 -0400
Message-Id: <20190903162519.7136-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 02b485e31d98265189b91f3e69c43df2ed50610c ]

Acquiring the reset GPIO low means that reset is being deasserted, this
is followed almost immediately with qcom_pcie_host_init() asserting it,
initializing it and then finally deasserting it again, for the link to
come up.

Some PCIe devices requires a minimum time between the initial deassert
and subsequent reset cycles. In a platform that boots with the reset
GPIO asserted this requirement is being violated by this deassert/assert
pulse.

Acquire the reset GPIO high to prevent this situation by matching the
state to the subsequent asserted state.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[lorenzo.pieralisi@arm.com: updated commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 79f06c76ae071..e292801fff7fd 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1230,7 +1230,7 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 
 	pcie->ops = of_device_get_match_data(dev);
 
-	pcie->reset = devm_gpiod_get_optional(dev, "perst", GPIOD_OUT_LOW);
+	pcie->reset = devm_gpiod_get_optional(dev, "perst", GPIOD_OUT_HIGH);
 	if (IS_ERR(pcie->reset)) {
 		ret = PTR_ERR(pcie->reset);
 		goto err_pm_runtime_put;
-- 
2.20.1

