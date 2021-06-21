Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20713AEF8A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhFUQkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhFUQiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 074DC61026;
        Mon, 21 Jun 2021 16:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292952;
        bh=yH2mODQzenO989ImZfhWXlNFs2sdMboMfKENIzR4VjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BviZikIC/gNnyxvgpU9Tj6UGNRuBjYQ0IOoJdOuO7hCa+yEl2xWPxcarw4ZTjJaq
         tZIu1AWol3Aupc6mXRsZ0Ky5PkHRAhAsrUgHPMNJ+DDlSu7/9qnPnuyV4h6FwWQXEg
         6h44AaOKT5Zi4f8NBbjUX9CZRk+iJxSMGtEvdHFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 045/178] mptcp: wake-up readers only for in sequence data
Date:   Mon, 21 Jun 2021 18:14:19 +0200
Message-Id: <20210621154923.773306688@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 99d1055ce2469dca3dd14be0991ff8133e25e3d0 ]

Currently we rely on the subflow->data_avail field, which is subject to
races:

	ssk1
		skb len = 500 DSS(seq=1, len=1000, off=0)
		# data_avail == MPTCP_SUBFLOW_DATA_AVAIL

	ssk2
		skb len = 500 DSS(seq = 501, len=1000)
		# data_avail == MPTCP_SUBFLOW_DATA_AVAIL

	ssk1
		skb len = 500 DSS(seq = 1, len=1000, off =500)
		# still data_avail == MPTCP_SUBFLOW_DATA_AVAIL,
		# as the skb is covered by a pre-existing map,
		# which was in-sequence at reception time.

Instead we can explicitly check if some has been received in-sequence,
propagating the info from __mptcp_move_skbs_from_subflow().

Additionally add the 'ONCE' annotation to the 'data_avail' memory
access, as msk will read it outside the subflow socket lock.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 33 ++++++++++++---------------------
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  | 23 +++++++++--------------
 3 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1d981babbcfe..78152b0820ce 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -689,15 +689,13 @@ static bool __mptcp_ofo_queue(struct mptcp_sock *msk)
 /* In most cases we will be able to lock the mptcp socket.  If its already
  * owned, we need to defer to the work queue to avoid ABBA deadlock.
  */
-static void move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
+static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct sock *sk = (struct sock *)msk;
 	unsigned int moved = 0;
 
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
-		return;
-
-	mptcp_data_lock(sk);
+		return false;
 
 	__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 	__mptcp_ofo_queue(msk);
@@ -709,7 +707,7 @@ static void move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 	 */
 	if (mptcp_pending_data_fin(sk, NULL))
 		mptcp_schedule_work(sk);
-	mptcp_data_unlock(sk);
+	return moved > 0;
 }
 
 void mptcp_data_ready(struct sock *sk, struct sock *ssk)
@@ -717,7 +715,6 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int sk_rbuf, ssk_rbuf;
-	bool wake;
 
 	/* The peer can send data while we are shutting down this
 	 * subflow at msk destruction time, but we must avoid enqueuing
@@ -726,28 +723,22 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	if (unlikely(subflow->disposable))
 		return;
 
-	/* move_skbs_to_msk below can legitly clear the data_avail flag,
-	 * but we will need later to properly woke the reader, cache its
-	 * value
-	 */
-	wake = subflow->data_avail == MPTCP_SUBFLOW_DATA_AVAIL;
-	if (wake)
-		set_bit(MPTCP_DATA_READY, &msk->flags);
-
 	ssk_rbuf = READ_ONCE(ssk->sk_rcvbuf);
 	sk_rbuf = READ_ONCE(sk->sk_rcvbuf);
 	if (unlikely(ssk_rbuf > sk_rbuf))
 		sk_rbuf = ssk_rbuf;
 
-	/* over limit? can't append more skbs to msk */
+	/* over limit? can't append more skbs to msk, Also, no need to wake-up*/
 	if (atomic_read(&sk->sk_rmem_alloc) > sk_rbuf)
-		goto wake;
-
-	move_skbs_to_msk(msk, ssk);
+		return;
 
-wake:
-	if (wake)
+	/* Wake-up the reader only for in-sequence data */
+	mptcp_data_lock(sk);
+	if (move_skbs_to_msk(msk, ssk)) {
+		set_bit(MPTCP_DATA_READY, &msk->flags);
 		sk->sk_data_ready(sk);
+	}
+	mptcp_data_unlock(sk);
 }
 
 void __mptcp_flush_join_list(struct mptcp_sock *msk)
@@ -850,7 +841,7 @@ static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
 	sock_owned_by_me(sk);
 
 	mptcp_for_each_subflow(msk, subflow) {
-		if (subflow->data_avail)
+		if (READ_ONCE(subflow->data_avail))
 			return mptcp_subflow_tcp_sock(subflow);
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e21a5bc36cf0..14e89e4bd4a8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -372,7 +372,6 @@ mptcp_subflow_rsk(const struct request_sock *rsk)
 enum mptcp_data_avail {
 	MPTCP_SUBFLOW_NODATA,
 	MPTCP_SUBFLOW_DATA_AVAIL,
-	MPTCP_SUBFLOW_OOO_DATA
 };
 
 struct mptcp_delegated_action {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8425cd393bf3..1ee4d106ce1c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -974,7 +974,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	pr_debug("msk=%p ssk=%p data_avail=%d skb=%p", subflow->conn, ssk,
 		 subflow->data_avail, skb_peek(&ssk->sk_receive_queue));
 	if (!skb_peek(&ssk->sk_receive_queue))
-		subflow->data_avail = 0;
+		WRITE_ONCE(subflow->data_avail, 0);
 	if (subflow->data_avail)
 		return true;
 
@@ -1012,18 +1012,13 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		ack_seq = mptcp_subflow_get_mapped_dsn(subflow);
 		pr_debug("msk ack_seq=%llx subflow ack_seq=%llx", old_ack,
 			 ack_seq);
-		if (ack_seq == old_ack) {
-			subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
-			break;
-		} else if (after64(ack_seq, old_ack)) {
-			subflow->data_avail = MPTCP_SUBFLOW_OOO_DATA;
-			break;
+		if (unlikely(before64(ack_seq, old_ack))) {
+			mptcp_subflow_discard_data(ssk, skb, old_ack - ack_seq);
+			continue;
 		}
 
-		/* only accept in-sequence mapping. Old values are spurious
-		 * retransmission
-		 */
-		mptcp_subflow_discard_data(ssk, skb, old_ack - ack_seq);
+		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
+		break;
 	}
 	return true;
 
@@ -1041,7 +1036,7 @@ fallback:
 		ssk->sk_error_report(ssk);
 		tcp_set_state(ssk, TCP_CLOSE);
 		tcp_send_active_reset(ssk, GFP_ATOMIC);
-		subflow->data_avail = 0;
+		WRITE_ONCE(subflow->data_avail, 0);
 		return false;
 	}
 
@@ -1051,7 +1046,7 @@ fallback:
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
 	subflow->map_data_len = skb->len;
 	subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
-	subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
+	WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
 	return true;
 }
 
@@ -1063,7 +1058,7 @@ bool mptcp_subflow_data_available(struct sock *sk)
 	if (subflow->map_valid &&
 	    mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len) {
 		subflow->map_valid = 0;
-		subflow->data_avail = 0;
+		WRITE_ONCE(subflow->data_avail, 0);
 
 		pr_debug("Done with mapping: seq=%u data_len=%u",
 			 subflow->map_subflow_seq,
-- 
2.30.2



