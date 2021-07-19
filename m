Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6283CE51F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbhGSPrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350201AbhGSPpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AAE61166;
        Mon, 19 Jul 2021 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711981;
        bh=mcTb9YtVPkdlUK0sxT/Pyc5bw4su8gIpZz+V9Lk3fTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVi3jE2drPNrM7VdtIOcqqTryC1Lk4tcD0QB+8E2VjiSOkAQKGHe6jmG5hhsTHef8
         H7lQ7ZjN+zGXBIgUQlmVCxT+0ckG0Ak09BSrU4oKJMECYsQCBnqvMUL6t2KlO7b311
         KN8mcQUTflxY53Mhy/3rvYjBGtRShVEp7eTvQ/24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 205/292] PCI: intel-gw: Fix INTx enable
Date:   Mon, 19 Jul 2021 16:54:27 +0200
Message-Id: <20210719144949.243113037@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 655832d12f2251e04031294f547c86935a0a126d ]

The legacy PCI interrupt lines need to be enabled using PCIE_APP_IRNEN bits
13 (INTA), 14 (INTB), 15 (INTC) and 16 (INTD). The old code however was
taking (for example) "13" as raw value instead of taking BIT(13).  Define
the legacy PCI interrupt bits using the BIT() macro and then use these in
PCIE_APP_IRN_INT.

Link: https://lore.kernel.org/r/20210106135540.48420-1-martin.blumenstingl@googlemail.com
Fixes: ed22aaaede44 ("PCI: dwc: intel: PCIe RC controller driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Rahul Tanwar <rtanwar@maxlinear.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-intel-gw.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-intel-gw.c b/drivers/pci/controller/dwc/pcie-intel-gw.c
index 0cedd1f95f37..ae96bfbb6c83 100644
--- a/drivers/pci/controller/dwc/pcie-intel-gw.c
+++ b/drivers/pci/controller/dwc/pcie-intel-gw.c
@@ -39,6 +39,10 @@
 #define PCIE_APP_IRN_PM_TO_ACK		BIT(9)
 #define PCIE_APP_IRN_LINK_AUTO_BW_STAT	BIT(11)
 #define PCIE_APP_IRN_BW_MGT		BIT(12)
+#define PCIE_APP_IRN_INTA		BIT(13)
+#define PCIE_APP_IRN_INTB		BIT(14)
+#define PCIE_APP_IRN_INTC		BIT(15)
+#define PCIE_APP_IRN_INTD		BIT(16)
 #define PCIE_APP_IRN_MSG_LTR		BIT(18)
 #define PCIE_APP_IRN_SYS_ERR_RC		BIT(29)
 #define PCIE_APP_INTX_OFST		12
@@ -48,10 +52,8 @@
 	PCIE_APP_IRN_RX_VDM_MSG | PCIE_APP_IRN_SYS_ERR_RC | \
 	PCIE_APP_IRN_PM_TO_ACK | PCIE_APP_IRN_MSG_LTR | \
 	PCIE_APP_IRN_BW_MGT | PCIE_APP_IRN_LINK_AUTO_BW_STAT | \
-	(PCIE_APP_INTX_OFST + PCI_INTERRUPT_INTA) | \
-	(PCIE_APP_INTX_OFST + PCI_INTERRUPT_INTB) | \
-	(PCIE_APP_INTX_OFST + PCI_INTERRUPT_INTC) | \
-	(PCIE_APP_INTX_OFST + PCI_INTERRUPT_INTD))
+	PCIE_APP_IRN_INTA | PCIE_APP_IRN_INTB | \
+	PCIE_APP_IRN_INTC | PCIE_APP_IRN_INTD)
 
 #define BUS_IATU_OFFSET			SZ_256M
 #define RESET_INTERVAL_MS		100
-- 
2.30.2



