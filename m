Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17C11FB776
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732202AbgFPPqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732200AbgFPPqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CDBB2071A;
        Tue, 16 Jun 2020 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322383;
        bh=b+3dapOenMoKzHmz4ZMKrtxot/1gdSwrklB994ycXnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1+8+YDAJ6YFPwPJTXGOMdenbbmg5OCATE9yW7ymlYQk2QuFXQgZkBovGJJVOb5Nb
         YZtOiCc7nTT7CjoIuUjz1jLX4OozNnBEMs2qH/oqQT6D5zHGppZ46r4cRBZ7TOp+Md
         LepR5indOQjJvnmls5njcHCxmIJl486qHpzv8sG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 110/163] mptcp: fix races between shutdown and recvmsg
Date:   Tue, 16 Jun 2020 17:34:44 +0200
Message-Id: <20200616153112.075696293@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 5969856ae8ce29c9d523a1a6145cbd9e87f7046c ]

The msk sk_shutdown flag is set by a workqueue, possibly
introducing some delay in user-space notification. If the last
subflow carries some data with the fin packet, the user space
can wake-up before RCV_SHUTDOWN is set. If it executes unblocking
recvmsg(), it may return with an error instead of eof.

Address the issue explicitly checking for eof in recvmsg(), when
no data is found.

Fixes: 59832e246515 ("mptcp: subflow: check parent mptcp socket on subflow state change")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -357,6 +357,27 @@ void mptcp_subflow_eof(struct sock *sk)
 		sock_hold(sk);
 }
 
+static void mptcp_check_for_eof(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int receivers = 0;
+
+	mptcp_for_each_subflow(msk, subflow)
+		receivers += !subflow->rx_eof;
+
+	if (!receivers && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
+		/* hopefully temporary hack: propagate shutdown status
+		 * to msk, when all subflows agree on it
+		 */
+		sk->sk_shutdown |= RCV_SHUTDOWN;
+
+		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
+		set_bit(MPTCP_DATA_READY, &msk->flags);
+		sk->sk_data_ready(sk);
+	}
+}
+
 static void mptcp_stop_timer(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -933,6 +954,9 @@ fallback:
 				break;
 			}
 
+			if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
+				mptcp_check_for_eof(msk);
+
 			if (sk->sk_shutdown & RCV_SHUTDOWN)
 				break;
 
@@ -1070,27 +1094,6 @@ static unsigned int mptcp_sync_mss(struc
 	return 0;
 }
 
-static void mptcp_check_for_eof(struct mptcp_sock *msk)
-{
-	struct mptcp_subflow_context *subflow;
-	struct sock *sk = (struct sock *)msk;
-	int receivers = 0;
-
-	mptcp_for_each_subflow(msk, subflow)
-		receivers += !subflow->rx_eof;
-
-	if (!receivers && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
-		/* hopefully temporary hack: propagate shutdown status
-		 * to msk, when all subflows agree on it
-		 */
-		sk->sk_shutdown |= RCV_SHUTDOWN;
-
-		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
-		set_bit(MPTCP_DATA_READY, &msk->flags);
-		sk->sk_data_ready(sk);
-	}
-}
-
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);


