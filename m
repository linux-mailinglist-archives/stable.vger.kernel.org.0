Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82EC6E5AE6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 09:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjDRHtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 03:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjDRHsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 03:48:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974295FEC;
        Tue, 18 Apr 2023 00:48:11 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id sz19so13756797ejc.2;
        Tue, 18 Apr 2023 00:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681804090; x=1684396090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l19cpi11+VLyNXUHh2KnWwPalv9JqFIq3IuDMicAupg=;
        b=pSX84xqzROANM2hGagaRoX4id6ox42yfA50GClMgbs+YZH7nTYGOdUgWghtiKreplP
         NQv8ZMH3HV9fhzQVoF/zoWyl2qL5mVYr2QUicz0exYzD9qFqbWtbbk+6+KFropKfzUGm
         Sa5YJab2vdhC5y+gdkjyc0oqAun1dee6tCcVnlPPNgElOe8QMr85r3l6GpH0BV+h68KO
         gE5MLYyFFbHiHwEXFdyX+HVRJKkpBXOGTPJDxOfP0QQXhdibcX6q9HNL1pcEw1yXI+ZE
         UvSceRdFCa0cS7VTF0nKywgHarEoqh3WRCsRjA44bFTSh0hI49NZzTvVFETNdrcwp2Ez
         CPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681804090; x=1684396090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l19cpi11+VLyNXUHh2KnWwPalv9JqFIq3IuDMicAupg=;
        b=Y2cBnJYaMvZTyo0ufjx1wM9x34biLvT8ww6oU8h4ZKQQAj9e5VP7DBragAgtzVYyP/
         urA47XvCfDzWy9QOj60K6kuJ+vOLWf/429X71s8JMFC6y8YY7Zpd5w1Q1dao8T+J9i15
         kCrQVPuo40k5veXHQQBC5/8Byttr3/jp5CsXZFG8rvpQGaxvKXWVe1NOXGxoZP2kc7xA
         PxdDiKFHzcQG0TYbTcbAEp13q7m3cjmI25TH423G8jR+iFalAVFGv5OUyslJRsCoziar
         AfNBSrN1I/Zcw4KFVBCjinYN+zaTT33gzeCEoys3OPZiMNv67zxjjij0v4TWiPCs5bYK
         O81A==
X-Gm-Message-State: AAQBX9eGUg3sKdWxknI88vbCQvcnmpP0wdBP0t6aoumcTXNzGW8lAetZ
        u//3v+FFBUdof5ow/iQPxaU=
X-Google-Smtp-Source: AKy350YBgXj2bPbCmHnmYdvZoLazNpv7yPdzMrGyRKc78iy8XexClRw1CNKw6QRlNpVA0xR9I2rrrQ==
X-Received: by 2002:a17:907:160b:b0:94f:9cd7:adff with SMTP id hb11-20020a170907160b00b0094f9cd7adffmr4663896ejc.18.1681804089808;
        Tue, 18 Apr 2023 00:48:09 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id gs8-20020a1709072d0800b0094f694e4ecbsm3048545ejc.146.2023.04.18.00.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 00:48:09 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, dlemoal@kernel.org,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Brian Norris <briannorris@chromium.org>,
        Caleb Connolly <kc@postmarketos.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/11] PCI: rockchip: Use u32 variable to access 32-bit registers
Date:   Tue, 18 Apr 2023 09:46:56 +0200
Message-Id: <20230418074700.1083505-10-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
References: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously u16 variables were used to access 32-bit registers, this
resulted in not all of the data being read from the registers. Also
the left shift of more than 16-bits would result in moving data out
of the variable. Use u32 variables to access 32-bit registers

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 10 +++++-----
 drivers/pci/controller/pcie-rockchip.h    |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 771f1bb93251..63fbb379638b 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -271,15 +271,15 @@ static int rockchip_pcie_ep_set_msi(struct pci_epc *epc, u8 fn, u8 vfn,
 {
 	struct rockchip_pcie_ep *ep = epc_get_drvdata(epc);
 	struct rockchip_pcie *rockchip = &ep->rockchip;
-	u16 flags;
+	u32 flags;
 
 	flags = rockchip_pcie_read(rockchip,
 				   ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
 				   ROCKCHIP_PCIE_EP_MSI_CTRL_REG);
 	flags &= ~ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_MASK;
 	flags |=
-	   ((multi_msg_cap << 1) <<  ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET) |
-	   PCI_MSI_FLAGS_64BIT;
+	   (multi_msg_cap << ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET) |
+	   (PCI_MSI_FLAGS_64BIT << ROCKCHIP_PCIE_EP_MSI_FLAGS_OFFSET);
 	flags &= ~ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP;
 	rockchip_pcie_write(rockchip, flags,
 			    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
@@ -291,7 +291,7 @@ static int rockchip_pcie_ep_get_msi(struct pci_epc *epc, u8 fn, u8 vfn)
 {
 	struct rockchip_pcie_ep *ep = epc_get_drvdata(epc);
 	struct rockchip_pcie *rockchip = &ep->rockchip;
-	u16 flags;
+	u32 flags;
 
 	flags = rockchip_pcie_read(rockchip,
 				   ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
@@ -352,7 +352,7 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
 					 u8 interrupt_num)
 {
 	struct rockchip_pcie *rockchip = &ep->rockchip;
-	u16 flags, mme, data, data_mask;
+	u32 flags, mme, data, data_mask;
 	u8 msi_count;
 	u64 pci_addr;
 	u32 r;
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index bef6d7098a2f..501d859420b4 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -227,6 +227,7 @@
 #define ROCKCHIP_PCIE_EP_CMD_STATUS			0x4
 #define   ROCKCHIP_PCIE_EP_CMD_STATUS_IS		BIT(19)
 #define ROCKCHIP_PCIE_EP_MSI_CTRL_REG			0x90
+#define   ROCKCHIP_PCIE_EP_MSI_FLAGS_OFFSET		16
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET		17
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_MASK		GENMASK(19, 17)
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MME_OFFSET		20
-- 
2.25.1

