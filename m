Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7316C37CDA3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244916AbhELQ5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244029AbhELQm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BB6761D06;
        Wed, 12 May 2021 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835781;
        bh=ygIK7z5uOqgkpJnxwlvSZ3xDHP48hYugPkoEYMnymNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpifwE/qR2nfP4WUyNC6wrwle78hrHBWIT4vc4ITlmgtufla4Y6Bba8Sx340d/rST
         3AVly66U4OauAvZirCqy86YybHLXsJDsaZB9vC5Ixq0NXWc2GjGQN2c16JanvrHspu
         d+BowR0VGEzNMZJcY9654eifuv2aOzDSjCAWLKXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 481/677] udp: skip L4 aggregation for UDP tunnel packets
Date:   Wed, 12 May 2021 16:48:47 +0200
Message-Id: <20210512144853.342204678@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 18f25dc399901426dff61e676ba603ff52c666f7 ]

If NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_UDP_FWD are enabled, and there
are UDP tunnels available in the system, udp_gro_receive() could end-up
doing L4 aggregation (either SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST) at
the outer UDP tunnel level for packets effectively carrying and UDP
tunnel header.

That could cause inner protocol corruption. If e.g. the relevant
packets carry a vxlan header, different vxlan ids will be ignored/
aggregated to the same GSO packet. Inner headers will be ignored, too,
so that e.g. TCP over vxlan push packets will be held in the GRO
engine till the next flush, etc.

Just skip the SKB_GSO_UDP_L4 and SKB_GSO_FRAGLIST code path if the
current packet could land in a UDP tunnel, and let udp_gro_receive()
do GRO via udp_sk(sk)->gro_receive.

The check implemented in this patch is broader than what is strictly
needed, as the existing UDP tunnel could be e.g. configured on top of
a different device: we could end-up skipping GRO at-all for some packets.

Anyhow, that is a very thin corner case and covering it will add quite
a bit of complexity.

v1 -> v2:
 - hopefully clarify the commit message

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Fixes: 36707061d6ba ("udp: allow forwarding of plain (non-fraglisted) UDP GRO packets")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index c5b4b586570f..25134a3548e9 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -515,21 +515,24 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	unsigned int off = skb_gro_offset(skb);
 	int flush = 1;
 
+	/* we can do L4 aggregation only if the packet can't land in a tunnel
+	 * otherwise we could corrupt the inner stream
+	 */
 	NAPI_GRO_CB(skb)->is_flist = 0;
-	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
-		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
+	if (!sk || !udp_sk(sk)->gro_receive) {
+		if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
+			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled : 1;
 
-	if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
-	    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
-		pp = call_gro_receive(udp_gro_receive_segment, head, skb);
+		if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
+		    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
+			pp = call_gro_receive(udp_gro_receive_segment, head, skb);
 		return pp;
 	}
 
-	if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
+	if (NAPI_GRO_CB(skb)->encap_mark ||
 	    (uh->check && skb->ip_summed != CHECKSUM_PARTIAL &&
 	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
-	     !NAPI_GRO_CB(skb)->csum_valid) ||
-	    !udp_sk(sk)->gro_receive)
+	     !NAPI_GRO_CB(skb)->csum_valid))
 		goto out;
 
 	/* mark that this skb passed once through the tunnel gro layer */
-- 
2.30.2



