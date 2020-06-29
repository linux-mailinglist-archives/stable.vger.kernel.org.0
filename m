Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5F820DB02
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388087AbgF2UCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733003AbgF2Tad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41BC2252C7;
        Mon, 29 Jun 2020 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445092;
        bh=/u7xzgp5yfHgdTybx9FkSBdR1Vp7JFFuuPvhqwapbCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEkB0mcbMDCFUkjwyBLUbMyGo20bok1cwKC34s38wNXJAuvyKICt88MSQXPv50g07
         Eyegg+By2WslKf3Q48ogWvy+wYHqyHHO0aLLZhEMqWmJ+6Oi80urSaVQLrKlXMoJDT
         1MhfY3nO1ovxX4Ub6qWyJIAKqfk7tcxOPJ5KEjv4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 02/78] net: be more gentle about silly gso requests coming from user
Date:   Mon, 29 Jun 2020 11:36:50 -0400
Message-Id: <20200629153806.2494953-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 7c6d2ecbda83150b2036a2b36b21381ad4667762 upstream.

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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index a16e0bdf77511..d19bfdcf77498 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -107,16 +107,17 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
+		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		if (skb->len - p_off <= gso_size)
-			return -EINVAL;
-
-		skb_shinfo(skb)->gso_size = gso_size;
-		skb_shinfo(skb)->gso_type = gso_type;
+		/* Too small packets are not really GSO ones. */
+		if (skb->len - p_off > gso_size) {
+			shinfo->gso_size = gso_size;
+			shinfo->gso_type = gso_type;
 
-		/* Header must be checked, and gso_segs computed. */
-		skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
-		skb_shinfo(skb)->gso_segs = 0;
+			/* Header must be checked, and gso_segs computed. */
+			shinfo->gso_type |= SKB_GSO_DODGY;
+			shinfo->gso_segs = 0;
+		}
 	}
 
 	return 0;
-- 
2.25.1

