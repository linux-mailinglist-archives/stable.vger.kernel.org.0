Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83C834C8BA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhC2IYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232590AbhC2IXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3418C61580;
        Mon, 29 Mar 2021 08:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006189;
        bh=ELGSmNtZy9Ij2rNuKOh2tOd2pUNxVYwfq9Q8mMRZgbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzWxU8rlmxBl+2FHpZEZvrcbaD3GT4aU3lTwnu0ivxfy4FDMy+R/RHaeFzgfk3pwa
         dcUm5InkagM8vMKiHQe9A1AjlVKlTgGGUZk6OsXgEJQmyKjn5Y5kayWdeNUNnSiZ8c
         QNJ+jPRTZXxDeUqvaBNHSek2ZrjttRjspvgw81QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Kardach <skardach@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/221] octeontx2-af: Modify default KEX profile to extract TX packet fields
Date:   Mon, 29 Mar 2021 09:58:02 +0200
Message-Id: <20210329075634.207880355@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

[ Upstream commit f1517f6f1d6fd97a18836b0fb6921f2cb105eeb4 ]

The current default Key Extraction(KEX) profile can only use RX
packet fields while generating the MCAM search key. The profile
can't be used for matching TX packet fields. This patch modifies
the default KEX profile to add support for extracting TX packet
fields into MCAM search key. Enabled Tx KPU packet parsing by
configuring TX PKIND in tx_parse_cfg.

Modified the KEX profile to extract 2 bytes of VLAN TCI from an
offset of 2 bytes from LB_PTR. The LB_PTR points to the byte offset
where the VLAN header starts. The NPC KPU parser profile has been
modified to point LB_PTR to the starting byte offset of VLAN header
which points to the tpid field.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   | 31 ++++++
 .../marvell/octeontx2/af/npc_profile.h        | 99 ++++++++++++++++---
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  4 +
 3 files changed, 120 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 91a9d00e4fb5..407b9477da24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -140,6 +140,15 @@ enum npc_kpu_lh_ltype {
 	NPC_LT_LH_CUSTOM1 = 0xF,
 };
 
+/* NPC port kind defines how the incoming or outgoing packets
+ * are processed. NPC accepts packets from up to 64 pkinds.
+ * Software assigns pkind for each incoming port such as CGX
+ * Ethernet interfaces, LBK interfaces, etc.
+ */
+enum npc_pkind_type {
+	NPC_TX_DEF_PKIND = 63ULL,	/* NIX-TX PKIND */
+};
+
 struct npc_kpu_profile_cam {
 	u8 state;
 	u8 state_mask;
@@ -300,6 +309,28 @@ struct nix_rx_action {
 /* NPC_AF_INTFX_KEX_CFG field masks */
 #define NPC_PARSE_NIBBLE		GENMASK_ULL(30, 0)
 
+/* NPC_PARSE_KEX_S nibble definitions for each field */
+#define NPC_PARSE_NIBBLE_CHAN		GENMASK_ULL(2, 0)
+#define NPC_PARSE_NIBBLE_ERRLEV		BIT_ULL(3)
+#define NPC_PARSE_NIBBLE_ERRCODE	GENMASK_ULL(5, 4)
+#define NPC_PARSE_NIBBLE_L2L3_BCAST	BIT_ULL(6)
+#define NPC_PARSE_NIBBLE_LA_FLAGS	GENMASK_ULL(8, 7)
+#define NPC_PARSE_NIBBLE_LA_LTYPE	BIT_ULL(9)
+#define NPC_PARSE_NIBBLE_LB_FLAGS	GENMASK_ULL(11, 10)
+#define NPC_PARSE_NIBBLE_LB_LTYPE	BIT_ULL(12)
+#define NPC_PARSE_NIBBLE_LC_FLAGS	GENMASK_ULL(14, 13)
+#define NPC_PARSE_NIBBLE_LC_LTYPE	BIT_ULL(15)
+#define NPC_PARSE_NIBBLE_LD_FLAGS	GENMASK_ULL(17, 16)
+#define NPC_PARSE_NIBBLE_LD_LTYPE	BIT_ULL(18)
+#define NPC_PARSE_NIBBLE_LE_FLAGS	GENMASK_ULL(20, 19)
+#define NPC_PARSE_NIBBLE_LE_LTYPE	BIT_ULL(21)
+#define NPC_PARSE_NIBBLE_LF_FLAGS	GENMASK_ULL(23, 22)
+#define NPC_PARSE_NIBBLE_LF_LTYPE	BIT_ULL(24)
+#define NPC_PARSE_NIBBLE_LG_FLAGS	GENMASK_ULL(26, 25)
+#define NPC_PARSE_NIBBLE_LG_LTYPE	BIT_ULL(27)
+#define NPC_PARSE_NIBBLE_LH_FLAGS	GENMASK_ULL(29, 28)
+#define NPC_PARSE_NIBBLE_LH_LTYPE	BIT_ULL(30)
+
 /* NIX Receive Vtag Action Structure */
 #define VTAG0_VALID_BIT		BIT_ULL(15)
 #define VTAG0_TYPE_MASK		GENMASK_ULL(14, 12)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 77bb4ed32600..077efc5007dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -148,6 +148,20 @@
 			(((bytesm1) << 16) | ((hdr_ofs) << 8) | ((ena) << 7) | \
 			 ((flags_ena) << 6) | ((key_ofs) & 0x3F))
 
+/* Rx parse key extract nibble enable */
+#define NPC_PARSE_NIBBLE_INTF_RX	(NPC_PARSE_NIBBLE_CHAN | \
+					 NPC_PARSE_NIBBLE_LA_LTYPE | \
+					 NPC_PARSE_NIBBLE_LB_LTYPE | \
+					 NPC_PARSE_NIBBLE_LC_LTYPE | \
+					 NPC_PARSE_NIBBLE_LD_LTYPE | \
+					 NPC_PARSE_NIBBLE_LE_LTYPE)
+/* Tx parse key extract nibble enable */
+#define NPC_PARSE_NIBBLE_INTF_TX	(NPC_PARSE_NIBBLE_LA_LTYPE | \
+					 NPC_PARSE_NIBBLE_LB_LTYPE | \
+					 NPC_PARSE_NIBBLE_LC_LTYPE | \
+					 NPC_PARSE_NIBBLE_LD_LTYPE | \
+					 NPC_PARSE_NIBBLE_LE_LTYPE)
+
 enum npc_kpu_parser_state {
 	NPC_S_NA = 0,
 	NPC_S_KPU1_ETHER,
@@ -13385,9 +13399,10 @@ static const struct npc_mcam_kex npc_mkex_default = {
 	.name = "default",
 	.kpu_version = NPC_KPU_PROFILE_VER,
 	.keyx_cfg = {
-		/* nibble: LA..LE (ltype only) + Channel */
-		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x49247,
-		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | ((1ULL << 19) - 1),
+		/* nibble: LA..LE (ltype only) + channel */
+		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_RX,
+		/* nibble: LA..LE (ltype only) */
+		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_TX,
 	},
 	.intf_lid_lt_ld = {
 	/* Default RX MCAM KEX profile */
@@ -13405,12 +13420,14 @@ static const struct npc_mcam_kex npc_mkex_default = {
 			/* Layer B: Single VLAN (CTAG) */
 			/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
 			[NPC_LT_LB_CTAG] = {
-				KEX_LD_CFG(0x03, 0x0, 0x1, 0x0, 0x4),
+				KEX_LD_CFG(0x03, 0x2, 0x1, 0x0, 0x4),
 			},
 			/* Layer B: Stacked VLAN (STAG|QinQ) */
 			[NPC_LT_LB_STAG_QINQ] = {
-				/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
-				KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4),
+				/* Outer VLAN: 2 bytes, KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* Ethertype: 2 bytes, KW0[47:32] */
+				KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x4),
 			},
 			[NPC_LT_LB_FDSA] = {
 				/* SWITCH PORT: 1 byte, KW0[63:48] */
@@ -13436,17 +13453,71 @@ static const struct npc_mcam_kex npc_mkex_default = {
 		[NPC_LID_LD] = {
 			/* Layer D:UDP */
 			[NPC_LT_LD_UDP] = {
-				/* SPORT: 2 bytes, KW3[15:0] */
-				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
-				/* DPORT: 2 bytes, KW3[31:16] */
-				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
+			},
+			/* Layer D:TCP */
+			[NPC_LT_LD_TCP] = {
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
+			},
+		},
+	},
+
+	/* Default TX MCAM KEX profile */
+	[NIX_INTF_TX] = {
+		[NPC_LID_LA] = {
+			/* Layer A: NIX_INST_HDR_S + Ethernet */
+			/* NIX appends 8 bytes of NIX_INST_HDR_S at the
+			 * start of each TX packet supplied to NPC.
+			 */
+			[NPC_LT_LA_IH_NIX_ETHER] = {
+				/* PF_FUNC: 2B , KW0 [47:32] */
+				KEX_LD_CFG(0x01, 0x0, 0x1, 0x0, 0x4),
+				/* DMAC: 6 bytes, KW1[63:16] */
+				KEX_LD_CFG(0x05, 0x8, 0x1, 0x0, 0xa),
+			},
+		},
+		[NPC_LID_LB] = {
+			/* Layer B: Single VLAN (CTAG) */
+			[NPC_LT_LB_CTAG] = {
+				/* CTAG VLAN[2..3] KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* CTAG VLAN[2..3] KW1[15:0] */
+				KEX_LD_CFG(0x01, 0x4, 0x1, 0x0, 0x8),
+			},
+			/* Layer B: Stacked VLAN (STAG|QinQ) */
+			[NPC_LT_LB_STAG_QINQ] = {
+				/* Outer VLAN: 2 bytes, KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* Outer VLAN: 2 Bytes, KW1[15:0] */
+				KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x8),
+			},
+		},
+		[NPC_LID_LC] = {
+			/* Layer C: IPv4 */
+			[NPC_LT_LC_IP] = {
+				/* SIP+DIP: 8 bytes, KW2[63:0] */
+				KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10),
+				/* TOS: 1 byte, KW1[63:56] */
+				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
+			},
+			/* Layer C: IPv6 */
+			[NPC_LT_LC_IP6] = {
+				/* Everything up to SADDR: 8 bytes, KW2[63:0] */
+				KEX_LD_CFG(0x07, 0x0, 0x1, 0x0, 0x10),
+			},
+		},
+		[NPC_LID_LD] = {
+			/* Layer D:UDP */
+			[NPC_LT_LD_UDP] = {
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
 			},
 			/* Layer D:TCP */
 			[NPC_LT_LD_TCP] = {
-				/* SPORT: 2 bytes, KW3[15:0] */
-				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
-				/* DPORT: 2 bytes, KW3[31:16] */
-				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
 			},
 		},
 	},
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 21a89dd76d3c..f6a3cf3e6f23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1129,6 +1129,10 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	/* Config Rx pkt length, csum checks and apad  enable / disable */
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_CFG(nixlf), req->rx_cfg);
 
+	/* Configure pkind for TX parse config */
+	cfg = NPC_TX_DEF_PKIND;
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
+
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
 	err = nix_interface_init(rvu, pcifunc, intf, nixlf);
 	if (err)
-- 
2.30.1



