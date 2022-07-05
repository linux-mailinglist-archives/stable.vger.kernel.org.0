Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5002A566DA8
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbiGEM05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbiGEMZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2891B7AE;
        Tue,  5 Jul 2022 05:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47E1D61AC4;
        Tue,  5 Jul 2022 12:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA6FC341C7;
        Tue,  5 Jul 2022 12:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023452;
        bh=5qoD6UHc/fsEDBxkPUURqSUA8zaiEj7hQnecIHLEC2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMnBfjffQ0ePuWqwxmLVrxHNAnXLiZSb47pjxDKTC/y54pwgGot/uDAifKg3GmSx7
         YZ/xYBqsxdSzvuHcCt6XfKE0edCu0R6BDiurd4oZo/5zY62+be+FN1E7nzFmp+nlMm
         7wfgKTPxIMMvg91GngvPVgoMhQKmY2Zmm4RWufEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 038/102] mptcp: fix race on unaccepted mptcp sockets
Date:   Tue,  5 Jul 2022 13:58:04 +0200
Message-Id: <20220705115619.494220072@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 6aeed9045071f2252ff4e98fc13d1e304f33e5b0 upstream.

When the listener socket owning the relevant request is closed,
it frees the unaccepted subflows and that causes later deletion
of the paired MPTCP sockets.

The mptcp socket's worker can run in the time interval between such delete
operations. When that happens, any access to msk->first will cause an UaF
access, as the subflow cleanup did not cleared such field in the mptcp
socket.

Address the issue explicitly traversing the listener socket accept
queue at close time and performing the needed cleanup on the pending
msk.

Note that the locking is a bit tricky, as we need to acquire the msk
socket lock, while still owning the subflow socket one.

Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    5 ++++
 net/mptcp/protocol.h |    2 +
 net/mptcp/subflow.c  |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2305,6 +2305,11 @@ static void __mptcp_close_ssk(struct soc
 		kfree_rcu(subflow, rcu);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
+		if (ssk->sk_state == TCP_LISTEN) {
+			tcp_set_state(ssk, TCP_CLOSE);
+			mptcp_subflow_queue_clean(ssk);
+			inet_csk_listen_stop(ssk);
+		}
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -286,6 +286,7 @@ struct mptcp_sock {
 
 	u32 setsockopt_seq;
 	char		ca_name[TCP_CA_NAME_MAX];
+	struct mptcp_sock	*dl_next;
 };
 
 #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
@@ -585,6 +586,7 @@ void mptcp_close_ssk(struct sock *sk, st
 		     struct mptcp_subflow_context *subflow);
 void mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_subflow_queue_clean(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1688,6 +1688,58 @@ static void subflow_state_change(struct
 	}
 }
 
+void mptcp_subflow_queue_clean(struct sock *listener_ssk)
+{
+	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
+	struct mptcp_sock *msk, *next, *head = NULL;
+	struct request_sock *req;
+
+	/* build a list of all unaccepted mptcp sockets */
+	spin_lock_bh(&queue->rskq_lock);
+	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
+		struct mptcp_subflow_context *subflow;
+		struct sock *ssk = req->sk;
+		struct mptcp_sock *msk;
+
+		if (!sk_is_mptcp(ssk))
+			continue;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		if (!subflow || !subflow->conn)
+			continue;
+
+		/* skip if already in list */
+		msk = mptcp_sk(subflow->conn);
+		if (msk->dl_next || msk == head)
+			continue;
+
+		msk->dl_next = head;
+		head = msk;
+	}
+	spin_unlock_bh(&queue->rskq_lock);
+	if (!head)
+		return;
+
+	/* can't acquire the msk socket lock under the subflow one,
+	 * or will cause ABBA deadlock
+	 */
+	release_sock(listener_ssk);
+
+	for (msk = head; msk; msk = next) {
+		struct sock *sk = (struct sock *)msk;
+		bool slow;
+
+		slow = lock_sock_fast_nested(sk);
+		next = msk->dl_next;
+		msk->first = NULL;
+		msk->dl_next = NULL;
+		unlock_sock_fast(sk, slow);
+	}
+
+	/* we are still under the listener msk socket lock */
+	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
+}
+
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);


