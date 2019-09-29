Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D55C1863
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfI2Rmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfI2Rbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC222086A;
        Sun, 29 Sep 2019 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778310;
        bh=qGQ9HN8LkKwm6Kshzu4NmFigna+xkzLDeB9AZNaGBU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJ150gPQb6Qd+F7WyjjhhPOLPN9OAg9A32y4vC0hoPpyBDkFsUf/5JGPvYcHVV+gY
         9Dzx3vyfzg43v8Q0MMpMihS74ny0WMqcOUKnDMZWx3qYo6LzwdkvvUu5JYzQGjOcUH
         aUwiNLK1KiP5eBj77d79P9qruy4rUEwv4INEqHY4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 28/49] PCI: histb: Propagate errors for optional regulators
Date:   Sun, 29 Sep 2019 13:30:28 -0400
Message-Id: <20190929173053.8400-28-sashal@kernel.org>
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

[ Upstream commit 8f9e1641ba445437095411d9fda2324121110d5d ]

regulator_get_optional() can fail for a number of reasons besides probe
deferral. It can for example return -ENOMEM if it runs out of memory as
it tries to allocate data structures. Propagating only -EPROBE_DEFER is
problematic because it results in these legitimately fatal errors being
treated as "regulator not specified in DT".

What we really want is to ignore the optional regulators only if they
have not been specified in DT. regulator_get_optional() returns -ENODEV
in this case, so that's the special case that we need to handle. So we
propagate all errors, except -ENODEV, so that real failures will still
cause the driver to fail probe.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-histb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-histb.c b/drivers/pci/controller/dwc/pcie-histb.c
index 954bc2b74bbcd..811b5c6d62eae 100644
--- a/drivers/pci/controller/dwc/pcie-histb.c
+++ b/drivers/pci/controller/dwc/pcie-histb.c
@@ -340,8 +340,8 @@ static int histb_pcie_probe(struct platform_device *pdev)
 
 	hipcie->vpcie = devm_regulator_get_optional(dev, "vpcie");
 	if (IS_ERR(hipcie->vpcie)) {
-		if (PTR_ERR(hipcie->vpcie) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+		if (PTR_ERR(hipcie->vpcie) != -ENODEV)
+			return PTR_ERR(hipcie->vpcie);
 		hipcie->vpcie = NULL;
 	}
 
-- 
2.20.1

