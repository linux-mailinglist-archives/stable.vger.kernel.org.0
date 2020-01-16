Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7113F5C6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388991AbgAPS6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388978AbgAPRGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8FB20663;
        Thu, 16 Jan 2020 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194403;
        bh=G7QWAhHlmc5ZheBORETdChgk5Ie7dO9owpOgebpVdNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Gxyq5KwWQkhTRUYIf9Uqu1nGBnDJInMz8OT66oLc2t/mQxz9Pw2h9kTQ88bYyr9P
         u9lalDLyWU53G6B5znefvSlTWKbjHJj+WbUNZby4RLNT2yMouj4rgI714RnKY7TsfS
         xyXizDHM33ZnWsh6ERkmaovDbXMEjAMuuOOqPZ1I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 328/671] RDMA/rxe: Consider skb reserve space based on netdev of GID
Date:   Thu, 16 Jan 2020 11:59:26 -0500
Message-Id: <20200116170509.12787-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 3bf3e2b881c1412d0329ce9376dfe1518489b8fc ]

Always consider the skb reserve space based on netdevice of the GID
attribute, regardless of vlan or non vlan netdevice.

Fixes: 43c9fc509fa5 ("rdma_rxe: make rxe work over 802.1q VLAN devices")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 8094cbaa54a9..54add70c22b5 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -533,8 +533,9 @@ struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 	if (unlikely(!skb))
 		goto out;
 
-	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(rxe->ndev));
+	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(ndev));
 
+	/* FIXME: hold reference to this netdev until life of this skb. */
 	skb->dev	= ndev;
 	if (av->network_type == RDMA_NETWORK_IPV4)
 		skb->protocol = htons(ETH_P_IP);
-- 
2.20.1

