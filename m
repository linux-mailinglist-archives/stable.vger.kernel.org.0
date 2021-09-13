Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE844092CC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344909AbhIMOPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244635AbhIMOOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E4F61AE4;
        Mon, 13 Sep 2021 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540602;
        bh=zntWbeY0RpZNmB/tgGvQlXTtojxuBbEAuPqXm+3U/ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6N/pV0qyijmf2GkGFwgpEQv4gOErOrqtyX2Nt5iK6UcZlJ2bFJqcDrgLna+gmIBE
         zHz7Sack/FCLiW7ItcEnB1iV451gVW+fabGDIoLUUPAcqgX9LIejlXlElHLoGmEffx
         IQFi6NDgsdKra48C899fTI6OUUvmiI5YqqikQEts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 259/300] octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg
Date:   Mon, 13 Sep 2021 15:15:20 +0200
Message-Id: <20210913131118.089481001@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit f2e4568ec95166605c77577953b2787c7f909978 ]

In npc_update_vf_flow_entry function the loop cursor
'index' is being changed inside the loop causing
the loop to spin forever. This in turn hogs the kworker
thread forever and no other mbox message is processed
by AF driver after that. Fix this by using
another variable in the loop.

Fixes: 55307fcb9258 ("octeontx2-af: Add mbox messages to install and delete MCAM rules")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 53ee1785c931..c1a3f70063b5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -823,7 +823,7 @@ void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
 static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				     int blkaddr, u16 pcifunc, u64 rx_action)
 {
-	int actindex, index, bank;
+	int actindex, index, bank, entry;
 	bool enable;
 
 	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
@@ -834,7 +834,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 		if (mcam->entry2target_pffunc[index] == pcifunc) {
 			bank = npc_get_bank(mcam, index);
 			actindex = index;
-			index &= (mcam->banksize - 1);
+			entry = index & (mcam->banksize - 1);
 
 			/* read vf flow entry enable status */
 			enable = is_mcam_entry_enabled(rvu, mcam, blkaddr,
@@ -844,7 +844,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 					      false);
 			/* update 'action' */
 			rvu_write64(rvu, blkaddr,
-				    NPC_AF_MCAMEX_BANKX_ACTION(index, bank),
+				    NPC_AF_MCAMEX_BANKX_ACTION(entry, bank),
 				    rx_action);
 			if (enable)
 				npc_enable_mcam_entry(rvu, mcam, blkaddr,
-- 
2.30.2



