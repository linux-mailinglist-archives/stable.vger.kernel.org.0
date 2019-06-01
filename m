Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504B831D44
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbfFAN2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729950AbfFAN12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E35C524937;
        Sat,  1 Jun 2019 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395647;
        bh=bBqzhpjlF9a5ewQjycgLTP6BzvF8Q9GBGeuSnfvvjww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehOpGPq7ip0HskbGxzeJvzPlvTTwgsUQVERM5GkdRpI/mjX55o1nbplPTV3mO4Cm8
         QAsUjp7wt5X2BFTzdqdKx+4xcR6pooz7cjuZVAipYZpEspB4QlAFth0ZZA5O2celdN
         I6HR52MUGl3aMqbBtSF6zRcdwdKnJWXNHscpbYHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Steven Price <steven.price@arm.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 49/56] PCI: xilinx: Check for __get_free_pages() failure
Date:   Sat,  1 Jun 2019 09:25:53 -0400
Message-Id: <20190601132600.27427-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

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
index 4cfa46360d122..6a2499f4d6109 100644
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

