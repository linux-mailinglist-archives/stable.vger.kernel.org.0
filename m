Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC55C1C16A0
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgEANvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731093AbgEANiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:38:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A12B205C9;
        Fri,  1 May 2020 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340331;
        bh=kWRqHbfq8qMhGX8i/RgDx7P4m3rhy5cTC7RFr0ex7YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxO7lXupu+dRjSd9vDt8g0FY024fQLDxsyVs0ujKYP+lqD3v0EHURQyGjFtRKXfDw
         Kvym/VswB69N8y+IG9h0pG5y4NEGr1UlO+JRxIONSWvzYhpx5d/gpudIGW5+zOmb9/
         dz02ac1N0utOq/2VeLy6Byo7pEuah5KWk7e+cp58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Pang <RaymondPang-oc@zhaoxin.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 35/83] PCI: Add ACS quirk for Zhaoxin Root/Downstream Ports
Date:   Fri,  1 May 2020 15:23:14 +0200
Message-Id: <20200501131533.238306482@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
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
@@ -4371,6 +4371,29 @@ static int pci_acs_ctrl_enabled(u16 acs_
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
  * AMD has indicated that the devices below do not support peer-to-peer
  * in any system where they are found in the southbridge with an AMD
  * IOMMU in the system.  Multifunction devices that do not support
@@ -4772,6 +4795,8 @@ static const struct pci_dev_acs_enabled
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x3038, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x3104, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x9083, pci_quirk_mf_endpoint_acs },
+	/* Zhaoxin Root/Downstream Ports */
+	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
 	{ 0 }
 };
 


