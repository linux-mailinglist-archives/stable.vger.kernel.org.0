Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA0A205EFE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390855AbgFWU2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390853AbgFWU2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:28:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAEE206C3;
        Tue, 23 Jun 2020 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944095;
        bh=677AxBPT09hWc7b3KKwq6Phe/nxySrd7VCuYixV9WB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6HeJRP8hDzG7nVDeZMN8S+FniHp9a4JqM/F9GwhhCSe1Ipeydq6uyxu17Hk5oEGZ
         7bNjleE4tpbKHTOTo0Zp4Lr7X8dXnPb2r1rXjBN9Pz/3bJxAsmlzO+ojHqprrkA6DU
         RhkVhMnNOkejxo9HYBdgXyW3TA8nDGQbfHB/z1BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/314] PCI: dwc: Fix inner MSI IRQ domain registration
Date:   Tue, 23 Jun 2020 21:56:06 +0200
Message-Id: <20200623195347.040122688@linuxfoundation.org>
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
index 8615f1548882a..fbcb211cceb43 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -263,6 +263,8 @@ int dw_pcie_allocate_domains(struct pcie_port *pp)
 		return -ENOMEM;
 	}
 
+	irq_domain_update_bus_token(pp->irq_domain, DOMAIN_BUS_NEXUS);
+
 	pp->msi_domain = pci_msi_create_irq_domain(fwnode,
 						   &dw_pcie_msi_domain_info,
 						   pp->irq_domain);
-- 
2.25.1



