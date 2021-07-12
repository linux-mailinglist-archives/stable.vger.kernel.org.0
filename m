Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349D23C49F0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhGLGrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238040AbhGLGqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E4FA6121E;
        Mon, 12 Jul 2021 06:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072147;
        bh=ofC5oRRWzFCiyWfMVsYGmrP6k09mpDAOH7LMQNqNYVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hv3K5qiq0pyGFOKbI+2ae26NkD6YTdCJRbJoYxI+WrIfCLXrXDQKcVImYqPjGkjJA
         eRPbg+Gpnv+3Ah3WV+jiVeMSG0RqIklz/9d6O78NAK/yuhHvZtqF8NGpMVvjgO5c9Q
         rgXPW3oQRjeX3JPZfehWVOAPm2aeghf6ZkB0coYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/593] vrf: do not push non-ND strict packets with a source LLA through packet taps again
Date:   Mon, 12 Jul 2021 08:08:53 +0200
Message-Id: <20210712060927.799307114@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 603113c514e95c3350598bc3cccbd03af7ea4ab2 ]

Non-ND strict packets with a source LLA go through the packet taps
again, while non-ND strict packets with other source addresses do not,
and we can see a clone of those packets on the vrf interface (we should
not). This is due to a series of changes:

Commit 6f12fa775530[1] made non-ND strict packets not being pushed again
in the packet taps. This changed with commit 205704c618af[2] for those
packets having a source LLA, as they need a lookup with the orig_iif.

The issue now is those packets do not skip the 'vrf_ip6_rcv' function to
the end (as the ones without a source LLA) and go through the check to
call packet taps again. This check was changed by commit 6f12fa775530[1]
and do not exclude non-strict packets anymore. Packets matching
'need_strict && !is_ndisc && is_ll_src' are now being sent through the
packet taps again. This can be seen by dumping packets on the vrf
interface.

Fix this by having the same code path for all non-ND strict packets and
selectively lookup with the orig_iif for those with a source LLA. This
has the effect to revert to the pre-205704c618af[2] condition, which
should also be easier to maintain.

[1] 6f12fa775530 ("vrf: mark skb for multicast or link-local as enslaved to VRF")
[2] 205704c618af ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")

Fixes: 205704c618af ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index bc96ac0c5769..2746f77745e4 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1312,22 +1312,22 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	int orig_iif = skb->skb_iif;
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
-	bool is_ll_src;
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
-	 * for packets with lladdr src, however, skip so that the dst can be
-	 * determine at input using original ifindex in the case that daddr
-	 * needs strict
+	 * For strict packets with a source LLA, determine the dst using the
+	 * original ifindex.
 	 */
-	is_ll_src = ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL;
-	if (skb->pkt_type == PACKET_LOOPBACK ||
-	    (need_strict && !is_ndisc && !is_ll_src)) {
+	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
+
 		if (skb->pkt_type == PACKET_LOOPBACK)
 			skb->pkt_type = PACKET_HOST;
+		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
+			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
+
 		goto out;
 	}
 
-- 
2.30.2



