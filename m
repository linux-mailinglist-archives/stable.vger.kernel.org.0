Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C06D13F44A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389735AbgAPSsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389068AbgAPRJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E557D2081E;
        Thu, 16 Jan 2020 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194580;
        bh=lV6vCJ54AZJJG/iIgMdGhEKiyRI7RwaFGDruA9QXvkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFeOe3C+EYsGO6AIAehSqPbsUF1AH1b/+dt8SaZ9WiD8ZHgc02g7pISBiNMNPdoPM
         4tRvj4iyh1svAxzMmIT9BFaKDsH2et9269p7NE9w0wQhPTaRXj4XB+3QCBL9vZZhPA
         TMeqQUvaulH+bQ2mfBzk6qacg1184UKTr+u/CKsk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 454/671] PCI: mobiveil: Remove the flag MSI_FLAG_MULTI_PCI_MSI
Date:   Thu, 16 Jan 2020 12:01:32 -0500
Message-Id: <20200116170509.12787-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a2d1e89d4867..dc228eb500ed 100644
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

