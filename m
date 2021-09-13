Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280AF4095D7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346078AbhIMOpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347765AbhIMOmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DFF0610FB;
        Mon, 13 Sep 2021 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541420;
        bh=Xezg9x5wjCOpfRC0YXkQm+V8U2cOtxHhM0BhpR4zjBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwbdsg1WWjJaFEazEu35sKHxSQ7AqU9PQjLhZt+50zWLnv9TDlA3LXQL+mezZIG+I
         o5TNxiIxSFgNmSFJ5rG7r0P1z356Kohsk3arotbfmawMb5vR/LsZ8FNncYmqZIDKJE
         JXX2hEOEwkEX3unzzUPRPJ1Glv2C0KZ0MNj+2tzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 291/334] octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg
Date:   Mon, 13 Sep 2021 15:15:45 +0200
Message-Id: <20210913131123.266058986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 38e8d58cf8a0..0122310ee3a7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -938,7 +938,7 @@ void rvu_npc_enable_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				     int blkaddr, u16 pcifunc, u64 rx_action)
 {
-	int actindex, index, bank;
+	int actindex, index, bank, entry;
 	bool enable;
 
 	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
@@ -949,7 +949,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 		if (mcam->entry2target_pffunc[index] == pcifunc) {
 			bank = npc_get_bank(mcam, index);
 			actindex = index;
-			index &= (mcam->banksize - 1);
+			entry = index & (mcam->banksize - 1);
 
 			/* read vf flow entry enable status */
 			enable = is_mcam_entry_enabled(rvu, mcam, blkaddr,
@@ -959,7 +959,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
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



