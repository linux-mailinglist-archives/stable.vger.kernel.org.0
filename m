Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1133CE16B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbhGSPZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347589AbhGSPTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50E8161279;
        Mon, 19 Jul 2021 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710330;
        bh=MvRSfttoZI3GgtL9eQvN7tVLaYVPRkt7MRt6y9OH+cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP3qR7N1UYUv2SSp+AFjIbDJWq2AVvWj0YwoI8nzdCdwkdQhCxey5bxHxcuQcIOxe
         4ES6ynWwtAcUceod2kuVQO4Ypw0ZiW5hcdnofC04rqstKxO6nfmKxAqqW78JASmNOm
         DcE9rTWM9ck8gvIqqF0sIquQv+57RaAoOnL4nips=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/243] PCI: intel-gw: Fix INTx enable
Date:   Mon, 19 Jul 2021 16:53:20 +0200
Message-Id: <20210719144946.424115728@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 5650cb78acba..5e1a284fdc53 100644
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



