Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1751D0D7F
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387957AbgEMJxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387954AbgEMJxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0506C20753;
        Wed, 13 May 2020 09:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363609;
        bh=iPa4Xr6Ty70rISOHMRVLustJX8yAz3kr/Ge5GvuPdVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDKTBiFU8ZcTS7eUhBG27ES/PsKLJM6lKM5niVDiN2ybBAryg8LrvN3dQe4s3sFB4
         M/nRGnN5ymiusidA5GtntQRUw1ZrJIR0/b8TEURBEwCSqjHEVrr6yHAt2TGyZiscW0
         AtjcH6L6EKzms7rqMnnnFq7yB+wy05afm+iGl+hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        "Rodney W. Grimes" <ietf@gndrsh.dnsmgr.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 053/118] wireguard: receive: use tunnel helpers for decapsulating ECN markings
Date:   Wed, 13 May 2020 11:44:32 +0200
Message-Id: <20200513094421.742472747@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Toke Høiland-Jørgensen" <toke@redhat.com>

[ Upstream commit eebabcb26ea1e3295704477c6cd4e772c96a9559 ]

WireGuard currently only propagates ECN markings on tunnel decap according
to the old RFC3168 specification. However, the spec has since been updated
in RFC6040 to recommend slightly different decapsulation semantics. This
was implemented in the kernel as a set of common helpers for ECN
decapsulation, so let's just switch over WireGuard to using those, so it
can benefit from this enhancement and any future tweaks. We do not drop
packets with invalid ECN marking combinations, because WireGuard is
frequently used to work around broken ISPs, which could be doing that.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Reported-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Cc: Dave Taht <dave.taht@gmail.com>
Cc: Rodney W. Grimes <ietf@gndrsh.dnsmgr.net>
Signed-off-by: Toke HÃ¸iland-JÃ¸rgensen <toke@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/receive.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -393,13 +393,11 @@ static void wg_packet_consume_data_done(
 		len = ntohs(ip_hdr(skb)->tot_len);
 		if (unlikely(len < sizeof(struct iphdr)))
 			goto dishonest_packet_size;
-		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
-			IP_ECN_set_ce(ip_hdr(skb));
+		INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds, ip_hdr(skb)->tos);
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
 		len = ntohs(ipv6_hdr(skb)->payload_len) +
 		      sizeof(struct ipv6hdr);
-		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
-			IP6_ECN_set_ce(skb, ipv6_hdr(skb));
+		INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds, ipv6_get_dsfield(ipv6_hdr(skb)));
 	} else {
 		goto dishonest_packet_type;
 	}


