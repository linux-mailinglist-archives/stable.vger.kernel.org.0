Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AD8148433
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390754AbgAXLTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:19:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390741AbgAXLTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:19:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85B320708;
        Fri, 24 Jan 2020 11:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864752;
        bh=UelN6tDKfbM0VyU4uVtgi7SNJR2wna7rh/JGw2VMtgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0eDBSOKrzhpUYlBBL+KMYoseRKVRVbcAbRSmngz2lBAepiGTBhoBMz7Dun6S6RViH
         X/9wnTKTI2o8MJKQ6L8ArCO1kmQtH2p2QhRwJ2nFVKNIm/NqfHVS4F1wCidW+AgsnN
         r93wR1cKNiDcwAViiAMaYKaUY80j+p7bsxFo8KE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 343/639] RDMA/rxe: Consider skb reserve space based on netdev of GID
Date:   Fri, 24 Jan 2020 10:28:33 +0100
Message-Id: <20200124093130.097354236@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8094cbaa54a9e..54add70c22b5c 100644
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



