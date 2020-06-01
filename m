Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EC01EAAE7
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgFASM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731228AbgFASM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 275392065C;
        Mon,  1 Jun 2020 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035145;
        bh=WU23nNkR3G/nRPopZOiNOhIRCnxBh9OTRX4WJrXY9L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcVqivQPLqUsIr7ItnE1DEboEXEslk2IOTvLet1o8txbU0n71dQLylJvK5DXc7YrH
         iNWHejY4xD5HYNus9fgBaRQKAQFEYmwdpPKv1xfAYhKfTowHKiVPxSVddm6NpLA20O
         Sg3wfo6rhAgXqKD+guaYqW5sx2MEX417nJ1mx/so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Taht <dave.taht@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 5.6 029/177] wireguard: queueing: preserve flow hash across packet scrubbing
Date:   Mon,  1 Jun 2020 19:52:47 +0200
Message-Id: <20200601174051.278370974@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit c78a0b4a78839d572d8a80f6a62221c0d7843135 ]

It's important that we clear most header fields during encapsulation and
decapsulation, because the packet is substantially changed, and we don't
want any info leak or logic bug due to an accidental correlation. But,
for encapsulation, it's wrong to clear skb->hash, since it's used by
fq_codel and flow dissection in general. Without it, classification does
not proceed as usual. This change might make it easier to estimate the
number of innerflows by examining clustering of out of order packets,
but this shouldn't open up anything that can't already be inferred
otherwise (e.g. syn packet size inference), and fq_codel can be disabled
anyway.

Furthermore, it might be the case that the hash isn't used or queried at
all until after wireguard transmits the encrypted UDP packet, which
means skb->hash might still be zero at this point, and thus no hash
taken over the inner packet data. In order to address this situation, we
force a calculation of skb->hash before encrypting packet data.

Of course this means that fq_codel might transmit packets slightly more
out of order than usual. Toke did some testing on beefy machines with
high quantities of parallel flows and found that increasing the
reply-attack counter to 8192 takes care of the most pathological cases
pretty well.

Reported-by: Dave Taht <dave.taht@gmail.com>
Reviewed-and-tested-by: Toke Høiland-Jørgensen <toke@toke.dk>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/messages.h |    2 +-
 drivers/net/wireguard/queueing.h |   10 +++++++++-
 drivers/net/wireguard/receive.c  |    2 +-
 drivers/net/wireguard/send.c     |    7 ++++++-
 4 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/net/wireguard/messages.h
+++ b/drivers/net/wireguard/messages.h
@@ -32,7 +32,7 @@ enum cookie_values {
 };
 
 enum counter_values {
-	COUNTER_BITS_TOTAL = 2048,
+	COUNTER_BITS_TOTAL = 8192,
 	COUNTER_REDUNDANT_BITS = BITS_PER_LONG,
 	COUNTER_WINDOW_SIZE = COUNTER_BITS_TOTAL - COUNTER_REDUNDANT_BITS
 };
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -87,12 +87,20 @@ static inline bool wg_check_packet_proto
 	return real_protocol && skb->protocol == real_protocol;
 }
 
-static inline void wg_reset_packet(struct sk_buff *skb)
+static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
 {
+	u8 l4_hash = skb->l4_hash;
+	u8 sw_hash = skb->sw_hash;
+	u32 hash = skb->hash;
 	skb_scrub_packet(skb, true);
 	memset(&skb->headers_start, 0,
 	       offsetof(struct sk_buff, headers_end) -
 		       offsetof(struct sk_buff, headers_start));
+	if (encapsulating) {
+		skb->l4_hash = l4_hash;
+		skb->sw_hash = sw_hash;
+		skb->hash = hash;
+	}
 	skb->queue_mapping = 0;
 	skb->nohdr = 0;
 	skb->peeked = 0;
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -485,7 +485,7 @@ int wg_packet_rx_poll(struct napi_struct
 		if (unlikely(wg_socket_endpoint_from_skb(&endpoint, skb)))
 			goto next;
 
-		wg_reset_packet(skb);
+		wg_reset_packet(skb, false);
 		wg_packet_consume_data_done(peer, skb, &endpoint);
 		free = false;
 
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -170,6 +170,11 @@ static bool encrypt_packet(struct sk_buf
 	struct sk_buff *trailer;
 	int num_frags;
 
+	/* Force hash calculation before encryption so that flow analysis is
+	 * consistent over the inner packet.
+	 */
+	skb_get_hash(skb);
+
 	/* Calculate lengths. */
 	padding_len = calculate_skb_padding(skb);
 	trailer_len = padding_len + noise_encrypted_len(0);
@@ -298,7 +303,7 @@ void wg_packet_encrypt_worker(struct wor
 		skb_list_walk_safe(first, skb, next) {
 			if (likely(encrypt_packet(skb,
 					PACKET_CB(first)->keypair))) {
-				wg_reset_packet(skb);
+				wg_reset_packet(skb, true);
 			} else {
 				state = PACKET_STATE_DEAD;
 				break;


