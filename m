Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4864092C9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344895AbhIMOPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243880AbhIMOOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B7661AE3;
        Mon, 13 Sep 2021 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540605;
        bh=l2XPui2b8VNLsWo6ZQxuyS/26lW9mt8IOZxqG6t76LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uF7kJqohBISzgs2k5Uu8c+x2KOVVf3NDTPB8ABHg9PXwdgu/Q8YvIfTbuQhSsjWzL
         55DWY91HKFfRJS+euGSksodNdKxWZz7vuQ1iDZQJidKRq5+PDfudhKEfY2w8ffc6bk
         o+DqNHGa3hMxnoTj7byYrgF6Eq6LW8APe3/Psk2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 260/300] octeontx2-af: Fix static code analyzer reported issues
Date:   Mon, 13 Sep 2021 15:15:21 +0200
Message-Id: <20210913131118.123308612@linuxfoundation.org>
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

[ Upstream commit 698a82ebfb4b2f2014baf31b7324b328a2a6366e ]

This patch fixes the static code analyzer reported issues
in rvu_npc.c. The reported errors are different sizes of
operands in bitops and returning uninitialized values.

Fixes: 651cd2652339 ("octeontx2-af: MCAM entry installation support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index c1a3f70063b5..4427abbc3aad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -23,7 +23,7 @@
 #define RSVD_MCAM_ENTRIES_PER_NIXLF	1 /* Ucast for LFs */
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
-#define NPC_HW_TSTAMP_OFFSET		8
+#define NPC_HW_TSTAMP_OFFSET		8ULL
 #define NPC_KEX_CHAN_MASK		0xFFFULL
 #define NPC_KEX_PF_FUNC_MASK		0xFFFFULL
 
@@ -1751,7 +1751,7 @@ static void npc_unmap_mcam_entry_and_cntr(struct rvu *rvu,
 					  int blkaddr, u16 entry, u16 cntr)
 {
 	u16 index = entry & (mcam->banksize - 1);
-	u16 bank = npc_get_bank(mcam, entry);
+	u32 bank = npc_get_bank(mcam, entry);
 
 	/* Remove mapping and reduce counter's refcnt */
 	mcam->entry2cntr_map[entry] = NPC_MCAM_INVALID_MAP;
@@ -2365,8 +2365,8 @@ int rvu_mbox_handler_npc_mcam_shift_entry(struct rvu *rvu,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
 	u16 old_entry, new_entry;
+	int blkaddr, rc = 0;
 	u16 index, cntr;
-	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
-- 
2.30.2



