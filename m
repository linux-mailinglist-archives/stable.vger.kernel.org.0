Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DBF2DEF71
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgLSNEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgLSND7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:03:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 07/34] udp: fix the proto value passed to ip_protocol_deliver_rcu for the segments
Date:   Sat, 19 Dec 2020 14:03:04 +0100
Message-Id: <20201219125341.738014350@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 10c678bd0a035ac2c64a9b26b222f20556227a53 ]

Guillaume noticed that: for segments udp_queue_rcv_one_skb() returns the
proto, and it should pass "ret" unmodified to ip_protocol_deliver_rcu().
Otherwize, with a negtive value passed, it will underflow inet_protos.

This can be reproduced with IPIP FOU:

  # ip fou add port 5555 ipproto 4
  # ethtool -K eth1 rx-gro-list on

Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
Reported-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2117,7 +2117,7 @@ static int udp_queue_rcv_skb(struct sock
 		__skb_pull(skb, skb_transport_offset(skb));
 		ret = udp_queue_rcv_one_skb(sk, skb);
 		if (ret > 0)
-			ip_protocol_deliver_rcu(dev_net(skb->dev), skb, -ret);
+			ip_protocol_deliver_rcu(dev_net(skb->dev), skb, ret);
 	}
 	return 0;
 }


