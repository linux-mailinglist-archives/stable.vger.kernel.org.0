Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3735335E14E
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 16:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhDMOWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 10:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhDMOWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 10:22:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AE4C061574
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 07:22:23 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id e14so14886764lfn.11
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 07:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sSdkvcoRP/DLD226a2zcjxaqs8CSLLa63pnFVOEgkYc=;
        b=CCZYPUChjpWx+NonKRNO2t2uLvncd+6QV5OYgzIv0mW7RUb2PXRzCrp9YvNG7NavmT
         Hv4Q4buek8R1ReXrHv5tWDpVzDs9A9XkdPFSzNwSnAW63VqafrqUh4nt2lf+CSIVTzfJ
         8RSlYD/yJc7ScBTWdXj6DTyAjBE+Sg7H2vwdAqxk/PGKVyTE6ZbyjnMaSoKx+dCerr8h
         ZZphWWEVF29QQYmM9dNL7tOK3yTMcYe9Irwit5fIWJbzQOIwY1ATZ/bb4kodsEm8mXk5
         riY/0u9CD9MUgnbtrR/xxiNeOto3j8fvNRvZ5BmEobzxNr2nJLv5w1VLD0tUqDqiaXsN
         TMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sSdkvcoRP/DLD226a2zcjxaqs8CSLLa63pnFVOEgkYc=;
        b=r6sanQFBmchYBaemr/0hW4SOjPaKwis+UPJBM6jc59amneIpXRxT2zV97KfhXeOpKV
         Ytq/j0Ync5TmSVdc9LGJo/xbg9NrLivs43rebx4xbTQv1pIdqvn8SZ9T3T8PGbml0IrJ
         YVd5s1OMSN4C42jGzGWGauXO69ys4cd3zNkxlrwmGaRqDQ6qjsc/2YpIIc/9F7ZL6bgo
         0lfWHeVjhBacQAhbL8hHxfgAVGeh1zmM9S5jeiBeku4SDGau3gwGAhQ8CTav7J8xVdFu
         1CAS/JDyzQ61NPS84UC6Qdop4PHj7G1T8PmeEfX68HyyQqL5LNp/5i8+9m1LqXvoDW2F
         pwnw==
X-Gm-Message-State: AOAM5316NHkRhgWbW5m6bErpVuNFUQBqCj+d6mc1quy9lT9tYqq8lWdC
        WECsbwvSw5JqHAzOkgFDBX3yEw==
X-Google-Smtp-Source: ABdhPJwWFZFUurHVGHK85bLZPRnJfU7A7DCmBmeM8JgP8wxpiCWeGBGIsnFMr+7bE6gxL9tu9LdRoQ==
X-Received: by 2002:a19:c187:: with SMTP id r129mr7608474lff.457.1618323741124;
        Tue, 13 Apr 2021 07:22:21 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id n7sm3397814lft.65.2021.04.13.07.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:22:20 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-pci@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2] PCI: dwc: Move iATU detection earlier
Date:   Tue, 13 Apr 2021 17:22:19 +0300
Message-Id: <20210413142219.2301430-1-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

dw_pcie_ep_init() depends on the detected iATU region numbers to allocate
the in/outbound window management bitmap.  It fails after 281f1f99cf3a
("PCI: dwc: Detect number of iATU windows").

Move the iATU region detection into a new function, move the detection to
the very beginning of dw_pcie_host_init() and dw_pcie_ep_init().  Also
remove it from the dw_pcie_setup(), since it's more like a software
initialization step than hardware setup.

Fixes: 281f1f99cf3a ("PCI: dwc: Detect number of iATU windows")
Link: https://lore.kernel.org/r/20210125044803.4310-1-Zhiqiang.Hou@nxp.com
Tested-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: stable@vger.kernel.org	# v5.11+
[DB: moved dw_pcie_iatu_detect to happen after host_init callback]
Link: https://lore.kernel.org/linux-pci/20210407131255.702054-1-dmitry.baryshkov@linaro.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c   |  2 ++
 drivers/pci/controller/dwc/pcie-designware-host.c |  1 +
 drivers/pci/controller/dwc/pcie-designware.c      | 11 ++++++++---
 drivers/pci/controller/dwc/pcie-designware.h      |  1 +
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 1c25d8337151..8d028a88b375 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -705,6 +705,8 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
 		}
 	}
 
+	dw_pcie_iatu_detect(pci);
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "addr_space");
 	if (!res)
 		return -EINVAL;
diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 7e55b2b66182..24192b40e3a2 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -398,6 +398,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 		if (ret)
 			goto err_free_msi;
 	}
+	dw_pcie_iatu_detect(pci);
 
 	dw_pcie_setup_rc(pp);
 	dw_pcie_msi_init(pp);
diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 004cb860e266..a945f0c0e73d 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -660,11 +660,9 @@ static void dw_pcie_iatu_detect_regions(struct dw_pcie *pci)
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
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 7247c8b01f04..7d6e9b7576be 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -306,6 +306,7 @@ int dw_pcie_prog_inbound_atu(struct dw_pcie *pci, u8 func_no, int index,
 void dw_pcie_disable_atu(struct dw_pcie *pci, int index,
 			 enum dw_pcie_region_type type);
 void dw_pcie_setup(struct dw_pcie *pci);
+void dw_pcie_iatu_detect(struct dw_pcie *pci);
 
 static inline void dw_pcie_writel_dbi(struct dw_pcie *pci, u32 reg, u32 val)
 {
-- 
2.30.2

