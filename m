Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F83E10BE0D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfK0UwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbfK0UwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011C42184C;
        Wed, 27 Nov 2019 20:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887926;
        bh=J8nLv1zzZihBjk9Qf7MzVMFSXvKTV4N1SPSE8aD/4sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6lfIAHBL/H5IlRIPS/SOlGnTs6WGPWJrVlYKmyFEfwRr47WzEdG2rJYBviosYluP
         NT+Fab0tC7n3eanm6gJeiee32Ha7arHPuo6JaJV6XxNNXjVNZ87Pf5f6B0vpBnAwFn
         gZpfzxZaqC2hBpJkbOIkSyDrLcTuWQ5NBA+rQwUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Manning <mmanning@vyatta.att-mail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 149/211] vrf: mark skb for multicast or link-local as enslaved to VRF
Date:   Wed, 27 Nov 2019 21:31:22 +0100
Message-Id: <20191127203108.083769323@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Manning <mmanning@vyatta.att-mail.com>

[ Upstream commit 6f12fa775530195a501fb090d092c637f32d0cc5 ]

The skb for packets that are multicast or to a link-local address are
not marked as being enslaved to a VRF, if they are received on a socket
bound to the VRF. This is needed for ND and it is preferable for the
kernel not to have to deal with the additional use-cases if ll or mcast
packets are handled as enslaved. However, this does not allow service
instances listening on unbound and bound to VRF sockets to distinguish
the VRF used, if packets are sent as multicast or to a link-local
address. The fix is for the VRF driver to also mark these skb as being
enslaved to the VRF.

Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 03e4fcdfeab73..e0cea5c05f0e2 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -996,24 +996,23 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 				   struct sk_buff *skb)
 {
 	int orig_iif = skb->skb_iif;
-	bool need_strict;
+	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
+	bool is_ndisc = ipv6_ndisc_frame(skb);
 
-	/* loopback traffic; do not push through packet taps again.
-	 * Reset pkt_type for upper layers to process skb
+	/* loopback, multicast & non-ND link-local traffic; do not push through
+	 * packet taps again. Reset pkt_type for upper layers to process skb
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK) {
+	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
-		skb->pkt_type = PACKET_HOST;
+		if (skb->pkt_type == PACKET_LOOPBACK)
+			skb->pkt_type = PACKET_HOST;
 		goto out;
 	}
 
-	/* if packet is NDISC or addressed to multicast or link-local
-	 * then keep the ingress interface
-	 */
-	need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
-	if (!ipv6_ndisc_frame(skb) && !need_strict) {
+	/* if packet is NDISC then keep the ingress interface */
+	if (!is_ndisc) {
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
-- 
2.20.1



