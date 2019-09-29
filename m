Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE72DC1839
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfI2Rby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729518AbfI2Rby (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0A3421925;
        Sun, 29 Sep 2019 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778313;
        bh=fmz5hC3yBNgy6dgTbMASSrGRRvVOVbS1qhdGVdbjLH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/gIGKn+Udn7cPkhPrlW6jyYfE5dVcHg4/DRmcG2h8ShQ5JmsD5UTGPg3pGuEL3u+
         Qmy5PSSWKY3Jfi/jUEeNdUrDh9iVgMftL8PQvh2Fx3L5m43qld4wduZpf0ARx6Wz1/
         Qg3GV5d6QJNa6CX+737VLQRtOYv/hkuT12VymCi4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 30/49] PCI: exynos: Propagate errors for optional PHYs
Date:   Sun, 29 Sep 2019 13:30:30 -0400
Message-Id: <20190929173053.8400-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit ddd6960087d4b45759434146d681a94bbb1c54ad ]

devm_of_phy_get() can fail for a number of reasons besides probe
deferral. It can for example return -ENOMEM if it runs out of memory as
it tries to allocate devres structures. Propagating only -EPROBE_DEFER
is problematic because it results in these legitimately fatal errors
being treated as "PHY not specified in DT".

What we really want is to ignore the optional PHYs only if they have not
been specified in DT. devm_of_phy_get() returns -ENODEV in this case, so
that's the special case that we need to handle. So we propagate all
errors, except -ENODEV, so that real failures will still cause the
driver to fail probe.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Cc: Jingoo Han <jingoohan1@gmail.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-exynos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-exynos.c b/drivers/pci/controller/dwc/pci-exynos.c
index cee5f2f590e2d..14a6ba4067fbe 100644
--- a/drivers/pci/controller/dwc/pci-exynos.c
+++ b/drivers/pci/controller/dwc/pci-exynos.c
@@ -465,7 +465,7 @@ static int __init exynos_pcie_probe(struct platform_device *pdev)
 
 	ep->phy = devm_of_phy_get(dev, np, NULL);
 	if (IS_ERR(ep->phy)) {
-		if (PTR_ERR(ep->phy) == -EPROBE_DEFER)
+		if (PTR_ERR(ep->phy) != -ENODEV)
 			return PTR_ERR(ep->phy);
 
 		ep->phy = NULL;
-- 
2.20.1

