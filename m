Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8554F316E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350669AbiDEJ7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbiDEJSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301AB9BADE;
        Tue,  5 Apr 2022 02:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3838B818F3;
        Tue,  5 Apr 2022 09:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E542C385A3;
        Tue,  5 Apr 2022 09:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149516;
        bh=H+wrthQDzaXAAOeIRN9O2lru9UGFfZdwB03CMg1HSOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMWuAaqAWt9rQN92LpAvNUQ+4t7U33QAMWv2sZAc7SpXW0wsXVcdPFz41UPqqXmrC
         r+3KQKBU7WUC2iSE7P+abOka1raME5QNGShOb51EX08UcWzfPRyWFdds+jk2x7VWGK
         26cPmReklCRylZPq1h4NQb1bGAADKXsOdj/op8So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0742/1017] octeontx2-af: initialize action variable
Date:   Tue,  5 Apr 2022 09:27:35 +0200
Message-Id: <20220405070416.288510791@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 33b5bc9e703383e396f275d51fc4bafa48dbae5a ]

Clang static analysis reports this representative issue
rvu_npc.c:898:15: warning: Assigned value is garbage
  or undefined
  req.match_id = action.match_id;
               ^ ~~~~~~~~~~~~~~~

The initial setting of action is conditional on
 if (is_mcam_entry_enabled(...))
The later check of action.op will sometimes be garbage.
So initialize action.

Reduce setting of
  *(u64 *)&action = 0x00;
to
  *(u64 *)&action = 0;

Fixes: 967db3529eca ("octeontx2-af: add support for multicast/promisc packet replication feature")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c   | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 91f86d77cd41..3a31fb8cc155 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -605,7 +605,7 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 	struct npc_install_flow_req req = { 0 };
 	struct npc_install_flow_rsp rsp = { 0 };
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct nix_rx_action action;
+	struct nix_rx_action action = { 0 };
 	int blkaddr, index;
 
 	/* AF's and SDP VFs work in promiscuous mode */
@@ -626,7 +626,6 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 		*(u64 *)&action = npc_get_mcam_action(rvu, mcam,
 						      blkaddr, index);
 	} else {
-		*(u64 *)&action = 0x00;
 		action.op = NIX_RX_ACTIONOP_UCAST;
 		action.pf_func = pcifunc;
 	}
@@ -657,7 +656,7 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct rvu_hwinfo *hw = rvu->hw;
 	int blkaddr, ucast_idx, index;
-	struct nix_rx_action action;
+	struct nix_rx_action action = { 0 };
 	u64 relaxed_mask;
 
 	if (!hw->cap.nix_rx_multicast && is_cgx_vf(rvu, pcifunc))
@@ -685,14 +684,14 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 						      blkaddr, ucast_idx);
 
 	if (action.op != NIX_RX_ACTIONOP_RSS) {
-		*(u64 *)&action = 0x00;
+		*(u64 *)&action = 0;
 		action.op = NIX_RX_ACTIONOP_UCAST;
 	}
 
 	/* RX_ACTION set to MCAST for CGX PF's */
 	if (hw->cap.nix_rx_multicast && pfvf->use_mce_list &&
 	    is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc))) {
-		*(u64 *)&action = 0x00;
+		*(u64 *)&action = 0;
 		action.op = NIX_RX_ACTIONOP_MCAST;
 		pfvf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
 		action.index = pfvf->promisc_mce_idx;
@@ -832,7 +831,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	struct rvu_hwinfo *hw = rvu->hw;
 	int blkaddr, ucast_idx, index;
 	u8 mac_addr[ETH_ALEN] = { 0 };
-	struct nix_rx_action action;
+	struct nix_rx_action action = { 0 };
 	struct rvu_pfvf *pfvf;
 	u16 vf_func;
 
@@ -861,14 +860,14 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 							blkaddr, ucast_idx);
 
 	if (action.op != NIX_RX_ACTIONOP_RSS) {
-		*(u64 *)&action = 0x00;
+		*(u64 *)&action = 0;
 		action.op = NIX_RX_ACTIONOP_UCAST;
 		action.pf_func = pcifunc;
 	}
 
 	/* RX_ACTION set to MCAST for CGX PF's */
 	if (hw->cap.nix_rx_multicast && pfvf->use_mce_list) {
-		*(u64 *)&action = 0x00;
+		*(u64 *)&action = 0;
 		action.op = NIX_RX_ACTIONOP_MCAST;
 		action.index = pfvf->mcast_mce_idx;
 	}
-- 
2.34.1



