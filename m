Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11E34F2F1D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242007AbiDEIgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239575AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEAA640E;
        Tue,  5 Apr 2022 01:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E45E5B81B90;
        Tue,  5 Apr 2022 08:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F35C385A0;
        Tue,  5 Apr 2022 08:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146610;
        bh=H+wrthQDzaXAAOeIRN9O2lru9UGFfZdwB03CMg1HSOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMsmOn/Y6cUhor2XlTIGTzudmhmWJaWoB4Tyl7a0cwXysEnsmtWIA42+t/G/y3FrR
         cIH9bdjSohRCyMFumnN7YXCGDi/VEx18QQZHeJF3gP6+CIQMpvf8upN1hkVdZYD4nx
         8uRnde/PbhXLHXUGhxA0l4Ll/5QNln4D9gMCzgac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0825/1126] octeontx2-af: initialize action variable
Date:   Tue,  5 Apr 2022 09:26:12 +0200
Message-Id: <20220405070431.779661459@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



