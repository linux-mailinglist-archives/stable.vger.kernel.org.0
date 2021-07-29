Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD943DAB50
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhG2Srr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhG2Srq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 14:47:46 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4358EC061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:47:43 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x14so9496445edr.12
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BgBym8v1bQm8+j2u4zCKvAvNrbscmdxOo2VMNucpSCo=;
        b=Gcix2J/TNu77oCzRj3OGSxP+YfC33Fxvz6speicNa0dScEKYc1T2xCs/44rZxfKAgy
         8IrAvyG1o9LoJ7gnSAKKfvhtJrFpye7QpjnTld3RN7JEDga15z6Ep1mJKYTmC0nftFH+
         fF9hvCCocAyN8VohmXk6HyxsLS2/hbHgS/G7Ne4Sf/rxAC++XAgaz8czxvAINK8gT+I7
         JrjIxVH6XmnV0i9l6GyXlR8Yd3qM9rohorzbRmFxzZ62jbBzYxzlJrdJwJX3G9IoOfVX
         NKLoDZdu2/Vrqc2lo2twDyuqhJlgguF9YRh+Uo07XOZygB9KT8bLLzq6jdGpeWCOa1ZF
         ajyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BgBym8v1bQm8+j2u4zCKvAvNrbscmdxOo2VMNucpSCo=;
        b=jE3DW7TBYRnE+AryvGasegcq3ia7yjc05zAmNV/vpFkrfK0AS4FZenn2GU6maUwIkh
         sXAImN69RNHdpj1okXxkydt7syKhVnwmadfNSggkYqSUjh3Kao1hWNK3Q4H8llUfYrXI
         HUu8yPeDD7Y1k1PqjKDhBAQnqXMxALpWrc1ohxsS5V/EasRv9jF6ajVH4536yjs/Wuio
         esbAwzZHgT97KmE4wCMCHYmI1zQF+F95eiyte2JtDiOMSIBKycDP3NbNCgRrDLoOvcag
         qg7hZswJ+RLukFOBBOdQGHPiohZT2NtNB4Q7NNOElud6uu+DCmxnWjoaJmLcXgWlTyOY
         k2AA==
X-Gm-Message-State: AOAM530u/UbjBE8PoW8xchnZWhIR3uMAfPe/sCRlaeKxsKM691ldXHWX
        twGQMl3HWqM/GmW6cJEPHFaNO3KBrz+V9+RF
X-Google-Smtp-Source: ABdhPJyfqH4k7DOV8g4pbEgol/pJMSyB8EQV8ztujqxjnQkXoXleEhim3AjnyoKepYDjtWKec7VRVQ==
X-Received: by 2002:aa7:da02:: with SMTP id r2mr7679882eds.249.1627584461697;
        Thu, 29 Jul 2021 11:47:41 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id c14sm1250207ejb.78.2021.07.29.11.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:47:41 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 4.14 1/2] virtio_net: Do not pull payload in skb->head
Date:   Thu, 29 Jul 2021 20:47:32 +0200
Message-Id: <20210729184733.3217814-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729184733.3217814-1-matthieu.baerts@tessares.net>
References: <20210729184733.3217814-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0f6925b3e8da0dbbb52447ca8a8b42b371aac7db ]

Xuan Zhuo reported that commit 3226b158e67c ("net: avoid 32 x truesize
under-estimation for tiny skbs") brought  a ~10% performance drop.

The reason for the performance drop was that GRO was forced
to chain sk_buff (using skb_shinfo(skb)->frag_list), which
uses more memory but also cause packet consumers to go over
a lot of overhead handling all the tiny skbs.

It turns out that virtio_net page_to_skb() has a wrong strategy :
It allocates skbs with GOOD_COPY_LEN (128) bytes in skb->head, then
copies 128 bytes from the page, before feeding the packet to GRO stack.

This was suboptimal before commit 3226b158e67c ("net: avoid 32 x truesize
under-estimation for tiny skbs") because GRO was using 2 frags per MSS,
meaning we were not packing MSS with 100% efficiency.

Fix is to pull only the ethernet header in page_to_skb()

Then, we change virtio_net_hdr_to_skb() to pull the missing
headers, instead of assuming they were already pulled by callers.

This fixes the performance regression, but could also allow virtio_net
to accept packets with more than 128bytes of headers.

Many thanks to Xuan Zhuo for his report, and his tests/help.

[ Backport note ]

    There was no conflict but the upstream patch was using a variable
    (metasize) not defined in < v5.7 kernels. This new variable has been
    introduced by commit 503d539a6e417 ("virtio_net: Add XDP meta data support").
    This commit has been backported in 5.4.112 and 4.19.186 to allow this
    commit 0f6925b3e8da0 ("virtio_net: Do not pull payload in skb->head")
    to be backported without issue.

    I don't think we want to backport this new feature related to XDP in
    older kernels < v4.19. In this version here, we simply drop this
    'metasize' variable as there is no need for it.

Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://www.spinics.net/lists/netdev/msg731397.html
Co-Developed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 drivers/net/virtio_net.c   | 10 +++++++---
 include/linux/virtio_net.h | 14 +++++++++-----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c8abbf81ef52..9e18389309cf 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -339,9 +339,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	offset += hdr_padded_len;
 	p += hdr_padded_len;
 
-	copy = len;
-	if (copy > skb_tailroom(skb))
-		copy = skb_tailroom(skb);
+	/* Copy all frame if it fits skb->head, otherwise
+	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
+	 */
+	if (len <= skb_tailroom(skb))
+		copy = len;
+	else
+		copy = ETH_HLEN;
 	skb_put_data(skb, p, copy);
 
 	len -= copy;
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 48afea1b8b4e..ca68826d8449 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
-		u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
-		u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
+		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
+
+		if (!pskb_may_pull(skb, needed))
+			return -EINVAL;
 
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
 
 		p_off = skb_transport_offset(skb) + thlen;
-		if (p_off > skb_headlen(skb))
+		if (!pskb_may_pull(skb, p_off))
 			return -EINVAL;
 	} else {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
@@ -100,14 +104,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			}
 
 			p_off = keys.control.thoff + thlen;
-			if (p_off > skb_headlen(skb) ||
+			if (!pskb_may_pull(skb, p_off) ||
 			    keys.basic.ip_proto != ip_proto)
 				return -EINVAL;
 
 			skb_set_transport_header(skb, keys.control.thoff);
 		} else if (gso_type) {
 			p_off = thlen;
-			if (p_off > skb_headlen(skb))
+			if (!pskb_may_pull(skb, p_off))
 				return -EINVAL;
 		}
 	}
-- 
2.31.1

