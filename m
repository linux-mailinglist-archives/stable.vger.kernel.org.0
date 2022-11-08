Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B8762151A
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiKHOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiKHOIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:08:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17D17720E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 208D0B81B04
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C22C433D6;
        Tue,  8 Nov 2022 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916484;
        bh=Uxhk/0p+ssTUV9Kv5nTzXWezS5Gy3x4ubP0W0AkPYME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfWmp8w+jA9Oz3AcVOmdAwQcQAX4TmSIP6Juzn8s/aw1rOl+Kq9RzegE10JEGIKtB
         O3VLCglddwTpyjkZsXZehZceLxtf3+svUutL4dz+KXKpwt2NaaJ/fquouKmJu89SFU
         oXzrCDr49H7/p+RdtTkSV1D2r9UlHFfHGsBwUAAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 036/197] net: lan966x: Adjust maximum frame size when vlan is enabled/disabled
Date:   Tue,  8 Nov 2022 14:37:54 +0100
Message-Id: <20221108133356.465069831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 25f28bb1b4a7717a9df3aa574d210374ebb6bb23 ]

When vlan filtering is enabled/disabled, it is required to adjust the
maximum received frame size that it can received. When vlan filtering is
enabled, it would all to receive extra 4 bytes, that are the vlan tag.
So the maximum frame size would be 1522 with a vlan tag. If vlan
filtering is disabled then the maximum frame size would be 1518
regardless if there is or not a vlan tag.

Fixes: 6d2c186afa5d ("net: lan966x: Add vlan support.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/lan966x/lan966x_regs.h | 15 +++++++++++++++
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 8265ad89f0bc..357ecc2f1089 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -444,6 +444,21 @@ enum lan966x_target {
 #define DEV_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
 	FIELD_GET(DEV_MAC_MAXLEN_CFG_MAX_LEN, x)
 
+/*      DEV:MAC_CFG_STATUS:MAC_TAGS_CFG */
+#define DEV_MAC_TAGS_CFG(t)       __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 12, 0, 1, 4)
+
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA        BIT(1)
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA, x)
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA_GET(x)\
+	FIELD_GET(DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA, x)
+
+#define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA            BIT(0)
+#define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+#define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA_GET(x)\
+	FIELD_GET(DEV_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+
 /*      DEV:MAC_CFG_STATUS:MAC_IFG_CFG */
 #define DEV_MAC_IFG_CFG(t)        __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 20, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index 8d7260cd7da9..3c44660128da 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -169,6 +169,12 @@ void lan966x_vlan_port_apply(struct lan966x_port *port)
 		ANA_VLAN_CFG_VLAN_POP_CNT,
 		lan966x, ANA_VLAN_CFG(port->chip_port));
 
+	lan_rmw(DEV_MAC_TAGS_CFG_VLAN_AWR_ENA_SET(port->vlan_aware) |
+		DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA_SET(port->vlan_aware),
+		DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
+		DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA,
+		lan966x, DEV_MAC_TAGS_CFG(port->chip_port));
+
 	/* Drop frames with multicast source address */
 	val = ANA_DROP_CFG_DROP_MC_SMAC_ENA_SET(1);
 	if (port->vlan_aware && !pvid)
-- 
2.35.1



