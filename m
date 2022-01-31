Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE024A43F0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359198AbiAaLZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41290 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377488AbiAaLXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA7ACB82A66;
        Mon, 31 Jan 2022 11:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC34BC340E8;
        Mon, 31 Jan 2022 11:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628180;
        bh=ejZ3+VcKOF2fi6Kv8uF1OBEzCn4J7O1TRHenkBL77kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEdkS8H7pmw8M4fNPT96CvUnoIqgbQ2jbyMiKi7ltfqSx2+KfNmAmNFYRhnTmkUrE
         PY9ADsx3gwFAs2mI9RmPSMVdB1dwzbEj1nUSSWobAa0iWY6EBNpTqcmLfWr+P5fzqB
         Tnw0uClAblE8h+1MUGz+2yUoAhyZF0aXPNztC/OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiran Kumar K <kirankumark@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 150/200] octeontx2-af: Add KPU changes to parse NGIO as separate layer
Date:   Mon, 31 Jan 2022 11:56:53 +0100
Message-Id: <20220131105238.605683728@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 0fe7ad35e36fd..4180376fa6763 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -185,7 +185,6 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU2_QINQ,
 	NPC_S_KPU2_ETAG,
 	NPC_S_KPU2_EXDSA,
-	NPC_S_KPU2_NGIO,
 	NPC_S_KPU2_CPT_CTAG,
 	NPC_S_KPU2_CPT_QINQ,
 	NPC_S_KPU3_CTAG,
@@ -212,6 +211,7 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU5_NSH,
 	NPC_S_KPU5_CPT_IP,
 	NPC_S_KPU5_CPT_IP6,
+	NPC_S_KPU5_NGIO,
 	NPC_S_KPU6_IP6_EXT,
 	NPC_S_KPU6_IP6_HOP_DEST,
 	NPC_S_KPU6_IP6_ROUT,
@@ -1120,15 +1120,6 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
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
@@ -1966,6 +1957,15 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
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
@@ -2749,15 +2749,6 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
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
@@ -5089,6 +5080,15 @@ static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
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
@@ -8422,14 +8422,6 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
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
@@ -9194,6 +9186,14 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
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
@@ -9890,14 +9890,6 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
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
@@ -11973,6 +11965,14 @@ static struct npc_kpu_profile_action kpu5_action_entries[] = {
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



