Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C35C6A09B7
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbjBWNJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjBWNJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D891C143
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D0DB615EA
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01024C433EF;
        Thu, 23 Feb 2023 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157761;
        bh=AYvWR9DrrHG6D8cu3z5XsXKiXVI7D/7g0Gmoh2kX+VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Swx0R+WNMIQRyg4W+FBfT8BdLhNEuWXy9rvjEU3N2kraqzqMjebTN6Tz8ewPSYue1
         CuBDuNlviudB6r1O1ubOXTiB+3r02sRdOUGelBte/UA3hXkUeEtIR7DLPRd26wr7GT
         lk/ZgKAkD9BDII+Uk1q3Di2kpVqGvd3aFN9OkBwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/46] nfp: ethtool: fix the bug of setting unsupported port speed
Date:   Thu, 23 Feb 2023 14:06:35 +0100
Message-Id: <20230223130432.876619065@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

[ Upstream commit 821de68c1f9c0236b0b9c10834cda900ae9b443c ]

Unsupported port speed can be set and cause error. Now fixing it
and return an error if setting unsupported speed.

This fix depends on the following, which was included in v6.2-rc1:
commit a61474c41e8c ("nfp: ethtool: support reporting link modes").

Fixes: 7c698737270f ("nfp: add support for .set_link_ksettings()")
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 194 ++++++++++++++----
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  12 ++
 2 files changed, 170 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 377c3b1185ee0..af376b9000677 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -293,35 +293,131 @@ nfp_net_set_fec_link_mode(struct nfp_eth_table_port *eth_port,
 	}
 }
 
-static const u16 nfp_eth_media_table[] = {
-	[NFP_MEDIA_1000BASE_CX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-	[NFP_MEDIA_1000BASE_KX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-	[NFP_MEDIA_10GBASE_KX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
-	[NFP_MEDIA_10GBASE_KR]		= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
-	[NFP_MEDIA_10GBASE_CX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
-	[NFP_MEDIA_10GBASE_CR]		= ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
-	[NFP_MEDIA_10GBASE_SR]		= ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
-	[NFP_MEDIA_10GBASE_ER]		= ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
-	[NFP_MEDIA_25GBASE_KR]		= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
-	[NFP_MEDIA_25GBASE_KR_S]	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
-	[NFP_MEDIA_25GBASE_CR]		= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
-	[NFP_MEDIA_25GBASE_CR_S]	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
-	[NFP_MEDIA_25GBASE_SR]		= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
-	[NFP_MEDIA_40GBASE_CR4]		= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
-	[NFP_MEDIA_40GBASE_KR4]		= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
-	[NFP_MEDIA_40GBASE_SR4]		= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
-	[NFP_MEDIA_40GBASE_LR4]		= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
-	[NFP_MEDIA_50GBASE_KR]		= ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
-	[NFP_MEDIA_50GBASE_SR]		= ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
-	[NFP_MEDIA_50GBASE_CR]		= ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
-	[NFP_MEDIA_50GBASE_LR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-	[NFP_MEDIA_50GBASE_ER]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-	[NFP_MEDIA_50GBASE_FR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-	[NFP_MEDIA_100GBASE_KR4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_SR4]	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_CR4]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_KP4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_CR10]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+static const struct nfp_eth_media_link_mode {
+	u16 ethtool_link_mode;
+	u16 speed;
+} nfp_eth_media_table[NFP_MEDIA_LINK_MODES_NUMBER] = {
+	[NFP_MEDIA_1000BASE_CX] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed			= NFP_SPEED_1G,
+	},
+	[NFP_MEDIA_1000BASE_KX] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed			= NFP_SPEED_1G,
+	},
+	[NFP_MEDIA_10GBASE_KX4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_CX4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_ER] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_25GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_KR_S] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_CR_S] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_40GBASE_CR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_KR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_SR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_LR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_50GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_LR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_ER] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_FR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_100GBASE_KR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_SR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_CR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_KP4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_CR10] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+};
+
+static const unsigned int nfp_eth_speed_map[NFP_SUP_SPEED_NUMBER] = {
+	[NFP_SPEED_1G]		= SPEED_1000,
+	[NFP_SPEED_10G]		= SPEED_10000,
+	[NFP_SPEED_25G]		= SPEED_25000,
+	[NFP_SPEED_40G]		= SPEED_40000,
+	[NFP_SPEED_50G]		= SPEED_50000,
+	[NFP_SPEED_100G]	= SPEED_100000,
 };
 
 static void nfp_add_media_link_mode(struct nfp_port *port,
@@ -334,8 +430,12 @@ static void nfp_add_media_link_mode(struct nfp_port *port,
 	};
 	struct nfp_cpp *cpp = port->app->cpp;
 
-	if (nfp_eth_read_media(cpp, &ethm))
+	if (nfp_eth_read_media(cpp, &ethm)) {
+		bitmap_fill(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
 		return;
+	}
+
+	bitmap_zero(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
 
 	for (u32 i = 0; i < 2; i++) {
 		supported_modes[i] = le64_to_cpu(ethm.supported_modes[i]);
@@ -344,20 +444,26 @@ static void nfp_add_media_link_mode(struct nfp_port *port,
 
 	for (u32 i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; i++) {
 		if (i < 64) {
-			if (supported_modes[0] & BIT_ULL(i))
-				__set_bit(nfp_eth_media_table[i],
+			if (supported_modes[0] & BIT_ULL(i)) {
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.supported);
+				__set_bit(nfp_eth_media_table[i].speed,
+					  port->speed_bitmap);
+			}
 
 			if (advertised_modes[0] & BIT_ULL(i))
-				__set_bit(nfp_eth_media_table[i],
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.advertising);
 		} else {
-			if (supported_modes[1] & BIT_ULL(i - 64))
-				__set_bit(nfp_eth_media_table[i],
+			if (supported_modes[1] & BIT_ULL(i - 64)) {
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.supported);
+				__set_bit(nfp_eth_media_table[i].speed,
+					  port->speed_bitmap);
+			}
 
 			if (advertised_modes[1] & BIT_ULL(i - 64))
-				__set_bit(nfp_eth_media_table[i],
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.advertising);
 		}
 	}
@@ -468,6 +574,22 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
 
 	if (cmd->base.speed != SPEED_UNKNOWN) {
 		u32 speed = cmd->base.speed / eth_port->lanes;
+		bool is_supported = false;
+
+		for (u32 i = 0; i < NFP_SUP_SPEED_NUMBER; i++) {
+			if (cmd->base.speed == nfp_eth_speed_map[i] &&
+			    test_bit(i, port->speed_bitmap)) {
+				is_supported = true;
+				break;
+			}
+		}
+
+		if (!is_supported) {
+			netdev_err(netdev, "Speed %u is not supported.\n",
+				   cmd->base.speed);
+			err = -EINVAL;
+			goto err_bad_set;
+		}
 
 		if (req_aneg) {
 			netdev_err(netdev, "Speed changing is not allowed when working on autoneg mode.\n");
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index 6793cdf9ff115..c31812287ded1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -38,6 +38,16 @@ enum nfp_port_flags {
 	NFP_PORT_CHANGED = 0,
 };
 
+enum {
+	NFP_SPEED_1G,
+	NFP_SPEED_10G,
+	NFP_SPEED_25G,
+	NFP_SPEED_40G,
+	NFP_SPEED_50G,
+	NFP_SPEED_100G,
+	NFP_SUP_SPEED_NUMBER
+};
+
 /**
  * struct nfp_port - structure representing NFP port
  * @netdev:	backpointer to associated netdev
@@ -52,6 +62,7 @@ enum nfp_port_flags {
  * @eth_forced:	for %NFP_PORT_PHYS_PORT port is forced UP or DOWN, don't change
  * @eth_port:	for %NFP_PORT_PHYS_PORT translated ETH Table port entry
  * @eth_stats:	for %NFP_PORT_PHYS_PORT MAC stats if available
+ * @speed_bitmap:	for %NFP_PORT_PHYS_PORT supported speed bitmap
  * @pf_id:	for %NFP_PORT_PF_PORT, %NFP_PORT_VF_PORT ID of the PCI PF (0-3)
  * @vf_id:	for %NFP_PORT_VF_PORT ID of the PCI VF within @pf_id
  * @pf_split:	for %NFP_PORT_PF_PORT %true if PCI PF has more than one vNIC
@@ -78,6 +89,7 @@ struct nfp_port {
 			bool eth_forced;
 			struct nfp_eth_table_port *eth_port;
 			u8 __iomem *eth_stats;
+			DECLARE_BITMAP(speed_bitmap, NFP_SUP_SPEED_NUMBER);
 		};
 		/* NFP_PORT_PF_PORT, NFP_PORT_VF_PORT */
 		struct {
-- 
2.39.0



