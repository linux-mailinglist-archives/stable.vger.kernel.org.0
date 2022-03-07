Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056D64CF706
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbiCGJoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbiCGJlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D27F5D19F;
        Mon,  7 Mar 2022 01:40:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 884D5B80F9F;
        Mon,  7 Mar 2022 09:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1268C340E9;
        Mon,  7 Mar 2022 09:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646004;
        bh=ycM/QmibiU7Q/BdwlMZj3lZ2noC+UzaK8jXmgw66M10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cv8CkeHqCaCv6lVMqQKWELTV/n3kOJ42/HHlLNhw3iO+fBtNmXQURcsUceJeNiRII
         qAnV8JJGtHT0MrtPW6V1k0u0AfPmdT+69GHpgEpDsHsFFKSsRb76x/uibgB33Q7nQb
         RdmFisxkEMm0JhDhY8f/5ttb6EXka1NPu4/KwTTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiran Kumar K <kirankumark@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/262] octeontx2-af: Optimize KPU1 processing for variable-length headers
Date:   Mon,  7 Mar 2022 10:17:28 +0100
Message-Id: <20220307091705.411688952@linuxfoundation.org>
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

From: Kiran Kumar K <kirankumark@marvell.com>

[ Upstream commit edadeb38dc2fa2550801995b748110c3e5e59557 ]

Optimized KPU1 entry processing for variable-length custom L2 headers
of size 24B, 90B by
	- Moving LA LTYPE parsing for 24B and 90B headers to PKIND.
	- Removing LA flags assignment for 24B and 90B headers.
	- Reserving a PKIND 55 to parse variable length headers.

Also, new mailbox(NPC_SET_PKIND) added to configure PKIND with
corresponding variable-length offset, mask, and shift count
(NPC_AF_KPUX_ENTRYX_ACTION0).

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  20 +-
 .../net/ethernet/marvell/octeontx2/af/npc.h   |   9 +-
 .../marvell/octeontx2/af/npc_profile.h        | 382 +++---------------
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |   2 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  96 +++++
 7 files changed, 195 insertions(+), 323 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 26ad71842b3b2..472eb2a5697a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -84,7 +84,7 @@ struct mbox_msghdr {
 #define OTX2_MBOX_REQ_SIG (0xdead)
 #define OTX2_MBOX_RSP_SIG (0xbeef)
 	u16 sig;         /* Signature, for validating corrupted msgs */
-#define OTX2_MBOX_VERSION (0x0009)
+#define OTX2_MBOX_VERSION (0x000a)
 	u16 ver;         /* Version of msg's structure for this ID */
 	u16 next_msgoff; /* Offset of next msg within mailbox region */
 	int rc;          /* Msg process'ed response code */
@@ -229,6 +229,8 @@ M(NPC_DELETE_FLOW,	  0x600e, npc_delete_flow,			\
 M(NPC_MCAM_READ_ENTRY,	  0x600f, npc_mcam_read_entry,			\
 				  npc_mcam_read_entry_req,		\
 				  npc_mcam_read_entry_rsp)		\
+M(NPC_SET_PKIND,        0x6010,   npc_set_pkind,                        \
+				  npc_set_pkind, msg_rsp)               \
 M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
 				   msg_req, npc_mcam_read_base_rule_rsp)  \
 M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
@@ -593,6 +595,22 @@ struct rpm_stats_rsp {
 	u64 tx_stats[RPM_TX_STATS_COUNT];
 };
 
+struct npc_set_pkind {
+	struct mbox_msghdr hdr;
+#define OTX2_PRIV_FLAGS_DEFAULT  BIT_ULL(0)
+#define OTX2_PRIV_FLAGS_CUSTOM   BIT_ULL(63)
+	u64 mode;
+#define PKIND_TX		BIT_ULL(0)
+#define PKIND_RX		BIT_ULL(1)
+	u8 dir;
+	u8 pkind; /* valid only in case custom flag */
+	u8 var_len_off; /* Offset of custom header length field.
+			 * Valid only for pkind NPC_RX_CUSTOM_PRE_L2_PKIND
+			 */
+	u8 var_len_off_mask; /* Mask for length with in offset */
+	u8 shift_dir; /* shift direction to get length of the header at var_len_off */
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3a819b24accc6..6e1192f526089 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -31,9 +31,9 @@ enum npc_kpu_la_ltype {
 	NPC_LT_LA_HIGIG2_ETHER,
 	NPC_LT_LA_IH_NIX_HIGIG2_ETHER,
 	NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-	NPC_LT_LA_CH_LEN_90B_ETHER,
 	NPC_LT_LA_CPT_HDR,
 	NPC_LT_LA_CUSTOM_L2_24B_ETHER,
+	NPC_LT_LA_CUSTOM_PRE_L2_ETHER,
 	NPC_LT_LA_CUSTOM0 = 0xE,
 	NPC_LT_LA_CUSTOM1 = 0xF,
 };
@@ -148,10 +148,11 @@ enum npc_kpu_lh_ltype {
  * Software assigns pkind for each incoming port such as CGX
  * Ethernet interfaces, LBK interfaces, etc.
  */
-#define NPC_UNRESERVED_PKIND_COUNT NPC_RX_VLAN_EXDSA_PKIND
+#define NPC_UNRESERVED_PKIND_COUNT NPC_RX_CUSTOM_PRE_L2_PKIND
 
 enum npc_pkind_type {
 	NPC_RX_LBK_PKIND = 0ULL,
+	NPC_RX_CUSTOM_PRE_L2_PKIND = 55ULL,
 	NPC_RX_VLAN_EXDSA_PKIND = 56ULL,
 	NPC_RX_CHLEN24B_PKIND = 57ULL,
 	NPC_RX_CPT_HDR_PKIND,
@@ -162,6 +163,10 @@ enum npc_pkind_type {
 	NPC_TX_DEF_PKIND,	/* NIX-TX PKIND */
 };
 
+enum npc_interface_type {
+	NPC_INTF_MODE_DEF,
+};
+
 /* list of known and supported fields in packet header and
  * fields present in key structure.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 588822a0cf21e..2b7030886daec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -176,9 +176,8 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU1_EXDSA,
 	NPC_S_KPU1_HIGIG2,
 	NPC_S_KPU1_IH_NIX_HIGIG2,
-	NPC_S_KPU1_CUSTOM_L2_90B,
+	NPC_S_KPU1_CUSTOM_PRE_L2,
 	NPC_S_KPU1_CPT_HDR,
-	NPC_S_KPU1_CUSTOM_L2_24B,
 	NPC_S_KPU1_VLAN_EXDSA,
 	NPC_S_KPU2_CTAG,
 	NPC_S_KPU2_CTAG2,
@@ -979,8 +978,8 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 16, 20, 0, 0,
-		NPC_S_KPU1_ETHER, 0, 0,
-		NPC_LID_LA, NPC_LT_NA,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0, 1,
+		NPC_LID_LA, NPC_LT_LA_CUSTOM_PRE_L2_ETHER,
 		0,
 		0, 0, 0, 0,
 
@@ -996,9 +995,9 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		36, 40, 44, 0, 0,
-		NPC_S_KPU1_CUSTOM_L2_24B, 0, 0,
-		NPC_LID_LA, NPC_LT_NA,
+		12, 16, 20, 0, 0,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 24, 1,
+		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
 		0,
 		0, 0, 0, 0,
 
@@ -1014,9 +1013,9 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		102, 106, 110, 0, 0,
-		NPC_S_KPU1_CUSTOM_L2_90B, 0, 0,
-		NPC_LID_LA, NPC_LT_NA,
+		12, 16, 20, 0, 0,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 90, 1,
+		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
 		0,
 		0, 0, 0, 0,
 
@@ -1711,7 +1710,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_IP,
 		0xffff,
 		0x0000,
@@ -1720,7 +1719,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_IP6,
 		0xffff,
 		0x0000,
@@ -1729,7 +1728,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_ARP,
 		0xffff,
 		0x0000,
@@ -1738,7 +1737,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_RARP,
 		0xffff,
 		0x0000,
@@ -1747,7 +1746,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_PTP,
 		0xffff,
 		0x0000,
@@ -1756,7 +1755,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_FCOE,
 		0xffff,
 		0x0000,
@@ -1765,7 +1764,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_CTAG,
 		0xffff,
 		NPC_ETYPE_CTAG,
@@ -1774,7 +1773,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_CTAG,
 		0xffff,
 		0x0000,
@@ -1783,7 +1782,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_SBTAG,
 		0xffff,
 		0x0000,
@@ -1792,7 +1791,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_QINQ,
 		0xffff,
 		0x0000,
@@ -1801,7 +1800,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_ETAG,
 		0xffff,
 		0x0000,
@@ -1810,7 +1809,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_MPLSU,
 		0xffff,
 		0x0000,
@@ -1819,7 +1818,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_MPLSM,
 		0xffff,
 		0x0000,
@@ -1828,7 +1827,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		NPC_ETYPE_NSH,
 		0xffff,
 		0x0000,
@@ -1837,7 +1836,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU1_CUSTOM_L2_90B, 0xff,
+		NPC_S_KPU1_CUSTOM_PRE_L2, 0xff,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -1926,141 +1925,6 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_IP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_IP6,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_ARP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_RARP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_PTP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_FCOE,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_SBTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_QINQ,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_ETAG,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_MPLSU,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_MPLSM,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		NPC_ETYPE_NSH,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CUSTOM_L2_24B, 0xff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU1_VLAN_EXDSA, 0xff,
 		NPC_ETYPE_CTAG,
@@ -9192,121 +9056,121 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
-		NPC_S_KPU5_IP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_IP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		6, 0, 0, 3, 0,
-		NPC_S_KPU5_IP6, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_IP6, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_ARP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_ARP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_RARP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_RARP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_PTP, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_PTP, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 3, 0,
-		NPC_S_KPU5_FCOE, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
+		NPC_S_KPU5_FCOE, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 12, 0, 0, 0,
-		NPC_S_KPU2_CTAG2, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_CTAG2, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_CTAG, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 22, 0, 0,
-		NPC_S_KPU2_SBTAG, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_SBTAG, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
+		NPC_S_KPU2_QINQ, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 12, 26, 0, 0,
-		NPC_S_KPU2_ETAG, 102, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_ETAG,
+		NPC_S_KPU2_ETAG, 12, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
+		NPC_S_KPU4_MPLS, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
+		NPC_S_KPU4_MPLS, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 0, 0, 2, 0,
-		NPC_S_KPU4_NSH, 104, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_WITH_NSH,
+		NPC_S_KPU4_NSH, 14, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_90B_ETHER,
-		NPC_F_LA_L_UNK_ETYPE,
+		NPC_S_NA, 0, 0,
+		NPC_LID_LA, NPC_LT_NA,
+		0,
 		0, 0, 0, 0,
 	},
 	{
@@ -9381,126 +9245,6 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 		NPC_F_LA_L_UNK_ETYPE,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 3, 0,
-		NPC_S_KPU5_IP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 3, 0,
-		NPC_S_KPU5_IP6, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_ARP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_RARP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_PTP, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 3, 0,
-		NPC_S_KPU5_FCOE, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 12, 0, 0, 0,
-		NPC_S_KPU2_CTAG2, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 22, 0, 0,
-		NPC_S_KPU2_SBTAG, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 12, 26, 0, 0,
-		NPC_S_KPU2_ETAG, 36, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_ETAG,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 2, 0,
-		NPC_S_KPU4_MPLS, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_WITH_MPLS,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 0, 0, 2, 0,
-		NPC_S_KPU4_NSH, 38, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_WITH_NSH,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LA, NPC_LT_LA_CUSTOM_L2_24B_ETHER,
-		NPC_F_LA_L_UNK_ETYPE,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 0, 0, 1, 0,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 1d9411232f1da..c3979ec2bb86d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -237,6 +237,7 @@ struct rvu_pfvf {
 	bool	cgx_in_use; /* this PF/VF using CGX? */
 	int	cgx_users;  /* number of cgx users - used only by PFs */
 
+	int     intf_mode;
 	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 	u8	nix_rx_intf; /* NIX0_RX/NIX1_RX interface to NPC */
 	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
@@ -794,6 +795,7 @@ void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 int blkaddr, u16 src, struct mcam_entry *entry,
 			 u8 *intf, u8 *ena);
+bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc);
 bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 void *rvu_first_cgx_pdata(struct rvu *rvu);
@@ -827,4 +829,7 @@ void rvu_switch_enable(struct rvu *rvu);
 void rvu_switch_disable(struct rvu *rvu);
 void rvu_switch_update_rules(struct rvu *rvu, u16 pcifunc);
 
+int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
+			   u64 pkind, u8 var_len_off, u8 var_len_off_mask,
+			   u8 shift_dir);
 #endif /* RVU_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 81e8ea9ee30ea..21e5906bcc372 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -411,7 +411,7 @@ int rvu_cgx_exit(struct rvu *rvu)
  * VF's of mapped PF and other PFs are not allowed. This fn() checks
  * whether a PFFUNC is permitted to do the config or not.
  */
-static bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
+inline bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
 {
 	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
 	    !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 959266894cf15..f43df4683943d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4555,6 +4555,10 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 			dev_err(rvu->dev, "CQ ctx disable failed\n");
 	}
 
+	/* reset HW config done for Switch headers */
+	rvu_npc_set_parse_mode(rvu, pcifunc, OTX2_PRIV_FLAGS_DEFAULT,
+			       (PKIND_TX | PKIND_RX), 0, 0, 0, 0);
+
 	nix_ctx_free(rvu, pfvf);
 
 	nix_free_all_bandprof(rvu, pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 87f18e32b4634..2f347e937f00a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -3183,6 +3183,102 @@ int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int
+npc_set_var_len_offset_pkind(struct rvu *rvu, u16 pcifunc, u64 pkind,
+			     u8 var_len_off, u8 var_len_off_mask, u8 shift_dir)
+{
+	struct npc_kpu_action0 *act0;
+	u8 shift_count = 0;
+	int blkaddr;
+	u64 val;
+
+	if (!var_len_off_mask)
+		return -EINVAL;
+
+	if (var_len_off_mask != 0xff) {
+		if (shift_dir)
+			shift_count = __ffs(var_len_off_mask);
+		else
+			shift_count = (8 - __fls(var_len_off_mask));
+	}
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, pcifunc);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -EINVAL;
+	}
+	val = rvu_read64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind));
+	act0 = (struct npc_kpu_action0 *)&val;
+	act0->var_len_shift = shift_count;
+	act0->var_len_right = shift_dir;
+	act0->var_len_mask = var_len_off_mask;
+	act0->var_len_offset = var_len_off;
+	rvu_write64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind), val);
+	return 0;
+}
+
+int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
+			   u64 pkind, u8 var_len_off, u8 var_len_off_mask,
+			   u8 shift_dir)
+
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int blkaddr, nixlf, rc, intf_mode;
+	int pf = rvu_get_pf(pcifunc);
+	u64 rxpkind, txpkind;
+	u8 cgx_id, lmac_id;
+
+	/* use default pkind to disable edsa/higig */
+	rxpkind = rvu_npc_get_pkind(rvu, pf);
+	txpkind = NPC_TX_DEF_PKIND;
+	intf_mode = NPC_INTF_MODE_DEF;
+
+	if (mode & OTX2_PRIV_FLAGS_CUSTOM) {
+		if (pkind == NPC_RX_CUSTOM_PRE_L2_PKIND) {
+			rc = npc_set_var_len_offset_pkind(rvu, pcifunc, pkind,
+							  var_len_off,
+							  var_len_off_mask,
+							  shift_dir);
+			if (rc)
+				return rc;
+		}
+		rxpkind = pkind;
+		txpkind = pkind;
+	}
+
+	if (dir & PKIND_RX) {
+		/* rx pkind set req valid only for cgx mapped PFs */
+		if (!is_cgx_config_permitted(rvu, pcifunc))
+			return 0;
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+		rc = cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				   rxpkind);
+		if (rc)
+			return rc;
+	}
+
+	if (dir & PKIND_TX) {
+		/* Tx pkind set request valid if PCIFUNC has NIXLF attached */
+		rc = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+		if (rc)
+			return rc;
+
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf),
+			    txpkind);
+	}
+
+	pfvf->intf_mode = intf_mode;
+	return 0;
+}
+
+int rvu_mbox_handler_npc_set_pkind(struct rvu *rvu, struct npc_set_pkind *req,
+				   struct msg_rsp *rsp)
+{
+	return rvu_npc_set_parse_mode(rvu, req->hdr.pcifunc, req->mode,
+				      req->dir, req->pkind, req->var_len_off,
+				      req->var_len_off_mask, req->shift_dir);
+}
+
 int rvu_mbox_handler_npc_read_base_steer_rule(struct rvu *rvu,
 					      struct msg_req *req,
 					      struct npc_mcam_read_base_rule_rsp *rsp)
-- 
2.34.1



