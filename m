Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6DC4CF693
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbiCGJmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241105AbiCGJlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C6A229;
        Mon,  7 Mar 2022 01:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E50E5B8102B;
        Mon,  7 Mar 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC5CC340E9;
        Mon,  7 Mar 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646015;
        bh=PRioSQYfQKeMU8Wa12OiSRW07y/KbzapIdF6LmgaBdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYoLBy5MJc/wG+glrAkNrG/2d9a8CDp/nh7+Dhk1HkMP442KgkCkLleC6kT5HDrox
         Q7FUZz4qDB1MZnu1NhqzOa5V3P53swSjBNbVxOI3Ebv3Z1+wjeKBWhsOvybZI1Ly6E
         vVJWq0nJ82ObRD0AiwUwR4AViWuugSIT4XrcfRuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/262] octeontx2-af: cn10k: RPM hardware timestamp configuration
Date:   Mon,  7 Mar 2022 10:17:30 +0100
Message-Id: <20220307091705.467083438@linuxfoundation.org>
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit d1489208681dfe432609fdaa49b160219c6e221c ]

MAC on CN10K support hardware timestamping such that 8 bytes addition
header is prepended to incoming packets. This patch does necessary
configuration to enable Hardware time stamping upon receiving request
from PF netdev interfaces.

Timestamp configuration is different on MAC (CGX) Octeontx2 silicon
and MAC (RPM) OcteonTX3 CN10k. Based on silicon variant appropriate
fn() pointer is called. Refactor MAC specific mbox messages to remove
unnecessary gaps in mboxids.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 10 ++---
 .../marvell/octeontx2/af/lmac_common.h        |  5 +++
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 41 ++++++++++---------
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 17 ++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  3 ++
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  4 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  4 +-
 7 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 34a089b71e554..d379a35c4618f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -838,9 +838,6 @@ void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
 	if (!cgx)
 		return;
 
-	if (is_dev_rpm(cgx))
-		return;
-
 	if (enable) {
 		/* Enable inbound PTP timestamping */
 		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
@@ -1545,9 +1542,11 @@ static int cgx_lmac_exit(struct cgx *cgx)
 static void cgx_populate_features(struct cgx *cgx)
 {
 	if (is_dev_rpm(cgx))
-		cgx->hw_features =  (RVU_MAC_RPM | RVU_LMAC_FEAT_FC);
+		cgx->hw_features = (RVU_LMAC_FEAT_DMACF | RVU_MAC_RPM |
+				    RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
 	else
-		cgx->hw_features = (RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
+		cgx->hw_features = (RVU_LMAC_FEAT_FC  | RVU_LMAC_FEAT_HIGIG2 |
+				    RVU_LMAC_FEAT_PTP | RVU_LMAC_FEAT_DMACF);
 }
 
 static struct mac_ops	cgx_mac_ops    = {
@@ -1571,6 +1570,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_get_pause_frm_status =	cgx_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		cgx_lmac_pause_frm_config,
+	.mac_enadis_ptp_config =	cgx_lmac_ptp_config,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index c38306b3384a7..fc6e7423cbd81 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -102,6 +102,11 @@ struct mac_ops {
 	void			(*mac_pause_frm_config)(void  *cgxd,
 							int lmac_id,
 							bool enable);
+
+	/* Enable/Disable Inbound PTP */
+	void			(*mac_enadis_ptp_config)(void  *cgxd,
+							 int lmac_id,
+							 bool enable);
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 472eb2a5697a4..c6643c7db1fc4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -154,23 +154,23 @@ M(CGX_PTP_RX_ENABLE,	0x20C, cgx_ptp_rx_enable, msg_req, msg_rsp)	\
 M(CGX_PTP_RX_DISABLE,	0x20D, cgx_ptp_rx_disable, msg_req, msg_rsp)	\
 M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
 			       cgx_pause_frm_cfg)			\
-M(CGX_FEC_SET,		0x210, cgx_set_fec_param, fec_mode, fec_mode)   \
-M(CGX_FEC_STATS,	0x211, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
-M(CGX_GET_PHY_FEC_STATS, 0x212, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
-M(CGX_FW_DATA_GET,	0x213, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
-M(CGX_SET_LINK_MODE,	0x214, cgx_set_link_mode, cgx_set_link_mode_req,\
-			       cgx_set_link_mode_rsp)	\
-M(CGX_FEATURES_GET,	0x215, cgx_features_get, msg_req,		\
-			       cgx_features_info_msg)			\
-M(RPM_STATS,		0x216, rpm_stats, msg_req, rpm_stats_rsp)	\
-M(CGX_MAC_ADDR_ADD,	0x217, cgx_mac_addr_add, cgx_mac_addr_add_req,    \
-			       cgx_mac_addr_add_rsp)		\
-M(CGX_MAC_ADDR_DEL,	0x218, cgx_mac_addr_del, cgx_mac_addr_del_req,    \
+M(CGX_FW_DATA_GET,	0x20F, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
+M(CGX_FEC_SET,		0x210, cgx_set_fec_param, fec_mode, fec_mode) \
+M(CGX_MAC_ADDR_ADD,	0x211, cgx_mac_addr_add, cgx_mac_addr_add_req,    \
+				cgx_mac_addr_add_rsp)		\
+M(CGX_MAC_ADDR_DEL,	0x212, cgx_mac_addr_del, cgx_mac_addr_del_req,    \
 			       msg_rsp)		\
-M(CGX_MAC_MAX_ENTRIES_GET, 0x219, cgx_mac_max_entries_get, msg_req,    \
+M(CGX_MAC_MAX_ENTRIES_GET, 0x213, cgx_mac_max_entries_get, msg_req,    \
 				  cgx_max_dmac_entries_get_rsp)		\
-M(CGX_MAC_ADDR_RESET,	0x21A, cgx_mac_addr_reset, msg_req, msg_rsp)	\
-M(CGX_MAC_ADDR_UPDATE,	0x21B, cgx_mac_addr_update, cgx_mac_addr_update_req, \
+M(CGX_FEC_STATS,	0x217, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
+M(CGX_SET_LINK_MODE,	0x218, cgx_set_link_mode, cgx_set_link_mode_req,\
+			       cgx_set_link_mode_rsp)	\
+M(CGX_GET_PHY_FEC_STATS, 0x219, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
+M(CGX_FEATURES_GET,	0x21B, cgx_features_get, msg_req,		\
+			       cgx_features_info_msg)			\
+M(RPM_STATS,		0x21C, rpm_stats, msg_req, rpm_stats_rsp)	\
+M(CGX_MAC_ADDR_RESET,	0x21D, cgx_mac_addr_reset, msg_req, msg_rsp)	\
+M(CGX_MAC_ADDR_UPDATE,	0x21E, cgx_mac_addr_update, cgx_mac_addr_update_req, \
 			       msg_rsp)					\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
@@ -577,10 +577,13 @@ struct cgx_mac_addr_update_req {
 };
 
 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
-#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precision time protocol */
-#define RVU_MAC_VERSION			BIT_ULL(2)
-#define RVU_MAC_CGX			BIT_ULL(3)
-#define RVU_MAC_RPM			BIT_ULL(4)
+#define	RVU_LMAC_FEAT_HIGIG2		BIT_ULL(1)
+			/* flow control from physical link higig2 messages */
+#define RVU_LMAC_FEAT_PTP		BIT_ULL(2) /* precison time protocol */
+#define RVU_LMAC_FEAT_DMACF		BIT_ULL(3) /* DMAC FILTER */
+#define RVU_MAC_VERSION			BIT_ULL(4)
+#define RVU_MAC_CGX			BIT_ULL(5)
+#define RVU_MAC_RPM			BIT_ULL(6)
 
 struct cgx_features_info_msg {
 	struct mbox_msghdr hdr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index b3803577324e6..c8f20b36adc89 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -29,6 +29,7 @@ static struct mac_ops	rpm_mac_ops   = {
 	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		rpm_lmac_pause_frm_config,
+	.mac_enadis_ptp_config =	rpm_lmac_ptp_config,
 };
 
 struct mac_ops *rpm_get_mac_ops(void)
@@ -267,3 +268,19 @@ int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 
 	return 0;
 }
+
+void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_CFG);
+	if (enable)
+		cfg |= RPMX_RX_TS_PREPEND;
+	else
+		cfg &= ~RPMX_RX_TS_PREPEND;
+	rpm_write(rpm, lmac_id, RPMX_CMRX_CFG, cfg);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index f0b069442dccb..57c8a687b488a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -14,6 +14,8 @@
 #define PCI_DEVID_CN10K_RPM		0xA060
 
 /* Registers */
+#define RPMX_CMRX_CFG			0x00
+#define RPMX_RX_TS_PREPEND              BIT_ULL(22)
 #define RPMX_CMRX_SW_INT                0x180
 #define RPMX_CMRX_SW_INT_W1S            0x188
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
@@ -54,4 +56,5 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 			      u8 rx_pause);
 int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat);
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
+void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index a5c717ad12c15..5bdbc77aa721d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -696,6 +696,7 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 	void *cgxd;
 
@@ -712,7 +713,8 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgxd = rvu_cgx_pdata(cgx_id, rvu);
 
-	cgx_lmac_ptp_config(cgxd, lmac_id, enable);
+	mac_ops = get_mac_ops(cgxd);
+	mac_ops->mac_enadis_ptp_config(cgxd, lmac_id, true);
 	/* If PTP is enabled then inform NPC that packets to be
 	 * parsed by this PF will have their data shifted by 8 bytes
 	 * and if PTP is disabled then no shift is required
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8c94e30d0499e..143b554d044bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4520,6 +4520,7 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct hwctx_disable_req ctx_req;
 	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 	void *cgxd;
 	int err;
@@ -4566,7 +4567,8 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	if (pfvf->hw_rx_tstamp_en) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 		cgxd = rvu_cgx_pdata(cgx_id, rvu);
-		cgx_lmac_ptp_config(cgxd, lmac_id, false);
+		mac_ops = get_mac_ops(cgxd);
+		mac_ops->mac_enadis_ptp_config(cgxd, lmac_id, false);
 		/* Undo NPC config done for PTP */
 		if (npc_config_ts_kpuaction(rvu, pf, pcifunc, false))
 			dev_err(rvu->dev, "NPC config for PTP failed\n");
-- 
2.34.1



