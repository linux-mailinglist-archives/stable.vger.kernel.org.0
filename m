Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73BA1FE6EA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgFRCh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgFRBNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA91221ED;
        Thu, 18 Jun 2020 01:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442822;
        bh=78btlO7Vr7itdFV3U5z5DJ2DrSrGncjQyVvThiu09Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFJp0m2PUHF02kQ/OeK4GYUuuIK1wTTRjBpqYBqEw0jC74TdcXXdpD7ZUftnhfMOr
         w9CnBvT+VMBTq0pWdx6jEdWBW0gTzi78Yla6Uy6uUkPFl+R/zFijLOTgadxGv7D/AR
         e4qqwY1c4P14OzR/Kn92Oz4/CbLyRwZPTUEWd/X4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 259/388] PCI: amlogic: meson: Don't use FAST_LINK_MODE to set up link
Date:   Wed, 17 Jun 2020 21:05:56 -0400
Message-Id: <20200618010805.600873-259-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 87dccf09323fc363bd0d072fcc12b96622ab8c69 ]

The vim3l board does not work with a standard PCIe switch (ASM1184e),
spitting all kind of errors - hinting at HW misconfiguration (no link,
port enumeration issues, etc).

According to the the Synopsys DWC PCIe Reference Manual, in the section
dedicated to the PLCR register, bit 7 is described (FAST_LINK_MODE) as:

"Sets all internal timers to fast mode for simulation purposes."

it is sound to set this bit from a simulation perspective, but on actual
silicon, which expects timers to have a nominal value, it is not.

Make sure the FAST_LINK_MODE bit is cleared when configuring the RC
to solve this problem.

Link: https://lore.kernel.org/r/20200429164230.309922-1-maz@kernel.org
Fixes: 9c0ef6d34fdb ("PCI: amlogic: Add the Amlogic Meson PCIe controller driver")
Signed-off-by: Marc Zyngier <maz@kernel.org>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-meson.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-meson.c b/drivers/pci/controller/dwc/pci-meson.c
index 3715dceca1bf..ca59ba9e0ecd 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -289,11 +289,11 @@ static void meson_pcie_init_dw(struct meson_pcie *mp)
 	meson_cfg_writel(mp, val, PCIE_CFG0);
 
 	val = meson_elb_readl(mp, PCIE_PORT_LINK_CTRL_OFF);
-	val &= ~LINK_CAPABLE_MASK;
+	val &= ~(LINK_CAPABLE_MASK | FAST_LINK_MODE);
 	meson_elb_writel(mp, val, PCIE_PORT_LINK_CTRL_OFF);
 
 	val = meson_elb_readl(mp, PCIE_PORT_LINK_CTRL_OFF);
-	val |= LINK_CAPABLE_X1 | FAST_LINK_MODE;
+	val |= LINK_CAPABLE_X1;
 	meson_elb_writel(mp, val, PCIE_PORT_LINK_CTRL_OFF);
 
 	val = meson_elb_readl(mp, PCIE_GEN2_CTRL_OFF);
-- 
2.25.1

