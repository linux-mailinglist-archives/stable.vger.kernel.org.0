Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DC24CF793
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiCGJql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238096AbiCGJmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD8C15A18;
        Mon,  7 Mar 2022 01:41:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A30B80F9F;
        Mon,  7 Mar 2022 09:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74A7C340F3;
        Mon,  7 Mar 2022 09:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646081;
        bh=Wt7B/bnSJ1P0KwmJ/NMxbKs0Pkrp1FbTdd1lziXU4UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rw3PMJiydzWuf8Nf5zWqeN+ROkTHZgS+qO9mu7+K7HrasMlyiAM08GZ0l4zw3CFwy
         kRX1fa2JfTUR05GrmqeS0XLXGPjzg2A0rEfMZuuOKf1DmazOjpzL+EUTGjKruEewju
         TSqqrk72W95IkHTNIhdsyFmZRcnMLKB74Z5HLXc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/262] of: net: move of_net under net/
Date:   Mon,  7 Mar 2022 10:17:49 +0100
Message-Id: <20220307091705.986552104@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e330fb14590c5c80f7195c3d8c9b4bcf79e1a5cd ]

Rob suggests to move of_net.c from under drivers/of/ somewhere
to the networking code.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/Kconfig    | 2 +-
 drivers/net/ethernet/arc/Kconfig    | 4 ++--
 drivers/net/ethernet/ezchip/Kconfig | 2 +-
 drivers/net/ethernet/litex/Kconfig  | 2 +-
 drivers/net/ethernet/mscc/Kconfig   | 2 +-
 drivers/of/Kconfig                  | 4 ----
 drivers/of/Makefile                 | 1 -
 include/linux/of_net.h              | 2 +-
 net/core/Makefile                   | 1 +
 net/core/net-sysfs.c                | 2 +-
 {drivers/of => net/core}/of_net.c   | 0
 11 files changed, 9 insertions(+), 13 deletions(-)
 rename {drivers/of => net/core}/of_net.c (100%)

diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index 4786f0504691d..899c8a2a34b6b 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -168,7 +168,7 @@ config SUNLANCE
 
 config AMD_XGBE
 	tristate "AMD 10GbE Ethernet driver"
-	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM
+	depends on (OF_ADDRESS || ACPI || PCI) && HAS_IOMEM
 	depends on X86 || ARM64 || COMPILE_TEST
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select BITREVERSE
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index 92a79c4ffa2c7..0a67612af2281 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -26,7 +26,7 @@ config ARC_EMAC_CORE
 config ARC_EMAC
 	tristate "ARC EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET
+	depends on OF_IRQ
 	depends on ARC || COMPILE_TEST
 	help
 	  On some legacy ARC (Synopsys) FPGA boards such as ARCAngel4/ML50x
@@ -36,7 +36,7 @@ config ARC_EMAC
 config EMAC_ROCKCHIP
 	tristate "Rockchip EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET && REGULATOR
+	depends on OF_IRQ && REGULATOR
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	help
 	  Support for Rockchip RK3036/RK3066/RK3188 EMAC ethernet controllers.
diff --git a/drivers/net/ethernet/ezchip/Kconfig b/drivers/net/ethernet/ezchip/Kconfig
index 38aa824efb25d..9241b9b1c7a36 100644
--- a/drivers/net/ethernet/ezchip/Kconfig
+++ b/drivers/net/ethernet/ezchip/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_EZCHIP
 
 config EZCHIP_NPS_MANAGEMENT_ENET
 	tristate "EZchip NPS management enet support"
-	depends on OF_IRQ && OF_NET
+	depends on OF_IRQ
 	depends on HAS_IOMEM
 	help
 	  Simple LAN device for debug or management purposes.
diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
index 63bf01d28f0cf..f99adbf26ab4e 100644
--- a/drivers/net/ethernet/litex/Kconfig
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_LITEX
 
 config LITEX_LITEETH
 	tristate "LiteX Ethernet support"
-	depends on OF_NET
+	depends on OF
 	help
 	  If you wish to compile a kernel for hardware with a LiteX LiteEth
 	  device then you should answer Y to this.
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index b6a73d151dec1..8dd8c7f425d2c 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -28,7 +28,7 @@ config MSCC_OCELOT_SWITCH
 	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
-	depends on OF_NET
+	depends on OF
 	select MSCC_OCELOT_SWITCH_LIB
 	select GENERIC_PHY
 	help
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 3dfeae8912dfc..80b5fd44ab1c7 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -70,10 +70,6 @@ config OF_IRQ
 	def_bool y
 	depends on !SPARC && IRQ_DOMAIN
 
-config OF_NET
-	depends on NETDEVICES
-	def_bool y
-
 config OF_RESERVED_MEM
 	def_bool OF_EARLY_FLATTREE
 
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index c13b982084a3a..e0360a44306e2 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
 obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
-obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_UNITTEST) += unittest.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index daef3b0d9270d..cf31188329b5a 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -8,7 +8,7 @@
 
 #include <linux/phy.h>
 
-#ifdef CONFIG_OF_NET
+#ifdef CONFIG_OF
 #include <linux/of.h>
 
 struct net_device;
diff --git a/net/core/Makefile b/net/core/Makefile
index 35ced6201814c..4268846f2f475 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
+obj-$(CONFIG_OF)	+= of_net.o
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index a4ae652633844..d7f9ee830d34c 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1927,7 +1927,7 @@ static struct class net_class __ro_after_init = {
 	.get_ownership = net_get_ownership,
 };
 
-#ifdef CONFIG_OF_NET
+#ifdef CONFIG_OF
 static int of_dev_node_match(struct device *dev, const void *data)
 {
 	for (; dev; dev = dev->parent) {
diff --git a/drivers/of/of_net.c b/net/core/of_net.c
similarity index 100%
rename from drivers/of/of_net.c
rename to net/core/of_net.c
-- 
2.34.1



