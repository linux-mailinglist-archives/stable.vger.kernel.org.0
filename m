Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C723CDFA7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344897AbhGSPLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346075AbhGSPKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEFBD61165;
        Mon, 19 Jul 2021 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709808;
        bh=Qoam8zCVidTeODVHFEEWi0BDF+uaW2BkhK7ptwjxiHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6EnCp5pYj9ATwarYna0/Lq9gP01iMt7peNsv/n55H/Yk/04J5ywOjbnFywbh19pM
         pnrlR9FdHdXaZxXsHJ8tO99cHPHpm5uVekUI3/B7oOyXeunwM/8CtEuAVOP94w9Yf8
         lT7MIhp/s45DIVZD+7oJVoilYB+HsoQJKqy/k5dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Sandor Bodo-Merle <sbodomerle@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ray Jui <ray.jui@broadcom.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/149] PCI: iproc: Support multi-MSI only on uniprocessor kernel
Date:   Mon, 19 Jul 2021 16:53:35 +0200
Message-Id: <20210719144926.653117145@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
index b77811dcead1..0cb2fa1e0af4 100644
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
@@ -539,6 +542,9 @@ int iproc_msi_init(struct iproc_pcie *pcie, struct device_node *node)
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



