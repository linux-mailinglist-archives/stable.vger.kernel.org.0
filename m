Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76D6328AF0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbhCASZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232800AbhCASSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:18:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD1F06506C;
        Mon,  1 Mar 2021 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619430;
        bh=jf4Ra3bK+Jrx7VR5X/cspBEB9XBNdMpA9TNa5h8NlsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kTU0XTpHe+Kc1x3dlO1MtqsKm2cJhGVzk5Z3Ps/ZvwbCXMCEPeQMDfDXJGnYM341
         FrF14vu/YngGAhhWFGTPD76p42zp5FGoCJoMEOa9vI/xoDBpoB/E1ddHvWmmahDJIS
         FtuQENdUVOsGh+CXtpUwma1pgypIwluJCOHiCZvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 451/663] PCI: rockchip: Make ep-gpios DT property optional
Date:   Mon,  1 Mar 2021 17:11:39 +0100
Message-Id: <20210301161204.203592734@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 58adbfb3ebec460e8b58875c682bafd866808e80 ]

The Rockchip PCIe controller DT binding clearly states that 'ep-gpios' is
an optional property. And indeed there are boards that don't require it.

Make the driver follow the binding by using devm_gpiod_get_optional()
instead of devm_gpiod_get().

[bhelgaas: tidy whitespace]
Link: https://lore.kernel.org/r/20210121162321.4538-2-wens@kernel.org
Fixes: e77f847df54c ("PCI: rockchip: Add Rockchip PCIe controller support")
Fixes: 956cd99b35a8 ("PCI: rockchip: Separate common code from RC driver")
Fixes: 964bac9455be ("PCI: rockchip: Split out rockchip_pcie_parse_dt() to parse DT")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
index 904dec0d3a88f..990a00e08bc5b 100644
--- a/drivers/pci/controller/pcie-rockchip.c
+++ b/drivers/pci/controller/pcie-rockchip.c
@@ -82,7 +82,7 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 	}
 
 	rockchip->mgmt_sticky_rst = devm_reset_control_get_exclusive(dev,
-								     "mgmt-sticky");
+								"mgmt-sticky");
 	if (IS_ERR(rockchip->mgmt_sticky_rst)) {
 		if (PTR_ERR(rockchip->mgmt_sticky_rst) != -EPROBE_DEFER)
 			dev_err(dev, "missing mgmt-sticky reset property in node\n");
@@ -118,11 +118,11 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 	}
 
 	if (rockchip->is_rc) {
-		rockchip->ep_gpio = devm_gpiod_get(dev, "ep", GPIOD_OUT_HIGH);
-		if (IS_ERR(rockchip->ep_gpio)) {
-			dev_err(dev, "missing ep-gpios property in node\n");
-			return PTR_ERR(rockchip->ep_gpio);
-		}
+		rockchip->ep_gpio = devm_gpiod_get_optional(dev, "ep",
+							    GPIOD_OUT_HIGH);
+		if (IS_ERR(rockchip->ep_gpio))
+			return dev_err_probe(dev, PTR_ERR(rockchip->ep_gpio),
+					     "failed to get ep GPIO\n");
 	}
 
 	rockchip->aclk_pcie = devm_clk_get(dev, "aclk");
-- 
2.27.0



