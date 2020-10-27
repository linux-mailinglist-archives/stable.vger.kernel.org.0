Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C2029BF8D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815555AbgJ0RDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793641AbgJ0PHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6CA20657;
        Tue, 27 Oct 2020 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811254;
        bh=y8bsv20wAs4Uk38UdpAxJPZ65OGYVZhayoDglNn7Bbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyVT9iY/5nxZ7v0bPivt854T0s7ta63BIE/d7HpzcMDUZcyUhi+29ktRv9om49CEM
         oJSDWalSX98jbHtbSzvuiesuTcHfi9x5BE6FJT+onrHXGllyyi050ZEmuTDGSyJmZK
         v0UswFId6By8WkcmB5n4/iujgCxg5OHsMcl71u0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 429/633] PCI: designware-ep: Fix the Header Type check
Date:   Tue, 27 Oct 2020 14:52:52 +0100
Message-Id: <20201027135542.847798241@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit 16270a92355722e387e9ca19627c5a4d7bae1354 ]

The current check will result in the multiple function device
fails to initialize. So fix the check by masking out the
multiple function bit.

Link: https://lore.kernel.org/r/20200818092746.24366-1-Zhiqiang.Hou@nxp.com
Fixes: 0b24134f7888 ("PCI: dwc: Add validation that PCIe core is set to correct mode")
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 3 ++-
 include/uapi/linux/pci_regs.h                   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 5e5b8821bed8c..ce1c00ea5fdca 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -505,7 +505,8 @@ int dw_pcie_ep_init_complete(struct dw_pcie_ep *ep)
 	u32 reg;
 	int i;
 
-	hdr_type = dw_pcie_readb_dbi(pci, PCI_HEADER_TYPE);
+	hdr_type = dw_pcie_readb_dbi(pci, PCI_HEADER_TYPE) &
+		   PCI_HEADER_TYPE_MASK;
 	if (hdr_type != PCI_HEADER_TYPE_NORMAL) {
 		dev_err(pci->dev,
 			"PCIe controller is not set to EP mode (hdr_type:0x%x)!\n",
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index f9701410d3b52..57a222014cd20 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -76,6 +76,7 @@
 #define PCI_CACHE_LINE_SIZE	0x0c	/* 8 bits */
 #define PCI_LATENCY_TIMER	0x0d	/* 8 bits */
 #define PCI_HEADER_TYPE		0x0e	/* 8 bits */
+#define  PCI_HEADER_TYPE_MASK		0x7f
 #define  PCI_HEADER_TYPE_NORMAL		0
 #define  PCI_HEADER_TYPE_BRIDGE		1
 #define  PCI_HEADER_TYPE_CARDBUS	2
-- 
2.25.1



