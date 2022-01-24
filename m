Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A22B498DFB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347653AbiAXTi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352462AbiAXTab (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:30:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB81C029830;
        Mon, 24 Jan 2022 11:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77FA46090A;
        Mon, 24 Jan 2022 19:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8F3C340E5;
        Mon, 24 Jan 2022 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051632;
        bh=zjFhddV6fMo/XM9nnuuK90VsKmvyM28pHTpGTioDg3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NREVZplD9evTi1zOzP/QsNuiMZzQOeP/5wf6H27lkPjPuHq3d53r1pl+/R90crVhp
         +heKURdbIT9HjY7ovZYqZvdO1weH0sWloAdVztmKaJsJC1A0pj00F5gLBCQGztWPA0
         vYH5qKmyjoy+JTXEPz6PjTrrn8oPG4kmZjlg1Zko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Bernaille <laurent.bernaille@datadoghq.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 005/239] veth: Do not record rx queue hint in veth_xmit
Date:   Mon, 24 Jan 2022 19:40:43 +0100
Message-Id: <20220124183943.285108675@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 710ad98c363a66a0cd8526465426c5c5f8377ee0 upstream.

Laurent reported that they have seen a significant amount of TCP retransmissions
at high throughput from applications residing in network namespaces talking to
the outside world via veths. The drops were seen on the qdisc layer (fq_codel,
as per systemd default) of the phys device such as ena or virtio_net due to all
traffic hitting a _single_ TX queue _despite_ multi-queue device. (Note that the
setup was _not_ using XDP on veths as the issue is generic.)

More specifically, after edbea9220251 ("veth: Store queue_mapping independently
of XDP prog presence") which made it all the way back to v4.19.184+,
skb_record_rx_queue() would set skb->queue_mapping to 1 (given 1 RX and 1 TX
queue by default for veths) instead of leaving at 0.

This is eventually retained and callbacks like ena_select_queue() will also pick
single queue via netdev_core_pick_tx()'s ndo_select_queue() once all the traffic
is forwarded to that device via upper stack or other means. Similarly, for others
not implementing ndo_select_queue() if XPS is disabled, netdev_pick_tx() might
call into the skb_tx_hash() and check for prior skb_rx_queue_recorded() as well.

In general, it is a _bad_ idea for virtual devices like veth to mess around with
queue selection [by default]. Given dev->real_num_tx_queues is by default 1,
the skb->queue_mapping was left untouched, and so prior to edbea9220251 the
netdev_core_pick_tx() could do its job upon __dev_queue_xmit() on the phys device.

Unbreak this and restore prior behavior by removing the skb_record_rx_queue()
from veth_xmit() altogether.

If the veth peer has an XDP program attached, then it would return the first RX
queue index in xdp_md->rx_queue_index (unless configured in non-default manner).
However, this is still better than breaking the generic case.

Fixes: edbea9220251 ("veth: Store queue_mapping independently of XDP prog presence")
Fixes: 638264dc9022 ("veth: Support per queue XDP ring")
Reported-by: Laurent Bernaille <laurent.bernaille@datadoghq.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/veth.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -197,7 +197,6 @@ static netdev_tx_t veth_xmit(struct sk_b
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
 		rcv_xdp = rcu_access_pointer(rq->xdp_prog);
-		skb_record_rx_queue(skb, rxq);
 	}
 
 	if (likely(veth_forward_skb(rcv, skb, rq, rcv_xdp) == NET_RX_SUCCESS)) {


