Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9230E4513A3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348554AbhKOTyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343707AbhKOTVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63735635CE;
        Mon, 15 Nov 2021 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001884;
        bh=T2SzI3QdECGtldzRSBc9jiLPSpbqao0/6woO6/BBIS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKx1Ldyn3hEAvMLKT5iZyOS//wuwVtXu7kS9E/3LfREk7FYfneoiRvk2BdUlmHxN2
         KHdnpzkE9EPsITWQKt+BYXNNbTwicZr8cKcG/qjR4oxk+Pm4NPOvzPCNHZd6ZHM7EL
         s0ry9AbJ3a1KzOVSPAB08br7v5uNNd6g9BPb7Kp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/917] mptcp: do not shrink snd_nxt when recovering
Date:   Mon, 15 Nov 2021 17:57:33 +0100
Message-Id: <20211115165440.889672462@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 0d199e4363b482badcedba764e2aceab53a4a10a ]

When recovering after a link failure, snd_nxt should not be set to a
lower value.  Else, update of snd_nxt is broken because:

  msk->snd_nxt += ret; (where ret is number of bytes sent)

assumes that snd_nxt always moves forward.
After reduction, its possible that snd_nxt update gets out of sync:
dfrag we just sent might have had a data sequence number even past
recovery_snd_nxt.

This change factors the common msk state update to a helper
and updates snd_nxt based on the current dfrag data sequence number.

The conditional is required for the recovery phase where we may
re-transmit old dfrags that are before current snd_nxt.

After this change, snd_nxt only moves forward and covers all in-sequence
data that was transmitted.

recovery_snd_nxt is retained to detect when recovery has completed.

Fixes: 1e1d9d6f119c5 ("mptcp: handle pending data on closed subflow")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  |  8 +++-----
 net/mptcp/protocol.c | 43 +++++++++++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index f0f22eb4fd5f7..350348f070700 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1019,11 +1019,9 @@ static void ack_update_msk(struct mptcp_sock *msk,
 	old_snd_una = msk->snd_una;
 	new_snd_una = mptcp_expand_seq(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
-	/* ACK for data not even sent yet and even above recovery bound? Ignore.*/
-	if (unlikely(after64(new_snd_una, snd_nxt))) {
-		if (!msk->recovery || after64(new_snd_una, msk->recovery_snd_nxt))
-			new_snd_una = old_snd_una;
-	}
+	/* ACK for data not even sent yet? Ignore.*/
+	if (unlikely(after64(new_snd_una, snd_nxt)))
+		new_snd_una = old_snd_una;
 
 	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d073b21113828..4379d69aead7e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1505,6 +1505,32 @@ static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 }
 
+static void mptcp_update_post_push(struct mptcp_sock *msk,
+				   struct mptcp_data_frag *dfrag,
+				   u32 sent)
+{
+	u64 snd_nxt_new = dfrag->data_seq;
+
+	dfrag->already_sent += sent;
+
+	msk->snd_burst -= sent;
+	msk->tx_pending_data -= sent;
+
+	snd_nxt_new += dfrag->already_sent;
+
+	/* snd_nxt_new can be smaller than snd_nxt in case mptcp
+	 * is recovering after a failover. In that event, this re-sends
+	 * old segments.
+	 *
+	 * Thus compute snd_nxt_new candidate based on
+	 * the dfrag->data_seq that was sent and the data
+	 * that has been handed to the subflow for transmission
+	 * and skip update in case it was old dfrag.
+	 */
+	if (likely(after64(snd_nxt_new, msk->snd_nxt)))
+		msk->snd_nxt = snd_nxt_new;
+}
+
 void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 {
 	struct sock *prev_ssk = NULL, *ssk = NULL;
@@ -1548,12 +1574,10 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			}
 
 			info.sent += ret;
-			dfrag->already_sent += ret;
-			msk->snd_nxt += ret;
-			msk->snd_burst -= ret;
-			msk->tx_pending_data -= ret;
 			copied += ret;
 			len -= ret;
+
+			mptcp_update_post_push(msk, dfrag, ret);
 		}
 		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
 	}
@@ -1606,13 +1630,11 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 				goto out;
 
 			info.sent += ret;
-			dfrag->already_sent += ret;
-			msk->snd_nxt += ret;
-			msk->snd_burst -= ret;
-			msk->tx_pending_data -= ret;
 			copied += ret;
 			len -= ret;
 			first = false;
+
+			mptcp_update_post_push(msk, dfrag, ret);
 		}
 		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
 	}
@@ -2183,15 +2205,12 @@ bool __mptcp_retransmit_pending_data(struct sock *sk)
 		return false;
 	}
 
-	/* will accept ack for reijected data before re-sending them */
-	if (!msk->recovery || after64(msk->snd_nxt, msk->recovery_snd_nxt))
-		msk->recovery_snd_nxt = msk->snd_nxt;
+	msk->recovery_snd_nxt = msk->snd_nxt;
 	msk->recovery = true;
 	mptcp_data_unlock(sk);
 
 	msk->first_pending = rtx_head;
 	msk->tx_pending_data += msk->snd_nxt - rtx_head->data_seq;
-	msk->snd_nxt = rtx_head->data_seq;
 	msk->snd_burst = 0;
 
 	/* be sure to clear the "sent status" on all re-injected fragments */
-- 
2.33.0



