Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33E734C8BC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhC2IYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231806AbhC2IXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FFDD619CF;
        Mon, 29 Mar 2021 08:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006200;
        bh=drVuqeO6EH03hFK4B3qDi0ktNDzprxhN07ztrzp0zHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVhcIRQi9B3ZQpuV5Wq2iQEWU8lPLCA53QorV4XX8CAIqM3Fyvp9rJH36gViUeM06
         RcOvv1tnHnfwwmWb0DW2IQywxS4YOaMnz/0iGxrVfwgpotLgJ4XOFcKoz1RgAs8b5n
         iIVJgB5wLjrCuUzc9f+C9oRMpljV845qFFH/Oz+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/221] octeontx2-af: fix infinite loop in unmapping NPC counter
Date:   Mon, 29 Mar 2021 09:58:06 +0200
Message-Id: <20210329075634.334220868@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index 511b01dd03ed..169ae491f978 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2035,10 +2035,10 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
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



