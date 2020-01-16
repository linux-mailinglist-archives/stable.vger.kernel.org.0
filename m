Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D643813F60E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388821AbgAPRGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388818AbgAPRGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 966D421D56;
        Thu, 16 Jan 2020 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194360;
        bh=F4cwf9f0yORGBvxuj54EAFRFgYgXoEyXBQKX2FzdycU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0zu3jqfVExMDvv5rWgMb1TfCUeSI+1RVPIHl6hojkNIdV1z4Tl8qTPeSv+HWsCZ8
         zUTAX94kX4NagCUDAaguYPoGBnN83dArmf6gsRhnARCOKEsNJA0wdmJ0oH1BGeAYjb
         r2yOsdKV3tNV+W+E6YWE3PDq6VYKE/ZrfZBiF4jg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 297/671] PCI: dwc: Fix dw_pcie_ep_find_capability() to return correct capability offset
Date:   Thu, 16 Jan 2020 11:58:55 -0500
Message-Id: <20200116170509.12787-34-sashal@kernel.org>
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

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 421db1ab287eebe80fd203eb009ae92836c586ad ]

commit beb4641a787d ("PCI: dwc: Add MSI-X callbacks handler") while
adding MSI-X callback handler, introduced dw_pcie_ep_find_capability()
and __dw_pcie_ep_find_next_cap() for finding the MSI and MSIX capability.

However if MSI or MSIX capability is the last capability (i.e there are
no additional items in the capabilities list and the Next Capability
Pointer is set to '0'), __dw_pcie_ep_find_next_cap will return '0'
even though MSI or MSIX capability may be present because of
incorrect ordering of the "next_cap_ptr" check. Fix it.

Fixes: beb4641a787d ("PCI: dwc: Add MSI-X callbacks handler")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 739d97080d3b..a3d07d9c598b 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -46,16 +46,19 @@ static u8 __dw_pcie_ep_find_next_cap(struct dw_pcie *pci, u8 cap_ptr,
 	u8 cap_id, next_cap_ptr;
 	u16 reg;
 
+	if (!cap_ptr)
+		return 0;
+
 	reg = dw_pcie_readw_dbi(pci, cap_ptr);
-	next_cap_ptr = (reg & 0xff00) >> 8;
 	cap_id = (reg & 0x00ff);
 
-	if (!next_cap_ptr || cap_id > PCI_CAP_ID_MAX)
+	if (cap_id > PCI_CAP_ID_MAX)
 		return 0;
 
 	if (cap_id == cap)
 		return cap_ptr;
 
+	next_cap_ptr = (reg & 0xff00) >> 8;
 	return __dw_pcie_ep_find_next_cap(pci, next_cap_ptr, cap);
 }
 
@@ -67,9 +70,6 @@ static u8 dw_pcie_ep_find_capability(struct dw_pcie *pci, u8 cap)
 	reg = dw_pcie_readw_dbi(pci, PCI_CAPABILITY_LIST);
 	next_cap_ptr = (reg & 0x00ff);
 
-	if (!next_cap_ptr)
-		return 0;
-
 	return __dw_pcie_ep_find_next_cap(pci, next_cap_ptr, cap);
 }
 
-- 
2.20.1

