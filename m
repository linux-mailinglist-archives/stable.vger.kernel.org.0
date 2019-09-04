Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8200A90F6
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389620AbfIDSMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733228AbfIDSMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:12:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B778206BA;
        Wed,  4 Sep 2019 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620760;
        bh=9j13SR6PFoGHS9DU6kXVZT3HtgNT+HZ/YvMRajqX1co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/aFSJHOxyK+rNYtQX7lDG4CCSKzHaaynUVJW/elX4v25VM5r5aiLHZBMx1Yu6hC6
         /1nY9zSOf771JrVl4YO2jt4efcVGnhqEMVfF5jNf4uKNs9Wvm/OBMM2GZt+sVqesv2
         wchixQAJNL1p/C4dfw/omwcI8W1ZkbTy3VRN/s6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 058/143] xfrm/xfrm_policy: fix dst dev null pointer dereference in collect_md mode
Date:   Wed,  4 Sep 2019 19:53:21 +0200
Message-Id: <20190904175316.343523033@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit c3b4c3a47e05d5fecf7354d75824a9d1b37f3e84 ]

In decode_session{4,6} there is a possibility that the skb dst dev is NULL,
e,g, with tunnel collect_md mode, which will cause kernel crash.
Here is what the code path looks like, for GRE:

- ip6gre_tunnel_xmit
  - ip6gre_xmit_ipv6
    - __gre6_xmit
      - ip6_tnl_xmit
        - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
    - icmpv6_send
      - icmpv6_route_lookup
        - xfrm_decode_session_reverse
          - decode_session4
            - oif = skb_dst(skb)->dev->ifindex; <-- here
          - decode_session6
            - oif = skb_dst(skb)->dev->ifindex; <-- here

The reason is __metadata_dst_init() init dst->dev to NULL by default.
We could not fix it in __metadata_dst_init() as there is no dev supplied.
On the other hand, the skb_dst(skb)->dev is actually not needed as we
called decode_session{4,6} via xfrm_decode_session_reverse(), so oif is not
used by: fl4->flowi4_oif = reverse ? skb->skb_iif : oif;

So make a dst dev check here should be clean and safe.

v4: No changes.

v3: No changes.

v2: fix the issue in decode_session{4,6} instead of updating shared dst dev
in {ip_md, ip6}_tunnel_xmit.

Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnels")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_policy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3272,7 +3272,7 @@ decode_session4(struct sk_buff *skb, str
 	struct flowi4 *fl4 = &fl->u.ip4;
 	int oif = 0;
 
-	if (skb_dst(skb))
+	if (skb_dst(skb) && skb_dst(skb)->dev)
 		oif = skb_dst(skb)->dev->ifindex;
 
 	memset(fl4, 0, sizeof(struct flowi4));
@@ -3390,7 +3390,7 @@ decode_session6(struct sk_buff *skb, str
 
 	nexthdr = nh[nhoff];
 
-	if (skb_dst(skb))
+	if (skb_dst(skb) && skb_dst(skb)->dev)
 		oif = skb_dst(skb)->dev->ifindex;
 
 	memset(fl6, 0, sizeof(struct flowi6));


