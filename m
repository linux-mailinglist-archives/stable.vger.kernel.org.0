Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A199B63DD4D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiK3S0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiK3S0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:26:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB4A14039
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 397C1B81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93694C433D6;
        Wed, 30 Nov 2022 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832767;
        bh=l1xllPJ4B6TNy4qLQl6IDmc57DRfuWx8yoJWqi5+u/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWzsNx6y5wh7fCkucPRRnGmHz0e7h/daf3zaX7lNXL/nnfCCwgA+DTmMKYov94P4a
         Vg/bGSu3T0se/lErHmG30dJFp15YT8dEnOY87vrnF9h6nbDPny5SEZfg9XPrmvT7bU
         htkHFv0t/LZgFq9o9+TVD/SGTZCWixTHSr1UaiYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christian Langrock <christian.langrock@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/162] xfrm: replay: Fix ESN wrap around for GSO
Date:   Wed, 30 Nov 2022 19:21:54 +0100
Message-Id: <20221130180529.401421543@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Langrock <christian.langrock@secunet.com>

[ Upstream commit 4b549ccce941798703f159b227aa28c716aa78fa ]

When using GSO it can happen that the wrong seq_hi is used for the last
packets before the wrap around. This can lead to double usage of a
sequence number. To avoid this, we should serialize this last GSO
packet.

Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c |  3 +++
 net/ipv6/esp6_offload.c |  3 +++
 net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
 net/xfrm/xfrm_replay.c  |  2 +-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 3450c9ba2728..84257678160a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -312,6 +312,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 			xo->seq.low += skb_shinfo(skb)->gso_segs;
 	}
 
+	if (xo->seq.low < seq)
+		xo->seq.hi++;
+
 	esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
 
 	ip_hdr(skb)->tot_len = htons(skb->len);
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1c3f02d05d2b..7608be04d0f5 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -343,6 +343,9 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 			xo->seq.low += skb_shinfo(skb)->gso_segs;
 	}
 
+	if (xo->seq.low < seq)
+		xo->seq.hi++;
+
 	esp.seqno = cpu_to_be64(xo->seq.low + ((u64)xo->seq.hi << 32));
 
 	len = skb->len - sizeof(struct ipv6hdr);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c255aac6b816..8b8e957a69c3 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -97,6 +97,18 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 	}
 }
 
+static inline bool xmit_xfrm_check_overflow(struct sk_buff *skb)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	__u32 seq = xo->seq.low;
+
+	seq += skb_shinfo(skb)->gso_segs;
+	if (unlikely(seq < xo->seq.low))
+		return true;
+
+	return false;
+}
+
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again)
 {
 	int err;
@@ -134,7 +146,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	if (skb_is_gso(skb) && unlikely(x->xso.dev != dev)) {
+	if (skb_is_gso(skb) && (unlikely(x->xso.dev != dev) ||
+				unlikely(xmit_xfrm_check_overflow(skb)))) {
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index c6a4338a0d08..65d009e3b6bb 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -657,7 +657,7 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 			oseq += skb_shinfo(skb)->gso_segs;
 		}
 
-		if (unlikely(oseq < replay_esn->oseq)) {
+		if (unlikely(xo->seq.low < replay_esn->oseq)) {
 			XFRM_SKB_CB(skb)->seq.output.hi = ++oseq_hi;
 			xo->seq.hi = oseq_hi;
 			replay_esn->oseq_hi = oseq_hi;
-- 
2.35.1



