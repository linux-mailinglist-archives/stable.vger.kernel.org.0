Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03585A4878
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiH2LKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiH2LKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:10:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ED06BCC2;
        Mon, 29 Aug 2022 04:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB7D16119C;
        Mon, 29 Aug 2022 11:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6527C433D6;
        Mon, 29 Aug 2022 11:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771223;
        bh=c0e7JQJFNyi8POOyQW/ypX+2I8U4cIQRGhOCmmIg/fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOFy0UY+qgAPK/1XkpJcRSXSN4MYpZT/AAVTcxA2Ytga/ZQJSTIWCIqLUZyrxhM5f
         oL5KkZrMu9sNR4VkUWXSh8YnPTuodwIPShCxsThdy7s0Zky/FYP1xeVUfpUyOCYZ1U
         LzyCkUNRAPZEFsoJ8SBhAO+z8Goc5Hf+jgSPA2YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/136] mptcp: stop relying on tcp_tx_skb_cache
Date:   Mon, 29 Aug 2022 12:59:08 +0200
Message-Id: <20220829105807.972808753@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit f70cad1085d1e01d3ec73c1078405f906237feee ]

We want to revert the skb TX cache, but MPTCP is currently
using it unconditionally.

Rework the MPTCP tx code, so that tcp_tx_skb_cache is not
needed anymore: do the whole coalescing check, skb allocation
skb initialization/update inside mptcp_sendmsg_frag(), quite
alike the current TCP code.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 137 ++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 60 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7f96e0c42a090..a089791414bfb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1224,6 +1224,7 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 		if (likely(__mptcp_add_ext(skb, gfp))) {
 			skb_reserve(skb, MAX_TCP_HEADER);
 			skb->reserved_tailroom = skb->end - skb->tail;
+			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 			return skb;
 		}
 		__kfree_skb(skb);
@@ -1233,31 +1234,23 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 	return NULL;
 }
 
-static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
+static struct sk_buff *__mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 {
 	struct sk_buff *skb;
 
-	if (ssk->sk_tx_skb_cache) {
-		skb = ssk->sk_tx_skb_cache;
-		if (unlikely(!skb_ext_find(skb, SKB_EXT_MPTCP) &&
-			     !__mptcp_add_ext(skb, gfp)))
-			return false;
-		return true;
-	}
-
 	skb = __mptcp_do_alloc_tx_skb(sk, gfp);
 	if (!skb)
-		return false;
+		return NULL;
 
 	if (likely(sk_wmem_schedule(ssk, skb->truesize))) {
-		ssk->sk_tx_skb_cache = skb;
-		return true;
+		tcp_skb_entail(ssk, skb);
+		return skb;
 	}
 	kfree_skb(skb);
-	return false;
+	return NULL;
 }
 
-static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, bool data_lock_held)
+static struct sk_buff *mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, bool data_lock_held)
 {
 	gfp_t gfp = data_lock_held ? GFP_ATOMIC : sk->sk_allocation;
 
@@ -1287,23 +1280,29 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct mptcp_sendmsg_info *info)
 {
 	u64 data_seq = dfrag->data_seq + info->sent;
+	int offset = dfrag->offset + info->sent;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool zero_window_probe = false;
 	struct mptcp_ext *mpext = NULL;
-	struct sk_buff *skb, *tail;
-	bool must_collapse = false;
-	int size_bias = 0;
-	int avail_size;
-	size_t ret = 0;
+	bool can_coalesce = false;
+	bool reuse_skb = true;
+	struct sk_buff *skb;
+	size_t copy;
+	int i;
 
 	pr_debug("msk=%p ssk=%p sending dfrag at seq=%llu len=%u already sent=%u",
 		 msk, ssk, dfrag->data_seq, dfrag->data_len, info->sent);
 
+	if (WARN_ON_ONCE(info->sent > info->limit ||
+			 info->limit > dfrag->data_len))
+		return 0;
+
 	/* compute send limit */
 	info->mss_now = tcp_send_mss(ssk, &info->size_goal, info->flags);
-	avail_size = info->size_goal;
+	copy = info->size_goal;
+
 	skb = tcp_write_queue_tail(ssk);
-	if (skb) {
+	if (skb && copy > skb->len) {
 		/* Limit the write to the size available in the
 		 * current skb, if any, so that we create at most a new skb.
 		 * Explicitly tells TCP internals to avoid collapsing on later
@@ -1316,62 +1315,80 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			goto alloc_skb;
 		}
 
-		must_collapse = (info->size_goal > skb->len) &&
-				(skb_shinfo(skb)->nr_frags < sysctl_max_skb_frags);
-		if (must_collapse) {
-			size_bias = skb->len;
-			avail_size = info->size_goal - skb->len;
+		i = skb_shinfo(skb)->nr_frags;
+		can_coalesce = skb_can_coalesce(skb, i, dfrag->page, offset);
+		if (!can_coalesce && i >= sysctl_max_skb_frags) {
+			tcp_mark_push(tcp_sk(ssk), skb);
+			goto alloc_skb;
 		}
-	}
 
+		copy -= skb->len;
+	} else {
 alloc_skb:
-	if (!must_collapse &&
-	    !mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held))
-		return 0;
+		skb = mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held);
+		if (!skb)
+			return -ENOMEM;
+
+		i = skb_shinfo(skb)->nr_frags;
+		reuse_skb = false;
+		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
+	}
 
 	/* Zero window and all data acked? Probe. */
-	avail_size = mptcp_check_allowed_size(msk, data_seq, avail_size);
-	if (avail_size == 0) {
+	copy = mptcp_check_allowed_size(msk, data_seq, copy);
+	if (copy == 0) {
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
-		if (skb || snd_una != msk->snd_nxt)
+		if (snd_una != msk->snd_nxt) {
+			tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
 			return 0;
+		}
+
 		zero_window_probe = true;
 		data_seq = snd_una - 1;
-		avail_size = 1;
-	}
+		copy = 1;
 
-	if (WARN_ON_ONCE(info->sent > info->limit ||
-			 info->limit > dfrag->data_len))
-		return 0;
+		/* all mptcp-level data is acked, no skbs should be present into the
+		 * ssk write queue
+		 */
+		WARN_ON_ONCE(reuse_skb);
+	}
 
-	ret = info->limit - info->sent;
-	tail = tcp_build_frag(ssk, avail_size + size_bias, info->flags,
-			      dfrag->page, dfrag->offset + info->sent, &ret);
-	if (!tail) {
-		tcp_remove_empty_skb(sk, tcp_write_queue_tail(ssk));
+	copy = min_t(size_t, copy, info->limit - info->sent);
+	if (!sk_wmem_schedule(ssk, copy)) {
+		tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
 		return -ENOMEM;
 	}
 
-	/* if the tail skb is still the cached one, collapsing really happened.
-	 */
-	if (skb == tail) {
-		TCP_SKB_CB(tail)->tcp_flags &= ~TCPHDR_PSH;
-		mpext->data_len += ret;
+	if (can_coalesce) {
+		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+	} else {
+		get_page(dfrag->page);
+		skb_fill_page_desc(skb, i, dfrag->page, offset, copy);
+	}
+
+	skb->len += copy;
+	skb->data_len += copy;
+	skb->truesize += copy;
+	sk_wmem_queued_add(ssk, copy);
+	sk_mem_charge(ssk, copy);
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	WRITE_ONCE(tcp_sk(ssk)->write_seq, tcp_sk(ssk)->write_seq + copy);
+	TCP_SKB_CB(skb)->end_seq += copy;
+	tcp_skb_pcount_set(skb, 0);
+
+	/* on skb reuse we just need to update the DSS len */
+	if (reuse_skb) {
+		TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
+		mpext->data_len += copy;
 		WARN_ON_ONCE(zero_window_probe);
 		goto out;
 	}
 
-	mpext = skb_ext_find(tail, SKB_EXT_MPTCP);
-	if (WARN_ON_ONCE(!mpext)) {
-		/* should never reach here, stream corrupted */
-		return -EINVAL;
-	}
-
 	memset(mpext, 0, sizeof(*mpext));
 	mpext->data_seq = data_seq;
 	mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
-	mpext->data_len = ret;
+	mpext->data_len = copy;
 	mpext->use_map = 1;
 	mpext->dsn64 = 1;
 
@@ -1380,18 +1397,18 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->dsn64);
 
 	if (zero_window_probe) {
-		mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
+		mptcp_subflow_ctx(ssk)->rel_write_seq += copy;
 		mpext->frozen = 1;
 		if (READ_ONCE(msk->csum_enabled))
-			mptcp_update_data_checksum(tail, ret);
+			mptcp_update_data_checksum(skb, copy);
 		tcp_push_pending_frames(ssk);
 		return 0;
 	}
 out:
 	if (READ_ONCE(msk->csum_enabled))
-		mptcp_update_data_checksum(tail, ret);
-	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
-	return ret;
+		mptcp_update_data_checksum(skb, copy);
+	mptcp_subflow_ctx(ssk)->rel_write_seq += copy;
+	return copy;
 }
 
 #define MPTCP_SEND_BURST_SIZE		((1 << 16) - \
-- 
2.35.1



