Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09E620618B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403981AbgFWUoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403978AbgFWUoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:44:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B22F321BE5;
        Tue, 23 Jun 2020 20:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945052;
        bh=nfBpttPTgdjEcAGwZzBdAE0VsG6wpa3cWqoOnuqOev0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yk94XXjJB7cXcPV0Qruw3PHzj4R6y3u5yrAqPtt74QxPopGbB9adgQ0StaXedCZe3
         nxwjCn74HGy1apvEWL6niLHEdStnYmbO9D065LUEcX5I6p66CVWlqBtWdHzdPzxExe
         LwUcoHoREoGJhGX06J9053OxvKioLVHt7JN0WNXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 020/136] PCI: aardvark: Dont blindly enable ASPM L0s and dont write to read-only register
Date:   Tue, 23 Jun 2020 21:57:56 +0200
Message-Id: <20200623195304.629278646@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 90c6cb4a355e7befcb557d217d1d8b8bd5875a05 ]

Trying to change Link Status register does not have any effect as this
is a read-only register. Trying to overwrite bits for Negotiated Link
Width does not make sense.

In future proper change of link width can be done via Lane Count Select
bits in PCIe Control 0 register.

Trying to unconditionally enable ASPM L0s via ASPM Control bits in Link
Control register is wrong. There should be at least some detection if
endpoint supports L0s as isn't mandatory.

Moreover ASPM Control bits in Link Control register are controlled by
pcie/aspm.c code which sets it according to system ASPM settings,
immediately after aardvark driver probes. So setting these bits by
aardvark driver has no long running effect.

Remove code which touches ASPM L0s bits from this driver and let
kernel's ASPM implementation to set ASPM state properly.

Some users are reporting issues that this code is problematic for some
Intel wifi cards and removing it fixes them, see e.g.:
https://bugzilla.kernel.org/show_bug.cgi?id=196339

If problems with Intel wifi cards occur even after this commit, then
pcie/aspm.c code could be modified / hooked to not enable ASPM L0s state
for affected problematic cards.

Link: https://lore.kernel.org/r/20200430080625.26070-3-pali@kernel.org
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 5f3048e75becb..c1db09fbbe041 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -365,10 +365,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 
 	advk_pcie_wait_for_link(pcie);
 
-	reg = PCIE_CORE_LINK_L0S_ENTRY |
-		(1 << PCIE_CORE_LINK_WIDTH_SHIFT);
-	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
-
 	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 	reg |= PCIE_CORE_CMD_MEM_ACCESS_EN |
 		PCIE_CORE_CMD_IO_ACCESS_EN |
-- 
2.25.1



