Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD1F34C759
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhC2IOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232636AbhC2INk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:13:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B71E96196D;
        Mon, 29 Mar 2021 08:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005611;
        bh=42qRDQwA3PzQ8gXbf6yCGbRBR9F6Rn83WITUPpQJlB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPqyxWEn/OmmnMPkbPquqIYU8npw5VhW3CnYvxfsUpGo/wi8cICFgXpDtip624Cla
         NYGKdJXqugnxA/BU/ho5zwE4oAzqSSXrgHda4i7CXtb5NMzQGgZ/QT87IH2stnONdH
         WovU+Uk3rBy/8BYwoJXIBqshg8KJyrYjTsW84b8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/111] veth: Store queue_mapping independently of XDP prog presence
Date:   Mon, 29 Mar 2021 09:58:02 +0200
Message-Id: <20210329075616.995366898@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit edbea922025169c0e5cdca5ebf7bf5374cc5566c ]

Currently, veth_xmit() would call the skb_record_rx_queue() only when
there is XDP program loaded on peer interface in native mode.

If peer has XDP prog in generic mode, then netif_receive_generic_xdp()
has a call to netif_get_rxqueue(skb), so for multi-queue veth it will
not be possible to grab a correct rxq.

To fix that, store queue_mapping independently of XDP prog presence on
peer interface.

Fixes: 638264dc9022 ("veth: Support per queue XDP ring")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Link: https://lore.kernel.org/bpf/20210303152903.11172-1-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 88cfd63f08a6..44ad412f9a06 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -254,8 +254,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
 		rcv_xdp = rcu_access_pointer(rq->xdp_prog);
-		if (rcv_xdp)
-			skb_record_rx_queue(skb, rxq);
+		skb_record_rx_queue(skb, rxq);
 	}
 
 	skb_tx_timestamp(skb);
-- 
2.30.1



