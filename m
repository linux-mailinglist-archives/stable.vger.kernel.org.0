Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D2928B889
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389976AbgJLNxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731542AbgJLNrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:47:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2540E221FE;
        Mon, 12 Oct 2020 13:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510394;
        bh=jsICx4f8JQKeXPa/962jhRrlk6pnLBFzBY8lgQx4K3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGkcPEpWkZ8/IKRgxXl9347PPPr3o19V5QgndmBICSMJFvgzDzPW0hMBAnDN+baU5
         zK/k0cFQohsJ/m5FZfskeOLUweT/ZPIvcnStUnwLXh+Ewh+OxYPNHxZnsLR5U3AxFf
         +WJu5CBfZn6b4nVJphtG7aQkpunrHf1lNP/0YcCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 079/124] octeontx2-af: Fix enable/disable of default NPC entries
Date:   Mon, 12 Oct 2020 15:31:23 +0200
Message-Id: <20201012133150.682928735@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit e154b5b70368a84a19505a0be9b0096c66562b56 ]

Packet replication feature present in Octeontx2
is a hardware linked list of PF and its VF
interfaces so that broadcast packets are sent
to all interfaces present in the list. It is
driver job to add and delete a PF/VF interface
to/from the list when the interface is brought
up and down. This patch fixes the
npc_enadis_default_entries function to handle
broadcast replication properly if packet replication
feature is present.

Fixes: 40df309e4166 ("octeontx2-af: Support to enable/disable default MCAM entries")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  3 ++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  5 ++--
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 26 ++++++++++++++-----
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index dcf25a0920084..b89dde2c8b089 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -463,6 +463,7 @@ void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr);
+int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
@@ -477,7 +478,7 @@ void rvu_npc_disable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, u64 chan);
-void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc);
+void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable);
 int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4f51c73..3495b3a6828c0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -17,7 +17,6 @@
 #include "npc.h"
 #include "cgx.h"
 
-static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
 static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 			    int type, int chan_id);
 
@@ -2020,7 +2019,7 @@ static int nix_update_mce_list(struct nix_mce_list *mce_list,
 	return 0;
 }
 
-static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
+int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 {
 	int err = 0, idx, next_idx, last_idx;
 	struct nix_mce_list *mce_list;
@@ -2065,7 +2064,7 @@ static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 
 	/* Disable MCAM entry in NPC */
 	if (!mce_list->count) {
-		rvu_npc_disable_bcast_entry(rvu, pcifunc);
+		rvu_npc_enable_bcast_entry(rvu, pcifunc, false);
 		goto end;
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0a214084406a6..fbaf9bcd83f2f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -530,7 +530,7 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 			      NIX_INTF_RX, &entry, true);
 }
 
-void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc)
+void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	int blkaddr, index;
@@ -543,7 +543,7 @@ void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc)
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc, 0, NIXLF_BCAST_ENTRY);
-	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, false);
+	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 }
 
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
@@ -622,23 +622,35 @@ static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
 					 nixlf, NIXLF_UCAST_ENTRY);
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 
-	/* For PF, ena/dis promisc and bcast MCAM match entries */
-	if (pcifunc & RVU_PFVF_FUNC_MASK)
+	/* For PF, ena/dis promisc and bcast MCAM match entries.
+	 * For VFs add/delete from bcast list when RX multicast
+	 * feature is present.
+	 */
+	if (pcifunc & RVU_PFVF_FUNC_MASK && !rvu->hw->cap.nix_rx_multicast)
 		return;
 
 	/* For bcast, enable/disable only if it's action is not
 	 * packet replication, incase if action is replication
-	 * then this PF's nixlf is removed from bcast replication
+	 * then this PF/VF's nixlf is removed from bcast replication
 	 * list.
 	 */
-	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc & ~RVU_PFVF_FUNC_MASK,
 					 nixlf, NIXLF_BCAST_ENTRY);
 	bank = npc_get_bank(mcam, index);
 	*(u64 *)&action = rvu_read64(rvu, blkaddr,
 	     NPC_AF_MCAMEX_BANKX_ACTION(index & (mcam->banksize - 1), bank));
-	if (action.op != NIX_RX_ACTIONOP_MCAST)
+
+	/* VFs will not have BCAST entry */
+	if (action.op != NIX_RX_ACTIONOP_MCAST &&
+	    !(pcifunc & RVU_PFVF_FUNC_MASK)) {
 		npc_enable_mcam_entry(rvu, mcam,
 				      blkaddr, index, enable);
+	} else {
+		nix_update_bcast_mce_list(rvu, pcifunc, enable);
+		/* Enable PF's BCAST entry for packet replication */
+		rvu_npc_enable_bcast_entry(rvu, pcifunc, enable);
+	}
+
 	if (enable)
 		rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf);
 	else
-- 
2.25.1



