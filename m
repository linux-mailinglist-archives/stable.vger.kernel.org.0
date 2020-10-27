Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141F29BDCD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812957AbgJ0Qq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794798AbgJ0PNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:13:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7C6E20657;
        Tue, 27 Oct 2020 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811619;
        bh=876ugGTYUCG5GvmuzmLBh8mkjKMdy2vxqd0GNel4T/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liDdhUhXXbM3SXiL1HnBfRHejKk2345M9VBzz8ylMhh6/UF+QYR66NWjb44jGSyBY
         O90WXry32qZZ7CDNQa3RkyNPXIfxgGDRHJfSxIJvJWEpcU/EdybYRNcfdA+ImRHR7t
         t01meXS2D9mMEqMPRj7/aS5kTcOM9SITiUB2p6q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
Subject: [PATCH 5.8 558/633] ip_gre: set dev->hard_header_len and dev->needed_headroom properly
Date:   Tue, 27 Oct 2020 14:55:01 +0100
Message-Id: <20201027135548.989318788@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit fdafed459998e2be0e877e6189b24cb7a0183224 ]

GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
conditionally. When it is set, it assumes the outer IP header is
already created before ipgre_xmit().

This is not true when we send packets through a raw packet socket,
where L2 headers are supposed to be constructed by user. Packet
socket calls dev_validate_header() to validate the header. But
GRE tunnel does not set dev->hard_header_len, so that check can
be simply bypassed, therefore uninit memory could be passed down
to ipgre_xmit(). Similar for dev->needed_headroom.

dev->hard_header_len is supposed to be the length of the header
created by dev->header_ops->create(), so it should be used whenever
header_ops is set, and dev->needed_headroom should be used when it
is not set.

Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
Cc: William Tu <u9012063@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 4e31f23e4117e..e70291748889b 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -625,9 +625,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
-		/* Need space for new headers */
-		if (skb_cow_head(skb, dev->needed_headroom -
-				      (tunnel->hlen + sizeof(struct iphdr))))
+		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
@@ -748,7 +746,11 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	len = tunnel->tun_hlen - len;
 	tunnel->hlen = tunnel->hlen + len;
 
-	dev->needed_headroom = dev->needed_headroom + len;
+	if (dev->header_ops)
+		dev->hard_header_len += len;
+	else
+		dev->needed_headroom += len;
+
 	if (set_mtu)
 		dev->mtu = max_t(int, dev->mtu - len, 68);
 
@@ -944,6 +946,7 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->parms.iph.protocol = IPPROTO_GRE;
 
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
+	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
@@ -987,10 +990,14 @@ static int ipgre_tunnel_init(struct net_device *dev)
 				return -EINVAL;
 			dev->flags = IFF_BROADCAST;
 			dev->header_ops = &ipgre_header_ops;
+			dev->hard_header_len = tunnel->hlen + sizeof(*iph);
+			dev->needed_headroom = 0;
 		}
 #endif
 	} else if (!tunnel->collect_md) {
 		dev->header_ops = &ipgre_header_ops;
+		dev->hard_header_len = tunnel->hlen + sizeof(*iph);
+		dev->needed_headroom = 0;
 	}
 
 	return ip_tunnel_init(dev);
-- 
2.25.1



