Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2710A37CEE9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345186AbhELRHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244748AbhELQvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3DF161454;
        Wed, 12 May 2021 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836268;
        bh=ioTsqXbVwYV6iqYpFBqK3emlGivUznW0he31nxkIpTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKsOjooxgJX0qi60+OIoKXH9VTRF+dDFStZ9U8oar2wBKoAQ06C6KY9rBM4Ak4MuI
         LF8BTKZt0gm2G2eePVqWgM/fPYCwlgOmFyjgPBB23RAzEcySqfRn4QTRtUimMtkOFP
         271NucGFyWzwAktHDgJdPFS834sdvUisApwxHMJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 643/677] mptcp: Retransmit DATA_FIN
Date:   Wed, 12 May 2021 16:51:29 +0200
Message-Id: <20210512144858.725622887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

[ Upstream commit 6477dd39e62c3a67cfa368ddc127410b4ae424c6 ]

With this change, the MPTCP-level retransmission timer is used to resend
DATA_FIN. The retranmit timer is not stopped while waiting for a
MPTCP-level ACK of DATA_FIN, and retransmitted DATA_FINs are sent on all
subflows. The retry interval starts at TCP_RTO_MIN and then doubles on
each attempt, up to TCP_RTO_MAX.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/146
Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5043c7cb0782..65e5d3eb1078 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -399,6 +399,14 @@ static bool mptcp_pending_data_fin(struct sock *sk, u64 *seq)
 	return false;
 }
 
+static void mptcp_set_datafin_timeout(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	mptcp_sk(sk)->timer_ival = min(TCP_RTO_MAX,
+				       TCP_RTO_MIN << icsk->icsk_retransmits);
+}
+
 static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
 {
 	long tout = ssk && inet_csk(ssk)->icsk_pending ?
@@ -1052,7 +1060,7 @@ out:
 	}
 
 	if (snd_una == READ_ONCE(msk->snd_nxt)) {
-		if (msk->timer_ival)
+		if (msk->timer_ival && !mptcp_data_fin_enabled(msk))
 			mptcp_stop_timer(sk);
 	} else {
 		mptcp_reset_timer(sk);
@@ -2276,8 +2284,19 @@ static void __mptcp_retrans(struct sock *sk)
 
 	__mptcp_clean_una_wakeup(sk);
 	dfrag = mptcp_rtx_head(sk);
-	if (!dfrag)
+	if (!dfrag) {
+		if (mptcp_data_fin_enabled(msk)) {
+			struct inet_connection_sock *icsk = inet_csk(sk);
+
+			icsk->icsk_retransmits++;
+			mptcp_set_datafin_timeout(sk);
+			mptcp_send_ack(msk);
+
+			goto reset_timer;
+		}
+
 		return;
+	}
 
 	ssk = mptcp_subflow_get_retrans(msk);
 	if (!ssk)
@@ -2460,6 +2479,8 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
 			pr_debug("Sending DATA_FIN on subflow %p", ssk);
 			mptcp_set_timeout(sk, ssk);
 			tcp_send_ack(ssk);
+			if (!mptcp_timer_pending(sk))
+				mptcp_reset_timer(sk);
 		}
 		break;
 	}
-- 
2.30.2



