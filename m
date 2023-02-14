Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B311696607
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbjBNOKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbjBNOKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:10:44 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA1829E14;
        Tue, 14 Feb 2023 06:10:12 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ml19so40537589ejb.0;
        Tue, 14 Feb 2023 06:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJTwPyCQKw5xBpJ8wEGHmbNEVhauYC4jLoYSRftpEKg=;
        b=kkFxkofTxxdGhjgj3REYIMX9GeLMAeendKxgveM/SC4TYLmR+K165wntSVZkcT61W4
         h6B6VVvZZFu8+tLVlu7t7atlSqNdbPm8OskYI1ZFZ7TJvgEFqyZcXpM3lghFOty+18e6
         vuLSNm6c4lEJ4xuPF3HOZ8n84/CVGect/6JMku3YXYtOdC0JXl2GvRqNdDzbaVN9oeUR
         V8emS1cvyF5+pvlZlmvYD3QIlNVe7JqrO60fsOkjHTQvBatJogE9FB3U/EpsvX4gxNqY
         1brOKk5Pv6t4Z+oRztT9NU6zThbDpdShToPEiL0DsRtUfRs8P4OTNUwrbx+SCdYcEmBi
         w0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJTwPyCQKw5xBpJ8wEGHmbNEVhauYC4jLoYSRftpEKg=;
        b=6tIWUhJiOrzo5Ma1ZIRrT12RHER3t4mTWJL9U1VFIe20d7IAyOJ52mb7901PM4YQEP
         Y+rSqezAgOuWR0YhLr0PHPScCoD/OPUl/Df0L3cG13tOjtFex7GGKBYRCt2SGRIHWs63
         iYPMl0u5VwjjDRIXVzpBGUGABt38ubK91OfEF7W5fv9wkDqZERISngiaTRsDhNKx428k
         K2Zv4DCF/nyiAIOqn133IwasP5l7UD+d1ZT5DCPtdr8iVmPXXGlhE/Mnrk8J40vN9FYz
         4twYWqKbsJl9LpGQfdA5GSzM9ESGqTU4xuth1Qu66YAJwG8NlxmxQvW8Tv/U8LQVPwSr
         F/fw==
X-Gm-Message-State: AO0yUKVrLIY48IA/zUUKTA2Lu1gJJi87XtBfbEZJ9xRUYXUXCjDvsvFl
        XTfoR+7crYXdbELpkLUaOKI=
X-Google-Smtp-Source: AK7set/c5lGyAwr4OVJk7RpIJxVAqoq2U13GK1o+yKE8UmSYOwLhqX6RvdpoS/x46llDlPwkZ1J+AQ==
X-Received: by 2002:a17:907:7d8a:b0:8aa:b526:36b3 with SMTP id oz10-20020a1709077d8a00b008aab52636b3mr4107755ejc.14.1676383797839;
        Tue, 14 Feb 2023 06:09:57 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id n11-20020a1709065e0b00b008b13814f804sm332241eju.186.2023.02.14.06.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:09:57 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, rick.wertenbroek@heig-vd.ch,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 2/9] PCI: rockchip: Write PCI Device ID to correct register
Date:   Tue, 14 Feb 2023 15:08:50 +0100
Message-Id: <20230214140858.1133292-3-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
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

Write PCI Device ID (DID) to the correct register. The Device ID was not
updated through the correct register. Device ID was written to a read-only
register and therefore did not work. The Device ID is now set through the
correct register. This is documented in the RK3399 TRM section 17.6.6.1.1

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 6 ++++--
 drivers/pci/controller/pcie-rockchip.h    | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index d5c477020..9b835377b 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -115,6 +115,7 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
 static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn, u8 vfn,
 					 struct pci_epf_header *hdr)
 {
+	u32 reg;
 	struct rockchip_pcie_ep *ep = epc_get_drvdata(epc);
 	struct rockchip_pcie *rockchip = &ep->rockchip;
 
@@ -127,8 +128,9 @@ static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn, u8 vfn,
 				    PCIE_CORE_CONFIG_VENDOR);
 	}
 
-	rockchip_pcie_write(rockchip, hdr->deviceid << 16,
-			    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) + PCI_VENDOR_ID);
+	reg = rockchip_pcie_read(rockchip, PCIE_EP_CONFIG_DID_VID);
+	reg = (reg & 0xFFFF) | (hdr->deviceid << 16);
+	rockchip_pcie_write(rockchip, reg, PCIE_EP_CONFIG_DID_VID);
 
 	rockchip_pcie_write(rockchip,
 			    hdr->revid |
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index 32c3a859c..51a123e5c 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -133,6 +133,8 @@
 #define PCIE_RC_RP_ATS_BASE		0x400000
 #define PCIE_RC_CONFIG_NORMAL_BASE	0x800000
 #define PCIE_RC_CONFIG_BASE		0xa00000
+#define PCIE_EP_CONFIG_BASE		0xa00000
+#define PCIE_EP_CONFIG_DID_VID		(PCIE_EP_CONFIG_BASE + 0x00)
 #define PCIE_RC_CONFIG_RID_CCR		(PCIE_RC_CONFIG_BASE + 0x08)
 #define PCIE_RC_CONFIG_DCR		(PCIE_RC_CONFIG_BASE + 0xc4)
 #define   PCIE_RC_CONFIG_DCR_CSPL_SHIFT		18
-- 
2.25.1

