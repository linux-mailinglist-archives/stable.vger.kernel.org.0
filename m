Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8275A6A09B6
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjBWNJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbjBWNJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C810F5FDF
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B26D616E0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFBBC433EF;
        Thu, 23 Feb 2023 13:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157758;
        bh=uTeTyuwhcHdkjXqTS5ZRiyWM/jfsu/3UvxskIw3TQLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Phts4BtoDgmYFSgOo24DCWHudV/6JJGLctEMQ/CX6fN8ykWeKG45dqvmDnhrJdAwt
         VWudcGWsGrug81Ys2kzojgvpeoHebzLwyl0gCOzZLnT0L3s5qLTiA9jclGCwH4hrtQ
         giHIqkenM2hRgxsVnMoX3FM1Hq6bxmmAFmqJ0wsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/46] nfp: ethtool: support reporting link modes
Date:   Thu, 23 Feb 2023 14:06:34 +0100
Message-Id: <20230223130432.835825803@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

From: Yu Xiao <yu.xiao@corigine.com>

[ Upstream commit a61474c41e8c530c54a26db4f5434f050ef7718d ]

Add support for reporting link modes,
including `Supported link modes` and `Advertised link modes`,
via ethtool $DEV.

A new command `SPCODE_READ_MEDIA` is added to read info from
management firmware. Also, the mapping table `nfp_eth_media_table`
associates the link modes between NFP and kernel. Both of them
help to support this ability.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/r/20221125113030.141642-1-simon.horman@corigine.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 821de68c1f9c ("nfp: ethtool: fix the bug of setting unsupported port speed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  1 +
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 73 +++++++++++++++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.c  | 17 +++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  | 56 ++++++++++++++
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 26 +++++++
 5 files changed, 173 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index afd3edfa24283..b9266cf72a172 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -28,6 +28,7 @@ struct nfp_hwinfo;
 struct nfp_mip;
 struct nfp_net;
 struct nfp_nsp_identify;
+struct nfp_eth_media_buf;
 struct nfp_port;
 struct nfp_rtsym;
 struct nfp_rtsym_table;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 991059d6cb32e..377c3b1185ee0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -293,6 +293,76 @@ nfp_net_set_fec_link_mode(struct nfp_eth_table_port *eth_port,
 	}
 }
 
+static const u16 nfp_eth_media_table[] = {
+	[NFP_MEDIA_1000BASE_CX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	[NFP_MEDIA_1000BASE_KX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	[NFP_MEDIA_10GBASE_KX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	[NFP_MEDIA_10GBASE_KR]		= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	[NFP_MEDIA_10GBASE_CX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	[NFP_MEDIA_10GBASE_CR]		= ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+	[NFP_MEDIA_10GBASE_SR]		= ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+	[NFP_MEDIA_10GBASE_ER]		= ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+	[NFP_MEDIA_25GBASE_KR]		= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	[NFP_MEDIA_25GBASE_KR_S]	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	[NFP_MEDIA_25GBASE_CR]		= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	[NFP_MEDIA_25GBASE_CR_S]	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	[NFP_MEDIA_25GBASE_SR]		= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+	[NFP_MEDIA_40GBASE_CR4]		= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_KR4]		= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_SR4]		= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_LR4]		= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+	[NFP_MEDIA_50GBASE_KR]		= ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+	[NFP_MEDIA_50GBASE_SR]		= ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+	[NFP_MEDIA_50GBASE_CR]		= ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+	[NFP_MEDIA_50GBASE_LR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_50GBASE_ER]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_50GBASE_FR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_100GBASE_KR4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_SR4]	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_CR4]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_KP4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_CR10]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+};
+
+static void nfp_add_media_link_mode(struct nfp_port *port,
+				    struct nfp_eth_table_port *eth_port,
+				    struct ethtool_link_ksettings *cmd)
+{
+	u64 supported_modes[2], advertised_modes[2];
+	struct nfp_eth_media_buf ethm = {
+		.eth_index = eth_port->eth_index,
+	};
+	struct nfp_cpp *cpp = port->app->cpp;
+
+	if (nfp_eth_read_media(cpp, &ethm))
+		return;
+
+	for (u32 i = 0; i < 2; i++) {
+		supported_modes[i] = le64_to_cpu(ethm.supported_modes[i]);
+		advertised_modes[i] = le64_to_cpu(ethm.advertised_modes[i]);
+	}
+
+	for (u32 i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; i++) {
+		if (i < 64) {
+			if (supported_modes[0] & BIT_ULL(i))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.supported);
+
+			if (advertised_modes[0] & BIT_ULL(i))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.advertising);
+		} else {
+			if (supported_modes[1] & BIT_ULL(i - 64))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.supported);
+
+			if (advertised_modes[1] & BIT_ULL(i - 64))
+				__set_bit(nfp_eth_media_table[i],
+					  cmd->link_modes.advertising);
+		}
+	}
+}
+
 /**
  * nfp_net_get_link_ksettings - Get Link Speed settings
  * @netdev:	network interface device structure
@@ -311,6 +381,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	u16 sts;
 
 	/* Init to unknowns */
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
@@ -321,6 +393,7 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	if (eth_port) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
+		nfp_add_media_link_mode(port, eth_port, cmd);
 		if (eth_port->supp_aneg) {
 			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
 			if (eth_port->aneg == NFP_ANEG_AUTO) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index 730fea214b8ab..7136bc48530ba 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -100,6 +100,7 @@ enum nfp_nsp_cmd {
 	SPCODE_FW_LOADED	= 19, /* Is application firmware loaded */
 	SPCODE_VERSIONS		= 21, /* Report FW versions */
 	SPCODE_READ_SFF_EEPROM	= 22, /* Read module EEPROM */
+	SPCODE_READ_MEDIA	= 23, /* Get either the supported or advertised media for a port */
 };
 
 struct nfp_nsp_dma_buf {
@@ -1100,4 +1101,20 @@ int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 	kfree(buf);
 
 	return ret;
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size)
+{
+	struct nfp_nsp_command_buf_arg media = {
+		{
+			.code		= SPCODE_READ_MEDIA,
+			.option		= size,
+		},
+		.in_buf		= buf,
+		.in_size	= size,
+		.out_buf	= buf,
+		.out_size	= size,
+	};
+
+	return nfp_nsp_command_buf(state, &media);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 992d72ac98d38..8f5cab0032d08 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -65,6 +65,11 @@ static inline bool nfp_nsp_has_read_module_eeprom(struct nfp_nsp *state)
 	return nfp_nsp_get_abi_ver_minor(state) > 28;
 }
 
+static inline bool nfp_nsp_has_read_media(struct nfp_nsp *state)
+{
+	return nfp_nsp_get_abi_ver_minor(state) > 33;
+}
+
 enum nfp_eth_interface {
 	NFP_INTERFACE_NONE	= 0,
 	NFP_INTERFACE_SFP	= 1,
@@ -97,6 +102,47 @@ enum nfp_eth_fec {
 	NFP_FEC_DISABLED_BIT,
 };
 
+/* link modes about RJ45 haven't been used, so there's no mapping to them */
+enum nfp_ethtool_link_mode_list {
+	NFP_MEDIA_W0_RJ45_10M,
+	NFP_MEDIA_W0_RJ45_10M_HD,
+	NFP_MEDIA_W0_RJ45_100M,
+	NFP_MEDIA_W0_RJ45_100M_HD,
+	NFP_MEDIA_W0_RJ45_1G,
+	NFP_MEDIA_W0_RJ45_2P5G,
+	NFP_MEDIA_W0_RJ45_5G,
+	NFP_MEDIA_W0_RJ45_10G,
+	NFP_MEDIA_1000BASE_CX,
+	NFP_MEDIA_1000BASE_KX,
+	NFP_MEDIA_10GBASE_KX4,
+	NFP_MEDIA_10GBASE_KR,
+	NFP_MEDIA_10GBASE_CX4,
+	NFP_MEDIA_10GBASE_CR,
+	NFP_MEDIA_10GBASE_SR,
+	NFP_MEDIA_10GBASE_ER,
+	NFP_MEDIA_25GBASE_KR,
+	NFP_MEDIA_25GBASE_KR_S,
+	NFP_MEDIA_25GBASE_CR,
+	NFP_MEDIA_25GBASE_CR_S,
+	NFP_MEDIA_25GBASE_SR,
+	NFP_MEDIA_40GBASE_CR4,
+	NFP_MEDIA_40GBASE_KR4,
+	NFP_MEDIA_40GBASE_SR4,
+	NFP_MEDIA_40GBASE_LR4,
+	NFP_MEDIA_50GBASE_KR,
+	NFP_MEDIA_50GBASE_SR,
+	NFP_MEDIA_50GBASE_CR,
+	NFP_MEDIA_50GBASE_LR,
+	NFP_MEDIA_50GBASE_ER,
+	NFP_MEDIA_50GBASE_FR,
+	NFP_MEDIA_100GBASE_KR4,
+	NFP_MEDIA_100GBASE_SR4,
+	NFP_MEDIA_100GBASE_CR4,
+	NFP_MEDIA_100GBASE_KP4,
+	NFP_MEDIA_100GBASE_CR10,
+	NFP_MEDIA_LINK_MODES_NUMBER
+};
+
 #define NFP_FEC_AUTO		BIT(NFP_FEC_AUTO_BIT)
 #define NFP_FEC_BASER		BIT(NFP_FEC_BASER_BIT)
 #define NFP_FEC_REED_SOLOMON	BIT(NFP_FEC_REED_SOLOMON_BIT)
@@ -256,6 +302,16 @@ enum nfp_nsp_sensor_id {
 int nfp_hwmon_read_sensor(struct nfp_cpp *cpp, enum nfp_nsp_sensor_id id,
 			  long *val);
 
+struct nfp_eth_media_buf {
+	u8 eth_index;
+	u8 reserved[7];
+	__le64 supported_modes[2];
+	__le64 advertised_modes[2];
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size);
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm);
+
 #define NFP_NSP_VERSION_BUFSZ	1024 /* reasonable size, not in the ABI */
 
 enum nfp_nsp_versions {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index bb64efec4c46b..570ac1bb2122f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -647,3 +647,29 @@ int __nfp_eth_set_split(struct nfp_nsp *nsp, unsigned int lanes)
 	return NFP_ETH_SET_BIT_CONFIG(nsp, NSP_ETH_RAW_PORT, NSP_ETH_PORT_LANES,
 				      lanes, NSP_ETH_CTRL_SET_LANES);
 }
+
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm)
+{
+	struct nfp_nsp *nsp;
+	int ret;
+
+	nsp = nfp_nsp_open(cpp);
+	if (IS_ERR(nsp)) {
+		nfp_err(cpp, "Failed to access the NSP: %pe\n", nsp);
+		return PTR_ERR(nsp);
+	}
+
+	if (!nfp_nsp_has_read_media(nsp)) {
+		nfp_warn(cpp, "Reading media link modes not supported. Please update flash\n");
+		ret = -EOPNOTSUPP;
+		goto exit_close_nsp;
+	}
+
+	ret = nfp_nsp_read_media(nsp, ethm, sizeof(*ethm));
+	if (ret)
+		nfp_err(cpp, "Reading media link modes failed: %pe\n", ERR_PTR(ret));
+
+exit_close_nsp:
+	nfp_nsp_close(nsp);
+	return ret;
+}
-- 
2.39.0



