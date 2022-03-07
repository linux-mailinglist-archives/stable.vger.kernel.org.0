Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5B94CF717
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbiCGJof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241119AbiCGJly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4DDE19;
        Mon,  7 Mar 2022 01:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D27ECB810B2;
        Mon,  7 Mar 2022 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FC1C340E9;
        Mon,  7 Mar 2022 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646021;
        bh=Siwz6QpJRTt+Npz05OdW3g5gp8nlvX75Sj1MJGMROlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcMnvj5oz9y1ARuvLkV7rLXXFrU4lBMdGr3HgpJN0DWPzJriQcRoT1NrEkES+I1Ff
         gWX5D2O23bG+ybYjNb2XsBgTfT4RlfQIwuYZC3qz68391zdGn/XMrWfFFuXi7Yt94U
         MfH6LKxVKwVYxr52SUocl2HVA8jABv23TYEAHYLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiran Kumar K <kirankumark@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/262] octeontx2-af: Adjust LA pointer for cpt parse header
Date:   Mon,  7 Mar 2022 10:17:32 +0100
Message-Id: <20220307091705.522456744@linuxfoundation.org>
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

[ Upstream commit 85212a127e469c5560daf63a9782755ee4b03619 ]

In case of ltype NPC_LT_LA_CPT_HDR, LA pointer is pointing to the
start of cpt parse header. Since cpt parse header has veriable
length padding, this will be a problem for DMAC extraction. Adding
KPU profile changes to adjust the LA pointer to start at ether header
in case of cpt parse header by
   - Adding ptr advance in pkind 58 to a fixed value 40
   - Adding variable length offset 7 and mask 7 (pad len in
     CPT_PARSE_HDR).
Also added the missing static declaration for npc_set_var_len_offset_pkind
function.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/npc_profile.h        | 173 ++++++++----------
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |   2 +-
 2 files changed, 80 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 2b7030886daec..fad5ecda4e647 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -187,6 +187,8 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU2_PREHEADER,
 	NPC_S_KPU2_EXDSA,
 	NPC_S_KPU2_NGIO,
+	NPC_S_KPU2_CPT_CTAG,
+	NPC_S_KPU2_CPT_QINQ,
 	NPC_S_KPU3_CTAG,
 	NPC_S_KPU3_STAG,
 	NPC_S_KPU3_QINQ,
@@ -1004,11 +1006,11 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		40, 54, 58, 0, 0,
-		NPC_S_KPU1_CPT_HDR, 0, 0,
+		12, 16, 20, 0, 0,
+		NPC_S_KPU1_CPT_HDR, 40, 0,
 		NPC_LID_LA, NPC_LT_NA,
 		0,
-		0, 0, 0, 0,
+		7, 7, 0, 0,
 
 	},
 	{
@@ -1846,80 +1848,35 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
 		NPC_ETYPE_IP,
 		0xffff,
 		0x0000,
 		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_IP6,
-		0xffff,
 		0x0000,
 		0x0000,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_QINQ,
+		NPC_ETYPE_IP6,
 		0xffff,
 		0x0000,
 		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
 		0x0000,
 		0x0000,
-		NPC_ETYPE_IP,
-		0xffff,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
+		NPC_ETYPE_CTAG,
 		0xffff,
 		0x0000,
 		0x0000,
-		NPC_ETYPE_IP6,
-		0xffff,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
 		0x0000,
 		0x0000,
-		NPC_ETYPE_CTAG,
-		0xffff,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		0x0000,
-		0x0000,
 		NPC_ETYPE_QINQ,
 		0xffff,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0x0000,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -2929,6 +2886,42 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU2_CPT_CTAG, 0xff,
+		NPC_ETYPE_IP,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_CTAG, 0xff,
+		NPC_ETYPE_IP6,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_QINQ, 0xff,
+		NPC_ETYPE_CTAG,
+		0xffff,
+		NPC_ETYPE_IP,
+		0xffff,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_QINQ, 0xff,
+		NPC_ETYPE_CTAG,
+		0xffff,
+		NPC_ETYPE_IP6,
+		0xffff,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_NA, 0X00,
 		0x0000,
@@ -9176,39 +9169,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
-		NPC_S_KPU5_CPT_IP, 56, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 3, 0,
-		NPC_S_KPU5_CPT_IP6, 56, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 54, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 54, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 3, 0,
-		NPC_S_KPU5_CPT_IP, 60, 1,
+		NPC_S_KPU5_CPT_IP, 14, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		0,
 		0, 0, 0, 0,
@@ -9216,7 +9177,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		6, 0, 0, 3, 0,
-		NPC_S_KPU5_CPT_IP6, 60, 1,
+		NPC_S_KPU5_CPT_IP6, 14, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		0,
 		0, 0, 0, 0,
@@ -9224,7 +9185,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 58, 1,
+		NPC_S_KPU2_CPT_CTAG, 12, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
 		0, 0, 0, 0,
@@ -9232,19 +9193,11 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 58, 1,
+		NPC_S_KPU2_CPT_QINQ, 12, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_L_UNK_ETYPE,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 0, 0, 1, 0,
@@ -10138,6 +10091,38 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		8, 0, 6, 2, 0,
+		NPC_S_KPU5_CPT_IP, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 2, 0,
+		NPC_S_KPU5_CPT_IP6, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		8, 0, 6, 2, 0,
+		NPC_S_KPU5_CPT_IP, 10, 1,
+		NPC_LID_LB, NPC_LT_LB_STAG_QINQ,
+		NPC_F_LB_U_MORE_TAG | NPC_F_LB_L_WITH_CTAG,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 2, 0,
+		NPC_S_KPU5_CPT_IP6, 10, 1,
+		NPC_LID_LB, NPC_LT_LB_STAG_QINQ,
+		NPC_F_LB_U_MORE_TAG | NPC_F_LB_L_WITH_CTAG,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LB, NPC_EC_L2_K3,
 		0, 0, 0, 0, 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 2f347e937f00a..fbb573c40c1ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -3183,7 +3183,7 @@ int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
-int
+static int
 npc_set_var_len_offset_pkind(struct rvu *rvu, u16 pcifunc, u64 pkind,
 			     u8 var_len_off, u8 var_len_off_mask, u8 shift_dir)
 {
-- 
2.34.1



