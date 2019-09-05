Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D210AA8C0
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfIEQUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:20:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41999 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733163AbfIEQSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id w22so2062623pfi.9
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LOcyk2Tlmy2C4zqKtlXcXvj1dEhOW89Bxfs+xhia+Lc=;
        b=RAocJqNuFAo+8EWLGQowOck0TpzPvE7OJtl5QzpsxoyoNf9Ngy0QrVRD8QbNLan0SK
         3atzqgCHL9vl7ujJipFG5mstF8vo8Cqw+J5f1YEz6GGZT2/PAdLdz7nI6i6jXlOhirHF
         s+zLL4x57Pv/j2bnLfroXzBT8ECnmG7bWvVFun5AEwZ8nHcWWz6+lasnvBgrzIAVU7RZ
         vO5xw8QOCOUZrUAHJcYqap8Q1iL7RIYViGVCWgaLpc0EWEHznv31BLWRVEeSeirK+C72
         4z451i7BQb96tTMghJ2Erm9bY0f74GAzJxLfVWq4p3mQV8fTbc8fi617kBInlSo8dIoz
         vCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LOcyk2Tlmy2C4zqKtlXcXvj1dEhOW89Bxfs+xhia+Lc=;
        b=YhvVnFdajiOpnurLN8PVjJwMPj2cgf0Qt/lNljpuMw+50gy6b6QylJweRS+qs/i4TD
         niu7wB9xo43wJf9ECk8TiR2btR2tG41JFvB/4SEoJfPHP89i1W5bSTC0WnTNBsBlMwnU
         ykjJzUuSkwA9CkL87UevIPFkPaAMJpHyOyVLs6VQWQTxGzbZh7nFhMM6rZoS0JtV9A+c
         iSxEB2nJFh/wjAA6mGI3fgt8jTf0fX4Si/O2765R8FdVtqWzMMBsYVEYWAsAqUBvNVaS
         dXVpgDKvR2KxFziyIpZYlTRFyUYnVN39YvYr9j34dVQ1Ayso5bFV3aIY0j9kqL4ONlGm
         STvA==
X-Gm-Message-State: APjAAAWuncZk3VV3STFT3Z5zQzvGffT0iCyj6oph0Szybps8hz9Bk/KI
        QH6ve/kbHJQ97LXViAizjmJoT94ldhU=
X-Google-Smtp-Source: APXvYqyMgjxfkjP3YNECcB58WCY+NHLygBK/D+S4VWMd6L7YO3gjUZq9S9Du5KS72s1N8hLa4mIKqA==
X-Received: by 2002:a63:db45:: with SMTP id x5mr3885637pgi.293.1567700282371;
        Thu, 05 Sep 2019 09:18:02 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:01 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 01/18] PCI: designware-ep: Fix find_first_zero_bit() usage
Date:   Thu,  5 Sep 2019 10:17:42 -0600
Message-Id: <20190905161759.28036-2-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@axis.com>

commit ad4a5becc689c3f32bbbc2b37eff89efe19dc2f9 upstream

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
---
 drivers/pci/dwc/pcie-designware-ep.c | 34 +++++++++++++++++++++-------
 drivers/pci/dwc/pcie-designware.h    |  8 +++++--
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/dwc/pcie-designware-ep.c b/drivers/pci/dwc/pcie-designware-ep.c
index abcbf0770358..71795db41261 100644
--- a/drivers/pci/dwc/pcie-designware-ep.c
+++ b/drivers/pci/dwc/pcie-designware-ep.c
@@ -74,8 +74,7 @@ static int dw_pcie_ep_inbound_atu(struct dw_pcie_ep *ep, enum pci_barno bar,
 	u32 free_win;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	free_win = find_first_zero_bit(&ep->ib_window_map,
-				       sizeof(ep->ib_window_map));
+	free_win = find_first_zero_bit(ep->ib_window_map, ep->num_ib_windows);
 	if (free_win >= ep->num_ib_windows) {
 		dev_err(pci->dev, "no free inbound window\n");
 		return -EINVAL;
@@ -89,7 +88,7 @@ static int dw_pcie_ep_inbound_atu(struct dw_pcie_ep *ep, enum pci_barno bar,
 	}
 
 	ep->bar_to_atu[bar] = free_win;
-	set_bit(free_win, &ep->ib_window_map);
+	set_bit(free_win, ep->ib_window_map);
 
 	return 0;
 }
@@ -100,8 +99,7 @@ static int dw_pcie_ep_outbound_atu(struct dw_pcie_ep *ep, phys_addr_t phys_addr,
 	u32 free_win;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	free_win = find_first_zero_bit(&ep->ob_window_map,
-				       sizeof(ep->ob_window_map));
+	free_win = find_first_zero_bit(ep->ob_window_map, ep->num_ob_windows);
 	if (free_win >= ep->num_ob_windows) {
 		dev_err(pci->dev, "no free outbound window\n");
 		return -EINVAL;
@@ -110,7 +108,7 @@ static int dw_pcie_ep_outbound_atu(struct dw_pcie_ep *ep, phys_addr_t phys_addr,
 	dw_pcie_prog_outbound_atu(pci, free_win, PCIE_ATU_TYPE_MEM,
 				  phys_addr, pci_addr, size);
 
-	set_bit(free_win, &ep->ob_window_map);
+	set_bit(free_win, ep->ob_window_map);
 	ep->outbound_addr[free_win] = phys_addr;
 
 	return 0;
@@ -125,7 +123,7 @@ static void dw_pcie_ep_clear_bar(struct pci_epc *epc, enum pci_barno bar)
 	dw_pcie_ep_reset_bar(pci, bar);
 
 	dw_pcie_disable_atu(pci, atu_index, DW_PCIE_REGION_INBOUND);
-	clear_bit(atu_index, &ep->ib_window_map);
+	clear_bit(atu_index, ep->ib_window_map);
 }
 
 static int dw_pcie_ep_set_bar(struct pci_epc *epc, enum pci_barno bar,
@@ -181,7 +179,7 @@ static void dw_pcie_ep_unmap_addr(struct pci_epc *epc, phys_addr_t addr)
 		return;
 
 	dw_pcie_disable_atu(pci, atu_index, DW_PCIE_REGION_OUTBOUND);
-	clear_bit(atu_index, &ep->ob_window_map);
+	clear_bit(atu_index, ep->ob_window_map);
 }
 
 static int dw_pcie_ep_map_addr(struct pci_epc *epc, phys_addr_t addr,
@@ -302,12 +300,32 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
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
diff --git a/drivers/pci/dwc/pcie-designware.h b/drivers/pci/dwc/pcie-designware.h
index 5af29d125c7e..ba9dedc31bfa 100644
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
-- 
2.17.1

