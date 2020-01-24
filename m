Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35987148127
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389371AbgAXLR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgAXLR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:27 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FED2087E;
        Fri, 24 Jan 2020 11:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864646;
        bh=+J6A71TgH4yJh6jNm/ZKKrDF7h0ZOORpwyKyg3R/p94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhRP2wA2c53yV4IIAGbxV4TymXXWE+C8wuWlMAwyIe8ofWlpeQI30ZjPwBnzB/Bir
         c/SKTsWBDI8F3zmdf/vzH4wN7D1kTeO1Yqln1lF1NTVE/5rVJLglqOBpVJYAXVQttS
         AOfy9rNf65MZPWGcGwlL/C9YfQeno8zSespaAciQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 312/639] PCI: dwc: Fix dw_pcie_ep_find_capability() to return correct capability offset
Date:   Fri, 24 Jan 2020 10:28:02 +0100
Message-Id: <20200124093126.050826344@linuxfoundation.org>
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
index 739d97080d3bd..a3d07d9c598bf 100644
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



