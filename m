Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6A25A4C05
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiH2Mg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiH2Mgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:36:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8344B1D31A;
        Mon, 29 Aug 2022 05:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB5AB80F4B;
        Mon, 29 Aug 2022 11:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C2CC433C1;
        Mon, 29 Aug 2022 11:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771508;
        bh=Ky9nomgv1UdChL3vKwYjaaj0E8a3NGLhtr35o/ZcjRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQvlS1iLgrJMsAQTe4UHcDr3lGWyzmib/R3E1MhRwVtF0drTBOWFs4SIPoH3S7e4Q
         Uya5kLnkp1ETIbIyZ3HlPTIKXCPFyDQlR/lwbnIsvFv3+siJsYpAK5detwf6sewCBT
         NhcUKR55tg5VmKC256Zz8UwC/pY7aBWXjhspazyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 038/158] net: dsa: microchip: move switch chip_id detection to ksz_common
Date:   Mon, 29 Aug 2022 12:58:08 +0200
Message-Id: <20220829105810.382846006@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Ramadoss <arun.ramadoss@microchip.com>

[ Upstream commit 91a98917a8839923d404a77c21646ca5fc9e330a ]

KSZ87xx and KSZ88xx have chip_id representation at reg location 0. And
KSZ9477 compatible switch and LAN937x switch have same chip_id detection
at location 0x01 and 0x02. To have the common switch detect
functionality for ksz switches, ksz_switch_detect function is
introduced.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c     | 48 +--------------
 drivers/net/dsa/microchip/ksz8795_reg.h | 16 -----
 drivers/net/dsa/microchip/ksz9477.c     | 21 -------
 drivers/net/dsa/microchip/ksz9477_reg.h |  1 -
 drivers/net/dsa/microchip/ksz_common.c  | 78 +++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h  | 19 +++++-
 6 files changed, 93 insertions(+), 90 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 12a599d5e61a4..3cc51ee5fb6cc 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1272,7 +1272,7 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
 			continue;
 		if (!ksz_is_ksz88x3(dev)) {
 			ksz_pread8(dev, i, regs[P_REMOTE_STATUS], &remote);
-			if (remote & PORT_FIBER_MODE)
+			if (remote & KSZ8_PORT_FIBER_MODE)
 				p->fiber = 1;
 		}
 		if (p->fiber)
@@ -1424,51 +1424,6 @@ static u32 ksz8_get_port_addr(int port, int offset)
 	return PORT_CTRL_ADDR(port, offset);
 }
 
-static int ksz8_switch_detect(struct ksz_device *dev)
-{
-	u8 id1, id2;
-	u16 id16;
-	int ret;
-
-	/* read chip id */
-	ret = ksz_read16(dev, REG_CHIP_ID0, &id16);
-	if (ret)
-		return ret;
-
-	id1 = id16 >> 8;
-	id2 = id16 & SW_CHIP_ID_M;
-
-	switch (id1) {
-	case KSZ87_FAMILY_ID:
-		if ((id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
-			return -ENODEV;
-
-		if (id2 == CHIP_ID_95) {
-			u8 val;
-
-			id2 = 0x95;
-			ksz_read8(dev, REG_PORT_STATUS_0, &val);
-			if (val & PORT_FIBER_MODE)
-				id2 = 0x65;
-		} else if (id2 == CHIP_ID_94) {
-			id2 = 0x94;
-		}
-		break;
-	case KSZ88_FAMILY_ID:
-		if (id2 != CHIP_ID_63)
-			return -ENODEV;
-		break;
-	default:
-		dev_err(dev->dev, "invalid family id: %d\n", id1);
-		return -ENODEV;
-	}
-	id16 &= ~0xff;
-	id16 |= id2;
-	dev->chip_id = id16;
-
-	return 0;
-}
-
 static int ksz8_switch_init(struct ksz_device *dev)
 {
 	struct ksz8 *ksz8 = dev->priv;
@@ -1522,7 +1477,6 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
 	.shutdown = ksz8_reset_switch,
-	.detect = ksz8_switch_detect,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
 };
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 4109433b6b6c2..b8f6ad7581bcd 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -14,23 +14,10 @@
 #define KS_PRIO_M			0x3
 #define KS_PRIO_S			2
 
-#define REG_CHIP_ID0			0x00
-
-#define KSZ87_FAMILY_ID			0x87
-#define KSZ88_FAMILY_ID			0x88
-
-#define REG_CHIP_ID1			0x01
-
-#define SW_CHIP_ID_M			0xF0
-#define SW_CHIP_ID_S			4
 #define SW_REVISION_M			0x0E
 #define SW_REVISION_S			1
 #define SW_START			0x01
 
-#define CHIP_ID_94			0x60
-#define CHIP_ID_95			0x90
-#define CHIP_ID_63			0x30
-
 #define KSZ8863_REG_SW_RESET		0x43
 
 #define KSZ8863_GLOBAL_SOFTWARE_RESET	BIT(4)
@@ -217,8 +204,6 @@
 #define REG_PORT_4_STATUS_0		0x48
 
 /* For KSZ8765. */
-#define PORT_FIBER_MODE			BIT(7)
-
 #define PORT_REMOTE_ASYM_PAUSE		BIT(5)
 #define PORT_REMOTE_SYM_PAUSE		BIT(4)
 #define PORT_REMOTE_100BTX_FD		BIT(3)
@@ -322,7 +307,6 @@
 
 #define REG_PORT_CTRL_5			0x05
 
-#define REG_PORT_STATUS_0		0x08
 #define REG_PORT_STATUS_1		0x09
 #define REG_PORT_LINK_MD_CTRL		0x0A
 #define REG_PORT_LINK_MD_RESULT		0x0B
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 876a801ac23a4..bcfdd505ca79a 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1363,23 +1363,6 @@ static u32 ksz9477_get_port_addr(int port, int offset)
 	return PORT_CTRL_ADDR(port, offset);
 }
 
-static int ksz9477_switch_detect(struct ksz_device *dev)
-{
-	u32 id32;
-	int ret;
-
-	/* read chip id */
-	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
-	if (ret)
-		return ret;
-
-	dev_dbg(dev->dev, "Switch detect: ID=%08x\n", id32);
-
-	dev->chip_id = id32 & 0x00FFFF00;
-
-	return 0;
-}
-
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
 	u8 data8;
@@ -1410,8 +1393,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	dev->features = GBIT_SUPPORT;
 
 	if (dev->chip_id == KSZ9893_CHIP_ID) {
-		/* Chip is from KSZ9893 design. */
-		dev_info(dev->dev, "Found KSZ9893\n");
 		dev->features |= IS_9893;
 
 		/* Chip does not support gigabit. */
@@ -1419,7 +1400,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 			dev->features &= ~GBIT_SUPPORT;
 		dev->phy_port_cnt = 2;
 	} else {
-		dev_info(dev->dev, "Found KSZ9477 or compatible\n");
 		/* Chip uses new XMII register definitions. */
 		dev->features |= NEW_XMII;
 
@@ -1446,7 +1426,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.shutdown = ksz9477_reset_switch,
-	.detect = ksz9477_switch_detect,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
 };
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 7a2c8d4767aff..077e35ab11b54 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -25,7 +25,6 @@
 
 #define REG_CHIP_ID2__1			0x0002
 
-#define CHIP_ID_63			0x63
 #define CHIP_ID_66			0x66
 #define CHIP_ID_67			0x67
 #define CHIP_ID_77			0x77
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 92a500e1ccd21..4511e99823f57 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -930,6 +930,72 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
+static int ksz_switch_detect(struct ksz_device *dev)
+{
+	u8 id1, id2;
+	u16 id16;
+	u32 id32;
+	int ret;
+
+	/* read chip id */
+	ret = ksz_read16(dev, REG_CHIP_ID0, &id16);
+	if (ret)
+		return ret;
+
+	id1 = FIELD_GET(SW_FAMILY_ID_M, id16);
+	id2 = FIELD_GET(SW_CHIP_ID_M, id16);
+
+	switch (id1) {
+	case KSZ87_FAMILY_ID:
+		if (id2 == KSZ87_CHIP_ID_95) {
+			u8 val;
+
+			dev->chip_id = KSZ8795_CHIP_ID;
+
+			ksz_read8(dev, KSZ8_PORT_STATUS_0, &val);
+			if (val & KSZ8_PORT_FIBER_MODE)
+				dev->chip_id = KSZ8765_CHIP_ID;
+		} else if (id2 == KSZ87_CHIP_ID_94) {
+			dev->chip_id = KSZ8794_CHIP_ID;
+		} else {
+			return -ENODEV;
+		}
+		break;
+	case KSZ88_FAMILY_ID:
+		if (id2 == KSZ88_CHIP_ID_63)
+			dev->chip_id = KSZ8830_CHIP_ID;
+		else
+			return -ENODEV;
+		break;
+	default:
+		ret = ksz_read32(dev, REG_CHIP_ID0, &id32);
+		if (ret)
+			return ret;
+
+		dev->chip_rev = FIELD_GET(SW_REV_ID_M, id32);
+		id32 &= ~0xFF;
+
+		switch (id32) {
+		case KSZ9477_CHIP_ID:
+		case KSZ9897_CHIP_ID:
+		case KSZ9893_CHIP_ID:
+		case KSZ9567_CHIP_ID:
+		case LAN9370_CHIP_ID:
+		case LAN9371_CHIP_ID:
+		case LAN9372_CHIP_ID:
+		case LAN9373_CHIP_ID:
+		case LAN9374_CHIP_ID:
+			dev->chip_id = id32;
+			break;
+		default:
+			dev_err(dev->dev,
+				"unsupported switch detected %x)\n", id32);
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
@@ -986,10 +1052,9 @@ int ksz_switch_register(struct ksz_device *dev,
 	mutex_init(&dev->alu_mutex);
 	mutex_init(&dev->vlan_mutex);
 
-	dev->dev_ops = ops;
-
-	if (dev->dev_ops->detect(dev))
-		return -EINVAL;
+	ret = ksz_switch_detect(dev);
+	if (ret)
+		return ret;
 
 	info = ksz_lookup_info(dev->chip_id);
 	if (!info)
@@ -998,10 +1063,15 @@ int ksz_switch_register(struct ksz_device *dev,
 	/* Update the compatible info with the probed one */
 	dev->info = info;
 
+	dev_info(dev->dev, "found switch: %s, rev %i\n",
+		 dev->info->dev_name, dev->chip_rev);
+
 	ret = ksz_check_device_id(dev);
 	if (ret)
 		return ret;
 
+	dev->dev_ops = ops;
+
 	ret = dev->dev_ops->init(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8500eaedad67a..e6bc5fb2b1303 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -90,6 +90,7 @@ struct ksz_device {
 
 	/* chip specific data */
 	u32 chip_id;
+	u8 chip_rev;
 	int cpu_port;			/* port connected to CPU */
 	int phy_port_cnt;
 	phy_interface_t compat_interface;
@@ -182,7 +183,6 @@ struct ksz_dev_ops {
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
-	int (*detect)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
 	void (*exit)(struct ksz_device *dev);
 };
@@ -353,6 +353,23 @@ static inline void ksz_regmap_unlock(void *__mtx)
 #define PORT_RX_ENABLE			BIT(1)
 #define PORT_LEARN_DISABLE		BIT(0)
 
+/* Switch ID Defines */
+#define REG_CHIP_ID0			0x00
+
+#define SW_FAMILY_ID_M			GENMASK(15, 8)
+#define KSZ87_FAMILY_ID			0x87
+#define KSZ88_FAMILY_ID			0x88
+
+#define KSZ8_PORT_STATUS_0		0x08
+#define KSZ8_PORT_FIBER_MODE		BIT(7)
+
+#define SW_CHIP_ID_M			GENMASK(7, 4)
+#define KSZ87_CHIP_ID_94		0x6
+#define KSZ87_CHIP_ID_95		0x9
+#define KSZ88_CHIP_ID_63		0x3
+
+#define SW_REV_ID_M			GENMASK(7, 4)
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
-- 
2.35.1



