Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B66E258E8C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 14:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgIAMuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 08:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgIAMuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 08:50:03 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DA6C061245;
        Tue,  1 Sep 2020 05:50:02 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e23so1469624eja.3;
        Tue, 01 Sep 2020 05:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TeP2OMTnX08luhi/Cf+M20naxDcFqoHuSCfrsdvdbQs=;
        b=u25gocfmHvWnUENdqC+EIpRNM7WAVhgZnDdK3HH5Qvx421X8HpAscJvCHSrUvXoFem
         2i+K90Pqxe4XtoYu0IwUtCBOXD3e2LwPCRTofmLnNytjINMAUxdoFO/JRauOrDWnwVZy
         y/gj0c7sGeDgJI1T+ivYt07SorAAWwGokZNSYFm/bFA7Rzh9mGvIV9YD5h+g5XP/ha/r
         Yw7XoMIr1h0Mss+DEjXaXvYAIrgN5+0neD+CLwe/eVTJMpYXac568ktpjfxUviTyVciX
         oc4mC0ypWa3ZYWRmghWNVvXaCEFhyRAm1q30sl3bZIrwl5BsPgT7dJwOv5eOQhkFyhXc
         JC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TeP2OMTnX08luhi/Cf+M20naxDcFqoHuSCfrsdvdbQs=;
        b=ro6Cajyh96x8VoDqBKsu0RXELWFFzLTzGlwVFIgF8KLgqJYMZahEX8cuQdROLdwbQL
         XUc1uZssn0Cujj/RYV8ecPsGdE5MWm1RoRzW+P/ovJUDUPTih8+tboKmYKY4ZIlNrhCk
         tcvP0bWiGXLLlqAcIpAp9G+KCjYgBstLZnWuxf+Sn3u+ZqfY2xppIS3h8VFGy1hn6+Jd
         p9yA02H6+aTk+AA0wp4sZ6ZQ+WyaBtyG5iYNVDx643af9l52fLG4GNt4JdGhASTUvaD3
         O+wzMKjJE35dkfoPBasMbREewFjnyN70sxMXuFuCzFHoiZ5S5rRRX/wN4Hw3ts2UFcS0
         GSrg==
X-Gm-Message-State: AOAM532RgIvBG6emHclXys7xU+rtwu/+NvVZcucMNOec9fexTsD4qjKX
        wWpLl3LYaZxNkGakazPCiqE=
X-Google-Smtp-Source: ABdhPJwd22fDSrMBk6KGt7ZiNC578JKHfx4PFTxHyLD3s9thWNGwOYt2JHqd5L9J5spk0LQZTWNGZA==
X-Received: by 2002:a17:906:3755:: with SMTP id e21mr1294445ejc.39.1598964601056;
        Tue, 01 Sep 2020 05:50:01 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-95-235-252-96.retail.telecomitalia.it. [95.235.252.96])
        by smtp.googlemail.com with ESMTPSA id t12sm1068724edy.61.2020.09.01.05.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 05:50:00 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0
Date:   Tue,  1 Sep 2020 14:49:54 +0200
Message-Id: <20200901124955.137-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Qsdk U-Boot can incorrectly leave the PCIe interface in an undefined
state if bootm command is used instead of bootipq. This is caused by the
not deinit of PCIe when bootm is called. Reset the PCIe before init
anyway to fix this U-Boot bug.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/pci/controller/dwc/pcie-qcom.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 3aac77a295ba..82336bbaf8dc 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -302,6 +302,9 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->por_reset);
 	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->phy_reset);
+
+	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
+
 	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
 }
 
@@ -314,6 +317,16 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	u32 val;
 	int ret;
 
+	/* reset the PCIe interface as uboot can leave it undefined state */
+	reset_control_assert(res->pci_reset);
+	reset_control_assert(res->axi_reset);
+	reset_control_assert(res->ahb_reset);
+	reset_control_assert(res->por_reset);
+	reset_control_assert(res->ext_reset);
+	reset_control_assert(res->phy_reset);
+
+	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
 	if (ret < 0) {
 		dev_err(dev, "cannot enable regulators\n");
-- 
2.27.0

