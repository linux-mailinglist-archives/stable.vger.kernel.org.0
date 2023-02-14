Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C496965A4
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjBNOBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjBNOBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:01:03 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95CE29E0D
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hx15so40244763ejc.11
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4b0gzVsxfEDBk+JDTdDvkxVPx/flrfnXIUXp8EED98=;
        b=Rj+gDejhI2iydjO+Cmu9XjUR7MbDPZkXo2+kUch26DAXv+3VADkP8UBAEo2sVPXjTN
         2hrG+K7FpXd12oRnTlejJp9mG2rXArdinfDI65lyQLCsVcfSgF6Zm4uCpUAw67wfU6/v
         M+GtrWU0shqCfn3ykR7ZU8MhBdID8/Ia88xA0AZvGH+2IJ/zPVcmU8/i3FsqPWqOrXRb
         nsM9mUABMVxRcDHcGbBw3faIUdBjVI128XkzjSlSYInXJWxJUaYTs6rVmYSzVwwj6EUy
         aoRZyzU0pJ4UmDiCggc1Rqv4lpfr2cbreg01H0+X1ePNEGwgjDtY6sk1Hd0tJ7ZZXluC
         Bo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4b0gzVsxfEDBk+JDTdDvkxVPx/flrfnXIUXp8EED98=;
        b=53M8d3DZ14fxJlhz18fdhYbZ0KRYjzquBA0/NQyTYIM5hg+geq9/CHOVZb5B9fXxRL
         FN98Bt/7gNtAJOECQrTSeXRKTBncrka7hO9uAPcQHqqkFiviA992h0jXElnzjgDV2Sgb
         F90+jG2SstTPaP+JnMj2Fqzuo3h+arFgHopTIbrhYZzVz3U+Kw8N0hk8WuR77Kj4p6AX
         zWKmO/xpRKHunelLY44auhswUsN2yLlc22x4J3oBrGcZRAdTKBOl7qlPzySnbWhgwmYR
         LpyY7w2fFW99sJ7sitDFZ2r4IpqAIcUrCtW0cVbjnRQwR1MtKsKS6YJyiu04KWm+AcQm
         jLLw==
X-Gm-Message-State: AO0yUKW7DDhh18/9HD8e43y9KqGzonXaMwazqX7XTBbYtWoAP2CyCaFP
        X9mX2jpOc34l61ehHFyCqF3pLZ/9vlo=
X-Google-Smtp-Source: AK7set++azwP/SZsh95wkHL5N/K3m68WI4lWJq3JIxdLUxVNbvY3tFi7TtV3RCSXa/vRYj6v/6Um7A==
X-Received: by 2002:a17:906:7f09:b0:878:5976:5bb7 with SMTP id d9-20020a1709067f0900b0087859765bb7mr2809438ejr.8.1676383231323;
        Tue, 14 Feb 2023 06:00:31 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id r1-20020a17090638c100b0088091cca1besm8273624ejd.134.2023.02.14.06.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:00:30 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     rick.wertenbroek@heig-vd.ch
Cc:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 7/9] PCI: rockchip: Fix legacy IRQ generation for RK3399 PCIe endpoint core
Date:   Tue, 14 Feb 2023 14:56:28 +0100
Message-Id: <20230214135630.1131245-8-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214135630.1131245-1-rick.wertenbroek@gmail.com>
References: <20230214135630.1131245-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix legacy IRQ generation for RK3399 PCIe endpoint core according to
the technical reference manual (TRM). Assert and deassert legacy
interrupt (INTx) through the legacy interrupt control register
("PCIE_CLIENT_LEGACY_INT_CTRL") instead of manually generating a PCIe
message. The generation of the legacy interrupt was tested and validated
with the PCIe endpoint test driver.

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 38 +++++------------------
 drivers/pci/controller/pcie-rockchip.h    |  6 ++++
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index cbc281a6a..ca5b363ba 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -328,45 +328,23 @@ static void rockchip_pcie_ep_assert_intx(struct rockchip_pcie_ep *ep, u8 fn,
 					 u8 intx, bool is_asserted)
 {
 	struct rockchip_pcie *rockchip = &ep->rockchip;
-	u32 r = ep->max_regions - 1;
-	u32 offset;
-	u32 status;
-	u8 msg_code;
-
-	if (unlikely(ep->irq_pci_addr != ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR ||
-		     ep->irq_pci_fn != fn)) {
-		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, r,
-					     AXI_WRAPPER_NOR_MSG,
-					     ep->irq_phys_addr, 0, 0);
-		ep->irq_pci_addr = ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR;
-		ep->irq_pci_fn = fn;
-	}
 
 	intx &= 3;
 	if (is_asserted) {
 		ep->irq_pending |= BIT(intx);
-		msg_code = ROCKCHIP_PCIE_MSG_CODE_ASSERT_INTA + intx;
 	} else {
 		ep->irq_pending &= ~BIT(intx);
-		msg_code = ROCKCHIP_PCIE_MSG_CODE_DEASSERT_INTA + intx;
 	}
 
-	status = rockchip_pcie_read(rockchip,
-				    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
-				    ROCKCHIP_PCIE_EP_CMD_STATUS);
-	status &= ROCKCHIP_PCIE_EP_CMD_STATUS_IS;
-
-	if ((status != 0) ^ (ep->irq_pending != 0)) {
-		status ^= ROCKCHIP_PCIE_EP_CMD_STATUS_IS;
-		rockchip_pcie_write(rockchip, status,
-				    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
-				    ROCKCHIP_PCIE_EP_CMD_STATUS);
+	if (is_asserted) {
+		rockchip_pcie_write(rockchip,
+			PCIE_CLIENT_INT_IN_ASSERT | PCIE_CLIENT_INT_PEND_ST_PEND,
+			PCIE_CLIENT_LEGACY_INT_CTRL);
+	} else {
+		rockchip_pcie_write(rockchip,
+			PCIE_CLIENT_INT_IN_DEASSERT | PCIE_CLIENT_INT_PEND_ST_NORMAL,
+			PCIE_CLIENT_LEGACY_INT_CTRL);
 	}
-
-	offset =
-	   ROCKCHIP_PCIE_MSG_ROUTING(ROCKCHIP_PCIE_MSG_ROUTING_LOCAL_INTX) |
-	   ROCKCHIP_PCIE_MSG_CODE(msg_code) | ROCKCHIP_PCIE_MSG_NO_DATA;
-	writel(0, ep->irq_cpu_addr + offset);
 }
 
 static int rockchip_pcie_ep_send_legacy_irq(struct rockchip_pcie_ep *ep, u8 fn,
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 72e427a0f..e90c2a2b8 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -39,6 +39,12 @@
 #define   PCIE_CLIENT_GEN_SEL_1		  HIWORD_UPDATE(0x0080, 0)
 #define   PCIE_CLIENT_GEN_SEL_2		  HIWORD_UPDATE_BIT(0x0080)
 #define PCIE_CLIENT_SIDE_BAND_STATUS	(PCIE_CLIENT_BASE + 0x20)
+#define PCIE_CLIENT_LEGACY_INT_CTRL		(PCIE_CLIENT_BASE + 0x0c)
+#define   PCIE_CLIENT_INT_IN_ASSERT		HIWORD_UPDATE_BIT(0x0002)
+#define   PCIE_CLIENT_INT_IN_DEASSERT	HIWORD_UPDATE(0x0002, 0)
+#define   PCIE_CLIENT_INT_PEND_ST_PEND	HIWORD_UPDATE_BIT(0x0001)
+#define   PCIE_CLIENT_INT_PEND_ST_NORMAL	HIWORD_UPDATE(0x0001, 0)
+#define PCIE_CLIENT_SIDE_BAND_STATUS	(PCIE_CLIENT_BASE + 0x20)
 #define   PCIE_CLIENT_PHY_ST			BIT(12)
 #define PCIE_CLIENT_DEBUG_OUT_0		(PCIE_CLIENT_BASE + 0x3c)
 #define   PCIE_CLIENT_DEBUG_LTSSM_MASK		GENMASK(5, 0)
-- 
2.25.1

