Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753873C4DCA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbhGLHO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238186AbhGLHNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:13:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9221061106;
        Mon, 12 Jul 2021 07:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073843;
        bh=5/X8mHOAm8usozCwlIQe0Yimyw2MPC4rCQGeV4Dg2CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvkdxOlWmB1c9ioTtKZSEZ8uPR6GKpSPgEvhE90pxXugosfKJ/VE63l40+mF+Wfeq
         T5NsdajKpTh+GHyNScm+Li5RuFktcLKvPkAldsFUTmWMidDM9J1Brm+mK1sEejkO7Y
         xFumFGcpnlOEYL3rxUxgvd25E8wLaGwrdpFSWDuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianwen Ji <jiji@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 351/700] xfrm: xfrm_state_mtu should return at least 1280 for ipv6
Date:   Mon, 12 Jul 2021 08:07:14 +0200
Message-Id: <20210712061013.661615068@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b515d2637276a3810d6595e10ab02c13bfd0b63a ]

Jianwen reported that IPv6 Interoperability tests are failing in an
IPsec case where one of the links between the IPsec peers has an MTU
of 1280. The peer generates a packet larger than this MTU, the router
replies with a "Packet too big" message indicating an MTU of 1280.
When the peer tries to send another large packet, xfrm_state_mtu
returns 1280 - ipsec_overhead, which causes ip6_setup_cork to fail
with EINVAL.

We can fix this by forcing xfrm_state_mtu to return IPV6_MIN_MTU when
IPv6 is used. After going through IPsec, the packet will then be
fragmented to obey the actual network's PMTU, just before leaving the
host.

Currently, TFC padding is capped to PMTU - overhead to avoid
fragementation: after padding and encapsulation, we still fit within
the PMTU. That behavior is preserved in this patch.

Fixes: 91657eafb64b ("xfrm: take net hdr len into account for esp payload size calculation")
Reported-by: Jianwen Ji <jiji@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h    |  1 +
 net/ipv4/esp4.c       |  2 +-
 net/ipv6/esp6.c       |  2 +-
 net/xfrm/xfrm_state.c | 14 ++++++++++++--
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c58a6d4eb610..6232a5f048bd 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1546,6 +1546,7 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
+u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 4b834bbf95e0..ed9857b2875d 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -673,7 +673,7 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 727d791ed5e6..9d1327b36bd3 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -708,7 +708,7 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 4496f7efa220..c25586156c6a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2518,7 +2518,7 @@ void xfrm_state_delete_tunnel(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
@@ -2549,7 +2549,17 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
 		 net_adj) & ~(blksize - 1)) + net_adj - 2;
 }
-EXPORT_SYMBOL_GPL(xfrm_state_mtu);
+EXPORT_SYMBOL_GPL(__xfrm_state_mtu);
+
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
+{
+	mtu = __xfrm_state_mtu(x, mtu);
+
+	if (x->props.family == AF_INET6 && mtu < IPV6_MIN_MTU)
+		return IPV6_MIN_MTU;
+
+	return mtu;
+}
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-- 
2.30.2



