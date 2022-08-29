Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97ED85A48BA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiH2LPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiH2LN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:13:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808173341A;
        Mon, 29 Aug 2022 04:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 136E7B80F2B;
        Mon, 29 Aug 2022 11:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEC9C433D6;
        Mon, 29 Aug 2022 11:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771255;
        bh=WBJLOiKgmCJhSoNPFPHvzfExi2tX4P6FT9wYsvgQ9M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyJT+D+Zvgln8GbW1772Kg9Oz3YuLmkAx9LFN240+hmE6TGLXUMdAEJnwu6oD7DHx
         BF8gRxusAJMeEcbDrnq21ck60j/vwCMQiQcYLs4skTHnvN2Gf/xa8Md8sFgCgPkrBr
         +t5d0zJ9l4yF2Pxl/F6quJW5p0DlKa3sfCIEuyQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/86] tcp: tweak len/truesize ratio for coalesce candidates
Date:   Mon, 29 Aug 2022 12:59:10 +0200
Message-Id: <20220829105758.337074804@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 240bfd134c592791fdceba1ce7fc3f973c33df2d ]

tcp_grow_window() is using skb->len/skb->truesize to increase tp->rcv_ssthresh
which has a direct impact on advertized window sizes.

We added TCP coalescing in linux-3.4 & linux-3.5:

Instead of storing skbs with one or two MSS in receive queue (or OFO queue),
we try to append segments together to reduce memory overhead.

High performance network drivers tend to cook skb with 3 parts :

1) sk_buff structure (256 bytes)
2) skb->head contains room to copy headers as needed, and skb_shared_info
3) page fragment(s) containing the ~1514 bytes frame (or more depending on MTU)

Once coalesced into a previous skb, 1) and 2) are freed.

We can therefore tweak the way we compute len/truesize ratio knowing
that skb->truesize is inflated by 1) and 2) soon to be freed.

This is done only for in-order skb, or skb coalesced into OFO queue.

The result is that low rate flows no longer pay the memory price of having
low GRO aggregation factor. Same result for drivers not using GRO.

This is critical to allow a big enough receiver window,
typically tcp_rmem[2] / 2.

We have been using this at Google for about 5 years, it is due time
to make it upstream.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d35e88b5ffcbe..33a3fb04ac4df 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -454,11 +454,12 @@ static void tcp_sndbuf_expand(struct sock *sk)
  */
 
 /* Slow part of check#2. */
-static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb)
+static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
+			     unsigned int skbtruesize)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
-	int truesize = tcp_win_from_space(sk, skb->truesize) >> 1;
+	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
 	int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
 
 	while (tp->rcv_ssthresh <= window) {
@@ -471,7 +472,27 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb)
 	return 0;
 }
 
-static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
+/* Even if skb appears to have a bad len/truesize ratio, TCP coalescing
+ * can play nice with us, as sk_buff and skb->head might be either
+ * freed or shared with up to MAX_SKB_FRAGS segments.
+ * Only give a boost to drivers using page frag(s) to hold the frame(s),
+ * and if no payload was pulled in skb->head before reaching us.
+ */
+static u32 truesize_adjust(bool adjust, const struct sk_buff *skb)
+{
+	u32 truesize = skb->truesize;
+
+	if (adjust && !skb_headlen(skb)) {
+		truesize -= SKB_TRUESIZE(skb_end_offset(skb));
+		/* paranoid check, some drivers might be buggy */
+		if (unlikely((int)truesize < (int)skb->len))
+			truesize = skb->truesize;
+	}
+	return truesize;
+}
+
+static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
+			    bool adjust)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int room;
@@ -480,15 +501,16 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
 
 	/* Check #1 */
 	if (room > 0 && !tcp_under_memory_pressure(sk)) {
+		unsigned int truesize = truesize_adjust(adjust, skb);
 		int incr;
 
 		/* Check #2. Increase window, if skb with such overhead
 		 * will fit to rcvbuf in future.
 		 */
-		if (tcp_win_from_space(sk, skb->truesize) <= skb->len)
+		if (tcp_win_from_space(sk, truesize) <= skb->len)
 			incr = 2 * tp->advmss;
 		else
-			incr = __tcp_grow_window(sk, skb);
+			incr = __tcp_grow_window(sk, skb, truesize);
 
 		if (incr) {
 			incr = max_t(int, incr, 2 * skb->len);
@@ -782,7 +804,7 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
 	tcp_ecn_check_ce(sk, skb);
 
 	if (skb->len >= 128)
-		tcp_grow_window(sk, skb);
+		tcp_grow_window(sk, skb, true);
 }
 
 /* Called to compute a smoothed rtt estimate. The data fed to this
@@ -4761,7 +4783,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		 * and trigger fast retransmit.
 		 */
 		if (tcp_is_sack(tp))
-			tcp_grow_window(sk, skb);
+			tcp_grow_window(sk, skb, true);
 		kfree_skb_partial(skb, fragstolen);
 		skb = NULL;
 		goto add_sack;
@@ -4849,7 +4871,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		 * and trigger fast retransmit.
 		 */
 		if (tcp_is_sack(tp))
-			tcp_grow_window(sk, skb);
+			tcp_grow_window(sk, skb, false);
 		skb_condense(skb);
 		skb_set_owner_r(skb, sk);
 	}
-- 
2.35.1



