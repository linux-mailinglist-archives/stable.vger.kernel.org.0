Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25129B966
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1800896AbgJ0Pso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796375AbgJ0PR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:17:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87FE320728;
        Tue, 27 Oct 2020 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811876;
        bh=9SyeiN8tusMmO57swdaEQsBCuhOH7kDgp6HiuibHQME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ri/EHTQpyB7nfxvB/XUCv8r4xfhhz0tsyBcB0Yr88kTeXtrFKFdF9WBlG8PmBSei
         PfCJ2Q95eUEA3mAd3qcr4geWy48GxyLlf73YkvBpRr7G9bETXxHopOGOS0jBAKP3FV
         yDx7uwmX/Y+JGYUSLiSPFACL2lJVAuAtUK0ynWy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 006/757] mptcp: fix fallback for MP_JOIN subflows
Date:   Tue, 27 Oct 2020 14:44:16 +0100
Message-Id: <20201027135450.829684670@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit d582484726c4c46c8580923e855665fb91e3463e ]

Additional/MP_JOIN subflows that do not pass some initial handshake
tests currently causes fallback to TCP. That is an RFC violation:
we should instead reset the subflow and leave the the msk untouched.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/91
Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |   32 +++++++++++++++++++++++++-------
 net/mptcp/protocol.h |    1 +
 net/mptcp/subflow.c  |   10 ++++++++--
 3 files changed, 34 insertions(+), 9 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -626,6 +626,12 @@ bool mptcp_established_options(struct so
 	if (unlikely(mptcp_check_fallback(sk)))
 		return false;
 
+	/* prevent adding of any MPTCP related options on reset packet
+	 * until we support MP_TCPRST/MP_FASTCLOSE
+	 */
+	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST))
+		return false;
+
 	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
 		ret = true;
 	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
@@ -676,7 +682,7 @@ bool mptcp_synack_options(const struct r
 	return false;
 }
 
-static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
+static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 				    struct mptcp_subflow_context *subflow,
 				    struct sk_buff *skb,
 				    struct mptcp_options_received *mp_opt)
@@ -693,15 +699,20 @@ static bool check_fully_established(stru
 		    TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq &&
 		    subflow->mp_join && mp_opt->mp_join &&
 		    READ_ONCE(msk->pm.server_side))
-			tcp_send_ack(sk);
+			tcp_send_ack(ssk);
 		goto fully_established;
 	}
 
-	/* we should process OoO packets before the first subflow is fully
-	 * established, but not expected for MP_JOIN subflows
+	/* we must process OoO packets before the first subflow is fully
+	 * established. OoO packets are instead a protocol violation
+	 * for MP_JOIN subflows as the peer must not send any data
+	 * before receiving the forth ack - cfr. RFC 8684 section 3.2.
 	 */
-	if (TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1)
+	if (TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1) {
+		if (subflow->mp_join)
+			goto reset;
 		return subflow->mp_capable;
+	}
 
 	if (mp_opt->dss && mp_opt->use_ack) {
 		/* subflows are fully established as soon as we get any
@@ -713,9 +724,12 @@ static bool check_fully_established(stru
 	}
 
 	/* If the first established packet does not contain MP_CAPABLE + data
-	 * then fallback to TCP
+	 * then fallback to TCP. Fallback scenarios requires a reset for
+	 * MP_JOIN subflows.
 	 */
 	if (!mp_opt->mp_capable) {
+		if (subflow->mp_join)
+			goto reset;
 		subflow->mp_capable = 0;
 		pr_fallback(msk);
 		__mptcp_do_fallback(msk);
@@ -732,12 +746,16 @@ fully_established:
 
 	subflow->pm_notified = 1;
 	if (subflow->mp_join) {
-		clear_3rdack_retransmission(sk);
+		clear_3rdack_retransmission(ssk);
 		mptcp_pm_subflow_established(msk, subflow);
 	} else {
 		mptcp_pm_fully_established(msk);
 	}
 	return true;
+
+reset:
+	mptcp_subflow_reset(ssk);
+	return false;
 }
 
 static u64 expand_ack(u64 old_ack, u64 cur_ack, bool use_64bit)
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -348,6 +348,7 @@ void mptcp_subflow_fully_established(str
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
+void mptcp_subflow_reset(struct sock *ssk);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, int ifindex,
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -270,6 +270,13 @@ static bool subflow_thmac_valid(struct m
 	return thmac == subflow->thmac;
 }
 
+void mptcp_subflow_reset(struct sock *ssk)
+{
+	tcp_set_state(ssk, TCP_CLOSE);
+	tcp_send_active_reset(ssk, GFP_ATOMIC);
+	tcp_done(ssk);
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -342,8 +349,7 @@ fallback:
 	return;
 
 do_reset:
-	tcp_send_active_reset(sk, GFP_ATOMIC);
-	tcp_done(sk);
+	mptcp_subflow_reset(sk);
 }
 
 struct request_sock_ops mptcp_subflow_request_sock_ops;


