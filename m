Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF0F3D6180
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhGZPcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237965AbhGZP3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01CCE60C40;
        Mon, 26 Jul 2021 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315806;
        bh=mU2SRVSw8pEKkAOT12ft4/nrudjXzw+yZ0lIPaS9tFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfwThaK883BWb7s3TAwEaaJLqdb/GloZg1BeI/rbm7djD1TgGRpQIkxDKLX3CMeBZ
         /55TjvzYvlAyRNBKZgafKc/whTj1kPucRx1ODG7iPIt+MZRkkhqmhycCLcRZ+wmmEe
         c15mjqF1X2QeCRMKScgXQBZlal3Rj4slovzhwkl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 038/223] mptcp: properly account bulk freed memory
Date:   Mon, 26 Jul 2021 17:37:10 +0200
Message-Id: <20210726153847.495428484@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit ce599c516386f09ca30848a1a4eb93d3fffbe187 ]

After commit 879526030c8b ("mptcp: protect the rx path with
the msk socket spinlock") the rmem currently used by a given
msk is really sk_rmem_alloc - rmem_released.

The safety check in mptcp_data_ready() does not take the above
in due account, as a result legit incoming data is kept in
subflow receive queue with no reason, delaying or blocking
MPTCP-level ack generation.

This change addresses the issue introducing a new helper to fetch
the rmem memory and using it as needed. Additionally add a MIB
counter for the exceptional event described above - the peer is
misbehaving.

Finally, introduce the required annotation when rmem_released is
updated.

Fixes: 879526030c8b ("mptcp: protect the rx path with the msk socket spinlock")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/211
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/mib.c      |  1 +
 net/mptcp/mib.h      |  1 +
 net/mptcp/protocol.c | 12 +++++++-----
 net/mptcp/protocol.h | 10 +++++++++-
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index eb2dc6dbe212..c8f4823cd79f 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -42,6 +42,7 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("RmSubflow", MPTCP_MIB_RMSUBFLOW),
 	SNMP_MIB_ITEM("MPPrioTx", MPTCP_MIB_MPPRIOTX),
 	SNMP_MIB_ITEM("MPPrioRx", MPTCP_MIB_MPPRIORX),
+	SNMP_MIB_ITEM("RcvPruned", MPTCP_MIB_RCVPRUNED),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index f0da4f060fe1..93fa7c95e206 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -35,6 +35,7 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_RMSUBFLOW,		/* Remove a subflow */
 	MPTCP_MIB_MPPRIOTX,		/* Transmit a MP_PRIO */
 	MPTCP_MIB_MPPRIORX,		/* Received a MP_PRIO */
+	MPTCP_MIB_RCVPRUNED,		/* Incoming packet dropped due to memory limit */
 	__MPTCP_MIB_MAX
 };
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 18f152bdb66f..94b707a39bc3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -465,7 +465,7 @@ static void mptcp_cleanup_rbuf(struct mptcp_sock *msk)
 	bool cleanup, rx_empty;
 
 	cleanup = (space > 0) && (space >= (old_space << 1));
-	rx_empty = !atomic_read(&sk->sk_rmem_alloc);
+	rx_empty = !__mptcp_rmem(sk);
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
@@ -714,8 +714,10 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 		sk_rbuf = ssk_rbuf;
 
 	/* over limit? can't append more skbs to msk, Also, no need to wake-up*/
-	if (atomic_read(&sk->sk_rmem_alloc) > sk_rbuf)
+	if (__mptcp_rmem(sk) > sk_rbuf) {
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
 		return;
+	}
 
 	/* Wake-up the reader only for in-sequence data */
 	mptcp_data_lock(sk);
@@ -1799,7 +1801,7 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 		if (!(flags & MSG_PEEK)) {
 			/* we will bulk release the skb memory later */
 			skb->destructor = NULL;
-			msk->rmem_released += skb->truesize;
+			WRITE_ONCE(msk->rmem_released, msk->rmem_released + skb->truesize);
 			__skb_unlink(skb, &msk->receive_queue);
 			__kfree_skb(skb);
 		}
@@ -1918,7 +1920,7 @@ static void __mptcp_update_rmem(struct sock *sk)
 
 	atomic_sub(msk->rmem_released, &sk->sk_rmem_alloc);
 	sk_mem_uncharge(sk, msk->rmem_released);
-	msk->rmem_released = 0;
+	WRITE_ONCE(msk->rmem_released, 0);
 }
 
 static void __mptcp_splice_receive_queue(struct sock *sk)
@@ -2420,7 +2422,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
 	msk->wmem_reserved = 0;
-	msk->rmem_released = 0;
+	WRITE_ONCE(msk->rmem_released, 0);
 	msk->tx_pending_data = 0;
 	msk->size_goal_cache = TCP_BASE_MSS;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f842c832f6b0..dc5b71de0a9a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -290,9 +290,17 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+/* the msk socket don't use the backlog, also account for the bulk
+ * free memory
+ */
+static inline int __mptcp_rmem(const struct sock *sk)
+{
+	return atomic_read(&sk->sk_rmem_alloc) - READ_ONCE(mptcp_sk(sk)->rmem_released);
+}
+
 static inline int __mptcp_space(const struct sock *sk)
 {
-	return tcp_space(sk) + READ_ONCE(mptcp_sk(sk)->rmem_released);
+	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf) - __mptcp_rmem(sk));
 }
 
 static inline struct mptcp_data_frag *mptcp_send_head(const struct sock *sk)
-- 
2.30.2



