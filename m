Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19B924B991
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbgHTLsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgHTKCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77DDF22BED;
        Thu, 20 Aug 2020 10:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917766;
        bh=eSuaLEycDt/TmbELdr/7tA34qeKIfGtLC3IoZFjSsNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlcdVXK9ylEfxdvwbhlAfotQmXSOilxiOJIbx8UqbZfZc0LzXFsSPFQ1er1WJN4fv
         GZ4Wj8tTOdQei++LkJZXZbOD6iNRjPcL36Ahy0beeS+p7g9GveZSbhm47QSnCk+hOm
         xD3aAiOB+UfkfGE+5R3TaujIe1+HsAnejjKQkTeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Brian Norris <briannorris@chromium.org>,
        Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 150/212] drivers/net/wan/lapbether: Added needed_headroom and a skb->len check
Date:   Thu, 20 Aug 2020 11:22:03 +0200
Message-Id: <20200820091609.992612876@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit c7ca03c216acb14466a713fedf1b9f2c24994ef2 ]

1. Added a skb->len check

This driver expects upper layers to include a pseudo header of 1 byte
when passing down a skb for transmission. This driver will read this
1-byte header. This patch added a skb->len check before reading the
header to make sure the header exists.

2. Changed to use needed_headroom instead of hard_header_len to request
necessary headroom to be allocated

In net/packet/af_packet.c, the function packet_snd first reserves a
headroom of length (dev->hard_header_len + dev->needed_headroom).
Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
which calls dev->header_ops->create, to create the link layer header.
If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
length (dev->hard_header_len), and assumes the user to provide the
appropriate link layer header.

So according to the logic of af_packet.c, dev->hard_header_len should
be the length of the header that would be created by
dev->header_ops->create.

However, this driver doesn't provide dev->header_ops, so logically
dev->hard_header_len should be 0.

So we should use dev->needed_headroom instead of dev->hard_header_len
to request necessary headroom to be allocated.

This change fixes kernel panic when this driver is used with AF_PACKET
SOCK_RAW sockets.

Call stack when panic:

[  168.399197] skbuff: skb_under_panic: text:ffffffff819d95fb len:20
put:14 head:ffff8882704c0a00 data:ffff8882704c09fd tail:0x11 end:0xc0
dev:veth0
...
[  168.399255] Call Trace:
[  168.399259]  skb_push.cold+0x14/0x24
[  168.399262]  eth_header+0x2b/0xc0
[  168.399267]  lapbeth_data_transmit+0x9a/0xb0 [lapbether]
[  168.399275]  lapb_data_transmit+0x22/0x2c [lapb]
[  168.399277]  lapb_transmit_buffer+0x71/0xb0 [lapb]
[  168.399279]  lapb_kick+0xe3/0x1c0 [lapb]
[  168.399281]  lapb_data_request+0x76/0xc0 [lapb]
[  168.399283]  lapbeth_xmit+0x56/0x90 [lapbether]
[  168.399286]  dev_hard_start_xmit+0x91/0x1f0
[  168.399289]  ? irq_init_percpu_irqstack+0xc0/0x100
[  168.399291]  __dev_queue_xmit+0x721/0x8e0
[  168.399295]  ? packet_parse_headers.isra.0+0xd2/0x110
[  168.399297]  dev_queue_xmit+0x10/0x20
[  168.399298]  packet_sendmsg+0xbf0/0x19b0
......

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Brian Norris <briannorris@chromium.org>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/lapbether.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -160,6 +160,12 @@ static netdev_tx_t lapbeth_xmit(struct s
 	if (!netif_running(dev))
 		goto drop;
 
+	/* There should be a pseudo header of 1 byte added by upper layers.
+	 * Check to make sure it is there before reading it.
+	 */
+	if (skb->len < 1)
+		goto drop;
+
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:
 		break;
@@ -308,6 +314,7 @@ static void lapbeth_setup(struct net_dev
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->destructor	     = free_netdev;
 	dev->type            = ARPHRD_X25;
+	dev->hard_header_len = 0;
 	dev->mtu             = 1000;
 	dev->addr_len        = 0;
 }
@@ -334,7 +341,8 @@ static int lapbeth_new_device(struct net
 	 * then this driver prepends a length field of 2 bytes,
 	 * then the underlying Ethernet device prepends its own header.
 	 */
-	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
+	ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
+					   + dev->needed_headroom;
 
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;


