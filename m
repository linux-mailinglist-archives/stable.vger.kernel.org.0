Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E2C6965A1
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjBNOBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjBNOBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:01:02 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA23729E11
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id gn39so1992528ejc.8
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wlhNVngokcMAaPIU9YsiNMvp+CICZXJFUIQaHO3ObSo=;
        b=VwcRa2shrLWdEF4tl/g0hdjjS3I64JZF1ZnOFYP7t/spidjjARse1lXguRFfSaCs0l
         qLYkNdRUyS8mOYgISzSkSBjy4MYT+WclSIr2A5h0vFKBVdGOCAPFu0mqsDapYFH3fZsj
         YtKXYw3E2nVvKbstCj+JPGng/xewyNrzQGiVJvdDnydfg7rMWoqw/JrwzbaLQxUVOQKP
         ZE7qzxtJB95qgHi5E3aZ+NmGo7sKcsS8OK5On6YxEl0Ge81mI9b1GT5kdcWyGpMNW8hD
         r/63bs3xh4dYnY99VkT379UkHDCdbcYljYrH00rkFLIuVPC3sGuKyRcv5U96Ir/KSXZo
         wA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlhNVngokcMAaPIU9YsiNMvp+CICZXJFUIQaHO3ObSo=;
        b=xscPqSemfALJehX67oco1avuMQ9QXxuo4S3P6fs/oHa4XiSvDOcPGTqKCVmsTVj4J5
         MKgM+ueOoj/4UYJHzxRwPZDz+drzQFTjvtsMJT3m/gpjbD5u2IYUnmG3BJy2wnfAgRNg
         GKGFcG0kFEM4yK2WFqHSb7Q9pqkRWFmci60NlnpbW/ociIgtf9mV2ZanO4u0AgclRfc6
         ZAHMps/oSpTBxH7OzaGVCnunplPlnvA45pJIRGIz4+JgirxhqamhDpt0BMaljFKCP/1z
         Phk071JjlQPmOjre1pMQK0pDLPz20OvYavxJqQcsEd/YE6iH1JLfg3htM2eICUO3E9eT
         cZEw==
X-Gm-Message-State: AO0yUKX7xBTT10fiOQDb7J3OT+HxL0MD7MLjdB1VIRjnjIpnoSGFWazE
        plYR8/2yuKhxMa2mQTIJr9ZubCR6tB8=
X-Google-Smtp-Source: AK7set8oaoz/3vqFdXKERpKW1HcbIC7cuEfUKZ2bHMo08t/H9NfK6qPr4yeESOs5I+auOeB64q7aRg==
X-Received: by 2002:a17:906:4dc2:b0:886:7e24:82eb with SMTP id f2-20020a1709064dc200b008867e2482ebmr2903048ejw.21.1676383228884;
        Tue, 14 Feb 2023 06:00:28 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id r1-20020a17090638c100b0088091cca1besm8273624ejd.134.2023.02.14.06.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:00:28 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     rick.wertenbroek@heig-vd.ch
Cc:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 4/9] PCI: rockchip: Add poll and timeout to wait for PHY PLLs to be locked
Date:   Tue, 14 Feb 2023 14:56:25 +0100
Message-Id: <20230214135630.1131245-5-rick.wertenbroek@gmail.com>
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

The RK3399 PCIe controller should wait until the PHY PLLs are locked.
Add poll and timeout to wait for PHY PLLs to be locked. If they cannot
be locked generate error message and jump to error handler. Accessing
registers in the PHY clock domain when PLLs are not locked causes hang
The PHY PLLs status is checked through a side channel register.
This is documented in the TRM section 17.5.8.1 "PCIe Initialization
Sequence".

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip.c | 16 ++++++++++++++++
 drivers/pci/controller/pcie-rockchip.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
index 990a00e08..5f2e2dd5d 100644
--- a/drivers/pci/controller/pcie-rockchip.c
+++ b/drivers/pci/controller/pcie-rockchip.c
@@ -14,6 +14,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
+#include <linux/iopoll.h>
 #include <linux/of_pci.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
@@ -153,6 +154,12 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 }
 EXPORT_SYMBOL_GPL(rockchip_pcie_parse_dt);
 
+#define rockchip_pcie_read_addr(addr) rockchip_pcie_read(rockchip, addr)
+/* 100 ms max wait time for PHY PLLs to lock */
+#define RK_PHY_PLL_LOCK_TIMEOUT_US 100000
+/* Sleep should be less than 20ms */
+#define RK_PHY_PLL_LOCK_SLEEP_US 1000
+
 int rockchip_pcie_init_port(struct rockchip_pcie *rockchip)
 {
 	struct device *dev = rockchip->dev;
@@ -254,6 +261,15 @@ int rockchip_pcie_init_port(struct rockchip_pcie *rockchip)
 		}
 	}
 
+	err = readx_poll_timeout(rockchip_pcie_read_addr, PCIE_CLIENT_SIDE_BAND_STATUS,
+		regs, !(regs & PCIE_CLIENT_PHY_ST), RK_PHY_PLL_LOCK_SLEEP_US,
+		RK_PHY_PLL_LOCK_TIMEOUT_US);
+
+	if (err) {
+		dev_err(dev, "PHY PLLs could not lock, %d\n", err);
+		goto err_power_off_phy;
+	}
+
 	/*
 	 * Please don't reorder the deassert sequence of the following
 	 * four reset pins.
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 51a123e5c..f3a5ff1cf 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -38,6 +38,8 @@
 #define   PCIE_CLIENT_MODE_EP            HIWORD_UPDATE(0x0040, 0)
 #define   PCIE_CLIENT_GEN_SEL_1		  HIWORD_UPDATE(0x0080, 0)
 #define   PCIE_CLIENT_GEN_SEL_2		  HIWORD_UPDATE_BIT(0x0080)
+#define PCIE_CLIENT_SIDE_BAND_STATUS	(PCIE_CLIENT_BASE + 0x20)
+#define   PCIE_CLIENT_PHY_ST			BIT(12)
 #define PCIE_CLIENT_DEBUG_OUT_0		(PCIE_CLIENT_BASE + 0x3c)
 #define   PCIE_CLIENT_DEBUG_LTSSM_MASK		GENMASK(5, 0)
 #define   PCIE_CLIENT_DEBUG_LTSSM_L1		0x18
-- 
2.25.1

