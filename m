Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F38349A306
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2364813AbiAXXtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:49:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44990 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454296AbiAXVcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4CBDB81243;
        Mon, 24 Jan 2022 21:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B0EC340E5;
        Mon, 24 Jan 2022 21:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059929;
        bh=fXl+KhFkFNVvhrHdnsaC4Mi8oIwGhOlNMCYqYf9MWAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W39tyQoXMDCNKjzUemHzN0lfVs5toboe4putFKZIOkm7drpJiN26tcEH/KF8umoJL
         UyMCPElxLtjOUSSRSzF1R3jZZW1OE+U0HUJFPLtkjYyezVGKcd7Zax0lRYOZBs1r7e
         fjU7+SuNjLLD5lSNiqkS+ARhnyFPdXu1J4hgRwH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qizhong Cheng <qizhong.cheng@mediatek.com>,
        Jianjun Wang <jianjun.wang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0782/1039] PCI: mediatek-gen3: Disable DVFSRC voltage request
Date:   Mon, 24 Jan 2022 19:42:51 +0100
Message-Id: <20220124184151.571970380@linuxfoundation.org>
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

From: Jianjun Wang <jianjun.wang@mediatek.com>

[ Upstream commit ab344fd43f2958726d17d651c0cb692c67dca382 ]

When the DVFSRC (dynamic voltage and frequency scaling resource collector)
feature is not implemented, the PCIe hardware will assert a voltage request
signal when exit from the L1 PM Substates to request a specific Vcore
voltage, but cannot receive the voltage ready signal, which will cause
the link to fail to exit the L1 PM Substates.

Disable DVFSRC voltage request by default, we need to find a common way to
enable it in the future.

Link: https://lore.kernel.org/r/20211015063602.29058-1-jianjun.wang@mediatek.com
Fixes: d3bf75b579b9 ("PCI: mediatek-gen3: Add MediaTek Gen3 driver for MT8192")
Tested-by: Qizhong Cheng <qizhong.cheng@mediatek.com>
Signed-off-by: Jianjun Wang <jianjun.wang@mediatek.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@google.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 17c59b0d6978b..21207df680ccf 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -79,6 +79,9 @@
 #define PCIE_ICMD_PM_REG		0x198
 #define PCIE_TURN_OFF_LINK		BIT(4)
 
+#define PCIE_MISC_CTRL_REG		0x348
+#define PCIE_DISABLE_DVFSRC_VLT_REQ	BIT(1)
+
 #define PCIE_TRANS_TABLE_BASE_REG	0x800
 #define PCIE_ATR_SRC_ADDR_MSB_OFFSET	0x4
 #define PCIE_ATR_TRSL_ADDR_LSB_OFFSET	0x8
@@ -297,6 +300,11 @@ static int mtk_pcie_startup_port(struct mtk_pcie_port *port)
 	val &= ~PCIE_INTX_ENABLE;
 	writel_relaxed(val, port->base + PCIE_INT_ENABLE_REG);
 
+	/* Disable DVFSRC voltage request */
+	val = readl_relaxed(port->base + PCIE_MISC_CTRL_REG);
+	val |= PCIE_DISABLE_DVFSRC_VLT_REQ;
+	writel_relaxed(val, port->base + PCIE_MISC_CTRL_REG);
+
 	/* Assert all reset signals */
 	val = readl_relaxed(port->base + PCIE_RST_CTRL_REG);
 	val |= PCIE_MAC_RSTB | PCIE_PHY_RSTB | PCIE_BRG_RSTB | PCIE_PE_RSTB;
-- 
2.34.1



