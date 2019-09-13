Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E40B1FE8
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbfIMNLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388852AbfIMNK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:10:59 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46B5020CC7;
        Fri, 13 Sep 2019 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380258;
        bh=SjPkWZcBWn0D1WC3gIwVHSRDQdoNIdR8pd86m7TBVv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjOv4dfJfUm47Q4LAzXGNXr1c5l3n4PXgxmvRsI8YLUeTaop+3r4xXUvGON21cbkw
         HvuZx/cQmduvUQ+S7Ap72Pw9z2Pqh7E2e5sNpjXb99nwJCOlWSbE2sHI7w+rqhknys
         9Yog+VRq8Uavp3Dn786b5LW2E0svk5D7gHn+aqks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@axis.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 09/21] PCI: designware-ep: Fix find_first_zero_bit() usage
Date:   Fri, 13 Sep 2019 14:07:02 +0100
Message-Id: <20190913130504.516843119@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
References: <20190913130501.285837292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@axis.com>

commit ad4a5becc689c3f32bbbc2b37eff89efe19dc2f9 upstream.

find_first_zero_bit()'s parameter 'size' is defined in bits,
not in bytes.

find_first_zero_bit() is called with size in bytes rather than bits,
which thus defines a too low upper limit, causing
dw_pcie_ep_inbound_atu() to assign iatu index #4 to both bar 4
and bar 5, which makes bar 5 overwrite the settings set by bar 4.

Since the sizes of the bitmaps are known, dynamically allocate the
bitmaps, and use the correct size when calling find_first_zero_bit().

Additionally, make sure that ep->num_ob_windows and ep->num_ib_windows,
which are obtained from device tree, are smaller than the maximum number
of iATUs (MAX_IATU_IN/MAX_IATU_OUT).

Fixes: f8aed6ec624f ("PCI: dwc: designware: Add EP mode support")
Signed-off-by: Niklas Cassel <niklas.cassel@axis.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/dwc/pcie-designware-ep.c |   34 ++++++++++++++++++++++++++--------
 drivers/pci/dwc/pcie-designware.h    |    8 ++++++--
 2 files changed, 32 insertions(+), 10 deletions(-)

--- a/drivers/pci/dwc/pcie-designware-ep.c
+++ b/drivers/pci/dwc/pcie-designware-ep.c
@@ -74,8 +74,7 @@ static int dw_pcie_ep_inbound_atu(struct
 	u32 free_win;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	free_win = find_first_zero_bit(&ep->ib_window_map,
-				       sizeof(ep->ib_window_map));
+	free_win = find_first_zero_bit(ep->ib_window_map, ep->num_ib_windows);
 	if (free_win >= ep->num_ib_windows) {
 		dev_err(pci->dev, "no free inbound window\n");
 		return -EINVAL;
@@ -89,7 +88,7 @@ static int dw_pcie_ep_inbound_atu(struct
 	}
 
 	ep->bar_to_atu[bar] = free_win;
-	set_bit(free_win, &ep->ib_window_map);
+	set_bit(free_win, ep->ib_window_map);
 
 	return 0;
 }
@@ -100,8 +99,7 @@ static int dw_pcie_ep_outbound_atu(struc
 	u32 free_win;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	free_win = find_first_zero_bit(&ep->ob_window_map,
-				       sizeof(ep->ob_window_map));
+	free_win = find_first_zero_bit(ep->ob_window_map, ep->num_ob_windows);
 	if (free_win >= ep->num_ob_windows) {
 		dev_err(pci->dev, "no free outbound window\n");
 		return -EINVAL;
@@ -110,7 +108,7 @@ static int dw_pcie_ep_outbound_atu(struc
 	dw_pcie_prog_outbound_atu(pci, free_win, PCIE_ATU_TYPE_MEM,
 				  phys_addr, pci_addr, size);
 
-	set_bit(free_win, &ep->ob_window_map);
+	set_bit(free_win, ep->ob_window_map);
 	ep->outbound_addr[free_win] = phys_addr;
 
 	return 0;
@@ -125,7 +123,7 @@ static void dw_pcie_ep_clear_bar(struct
 	dw_pcie_ep_reset_bar(pci, bar);
 
 	dw_pcie_disable_atu(pci, atu_index, DW_PCIE_REGION_INBOUND);
-	clear_bit(atu_index, &ep->ib_window_map);
+	clear_bit(atu_index, ep->ib_window_map);
 }
 
 static int dw_pcie_ep_set_bar(struct pci_epc *epc, enum pci_barno bar,
@@ -181,7 +179,7 @@ static void dw_pcie_ep_unmap_addr(struct
 		return;
 
 	dw_pcie_disable_atu(pci, atu_index, DW_PCIE_REGION_OUTBOUND);
-	clear_bit(atu_index, &ep->ob_window_map);
+	clear_bit(atu_index, ep->ob_window_map);
 }
 
 static int dw_pcie_ep_map_addr(struct pci_epc *epc, phys_addr_t addr,
@@ -302,12 +300,32 @@ int dw_pcie_ep_init(struct dw_pcie_ep *e
 		dev_err(dev, "unable to read *num-ib-windows* property\n");
 		return ret;
 	}
+	if (ep->num_ib_windows > MAX_IATU_IN) {
+		dev_err(dev, "invalid *num-ib-windows*\n");
+		return -EINVAL;
+	}
 
 	ret = of_property_read_u32(np, "num-ob-windows", &ep->num_ob_windows);
 	if (ret < 0) {
 		dev_err(dev, "unable to read *num-ob-windows* property\n");
 		return ret;
 	}
+	if (ep->num_ob_windows > MAX_IATU_OUT) {
+		dev_err(dev, "invalid *num-ob-windows*\n");
+		return -EINVAL;
+	}
+
+	ep->ib_window_map = devm_kzalloc(dev, sizeof(long) *
+					 BITS_TO_LONGS(ep->num_ib_windows),
+					 GFP_KERNEL);
+	if (!ep->ib_window_map)
+		return -ENOMEM;
+
+	ep->ob_window_map = devm_kzalloc(dev, sizeof(long) *
+					 BITS_TO_LONGS(ep->num_ob_windows),
+					 GFP_KERNEL);
+	if (!ep->ob_window_map)
+		return -ENOMEM;
 
 	addr = devm_kzalloc(dev, sizeof(phys_addr_t) * ep->num_ob_windows,
 			    GFP_KERNEL);
--- a/drivers/pci/dwc/pcie-designware.h
+++ b/drivers/pci/dwc/pcie-designware.h
@@ -114,6 +114,10 @@
 #define MAX_MSI_IRQS			32
 #define MAX_MSI_CTRLS			(MAX_MSI_IRQS / 32)
 
+/* Maximum number of inbound/outbound iATUs */
+#define MAX_IATU_IN			256
+#define MAX_IATU_OUT			256
+
 struct pcie_port;
 struct dw_pcie;
 struct dw_pcie_ep;
@@ -193,8 +197,8 @@ struct dw_pcie_ep {
 	size_t			page_size;
 	u8			bar_to_atu[6];
 	phys_addr_t		*outbound_addr;
-	unsigned long		ib_window_map;
-	unsigned long		ob_window_map;
+	unsigned long		*ib_window_map;
+	unsigned long		*ob_window_map;
 	u32			num_ib_windows;
 	u32			num_ob_windows;
 };


