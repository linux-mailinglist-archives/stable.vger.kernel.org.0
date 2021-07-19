Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F113CE3F8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347143AbhGSPlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348527AbhGSPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2A53616EC;
        Mon, 19 Jul 2021 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711241;
        bh=IiQLSQKe0QytNTZJeipUQIlPirPvmPbnwL7v6w/WYx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYk8SNXDFEpZQhyAV04KxFb88T/Wo1PgD1FY3GWkDRFE9aOpHGnVNOXoldP8+2ZZL
         hQAHkVIsJlUuvN6hh05Vs1Uf4pcZy8PFuL5kpHRiYHUHS7epJ/aBVr84eappwXsexo
         qm+tsCWv7WOp82Z4Xu1s/oRKl7vy6N5Zu74pP0Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 236/351] PCI: intel-gw: Fix INTx enable
Date:   Mon, 19 Jul 2021 16:53:02 +0200
Message-Id: <20210719144952.751818796@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index f89a7d24ba28..d15cf35fa7f2 100644
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



