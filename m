Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B3D6D4A99
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbjDCOst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbjDCOs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:48:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B41F2D48F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB832CE1309
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F007BC433D2;
        Mon,  3 Apr 2023 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533229;
        bh=cnK+bSlq/AFLy6JLlVpQzwyByrm0HpUiKc7cUGMa7iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sm7K9iX2Sj8mdlCC1lWHXyJnsu/xmMxPj7S/YRfbeGg7zy3f+0AgUCJRyJNElNPPd
         8HxPriMxzB9SC7ei527vrRTEe3WGQLz39S+7oommDeADXHdcVv13/XR7maXyx/nBJQ
         oZ12f9jjhqLh+tTPoHCh+6p3M6yb696HigquLpF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Auhagen <sven.auhagen@voleatech.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 103/187] net: mvpp2: parser fix PPPoE
Date:   Mon,  3 Apr 2023 16:09:08 +0200
Message-Id: <20230403140419.363553316@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit 031a416c2170866be5132ae42e14453d669b0cb1 ]

In PPPoE add all IPv4 header option length to the parser
and adjust the L3 and L4 offset accordingly.
Currently the L4 match does not work with PPPoE and
all packets are matched as L3 IP4 OPT.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_prs.c    | 82 ++++++++-----------
 1 file changed, 34 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index ed8be396428b9..9af22f497a40f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1607,59 +1607,45 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
 static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
 {
 	struct mvpp2_prs_entry pe;
-	int tid;
-
-	/* IPv4 over PPPoE with options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
-
-	memset(&pe, 0, sizeof(pe));
-	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
-	pe.index = tid;
-
-	mvpp2_prs_match_etype(&pe, 0, PPP_IP);
-
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4_OPT,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* goto ipv4 dest-address (skip eth_type + IP-header-size - 4) */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
-				 sizeof(struct iphdr) - 4,
-				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
-	/* Set L3 offset */
-	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
-				  MVPP2_ETH_TYPE_LEN,
-				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
-
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
-	mvpp2_prs_hw_write(priv, &pe);
+	int tid, ihl;
 
-	/* IPv4 over PPPoE without options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
+	/* IPv4 over PPPoE with header length >= 5 */
+	for (ihl = MVPP2_PRS_IPV4_IHL_MIN; ihl <= MVPP2_PRS_IPV4_IHL_MAX; ihl++) {
+		tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
+						MVPP2_PE_LAST_FREE_TID);
+		if (tid < 0)
+			return tid;
 
-	pe.index = tid;
+		memset(&pe, 0, sizeof(pe));
+		mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
+		pe.index = tid;
 
-	mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
-				     MVPP2_PRS_IPV4_HEAD |
-				     MVPP2_PRS_IPV4_IHL_MIN,
-				     MVPP2_PRS_IPV4_HEAD_MASK |
-				     MVPP2_PRS_IPV4_IHL_MASK);
+		mvpp2_prs_match_etype(&pe, 0, PPP_IP);
+		mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
+					     MVPP2_PRS_IPV4_HEAD | ihl,
+					     MVPP2_PRS_IPV4_HEAD_MASK |
+					     MVPP2_PRS_IPV4_IHL_MASK);
 
-	/* Clear ri before updating */
-	pe.sram[MVPP2_PRS_SRAM_RI_WORD] = 0x0;
-	pe.sram[MVPP2_PRS_SRAM_RI_CTRL_WORD] = 0x0;
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
+		mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
+		mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
+					 MVPP2_PRS_RI_L3_PROTO_MASK);
+		/* goto ipv4 dst-address (skip eth_type + IP-header-size - 4) */
+		mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
+					 sizeof(struct iphdr) - 4,
+					 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+		/* Set L3 offset */
+		mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
+					  MVPP2_ETH_TYPE_LEN,
+					  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
+		/* Set L4 offset */
+		mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
+					  MVPP2_ETH_TYPE_LEN + (ihl * 4),
+					  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
 
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
-	mvpp2_prs_hw_write(priv, &pe);
+		/* Update shadow table and hw entry */
+		mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
+		mvpp2_prs_hw_write(priv, &pe);
+	}
 
 	/* IPv6 over PPPoE */
 	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-- 
2.39.2



