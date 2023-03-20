Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9EA6C19E3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjCTPj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjCTPjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:39:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722A8303D5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4213615C0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35EFC4339C;
        Mon, 20 Mar 2023 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326225;
        bh=QGsbkLhb89YvLy4hDjzoDeig+7yhipWhb45h0SBcCNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cd4OoI8dabuoSwTJ/XrmNobETqMOTglBq/lE68h3m2FfKwwBnncVaBhrlV8P4mi5K
         cnKKJK/vVFUXB+JLkSWpztNaBdOQaPvcyu23iauPdLzL3McziBwLHRk+NhlzUKcRZb
         5+/Ekwl9cf3XyIcRF0pJhZd9Q8nkU3HikOLzQ87U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 174/211] mptcp: refactor passive socket initialization
Date:   Mon, 20 Mar 2023 15:55:09 +0100
Message-Id: <20230320145520.743734782@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 3a236aef280ed5122b2d47087eb514d0921ae033 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   17 -----------------
 net/mptcp/subflow.c  |   27 +++++++++++++++++++++------
 2 files changed, 21 insertions(+), 23 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -825,7 +825,6 @@ static bool __mptcp_finish_join(struct m
 	if (sk->sk_socket && !ssk->sk_socket)
 		mptcp_sock_graft(ssk, sk->sk_socket);
 
-	mptcp_propagate_sndbuf((struct sock *)msk, ssk);
 	mptcp_sockopt_sync_locked(msk, ssk);
 	return true;
 }
@@ -3699,22 +3698,6 @@ static int mptcp_stream_accept(struct so
 
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
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -396,6 +396,12 @@ void mptcp_subflow_reset(struct sock *ss
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
 
@@ -749,6 +755,7 @@ static struct sock *subflow_syn_recv_soc
 	struct mptcp_options_received mp_opt;
 	bool fallback, fallback_is_fatal;
 	struct sock *new_msk = NULL;
+	struct mptcp_sock *owner;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
@@ -823,6 +830,8 @@ create_child:
 		ctx->setsockopt_seq = listener->setsockopt_seq;
 
 		if (ctx->mp_capable) {
+			owner = mptcp_sk(new_msk);
+
 			/* this can't race with mptcp_close(), as the msk is
 			 * not yet exposted to user-space
 			 */
@@ -831,14 +840,14 @@ create_child:
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
 
@@ -846,15 +855,21 @@ create_child:
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


