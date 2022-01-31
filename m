Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CF54A4390
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376725AbiAaLV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378435AbiAaLUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E2FC0604C4;
        Mon, 31 Jan 2022 03:12:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7C8B82A60;
        Mon, 31 Jan 2022 11:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B0FC36AE2;
        Mon, 31 Jan 2022 11:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627550;
        bh=i6vNzAuUx7hTZc8ChAo/kuIGElfoW0kNZKcnVbrqh1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d30/Gpp/ytFMruGFHtWljNgQQIF9nqatV1MSoyFyEh9cpH3nG/nLrRJtorH2Z8nhw
         LZKTx5EdvbPxDCYWNoCH/Jus4p2V9KTx6MH/8B4IvzN6w9Aaz1vh5C91P2CY66kmZ9
         SklsmgCTwUS2DdXCELnvAxqj6thW8l/onyMhFl1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/171] octeontx2-af: Do not fixup all VF action entries
Date:   Mon, 31 Jan 2022 11:56:25 +0100
Message-Id: <20220131105234.102954173@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit d225c449ab2be25273a3674f476c6c0b57c50254 ]

AF modifies all the rules destined for VF to use
the action same as default RSS action. This fixup
was needed because AF only installs default rules with
RSS action. But the action in rules installed by a PF
for its VFs should not be changed by this fixup.
This is because action can be drop or direct to
queue as specified by user(ntuple filters).
This patch fixes that problem.

Fixes: 967db3529eca ("octeontx2-af: add support for multicast/promisc packet")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 22 ++++++++++++++++---
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 20 ++++++++++-------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 5efb4174e82df..87f18e32b4634 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -402,6 +402,7 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 			      int blkaddr, int index, struct mcam_entry *entry,
 			      bool *enable)
 {
+	struct rvu_npc_mcam_rule *rule;
 	u16 owner, target_func;
 	struct rvu_pfvf *pfvf;
 	u64 rx_action;
@@ -423,6 +424,12 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 	      test_bit(NIXLF_INITIALIZED, &pfvf->flags)))
 		*enable = false;
 
+	/* fix up not needed for the rules added by user(ntuple filters) */
+	list_for_each_entry(rule, &mcam->mcam_rules, list) {
+		if (rule->entry == index)
+			return;
+	}
+
 	/* copy VF default entry action to the VF mcam entry */
 	rx_action = npc_get_default_entry_action(rvu, mcam, blkaddr,
 						 target_func);
@@ -489,8 +496,8 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	}
 
 	/* PF installing VF rule */
-	if (intf == NIX_INTF_RX && actindex < mcam->bmap_entries)
-		npc_fixup_vf_rule(rvu, mcam, blkaddr, index, entry, &enable);
+	if (is_npc_intf_rx(intf) && actindex < mcam->bmap_entries)
+		npc_fixup_vf_rule(rvu, mcam, blkaddr, actindex, entry, &enable);
 
 	/* Set 'action' */
 	rvu_write64(rvu, blkaddr,
@@ -916,7 +923,8 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				     int blkaddr, u16 pcifunc, u64 rx_action)
 {
 	int actindex, index, bank, entry;
-	bool enable;
+	struct rvu_npc_mcam_rule *rule;
+	bool enable, update;
 
 	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
 		return;
@@ -924,6 +932,14 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	mutex_lock(&mcam->lock);
 	for (index = 0; index < mcam->bmap_entries; index++) {
 		if (mcam->entry2target_pffunc[index] == pcifunc) {
+			update = true;
+			/* update not needed for the rules added via ntuple filters */
+			list_for_each_entry(rule, &mcam->mcam_rules, list) {
+				if (rule->entry == index)
+					update = false;
+			}
+			if (!update)
+				continue;
 			bank = npc_get_bank(mcam, index);
 			actindex = index;
 			entry = index & (mcam->banksize - 1);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 51ddc7b81d0bd..ca404d51d9f56 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1098,14 +1098,6 @@ find_rule:
 		write_req.cntr = rule->cntr;
 	}
 
-	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req,
-						    &write_rsp);
-	if (err) {
-		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
-		if (new)
-			kfree(rule);
-		return err;
-	}
 	/* update rule */
 	memcpy(&rule->packet, &dummy.packet, sizeof(rule->packet));
 	memcpy(&rule->mask, &dummy.mask, sizeof(rule->mask));
@@ -1129,6 +1121,18 @@ find_rule:
 	if (req->default_rule)
 		pfvf->def_ucast_rule = rule;
 
+	/* write to mcam entry registers */
+	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req,
+						    &write_rsp);
+	if (err) {
+		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
+		if (new) {
+			list_del(&rule->list);
+			kfree(rule);
+		}
+		return err;
+	}
+
 	/* VF's MAC address is being changed via PF  */
 	if (pf_set_vfs_mac) {
 		ether_addr_copy(pfvf->default_mac, req->packet.dmac);
-- 
2.34.1



