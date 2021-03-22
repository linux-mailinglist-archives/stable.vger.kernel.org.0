Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E158A344286
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCVMn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhCVMkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB8C460238;
        Mon, 22 Mar 2021 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416729;
        bh=7f2g5FZMTBHVQwI8OzxkML0cXz8BHG7/wCDSRSZQRDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8lnRNjXjqkt1EJN7aPLUu/MHW4cS2R6s62txVGKJwW0kOUsxWZY1cfREh226dWnV
         BUK9ND9OGdRaHTzBA7ZM+3OQEAxfQY3zigG0TjKKU8IgcfqsyKmwqT3r+pyVI79Hme
         /rtoy6mIH1vWaMYOgXLNWrZjpTRTPVl/xT7LWl2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/157] mptcp: reduce the arguments of mptcp_sendmsg_frag
Date:   Mon, 22 Mar 2021 13:27:34 +0100
Message-Id: <20210322121936.855497305@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit caf971df01b86f33f151bcfa61b4385cf5e43822 ]

The current argument list is pretty long and quite unreadable,
move many of them into a specific struct. Later patches
will add more stuff to such struct.

Additionally drop the 'timeo' argument, now unused.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 53 ++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0504a5f13c2a..888eb6a86dad 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -886,12 +886,16 @@ mptcp_carve_data_frag(const struct mptcp_sock *msk, struct page_frag *pfrag,
 	return dfrag;
 }
 
+struct mptcp_sendmsg_info {
+	int mss_now;
+	int size_goal;
+};
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct msghdr *msg, struct mptcp_data_frag *dfrag,
-			      long *timeo, int *pmss_now,
-			      int *ps_goal)
+			      struct mptcp_sendmsg_info *info)
 {
-	int mss_now, avail_size, size_goal, offset, ret, frag_truesize = 0;
+	int avail_size, offset, ret, frag_truesize = 0;
 	bool dfrag_collapsed, can_collapse = false;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
@@ -917,10 +921,8 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	}
 
 	/* compute copy limit */
-	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-	*pmss_now = mss_now;
-	*ps_goal = size_goal;
-	avail_size = size_goal;
+	info->mss_now = tcp_send_mss(ssk, &info->size_goal, msg->msg_flags);
+	avail_size = info->size_goal;
 	skb = tcp_write_queue_tail(ssk);
 	if (skb) {
 		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
@@ -931,12 +933,12 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 * queue management operation, to avoid breaking the ext <->
 		 * SSN association set here
 		 */
-		can_collapse = (size_goal - skb->len > 0) &&
+		can_collapse = (info->size_goal - skb->len > 0) &&
 			      mptcp_skb_can_collapse_to(*write_seq, skb, mpext);
 		if (!can_collapse)
 			TCP_SKB_CB(skb)->eor = 1;
 		else
-			avail_size = size_goal - skb->len;
+			avail_size = info->size_goal - skb->len;
 	}
 
 	if (!retransmission) {
@@ -1168,11 +1170,15 @@ static void ssk_check_wmem(struct mptcp_sock *msk)
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
-	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_sendmsg_info info = {
+		.mss_now = 0,
+		.size_goal = 0,
+	};
 	struct page_frag *pfrag;
 	size_t copied = 0;
 	struct sock *ssk;
+	int ret = 0;
 	u32 sndbuf;
 	bool tx_ok;
 	long timeo;
@@ -1241,8 +1247,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	lock_sock(ssk);
 	tx_ok = msg_data_left(msg);
 	while (tx_ok) {
-		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &timeo, &mss_now,
-					 &size_goal);
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &info);
 		if (ret < 0) {
 			if (ret == -EAGAIN && timeo > 0) {
 				mptcp_set_timeout(sk, ssk);
@@ -1265,8 +1270,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (!sk_stream_memory_free(ssk) ||
 		    !mptcp_page_frag_refill(ssk, pfrag) ||
 		    !mptcp_ext_cache_refill(msk)) {
-			tcp_push(ssk, msg->msg_flags, mss_now,
-				 tcp_sk(ssk)->nonagle, size_goal);
+			tcp_push(ssk, msg->msg_flags, info.mss_now,
+				 tcp_sk(ssk)->nonagle, info.size_goal);
 			mptcp_set_timeout(sk, ssk);
 			release_sock(ssk);
 			goto restart;
@@ -1286,8 +1291,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		 * limits before we send more data.
 		 */
 		if (unlikely(!sk_stream_memory_free(sk))) {
-			tcp_push(ssk, msg->msg_flags, mss_now,
-				 tcp_sk(ssk)->nonagle, size_goal);
+			tcp_push(ssk, msg->msg_flags, info.mss_now,
+				 tcp_sk(ssk)->nonagle, info.size_goal);
 			mptcp_clean_una(sk);
 			if (!sk_stream_memory_free(sk)) {
 				/* can't send more for now, need to wait for
@@ -1304,8 +1309,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	mptcp_set_timeout(sk, ssk);
 	if (copied) {
-		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
-			 size_goal);
+		tcp_push(ssk, msg->msg_flags, info.mss_now,
+			 tcp_sk(ssk)->nonagle, info.size_goal);
 
 		/* start the timer, if it's not pending */
 		if (!mptcp_timer_pending(sk))
@@ -1747,14 +1752,15 @@ static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
 	struct sock *ssk, *sk = &msk->sk.icsk_inet.sk;
-	int orig_len, orig_offset, mss_now = 0, size_goal = 0;
+	struct mptcp_sendmsg_info info = {};
 	struct mptcp_data_frag *dfrag;
+	int orig_len, orig_offset;
 	u64 orig_write_seq;
 	size_t copied = 0;
 	struct msghdr msg = {
 		.msg_flags = MSG_DONTWAIT,
 	};
-	long timeo = 0;
+	int ret;
 
 	lock_sock(sk);
 	mptcp_clean_una_wakeup(sk);
@@ -1793,8 +1799,7 @@ static void mptcp_worker(struct work_struct *work)
 	orig_offset = dfrag->offset;
 	orig_write_seq = dfrag->data_seq;
 	while (dfrag->data_len > 0) {
-		int ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &timeo,
-					     &mss_now, &size_goal);
+		ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &info);
 		if (ret < 0)
 			break;
 
@@ -1807,8 +1812,8 @@ static void mptcp_worker(struct work_struct *work)
 			break;
 	}
 	if (copied)
-		tcp_push(ssk, msg.msg_flags, mss_now, tcp_sk(ssk)->nonagle,
-			 size_goal);
+		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
+			 info.size_goal);
 
 	dfrag->data_seq = orig_write_seq;
 	dfrag->offset = orig_offset;
-- 
2.30.1



