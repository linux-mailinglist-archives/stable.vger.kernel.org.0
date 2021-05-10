Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDEB378926
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbhEJLZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238081AbhEJLRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4726162A;
        Mon, 10 May 2021 11:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645146;
        bh=NoKNio/PnPh88FuR6wTx74E1Wu2SriaCgj6ot9PHIcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbpgY5MgZfSIcb8gfbtXwsxBwGgPeEXPtb+wTtBBtC6zE1glQUyFh78aTgZFugyvp
         Dn/1Tx/tICxAG2SPHldxflnZMMbY1vaDmMSGI4dr9kI8fEO09A0nmqiPr/WJp1yqn9
         ATUXaNuXDTK4d+Pr71Yasg9XcmR7CB06owDEyLWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.12 370/384] PCI: dwc: Move iATU detection earlier
Date:   Mon, 10 May 2021 12:22:39 +0200
Message-Id: <20210510102026.964087402@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

commit 8bcca26585585ae4b44d25d30f351ad0afa4976b upstream.

dw_pcie_ep_init() depends on the detected iATU region numbers to allocate
the in/outbound window management bitmap.  It fails after 281f1f99cf3a
("PCI: dwc: Detect number of iATU windows").

Move the iATU region detection into a new function, move the detection to
the very beginning of dw_pcie_host_init() and dw_pcie_ep_init().  Also
remove it from the dw_pcie_setup(), since it's more like a software
initialization step than hardware setup.

Link: https://lore.kernel.org/r/20210125044803.4310-1-Zhiqiang.Hou@nxp.com
Link: https://lore.kernel.org/linux-pci/20210407131255.702054-1-dmitry.baryshkov@linaro.org
Link: https://lore.kernel.org/r/20210413142219.2301430-1-dmitry.baryshkov@linaro.org
Fixes: 281f1f99cf3a ("PCI: dwc: Detect number of iATU windows")
Tested-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
[DB: moved dw_pcie_iatu_detect to happen after host_init callback]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: stable@vger.kernel.org	# v5.11+
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c   |    2 ++
 drivers/pci/controller/dwc/pcie-designware-host.c |    1 +
 drivers/pci/controller/dwc/pcie-designware.c      |   11 ++++++++---
 drivers/pci/controller/dwc/pcie-designware.h      |    1 +
 4 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -705,6 +705,8 @@ int dw_pcie_ep_init(struct dw_pcie_ep *e
 		}
 	}
 
+	dw_pcie_iatu_detect(pci);
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "addr_space");
 	if (!res)
 		return -EINVAL;
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -398,6 +398,7 @@ int dw_pcie_host_init(struct pcie_port *
 		if (ret)
 			goto err_free_msi;
 	}
+	dw_pcie_iatu_detect(pci);
 
 	dw_pcie_setup_rc(pp);
 	dw_pcie_msi_init(pp);
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -660,11 +660,9 @@ static void dw_pcie_iatu_detect_regions(
 	pci->num_ob_windows = ob;
 }
 
-void dw_pcie_setup(struct dw_pcie *pci)
+void dw_pcie_iatu_detect(struct dw_pcie *pci)
 {
-	u32 val;
 	struct device *dev = pci->dev;
-	struct device_node *np = dev->of_node;
 	struct platform_device *pdev = to_platform_device(dev);
 
 	if (pci->version >= 0x480A || (!pci->version &&
@@ -693,6 +691,13 @@ void dw_pcie_setup(struct dw_pcie *pci)
 
 	dev_info(pci->dev, "Detected iATU regions: %u outbound, %u inbound",
 		 pci->num_ob_windows, pci->num_ib_windows);
+}
+
+void dw_pcie_setup(struct dw_pcie *pci)
+{
+	u32 val;
+	struct device *dev = pci->dev;
+	struct device_node *np = dev->of_node;
 
 	if (pci->link_gen > 0)
 		dw_pcie_link_set_max_speed(pci, pci->link_gen);
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -306,6 +306,7 @@ int dw_pcie_prog_inbound_atu(struct dw_p
 void dw_pcie_disable_atu(struct dw_pcie *pci, int index,
 			 enum dw_pcie_region_type type);
 void dw_pcie_setup(struct dw_pcie *pci);
+void dw_pcie_iatu_detect(struct dw_pcie *pci);
 
 static inline void dw_pcie_writel_dbi(struct dw_pcie *pci, u32 reg, u32 val)
 {


