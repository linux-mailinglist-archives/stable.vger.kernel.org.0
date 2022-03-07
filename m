Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7AF4CF6D9
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiCGJnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbiCGJly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EDCB93;
        Mon,  7 Mar 2022 01:40:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD482B80F9F;
        Mon,  7 Mar 2022 09:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30218C340E9;
        Mon,  7 Mar 2022 09:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646024;
        bh=C2gY0yc/aIldAiiZrv3qT9aP3F8xRf8X+lBHt1DXKzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUTyM/IELB05h9gbToCrCFkj85as8lYiAyfJesff7SzRxHcoZJLA+R2eQivXe19ca
         OGgbp7r23ouVuc3neCeDQvJFenNK3diQWBEHrDbR9c/uH01aS/kck2gX2pAOxBJcaF
         1M3XyfW+G2r8CJ8oVf6+zXiQMaEegjBJIWklxyX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiran Kumar K <kirankumark@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/262] octeontx2-af: Add KPU changes to parse NGIO as separate layer
Date:   Mon,  7 Mar 2022 10:17:33 +0100
Message-Id: <20220307091705.549988903@linuxfoundation.org>
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

[ Upstream commit 745166fcf01cecc4f5ff3defc6586868349a43f9 ]

With current KPU profile NGIO is being parsed along with CTAG as
a single layer. Because of this MCAM/ntuple rules installed with
ethertype as 0x8842 are not being hit. Adding KPU profile changes
to parse NGIO in separate ltype and CTAG in separate ltype.

Fixes: f9c49be90c05 ("octeontx2-af: Update the default KPU profile and fixes")
Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/npc_profile.h        | 70 +++++++++----------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index fad5ecda4e647..695123e32ba85 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -186,7 +186,6 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU2_ETAG,
 	NPC_S_KPU2_PREHEADER,
 	NPC_S_KPU2_EXDSA,
-	NPC_S_KPU2_NGIO,
 	NPC_S_KPU2_CPT_CTAG,
 	NPC_S_KPU2_CPT_QINQ,
 	NPC_S_KPU3_CTAG,
@@ -213,6 +212,7 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU5_NSH,
 	NPC_S_KPU5_CPT_IP,
 	NPC_S_KPU5_CPT_IP6,
+	NPC_S_KPU5_NGIO,
 	NPC_S_KPU6_IP6_EXT,
 	NPC_S_KPU6_IP6_HOP_DEST,
 	NPC_S_KPU6_IP6_ROUT,
@@ -1117,15 +1117,6 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU1_ETHER, 0xff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		NPC_ETYPE_NGIO,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU1_ETHER, 0xff,
 		NPC_ETYPE_CTAG,
@@ -1986,6 +1977,15 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU2_CTAG, 0xff,
+		NPC_ETYPE_NGIO,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_KPU2_CTAG, 0xff,
 		NPC_ETYPE_PPPOE,
@@ -2877,15 +2877,6 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU2_NGIO, 0xff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU2_CPT_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -5205,6 +5196,15 @@ static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU5_NGIO, 0xff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_NA, 0X00,
 		0x0000,
@@ -8499,14 +8499,6 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 12, 0, 0, 0,
-		NPC_S_KPU2_NGIO, 12, 1,
-		NPC_LID_LA, NPC_LT_LA_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 12, 0, 0, 0,
@@ -9291,6 +9283,14 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 2, 0,
+		NPC_S_KPU5_NGIO, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -10083,14 +10083,6 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 		NPC_F_LB_U_UNK_ETYPE | NPC_F_LB_L_EXDSA,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LC, NPC_LT_LC_NGIO,
-		0,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -12154,6 +12146,14 @@ static struct npc_kpu_profile_action kpu5_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 1,
+		NPC_LID_LC, NPC_LT_LC_NGIO,
+		0,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LC, NPC_EC_UNK,
 		0, 0, 0, 0, 1,
-- 
2.34.1



