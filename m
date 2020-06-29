Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C5720D82F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgF2ThI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733016AbgF2Tae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0CB523E55;
        Mon, 29 Jun 2020 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444905;
        bh=dtqLu1m1J2roq7efb5x4Fu7ijYgPk7csKPlExGmhc6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PW5aJ9uInORg2uffgTjr4RbSVThpTO5qeTBZB5ZSJKzE81P+6wKF02U2oZT9MyxHm
         85gWwx8S9yVgr6CF6ztGpfEo1zWZNI1GNOvfvYD+ll7Xss15E1BTPYduodhqJBNhRf
         r/6rjfWgYeWOM8//XWiBINrDneteOfa6m/zDw03g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 001/131] net: be more gentle about silly gso requests coming from user
Date:   Mon, 29 Jun 2020 11:32:52 -0400
Message-Id: <20200629153502.2494656-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
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
index 1c296f370e461..f32fe7080d2ec 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -109,16 +109,17 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 
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

