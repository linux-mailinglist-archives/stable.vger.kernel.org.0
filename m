Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2A134C78E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhC2IQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232929AbhC2IOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2D4A61477;
        Mon, 29 Mar 2021 08:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005685;
        bh=4VQOAETgK4tCSOh11+Uk4AmzYSjvyWfk78A8is7pybo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yINcY1AlipxuMkQHZ5Kbk/zOoJiwGwZnqtPq30tezl1YyAGslb7FFj+DacUyjgrdU
         5fj+7xvZ2nksMSFIaSM56/o1TYr9OPNCaLX8K9xhL6MV7DKuL3L9X6gfDekkYIxWmU
         r0HFrxcxf2ubHEbG+NXzjXziT5O/53tkRx8nUL10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/111] octeontx2-af: fix infinite loop in unmapping NPC counter
Date:   Mon, 29 Mar 2021 09:58:29 +0200
Message-Id: <20210329075617.910112474@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 64451b98306bf1334a62bcd020ec92bdb4cb68db ]

unmapping npc counter works in a way by traversing all mcam
entries to find which mcam rule is associated with counter.
But loop cursor variable 'entry' is not incremented before
checking next mcam entry which resulting in infinite loop.

This in turn hogs the kworker thread forever and no other
mbox message is processed by AF driver after that.
Fix this by updating entry value before checking next
mcam entry.

Fixes: a958dd59f9ce ("octeontx2-af: Map or unmap NPC MCAM entry and counter")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 15f70273e29c..d82a519a0cd9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1967,10 +1967,10 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
 		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
 		if (index >= mcam->bmap_entries)
 			break;
+		entry = index + 1;
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
 
-		entry = index + 1;
 		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
 					      index, req->cntr);
 	}
-- 
2.30.1



