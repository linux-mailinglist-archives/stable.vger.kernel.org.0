Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B346965A2
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBNOBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjBNOBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:01:03 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD0C29E04
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id sa10so40256630ejc.9
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJTwPyCQKw5xBpJ8wEGHmbNEVhauYC4jLoYSRftpEKg=;
        b=jq0g/BJtaUerhPIqyfi+wQOwRz7qGV6n1NHNbWj+z100eYf+UhE9NRPl+Eisfz/OXz
         jlrmWXVcqIvAN4o9Dd98TUt4dd0Hw2HKUol1klCGtIgvWAw+4KnPGvS8TefeVHT/4QOa
         B43siFbVR9t4uJO33iBq0MC7iO/HVLNw0atZ7tik5S2RQ9RVsJwghoQV+fd0/+Pf6oXl
         4izXl9S9Z1l4yDIrznunQOjwsqu8mEgLAPxpQkNIpeNzGL0Vjlb6HQD60ul50LRmIWb9
         QEk8oOIVGdfIWF78+00uLAAh4dtmUOyDlqkn1rpOl8ZkGYicxhhdI8CbRI4Lk+zc+SN2
         EhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJTwPyCQKw5xBpJ8wEGHmbNEVhauYC4jLoYSRftpEKg=;
        b=MZo8UZX8zUa5B24X3lYMm77fCEFykvIR+oNNzOZ6J8Z4Ptbq55P2V5R4zpVllOrEWa
         eaV10yiRCGNzwUMGNd6wcmXOnfq7YomgQlIL7oYW5OdRbOu1AzHlz2mqdJwAaLAlkGlN
         9FlxUrO7F0FZZDuoyjc1HCwhsjf/ydgTR6jcysqS5kKKSd9sQ0NvT/GpCTBUuCt/fDha
         E3NidFS4XQisfC6DKIesHIdE9VbBVBmu4Pzd4b7QHsZRiyk8CYzcXufdWzVinOth+G6Z
         ahO1YscjHbmaJw+qcKL09YqB29coTeX8XvtPd5oNJwcDpwjFjAhqmPijsBOQaJIIcUuP
         +24Q==
X-Gm-Message-State: AO0yUKVCI+8L+vTiZ3XgNcv+wrqVFyLJIQv4YBkD9NRYNNLS4IilZX0h
        ihvrCL/R3sdokJ2vhGVAGu0=
X-Google-Smtp-Source: AK7set80QU4AWU4gQWmurwfk+XqxK22vaFbVipTyuytxQQ+V7bYNVtw/u8SisdFidQBIdWULg258wg==
X-Received: by 2002:a17:906:a2d6:b0:883:b1b4:e798 with SMTP id by22-20020a170906a2d600b00883b1b4e798mr2848590ejb.10.1676383227131;
        Tue, 14 Feb 2023 06:00:27 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id r1-20020a17090638c100b0088091cca1besm8273624ejd.134.2023.02.14.06.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:00:26 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     rick.wertenbroek@heig-vd.ch
Cc:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/9] PCI: rockchip: Write PCI Device ID to correct register
Date:   Tue, 14 Feb 2023 14:56:23 +0100
Message-Id: <20230214135630.1131245-3-rick.wertenbroek@gmail.com>
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

