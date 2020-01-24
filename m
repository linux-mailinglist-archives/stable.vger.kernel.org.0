Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9992514824B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391468AbgAXL0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391588AbgAXL0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:46 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B45C2075D;
        Fri, 24 Jan 2020 11:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865206;
        bh=OGxVUGjvj5du1rg7UWcWQJE0Kmdun1QAZUtLSwOl7Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFTOmS8nczD08Z4ILtazRnmR/zt4EZGmtozFMuJpQjSnM8LDhwNiBBjb4p38tFVrR
         IHUWR+5kW5kezWnvB2CFNfHdVdHGKFHSvyJTs6zme3HGOtRDCHCF2/Vi4PilHszMJc
         oEJd3/cA6rHckeobiRFD3usoxOgYCwu4XeoUyCoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 469/639] PCI: mobiveil: Remove the flag MSI_FLAG_MULTI_PCI_MSI
Date:   Fri, 24 Jan 2020 10:30:39 +0100
Message-Id: <20200124093146.185771483@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit a131fb6364c1be0924dcb969ecf6b988c556a5d5 ]

The Mobiveil internal MSI controller requires separate target addresses,
one per MSI vector; this is clearly incompatible with the Multiple MSI
feature, which requires the same target address for all vectors
requested by an endpoint (ie the Message Address field in the MSI
Capability structure), so the multi MSI feature is clearly not
supported by the host controller driver.

Remove the flag MSI_FLAG_MULTI_PCI_MSI and with it multi MSI support,
fixing the misconfiguration.

Fixes: 1e913e58335f ("PCI: mobiveil: Add MSI support")
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index a2d1e89d48674..dc228eb500edd 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -643,7 +643,7 @@ static struct irq_chip mobiveil_msi_irq_chip = {
 
 static struct msi_domain_info mobiveil_msi_domain_info = {
 	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX),
+		   MSI_FLAG_PCI_MSIX),
 	.chip	= &mobiveil_msi_irq_chip,
 };
 
-- 
2.20.1



