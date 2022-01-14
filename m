Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D448E555
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbiANIRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239525AbiANIRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:17:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C314C06173E;
        Fri, 14 Jan 2022 00:17:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D24DBB82437;
        Fri, 14 Jan 2022 08:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DA8C36AE9;
        Fri, 14 Jan 2022 08:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148241;
        bh=tOSNqUX7EbUWnILsZ/BrQ8o9gGL16w7i1QXnjnaEpXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ABxK+EO+o36H2idPTa1D7BBNkkjszG9E4/kjQg+Wtkx+MEU24Y/NfC3xBJslV0Vv
         La2AN3zgpqR9Sf2iMXkP+qTt2XK2yF70oAzXkod2cdzZn1Wjv8QfngtRFEsb1dllTq
         l9A67RnUk8hOaasSS1TJtOMdUinMKf3hu1rx8goo=
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
Subject: [PATCH 5.4 07/18] veth: Do not record rx queue hint in veth_xmit
Date:   Fri, 14 Jan 2022 09:16:14 +0100
Message-Id: <20220114081541.713024234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
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
@@ -254,7 +254,6 @@ static netdev_tx_t veth_xmit(struct sk_b
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
 		rcv_xdp = rcu_access_pointer(rq->xdp_prog);
-		skb_record_rx_queue(skb, rxq);
 	}
 
 	skb_tx_timestamp(skb);


