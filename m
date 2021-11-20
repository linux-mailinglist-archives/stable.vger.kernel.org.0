Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1796457E69
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhKTMoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237259AbhKTMoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:44:07 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D46CC061574
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637412062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Doh3R1ILM4ebcu1GsGngu/p/+ecj2NCrShmGAQilqss=;
        b=RgvGaXDhsdoWuPJC2CQ/l3vDf3/hdY85i/sfFpdt7/ru9591FAE4OQkfumEbWjs19PKgdU
        cNuUkapSVsHR/+KSbMdRz7MdUsnDj8eEtkLsIu06179MKxgbU0iZOAj0Yh6UdfkU9nnzpd
        hLCV8kfH4FUJ8Sk+9ex8sD0YA9zZGJk=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.4 3/3] batman-adv: Don't always reallocate the fragmentation skb head
Date:   Sat, 20 Nov 2021 13:40:53 +0100
Message-Id: <20211120124053.261156-4-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211120124053.261156-1-sven@narfation.org>
References: <20211120124053.261156-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 992b03b88e36254e26e9a4977ab948683e21bd9f upstream.

When a packet is fragmented by batman-adv, the original batman-adv header
is not modified. Only a new fragmentation is inserted between the original
one and the ethernet header. The code must therefore make sure that it has
a writable region of this size in the skbuff head.

But it is not useful to always reallocate the skbuff by this size even when
there would be more than enough headroom still in the skb. The reallocation
is just to costly during in this codepath.

Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/fragmentation.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index f1d202ff396c..0da90e73c79b 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -527,13 +527,14 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 		frag_header.no++;
 	}
 
-	/* Make room for the fragment header. */
-	if (batadv_skb_head_push(skb, header_size) < 0 ||
-	    pskb_expand_head(skb, header_size + ETH_HLEN, 0, GFP_ATOMIC) < 0) {
-		ret = -ENOMEM;
+	/* make sure that there is at least enough head for the fragmentation
+	 * and ethernet headers
+	 */
+	ret = skb_cow_head(skb, ETH_HLEN + header_size);
+	if (ret < 0)
 		goto put_primary_if;
-	}
 
+	skb_push(skb, header_size);
 	memcpy(skb->data, &frag_header, header_size);
 
 	/* Send the last fragment */
-- 
2.30.2

