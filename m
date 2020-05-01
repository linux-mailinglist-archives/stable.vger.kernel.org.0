Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7C1C14D2
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbgEANnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731610AbgEANnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A28F20757;
        Fri,  1 May 2020 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340595;
        bh=PeQtKIAleQy6HOosdj2MCVxCQ38sxvlUcKeh2ybvwSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCkKfS/9IL0bseOeh8FqI+aKQwt5dNEsSvt3PRz81c2B+etTqMtjH3B7jED00ODsl
         rq99GakmQ/3Dzuwzz+zdZ/OHsNQP/kZshM1ZbZuzW9Y48Z1wD1cHx+a2eSXA1O6KXl
         yea2k2knDtfZn2pRy/hWfj2t8BSoaEiBfgwW3EJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Pang <RaymondPang-oc@zhaoxin.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.6 046/106] PCI: Add ACS quirk for Zhaoxin Root/Downstream Ports
Date:   Fri,  1 May 2020 15:23:19 +0200
Message-Id: <20200501131549.221200148@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Pang <RaymondPang-oc@zhaoxin.com>

commit 299bd044a6f332b4a6c8f708575c27cad70a35c1 upstream.

Many Zhaoxin Root Ports and Switch Downstream Ports do provide ACS-like
capability but have no ACS Capability Structure.  Peer-to-Peer transactions
could be blocked between these ports, so add quirk so devices behind them
could be assigned to different IOMMU group.

Link: https://lore.kernel.org/r/20200327091148.5190-4-RaymondPang-oc@zhaoxin.com
Signed-off-by: Raymond Pang <RaymondPang-oc@zhaoxin.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4466,6 +4466,29 @@ static int pci_quirk_xgene_acs(struct pc
 }
 
 /*
+ * Many Zhaoxin Root Ports and Switch Downstream Ports have no ACS capability.
+ * But the implementation could block peer-to-peer transactions between them
+ * and provide ACS-like functionality.
+ */
+static int  pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	if (!pci_is_pcie(dev) ||
+	    ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
+	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
+		return -ENOTTY;
+
+	switch (dev->device) {
+	case 0x0710 ... 0x071e:
+	case 0x0721:
+	case 0x0723 ... 0x0732:
+		return pci_acs_ctrl_enabled(acs_flags,
+			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	}
+
+	return false;
+}
+
+/*
  * Many Intel PCH Root Ports do provide ACS-like features to disable peer
  * transactions and validate bus numbers in requests, but do not provide an
  * actual PCIe ACS capability.  This is the list of device IDs known to fall
@@ -4771,6 +4794,8 @@ static const struct pci_dev_acs_enabled
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x3038, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x3104, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x9083, pci_quirk_mf_endpoint_acs },
+	/* Zhaoxin Root/Downstream Ports */
+	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
 	{ 0 }
 };
 


