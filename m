Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8B4B1F1E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389785AbfIMNQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389198AbfIMNQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:01 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10746208C0;
        Fri, 13 Sep 2019 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380560;
        bh=xfLMvEAb89BJvZFgrnyHbHexMVIDN8oo/7auQHJhcME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICpxHzXJyvaCuE4tVNMD5vP5t0OOsK+zsA0VGcINDgp5CX/S1B4PA8o2tioCWxd8f
         RVgeTc0aHuM2jWjQQ3eZVNdftvZQqbpYKin/wLYQAcZL63mC+iZlUDO/lXRjqj0PjX
         h3G1tbnSOUseDil1crN/qGV3vbZgn3BOKNXNCYFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/190] PCI: qcom: Dont deassert reset GPIO during probe
Date:   Fri, 13 Sep 2019 14:05:59 +0100
Message-Id: <20190913130607.956163583@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



