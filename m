Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FDE206414
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392223AbgFWVPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390857AbgFWU2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:28:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13C4220702;
        Tue, 23 Jun 2020 20:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944097;
        bh=4Xyvuee6hmLEbgdfaRccXExj/AfzcY7UERLYDnt/UC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWwdinvGv3dfmYOqNzpq9CutkKelGMsk1EY6TH/buDBZAxqqz9XYGxybCzRA2caOo
         0pqeY7ncI8pbwZgX3f3reoy+2F/pKTv9YsI8RvHPC1SaFWPoHaXOx8qUcXFoixWzSS
         kmDun9GJ0g1PgusaSv5CMRAJ3HjLQmpic1WuEfwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/314] PCI: amlogic: meson: Dont use FAST_LINK_MODE to set up link
Date:   Tue, 23 Jun 2020 21:56:07 +0200
Message-Id: <20200623195347.087750573@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b927a92e3463e..8c9f887048746 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -301,11 +301,11 @@ static void meson_pcie_init_dw(struct meson_pcie *mp)
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



