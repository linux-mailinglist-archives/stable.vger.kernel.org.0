Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3515C17B4
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbfI2RfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730485AbfI2Re7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB99021A4C;
        Sun, 29 Sep 2019 17:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778499;
        bh=JXsJn0E61UtLuEWduYdvBlin/nEHZ4PJC+mbabp26Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2XMsOMJlYdc0NeRmUvu6NrZxKDTzc4um84kEx0Dv9GegCRLYoS2eSA+IL4i0BWuh
         TyA837ORbJ1SdRvcTv7z80aIscgQs1+n41lcmVp51NfFIRQ3IvbrgohRnf9xzWLJ4l
         nHkDyPyxYACgv1TKEn94ZzrhAHud21nE18dEyPOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Richard Zhu <hongxing.zhu@nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, kernel@pengutronix.de,
        linux-imx@nxp.com, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/33] PCI: imx6: Propagate errors for optional regulators
Date:   Sun, 29 Sep 2019 13:34:07 -0400
Message-Id: <20190929173424.9361-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173424.9361-1-sashal@kernel.org>
References: <20190929173424.9361-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 2170a09fb4b0f66e06e5bcdcbc98c9ccbf353650 ]

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
Cc: Richard Zhu <hongxing.zhu@nxp.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de
Cc: linux-imx@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 3826b444298c1..3b2ceb5667289 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -807,8 +807,8 @@ static int imx6_pcie_probe(struct platform_device *pdev)
 
 	imx6_pcie->vpcie = devm_regulator_get_optional(&pdev->dev, "vpcie");
 	if (IS_ERR(imx6_pcie->vpcie)) {
-		if (PTR_ERR(imx6_pcie->vpcie) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+		if (PTR_ERR(imx6_pcie->vpcie) != -ENODEV)
+			return PTR_ERR(imx6_pcie->vpcie);
 		imx6_pcie->vpcie = NULL;
 	}
 
-- 
2.20.1

