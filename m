Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707721F4474
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbgFISEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgFIRwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:52:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC2F20774;
        Tue,  9 Jun 2020 17:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725127;
        bh=R/2+iH0ntOAXXcyfdHjyJIeGtR8m6nlM7VYdO+xk6Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGiGlpsv78ZxLpPpISRRRINaRgbklQyt0rsqe95S2IP7okbQM8MxyUL1R3CjOwz2e
         lRhTNvoXdgy8jPct9v1OyDjNvgPm9mK0au1OZ8wJ7ViMA5D6p0aJSqASnfweWcZiNP
         TcxUFZlzTWAdjvJoMkDtcPxhOeKzBFiGCECDu4PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 11/34] net: be more gentle about silly gso requests coming from user
Date:   Tue,  9 Jun 2020 19:45:07 +0200
Message-Id: <20200609174054.051190910@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7c6d2ecbda83150b2036a2b36b21381ad4667762 ]

Recent change in virtio_net_hdr_to_skb() broke some packetdrill tests.

When --mss=XXX option is set, packetdrill always provide gso_type & gso_size
for its inbound packets, regardless of packet size.

	if (packet->tcp && packet->mss) {
		if (packet->ipv4)
			gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
		else
			gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
		gso.gso_size = packet->mss;
	}

Since many other programs could do the same, relax virtio_net_hdr_to_skb()
to no longer return an error, but instead ignore gso settings.

This keeps Willem intent to make sure no malicious packet could
reach gso stack.

Note that TCP stack has a special logic in tcp_set_skb_tso_segs()
to clear gso_size for small packets.

Fixes: 6dd912f82680 ("net: check untrusted gso_size at kernel entry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -109,16 +109,17 @@ retry:
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
+		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		if (skb->len - p_off <= gso_size)
-			return -EINVAL;
+		/* Too small packets are not really GSO ones. */
+		if (skb->len - p_off > gso_size) {
+			shinfo->gso_size = gso_size;
+			shinfo->gso_type = gso_type;
 
-		skb_shinfo(skb)->gso_size = gso_size;
-		skb_shinfo(skb)->gso_type = gso_type;
-
-		/* Header must be checked, and gso_segs computed. */
-		skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
-		skb_shinfo(skb)->gso_segs = 0;
+			/* Header must be checked, and gso_segs computed. */
+			shinfo->gso_type |= SKB_GSO_DODGY;
+			shinfo->gso_segs = 0;
+		}
 	}
 
 	return 0;


