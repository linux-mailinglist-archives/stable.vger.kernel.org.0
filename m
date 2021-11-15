Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FB3450CC5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbhKORnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:43:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238529AbhKORlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EBBB632F8;
        Mon, 15 Nov 2021 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997234;
        bh=VNzS/jKZQ3rCuMIgQWgsCaTW2CEEuoUROPX3FPzlVOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PyiSrDfDCpPB4aeZ74mD7hMeGZxkYx9f7I8+rf2jbtNPzoarIXkTzlY2VJlmyd7M
         c3irInGMtlhdHrDXNNKLX6wnAKebNsGhbU+iCVeO0Q5j6gXMp8+a3WyNDShGpx1gw7
         Xt9pQZmppTbWsTizihWG0qgcFyRIvm7pCJQb0meY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyril Strejc <cyril.strejc@skoda.cz>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/575] net: multicast: calculate csum of looped-back and forwarded packets
Date:   Mon, 15 Nov 2021 17:56:37 +0100
Message-Id: <20211115165346.122254948@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cyril Strejc <cyril.strejc@skoda.cz>

[ Upstream commit 9122a70a6333705c0c35614ddc51c274ed1d3637 ]

During a testing of an user-space application which transmits UDP
multicast datagrams and utilizes multicast routing to send the UDP
datagrams out of defined network interfaces, I've found a multicast
router does not fill-in UDP checksum into locally produced, looped-back
and forwarded UDP datagrams, if an original output NIC the datagrams
are sent to has UDP TX checksum offload enabled.

The datagrams are sent malformed out of the NIC the datagrams have been
forwarded to.

It is because:

1. If TX checksum offload is enabled on the output NIC, UDP checksum
   is not calculated by kernel and is not filled into skb data.

2. dev_loopback_xmit(), which is called solely by
   ip_mc_finish_output(), sets skb->ip_summed = CHECKSUM_UNNECESSARY
   unconditionally.

3. Since 35fc92a9 ("[NET]: Allow forwarding of ip_summed except
   CHECKSUM_COMPLETE"), the ip_summed value is preserved during
   forwarding.

4. If ip_summed != CHECKSUM_PARTIAL, checksum is not calculated during
   a packet egress.

The minimum fix in dev_loopback_xmit():

1. Preserves skb->ip_summed CHECKSUM_PARTIAL. This is the
   case when the original output NIC has TX checksum offload enabled.
   The effects are:

     a) If the forwarding destination interface supports TX checksum
        offloading, the NIC driver is responsible to fill-in the
        checksum.

     b) If the forwarding destination interface does NOT support TX
        checksum offloading, checksums are filled-in by kernel before
        skb is submitted to the NIC driver.

     c) For local delivery, checksum validation is skipped as in the
        case of CHECKSUM_UNNECESSARY, thanks to skb_csum_unnecessary().

2. Translates ip_summed CHECKSUM_NONE to CHECKSUM_UNNECESSARY. It
   means, for CHECKSUM_NONE, the behavior is unmodified and is there
   to skip a looped-back packet local delivery checksum validation.

Signed-off-by: Cyril Strejc <cyril.strejc@skoda.cz>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/udp.h | 5 +++--
 net/core/dev.c    | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 949ae14a54250..435cc009e6eaa 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -488,8 +488,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
 	 * packets in udp_gro_complete_segment. As does UDP GSO, verified by
 	 * udp_send_skb. But when those packets are looped in dev_loopback_xmit
-	 * their ip_summed is set to CHECKSUM_UNNECESSARY. Reset in this
-	 * specific case, where PARTIAL is both correct and required.
+	 * their ip_summed CHECKSUM_NONE is changed to CHECKSUM_UNNECESSARY.
+	 * Reset in this specific case, where PARTIAL is both correct and
+	 * required.
 	 */
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		skb->ip_summed = CHECKSUM_PARTIAL;
diff --git a/net/core/dev.c b/net/core/dev.c
index 6a4e0e3c59fec..e14294e9ba321 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3867,7 +3867,8 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb_reset_mac_header(skb);
 	__skb_pull(skb, skb_network_offset(skb));
 	skb->pkt_type = PACKET_LOOPBACK;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	if (skb->ip_summed == CHECKSUM_NONE)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	WARN_ON(!skb_dst(skb));
 	skb_dst_force(skb);
 	netif_rx_ni(skb);
-- 
2.33.0



