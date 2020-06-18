Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA29A1FE6EE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgFRChf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbgFRBNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A740521924;
        Thu, 18 Jun 2020 01:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442821;
        bh=+7/PlDzWUjyfolRw+6reVX66V0k0Iko13dyWim3CMY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sddd2DOQO+XZ2HjHKK2SIMigVF5QnzkN/YU1b3nwiR0CruEdwju4p+BrzIOPxRCq2
         q9nAFRs9vDiy398BWNeBsAYYihALdJaHYhyC3T0SzEh4X46mpj2jiHglHAgmSKE18V
         L7BRkyq2WOuBhxmpbX2fdASNfjJVtUnhff5nJcq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 258/388] PCI: dwc: Fix inner MSI IRQ domain registration
Date:   Wed, 17 Jun 2020 21:05:55 -0400
Message-Id: <20200618010805.600873-258-sashal@kernel.org>
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

[ Upstream commit 0414b93e78d87ecc24ae1a7e61fe97deb29fa2f4 ]

On a system that uses the internal DWC MSI widget, I get this
warning from debugfs when CONFIG_GENERIC_IRQ_DEBUGFS is selected:

  debugfs: File ':soc:pcie@fc000000' in directory 'domains' already present!

This is due to the fact that the DWC MSI code tries to register two
IRQ domains for the same firmware node, without telling the low
level code how to distinguish them (by setting a bus token). This
further confuses debugfs which tries to create corresponding
files for each domain.

Fix it by tagging the inner domain as DOMAIN_BUS_NEXUS, which is
the closest thing we have as to "generic MSI".

Link: https://lore.kernel.org/r/20200501113921.366597-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Jingoo Han <jingoohan1@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 395feb8ca051..3c43311bb95c 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -264,6 +264,8 @@ int dw_pcie_allocate_domains(struct pcie_port *pp)
 		return -ENOMEM;
 	}
 
+	irq_domain_update_bus_token(pp->irq_domain, DOMAIN_BUS_NEXUS);
+
 	pp->msi_domain = pci_msi_create_irq_domain(fwnode,
 						   &dw_pcie_msi_domain_info,
 						   pp->irq_domain);
-- 
2.25.1

