Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4893A029B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhFHTHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237376AbhFHTE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CE62613CA;
        Tue,  8 Jun 2021 18:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177962;
        bh=hj6mXvnoMal4PRcF2xTdllekSdclgOAcdrlzJ429Zv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgLmCBGQHx2g9XwYz7y5hhLVa29tkDPEIpXALruAMv+Dl3qcvn3acJ0K+Ducl5jAl
         z+5zVLHXjsDbGvBzbqeFQ2g3nOXX3k0PP3WThx5EbcT4GBhW3JwNX9UQb8M7mu3Mfc
         SKNXHcc8FAlvbBLH6RztYmDtCZJ72TWF2jokpKtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 026/161] mptcp: do not reset MP_CAPABLE subflow on mapping errors
Date:   Tue,  8 Jun 2021 20:25:56 +0200
Message-Id: <20210608175946.334186622@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit dea2b1ea9c705c5ba351a9174403fd83dbb68fc3 ]

When some mapping related errors occurs we close the main
MPC subflow with a RST. We should instead fallback gracefully
to TCP, and do the reset only for MPJ subflows.

Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/192
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 59 +++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8878317b4386..8425cd393bf3 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -984,22 +984,11 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		u64 old_ack;
 
 		status = get_mapping_status(ssk, msk);
-		pr_debug("msk=%p ssk=%p status=%d", msk, ssk, status);
-		if (status == MAPPING_INVALID) {
-			ssk->sk_err = EBADMSG;
-			goto fatal;
-		}
-		if (status == MAPPING_DUMMY) {
-			__mptcp_do_fallback(msk);
-			skb = skb_peek(&ssk->sk_receive_queue);
-			subflow->map_valid = 1;
-			subflow->map_seq = READ_ONCE(msk->ack_seq);
-			subflow->map_data_len = skb->len;
-			subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq -
-						   subflow->ssn_offset;
-			subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
-			return true;
-		}
+		if (unlikely(status == MAPPING_INVALID))
+			goto fallback;
+
+		if (unlikely(status == MAPPING_DUMMY))
+			goto fallback;
 
 		if (status != MAPPING_OK)
 			goto no_data;
@@ -1012,10 +1001,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		 * MP_CAPABLE-based mapping
 		 */
 		if (unlikely(!READ_ONCE(msk->can_ack))) {
-			if (!subflow->mpc_map) {
-				ssk->sk_err = EBADMSG;
-				goto fatal;
-			}
+			if (!subflow->mpc_map)
+				goto fallback;
 			WRITE_ONCE(msk->remote_key, subflow->remote_key);
 			WRITE_ONCE(msk->ack_seq, subflow->map_seq);
 			WRITE_ONCE(msk->can_ack, true);
@@ -1043,15 +1030,29 @@ static bool subflow_check_data_avail(struct sock *ssk)
 no_data:
 	subflow_sched_work_if_closed(msk, ssk);
 	return false;
-fatal:
-	/* fatal protocol error, close the socket */
-	/* This barrier is coupled with smp_rmb() in tcp_poll() */
-	smp_wmb();
-	ssk->sk_error_report(ssk);
-	tcp_set_state(ssk, TCP_CLOSE);
-	tcp_send_active_reset(ssk, GFP_ATOMIC);
-	subflow->data_avail = 0;
-	return false;
+
+fallback:
+	/* RFC 8684 section 3.7. */
+	if (subflow->mp_join || subflow->fully_established) {
+		/* fatal protocol error, close the socket.
+		 * subflow_error_report() will introduce the appropriate barriers
+		 */
+		ssk->sk_err = EBADMSG;
+		ssk->sk_error_report(ssk);
+		tcp_set_state(ssk, TCP_CLOSE);
+		tcp_send_active_reset(ssk, GFP_ATOMIC);
+		subflow->data_avail = 0;
+		return false;
+	}
+
+	__mptcp_do_fallback(msk);
+	skb = skb_peek(&ssk->sk_receive_queue);
+	subflow->map_valid = 1;
+	subflow->map_seq = READ_ONCE(msk->ack_seq);
+	subflow->map_data_len = skb->len;
+	subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
+	subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
+	return true;
 }
 
 bool mptcp_subflow_data_available(struct sock *sk)
-- 
2.30.2



