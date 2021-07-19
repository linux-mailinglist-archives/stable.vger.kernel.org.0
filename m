Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5453CE1B2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347364AbhGSP1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347583AbhGSPTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DC96613EB;
        Mon, 19 Jul 2021 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710321;
        bh=rcGreCIoz1dl8poNvVGGA1M3PbJmnLSrc+aGpbVweUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeMI6rMxCymI22Teg/1CyW++teKsE3ADYH4GimAjs5hkpMpZSnnxEtqBk7xQ3LWnN
         E+k6B/uHvut/T4Bhn8/+78bJZhqI50JWEWUFUaPOP2010/XdKo6wE1arRr7R6hSRIo
         Spi9jhOf01TqVccXtOT4jrcXjpBhGfveDyh9h0AE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Sandor Bodo-Merle <sbodomerle@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ray Jui <ray.jui@broadcom.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/243] PCI: iproc: Support multi-MSI only on uniprocessor kernel
Date:   Mon, 19 Jul 2021 16:53:16 +0200
Message-Id: <20210719144946.289929417@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandor Bodo-Merle <sbodomerle@gmail.com>

[ Upstream commit 2dc0a201d0f59e6818ef443609f0850a32910844 ]

The interrupt affinity scheme used by this driver is incompatible with
multi-MSI as it implies moving the doorbell address to that of another MSI
group.  This isn't possible for multi-MSI, as all the MSIs must have the
same doorbell address. As such it is restricted to systems with a single
CPU.

Link: https://lore.kernel.org/r/20210622152630.40842-2-sbodomerle@gmail.com
Fixes: fc54bae28818 ("PCI: iproc: Allow allocation of multiple MSIs")
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sandor Bodo-Merle <sbodomerle@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Pali Rohár <pali@kernel.org>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc-msi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-iproc-msi.c b/drivers/pci/controller/pcie-iproc-msi.c
index 557d93dcb3bc..81b4effeb130 100644
--- a/drivers/pci/controller/pcie-iproc-msi.c
+++ b/drivers/pci/controller/pcie-iproc-msi.c
@@ -171,7 +171,7 @@ static struct irq_chip iproc_msi_irq_chip = {
 
 static struct msi_domain_info iproc_msi_domain_info = {
 	.flags = MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX,
+		MSI_FLAG_PCI_MSIX,
 	.chip = &iproc_msi_irq_chip,
 };
 
@@ -250,6 +250,9 @@ static int iproc_msi_irq_domain_alloc(struct irq_domain *domain,
 	struct iproc_msi *msi = domain->host_data;
 	int hwirq, i;
 
+	if (msi->nr_cpus > 1 && nr_irqs > 1)
+		return -EINVAL;
+
 	mutex_lock(&msi->bitmap_lock);
 
 	/*
@@ -540,6 +543,9 @@ int iproc_msi_init(struct iproc_pcie *pcie, struct device_node *node)
 	mutex_init(&msi->bitmap_lock);
 	msi->nr_cpus = num_possible_cpus();
 
+	if (msi->nr_cpus == 1)
+		iproc_msi_domain_info.flags |=  MSI_FLAG_MULTI_PCI_MSI;
+
 	msi->nr_irqs = of_irq_count(node);
 	if (!msi->nr_irqs) {
 		dev_err(pcie->dev, "found no MSI GIC interrupt\n");
-- 
2.30.2



