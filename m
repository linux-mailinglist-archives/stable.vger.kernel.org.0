Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77CD3DAB35
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhG2Sos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhG2Sor (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 14:44:47 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0E9C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:44:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id go31so12313544ejc.6
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IJCtU0NB5rX9fRkjpYkWaD+fM0k0XWWOjWtRzvJseYM=;
        b=oFkPaMbUjLcir5DMXx2v57YUTBe+yovQDDXkqR+F8kova7CgFmX1omG7BeiZxO8kzT
         kG4p6kY6w0LP1Ij8aC5KjPr1XIIVYS3UoN28HzkHwUeVTNAb40XQX8uwe/VbFXl70hPS
         70ScBqdkEO1Zxc1oQu48hjaDAxfQl5bcPJiRgL5H+M3pPbLETvMKhDWD5Wc8o5mhF5Ub
         X0JAgbVlQ2UzrrJ/MCVbTru4OEQH0KgTubHqdpym74QgJaik1Vq9nfP/o4BITJm7EYr+
         pdDdtGTUSy6H6Xr1XEUMKfYspw8BgZpEbPNnngGuAMJ627MW4sl8aXsmJl0rAv83KgIu
         01rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IJCtU0NB5rX9fRkjpYkWaD+fM0k0XWWOjWtRzvJseYM=;
        b=Ck+mLGuLkF7AdH164jSRUvd3FeA5P5OhfD6bFhLXuNgkMavFWn5Geemxm4ppSbbvZe
         MTjhX1ypwqYFkC/e5bMo7XjMhUc3HSaTWFy8qgWFUbYgeAuTwviOsD4c1qmElDHeC0r4
         NWmKINwyMM5crOIgvY47UC0TOtSR7OXHFKxGiaRWfzCflmUgv5ub2UCOTNk9+B0Qncr4
         LJR9LRcWLWssLPpW0+shJlqK838240OObFOdmdz6yH8TrvCtOwZZH/LXE2bXeV7hBA0K
         LLiRPFuKXbS7fyYEiTC8H0lBTl+2eXAPFDGFTyOuy7qdfSd+CYcxr67UHgd+opoK4CEQ
         miew==
X-Gm-Message-State: AOAM532V+ra9ArIEOdEh2oIkeLNuZr1XHXBmTGlCkniprsXxgcq3q2TZ
        ANCPqgBdBjc786TBucCAbvjHwa/LdcoMILTA
X-Google-Smtp-Source: ABdhPJyMxxBJ5DL26//cIOqlwit7l+m+RybERVIOER4a20p8/KH/DQycuvIKlAhpp+JkLa1lRKWZyw==
X-Received: by 2002:a17:906:2451:: with SMTP id a17mr5860542ejb.75.1627584282704;
        Thu, 29 Jul 2021 11:44:42 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id l2sm1260057ejg.37.2021.07.29.11.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:44:42 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 4.19 1/2] virtio_net: Do not pull payload in skb->head
Date:   Thu, 29 Jul 2021 20:44:26 +0200
Message-Id: <20210729184427.3202526-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729184427.3202526-1-matthieu.baerts@tessares.net>
References: <20210729184427.3202526-1-matthieu.baerts@tessares.net>
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
index 5e8b40630286..1a8fe5bacb19 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -413,9 +413,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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
+		copy = ETH_HLEN + metasize;
 	skb_put_data(skb, p, copy);
 
 	if (metasize) {
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index a1829139ff4a..8f48264f5dab 100644
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
@@ -102,14 +106,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
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

