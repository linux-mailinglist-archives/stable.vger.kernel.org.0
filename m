Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04926C0FDB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCTK4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjCTK4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:56:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DDDD32A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E6F6CE1193
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C42C433D2;
        Mon, 20 Mar 2023 10:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679309262;
        bh=2DuyO9cT0j8WJ3xWT5t+gPmCVz9rk6td5l03gpcnQvk=;
        h=Subject:To:Cc:From:Date:From;
        b=ifvwY7MGADbue1SCXQ624ve1asplZoDouC7I1PQ5Y/qknLlEhITTeSGy07o0M30ms
         X+gXZCw/I+M1Eop29+mU2JMRbrY6Uabb/tzQRM/hK/pGv2GTGlab8PNMoxU1sAbnlZ
         XJTCfWFJymMrH+eCzsAdtlKpB7H6NDpq5FxtufH4=
Subject: FAILED: patch "[PATCH] mptcp: refactor passive socket initialization" failed to apply to 6.1-stable tree
To:     pabeni@redhat.com, cpaasch@apple.com, kuba@kernel.org,
        matthieu.baerts@tessares.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:47:39 +0100
Message-ID: <167930925942146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 3a236aef280ed5122b2d47087eb514d0921ae033
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930925942146@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

3a236aef280e ("mptcp: refactor passive socket initialization")
dfc8d0603033 ("mptcp: implement delayed seq generation for passive fastopen")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a236aef280ed5122b2d47087eb514d0921ae033 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 9 Mar 2023 15:49:58 +0100
Subject: [PATCH] mptcp: refactor passive socket initialization

After commit 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
unaccepted msk sockets go throu complete shutdown, we don't need anymore
to delay inserting the first subflow into the subflow lists.

The reference counting deserve some extra care, as __mptcp_close() is
unaware of the request socket linkage to the first subflow.

Please note that this is more a refactoring than a fix but because this
modification is needed to include other corrections, see the following
commits. Then a Fixes tag has been added here to help the stable team.

Fixes: 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3ad9c46202fc..447641d34c2c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -825,7 +825,6 @@ static bool __mptcp_finish_join(struct mptcp_sock *msk, struct sock *ssk)
 	if (sk->sk_socket && !ssk->sk_socket)
 		mptcp_sock_graft(ssk, sk->sk_socket);
 
-	mptcp_propagate_sndbuf((struct sock *)msk, ssk);
 	mptcp_sockopt_sync_locked(msk, ssk);
 	return true;
 }
@@ -3708,22 +3707,6 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 		lock_sock(newsk);
 
-		/* PM/worker can now acquire the first subflow socket
-		 * lock without racing with listener queue cleanup,
-		 * we can notify it, if needed.
-		 *
-		 * Even if remote has reset the initial subflow by now
-		 * the refcnt is still at least one.
-		 */
-		subflow = mptcp_subflow_ctx(msk->first);
-		list_add(&subflow->node, &msk->conn_list);
-		sock_hold(msk->first);
-		if (mptcp_is_fully_established(newsk))
-			mptcp_pm_fully_established(msk, msk->first, GFP_KERNEL);
-
-		mptcp_rcv_space_init(msk, msk->first);
-		mptcp_propagate_sndbuf(newsk, msk->first);
-
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5070dc33675d..a631a5e6fc7b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -397,6 +397,12 @@ void mptcp_subflow_reset(struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
+	/* mptcp_mp_fail_no_response() can reach here on an already closed
+	 * socket
+	 */
+	if (ssk->sk_state == TCP_CLOSE)
+		return;
+
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
@@ -750,6 +756,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	struct mptcp_options_received mp_opt;
 	bool fallback, fallback_is_fatal;
 	struct sock *new_msk = NULL;
+	struct mptcp_sock *owner;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
@@ -824,6 +831,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		ctx->setsockopt_seq = listener->setsockopt_seq;
 
 		if (ctx->mp_capable) {
+			owner = mptcp_sk(new_msk);
+
 			/* this can't race with mptcp_close(), as the msk is
 			 * not yet exposted to user-space
 			 */
@@ -832,14 +841,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* record the newly created socket as the first msk
 			 * subflow, but don't link it yet into conn_list
 			 */
-			WRITE_ONCE(mptcp_sk(new_msk)->first, child);
+			WRITE_ONCE(owner->first, child);
 
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
 			mptcp_sk(new_msk)->setsockopt_seq = ctx->setsockopt_seq;
-			mptcp_pm_new_connection(mptcp_sk(new_msk), child, 1);
-			mptcp_token_accept(subflow_req, mptcp_sk(new_msk));
+			mptcp_pm_new_connection(owner, child, 1);
+			mptcp_token_accept(subflow_req, owner);
 			ctx->conn = new_msk;
 			new_msk = NULL;
 
@@ -847,15 +856,21 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 * uses the correct data
 			 */
 			mptcp_copy_inaddrs(ctx->conn, child);
+			mptcp_propagate_sndbuf(ctx->conn, child);
+
+			mptcp_rcv_space_init(owner, child);
+			list_add(&ctx->node, &owner->conn_list);
+			sock_hold(child);
 
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-			if (mp_opt.suboptions & OPTION_MPTCP_MPC_ACK)
+			if (mp_opt.suboptions & OPTION_MPTCP_MPC_ACK) {
 				mptcp_subflow_fully_established(ctx, &mp_opt);
+				mptcp_pm_fully_established(owner, child, GFP_ATOMIC);
+				ctx->pm_notified = 1;
+			}
 		} else if (ctx->mp_join) {
-			struct mptcp_sock *owner;
-
 			owner = subflow_req->msk;
 			if (!owner) {
 				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);

