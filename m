Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AB444281
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391905AbfFMQXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731027AbfFMIhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:37:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 881B82064A;
        Thu, 13 Jun 2019 08:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415065;
        bh=oYqC04aPf7VZNvrzfJCBtCgxiTAbso4bcLVHXA6xQRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCgDxRBUJ9eQy1/pzWM6tfGP8v7heiquWbgwsivFo8ZOk4eSuvguSMJe3j4Mgwu+y
         QlvoOnkwF7GZ1+kan0ps3oPa6PyUcNVb9KlSWgeRx+QE8t00zzfCshH88tmLqEraHp
         R2IG3+CE4BvDxRVDBDsYda4Xh3fOcBgWxoy68/J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-renesas-soc@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 65/81] PCI: rcar: Fix 64bit MSI message address handling
Date:   Thu, 13 Jun 2019 10:33:48 +0200
Message-Id: <20190613075653.797782757@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 954b4b752a4c4e963b017ed8cef4c453c5ed308d ]

The MSI message address in the RC address space can be 64 bit. The
R-Car PCIe RC supports such a 64bit MSI message address as well.
The code currently uses virt_to_phys(__get_free_pages()) to obtain
a reserved page for the MSI message address, and the return value
of which can be a 64 bit physical address on 64 bit system.

However, the driver only programs PCIEMSIALR register with the bottom
32 bits of the virt_to_phys(__get_free_pages()) return value and does
not program the top 32 bits into PCIEMSIAUR, but rather programs the
PCIEMSIAUR register with 0x0. This worked fine on older 32 bit R-Car
SoCs, however may fail on new 64 bit R-Car SoCs.

Since from a PCIe controller perspective, an inbound MSI is a memory
write to a special address (in case of this controller, defined by
the value in PCIEMSIAUR:PCIEMSIALR), which triggers an interrupt, but
never hits the DRAM _and_ because allocation of an MSI by a PCIe card
driver obtains the MSI message address by reading PCIEMSIAUR:PCIEMSIALR
in rcar_msi_setup_irqs(), incorrectly programmed PCIEMSIAUR cannot
cause memory corruption or other issues.

There is however the possibility that if virt_to_phys(__get_free_pages())
returned address above the 32bit boundary _and_ PCIEMSIAUR was programmed
to 0x0 _and_ if the system had physical RAM at the address matching the
value of PCIEMSIALR, a PCIe card driver could allocate a buffer with a
physical address matching the value of PCIEMSIALR and a remote write to
such a buffer by a PCIe card would trigger a spurious MSI.

Fixes: e015f88c368d ("PCI: rcar: Add support for R-Car H3 to pcie-rcar")
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Simon Horman <horms+renesas@verge.net.au>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-renesas-soc@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pcie-rcar.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/host/pcie-rcar.c b/drivers/pci/host/pcie-rcar.c
index fad57d068db3..2b0a1f3b8265 100644
--- a/drivers/pci/host/pcie-rcar.c
+++ b/drivers/pci/host/pcie-rcar.c
@@ -849,7 +849,7 @@ static int rcar_pcie_enable_msi(struct rcar_pcie *pcie)
 {
 	struct device *dev = pcie->dev;
 	struct rcar_msi *msi = &pcie->msi;
-	unsigned long base;
+	phys_addr_t base;
 	int err, i;
 
 	mutex_init(&msi->lock);
@@ -894,8 +894,8 @@ static int rcar_pcie_enable_msi(struct rcar_pcie *pcie)
 	}
 	base = virt_to_phys((void *)msi->pages);
 
-	rcar_pci_write_reg(pcie, base | MSIFE, PCIEMSIALR);
-	rcar_pci_write_reg(pcie, 0, PCIEMSIAUR);
+	rcar_pci_write_reg(pcie, lower_32_bits(base) | MSIFE, PCIEMSIALR);
+	rcar_pci_write_reg(pcie, upper_32_bits(base), PCIEMSIAUR);
 
 	/* enable all MSI interrupts */
 	rcar_pci_write_reg(pcie, 0xffffffff, PCIEMSIIER);
-- 
2.20.1



