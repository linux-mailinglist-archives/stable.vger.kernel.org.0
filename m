Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8914D59C
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfFTR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbfFTR7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 13:59:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A2E2083B;
        Thu, 20 Jun 2019 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053560;
        bh=B4ziijeeYPHWG8gk+zu0SbSDVRVGhUhn/n3OnKn/15E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiKboVoboXS2gp/mGt0zyrWqsq61wJcaWIRtRaPRwkxBuD7845XupzWSD5WAk34Ct
         1TiD+BG5b+/ZU4tP8tgoBjvh3E5a+9Vu27z0ut5X6GmpdhEWG1DT7JsKp0Nu3QcRCn
         PuQ2KSdi78lRExEBqBliTMO9QJ4BkbqUPALQrXKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Steven Price <steven.price@arm.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 31/84] PCI: xilinx: Check for __get_free_pages() failure
Date:   Thu, 20 Jun 2019 19:56:28 +0200
Message-Id: <20190620174342.507765310@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 699ca30162686bf305cdf94861be02eb0cf9bda2 ]

If __get_free_pages() fails, return -ENOMEM to avoid a NULL pointer
dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pcie-xilinx.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c
index 4cfa46360d12..6a2499f4d610 100644
--- a/drivers/pci/host/pcie-xilinx.c
+++ b/drivers/pci/host/pcie-xilinx.c
@@ -349,14 +349,19 @@ static const struct irq_domain_ops msi_domain_ops = {
  * xilinx_pcie_enable_msi - Enable MSI support
  * @port: PCIe port information
  */
-static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
+static int xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
 {
 	phys_addr_t msg_addr;
 
 	port->msi_pages = __get_free_pages(GFP_KERNEL, 0);
+	if (!port->msi_pages)
+		return -ENOMEM;
+
 	msg_addr = virt_to_phys((void *)port->msi_pages);
 	pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);
 	pcie_write(port, msg_addr, XILINX_PCIE_REG_MSIBASE2);
+
+	return 0;
 }
 
 /* INTx Functions */
@@ -555,6 +560,7 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)
 	struct device *dev = port->dev;
 	struct device_node *node = dev->of_node;
 	struct device_node *pcie_intc_node;
+	int ret;
 
 	/* Setup INTx */
 	pcie_intc_node = of_get_next_child(node, NULL);
@@ -582,7 +588,9 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)
 			return PTR_ERR(port->irq_domain);
 		}
 
-		xilinx_pcie_enable_msi(port);
+		ret = xilinx_pcie_enable_msi(port);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.20.1



