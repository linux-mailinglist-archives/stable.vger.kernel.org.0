Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380ED79567
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388908AbfG2TmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388448AbfG2TmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:42:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8AFE2054F;
        Mon, 29 Jul 2019 19:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429333;
        bh=vAAYYYO4yztIIOn+PQ+PjDFS5Xe9i+FQ/NqxpfmeSts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgL0JSZ545e3PfXzahaPesP0vqbjUI2bi6dn7nRYmYz7LYpvijkSJrmmO05rvajTp
         gz7t8/Y1PAgN20byiWmhz46LFVvfbJN/e99wwy5UyRCy3NglRNgBHd+pD5u2O2aEyZ
         ePKRcE5r/57MT40b3fH3j7ly3ew9rWAe6/OEqm5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/113] PCI: mobiveil: Fix the Class Code field
Date:   Mon, 29 Jul 2019 21:22:30 +0200
Message-Id: <20190729190710.522812464@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0122af0a08243f344a438f924e5c2486486555b3 ]

Fix up the Class Code field in PCI configuration space and set it to
PCI_CLASS_BRIDGE_PCI.

Move the Class Code fixup to function mobiveil_host_init() where
it belongs.

Fixes: 9af6bcb11e12 ("PCI: mobiveil: Add Mobiveil PCIe Host Bridge IP driver")
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Reviewed-by: Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index d9f2d0f2d602..3e81e68b5ce0 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -565,6 +565,12 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 		}
 	}
 
+	/* fixup for PCIe class register */
+	value = csr_readl(pcie, PAB_INTP_AXI_PIO_CLASS);
+	value &= 0xff;
+	value |= (PCI_CLASS_BRIDGE_PCI << 16);
+	csr_writel(pcie, value, PAB_INTP_AXI_PIO_CLASS);
+
 	/* setup MSI hardware registers */
 	mobiveil_pcie_enable_msi(pcie);
 
@@ -805,9 +811,6 @@ static int mobiveil_pcie_probe(struct platform_device *pdev)
 		goto error;
 	}
 
-	/* fixup for PCIe class register */
-	csr_writel(pcie, 0x060402ab, PAB_INTP_AXI_PIO_CLASS);
-
 	/* initialize the IRQ domains */
 	ret = mobiveil_pcie_init_irq_domain(pcie);
 	if (ret) {
-- 
2.20.1



