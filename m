Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE5FEE52
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbfKPPut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730624AbfKPPus (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:48 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4705120891;
        Sat, 16 Nov 2019 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919447;
        bh=hZs1P9plDIJ8W2ENJ7RonhFFJIGU5K6ekGDrHHqkUQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRayVvUSTCxczMo+kdZRUht1u6fh42BviXqFflJWEsxIZ2G8mLSp7L759bz7rO+D2
         H7DxXLWTd3qK/ySUiSSh0YYXfS85JKDgsfzOCzSxbYUx7CTbt/dmTTAq83yjdV4gag
         PBsZfLMRXhwM0gxCmRTstS4Gck+SBIq0/r7qYdaY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 145/150] PCI: keystone: Use quirk to limit MRRS for K2G
Date:   Sat, 16 Nov 2019 10:47:23 -0500
Message-Id: <20191116154729.9573-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 148e340c0696369fadbbddc8f4bef801ed247d71 ]

PCI controller in K2G also has a limitation that memory read request
size (MRRS) must not exceed 256 bytes. Use the quirk to limit MRRS
(added for K2HK, K2L and K2E) for K2G as well.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/dwc/pci-keystone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/dwc/pci-keystone.c b/drivers/pci/dwc/pci-keystone.c
index 9bc52e4cf52a0..3ea8288c16053 100644
--- a/drivers/pci/dwc/pci-keystone.c
+++ b/drivers/pci/dwc/pci-keystone.c
@@ -39,6 +39,7 @@
 #define PCIE_RC_K2HK		0xb008
 #define PCIE_RC_K2E		0xb009
 #define PCIE_RC_K2L		0xb00a
+#define PCIE_RC_K2G		0xb00b
 
 #define to_keystone_pcie(x)	dev_get_drvdata((x)->dev)
 
@@ -53,6 +54,8 @@ static void quirk_limit_mrrs(struct pci_dev *dev)
 		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
 		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2L),
 		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
+		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2G),
+		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
 		{ 0, },
 	};
 
-- 
2.20.1

