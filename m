Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75867408D80
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbhIMN0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241077AbhIMNYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F35610F7;
        Mon, 13 Sep 2021 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539324;
        bh=4GirnvqiFW1de6RlU3zHHWkUkP41eUj0U7fzJXGu/a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZ0u3e4S9Xnqk4qz9tu0ZqswNTc6M5mlyWtAakRkiDw6zCqfmXu1QpDqwhpXSYD6o
         neHccKN92Gza5N7nss4/rZEFJOLK79sEx7lyzhC6zmUwCcZNmWl9ShrFQMUQK46yGa
         UWR0joExND00jyRVKeF8v7/Xu9iYZOve9iUek1Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/144] octeontx2-af: Fix loop in free and unmap counter
Date:   Mon, 13 Sep 2021 15:15:06 +0200
Message-Id: <20210913131052.111182092@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 6537e96d743b89294b397b4865c6c061abae31b0 ]

When the given counter does not belong to the entry
then code ends up in infinite loop because the loop
cursor, entry is not getting updated further. This
patch fixes that by updating entry for every iteration.

Fixes: a958dd59f9ce ("octeontx2-af: Map or unmap NPC MCAM entry and counter")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index d82a519a0cd9..f9f246c82c97 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2013,10 +2013,11 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
 		if (index >= mcam->bmap_entries)
 			break;
+		entry = index + 1;
+
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
 
-		entry = index + 1;
 		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
 					      index, req->cntr);
 	}
-- 
2.30.2



