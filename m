Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5E43F5E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387845AbfFMP4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731520AbfFMIvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D2220851;
        Thu, 13 Jun 2019 08:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415863;
        bh=NIHUt78GqB9CwMdiYBFF7fCkC0zbkLSvOS8PMpFSDDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSonEmzvfxsfaHLCPqAmfATKe0gpZjth7yVmSf5jeg04261bBnwEDSecV/6Ync5X0
         kUXaI9Lu9omZDAe68J/f2AdtPXJuWqngaLAnALAgcp5oMc1Oh+5ACldI9gqEJX6E9M
         uFrm/AiWOR0I/+mds3BjS4rwCRLpyL40JbTszKnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 124/155] PCI: dwc: Remove default MSI initialization for platform specific MSI chips
Date:   Thu, 13 Jun 2019 10:33:56 +0200
Message-Id: <20190613075659.784066759@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fd8a44bd5b76dc77133f814dd63d414d49dc74c0 ]

Platforms which populate msi_host_init() have their own MSI controller
logic. Writing to MSI control registers on platforms which do not use
Designware's MSI controller logic might have side effects.

To be safe, do not write to MSI control registers if the platform uses
its own MSI controller logic instead of Designware's MSI one.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
[lorenzo.pieralisi@arm.com: updated commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-host.c | 24 ++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 9d22b19b76f2..214e883aa0a1 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -653,17 +653,19 @@ void dw_pcie_setup_rc(struct pcie_port *pp)
 
 	dw_pcie_setup(pci);
 
-	num_ctrls = pp->num_vectors / MAX_MSI_IRQS_PER_CTRL;
-
-	/* Initialize IRQ Status array */
-	for (ctrl = 0; ctrl < num_ctrls; ctrl++) {
-		pp->irq_mask[ctrl] = ~0;
-		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_MASK +
-					(ctrl * MSI_REG_CTRL_BLOCK_SIZE),
-				    4, pp->irq_mask[ctrl]);
-		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE +
-					(ctrl * MSI_REG_CTRL_BLOCK_SIZE),
-				    4, ~0);
+	if (!pp->ops->msi_host_init) {
+		num_ctrls = pp->num_vectors / MAX_MSI_IRQS_PER_CTRL;
+
+		/* Initialize IRQ Status array */
+		for (ctrl = 0; ctrl < num_ctrls; ctrl++) {
+			pp->irq_mask[ctrl] = ~0;
+			dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_MASK +
+					    (ctrl * MSI_REG_CTRL_BLOCK_SIZE),
+					    4, pp->irq_mask[ctrl]);
+			dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE +
+					    (ctrl * MSI_REG_CTRL_BLOCK_SIZE),
+					    4, ~0);
+		}
 	}
 
 	/* Setup RC BARs */
-- 
2.20.1



