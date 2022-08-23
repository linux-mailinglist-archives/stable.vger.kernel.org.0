Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0943859D414
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242029AbiHWIMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242326AbiHWILH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CFDE0BD;
        Tue, 23 Aug 2022 01:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64672B81C23;
        Tue, 23 Aug 2022 08:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B193AC433C1;
        Tue, 23 Aug 2022 08:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242099;
        bh=Iz3mcDSD/CX4/0hqF9gIv3op0gD/0aLMMXcQHT087NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2tjh9En7en5fmFM8DS6Tm9HhhQ+BZqidFjjaX+rUQR8SXLZVlBFBvg3k8Rip6zvR
         71JjVaO/U38l6Kqxoj0d8HWElVLhRM0mTvgiBUxh+wYl3T+dGJxKEZ/F+NVrdx6Wgt
         Vzb0LonoGJHy+LTr8myX4EcUMjBSvkTUvxqx7xLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nguyen Dinh Phi <phind.uet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 058/365] mptcp: move subflow cleanup in mptcp_destroy_common()
Date:   Tue, 23 Aug 2022 09:59:19 +0200
Message-Id: <20220823080120.606301802@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit c0bf3c6aa444a5ef44acc57ef6cfa53fd4fc1c9b upstream.

If the mptcp socket creation fails due to a CGROUP_INET_SOCK_CREATE
eBPF program, the MPTCP protocol ends-up leaking all the subflows:
the related cleanup happens in __mptcp_destroy_sock() that is not
invoked in such code path.

Address the issue moving the subflow sockets cleanup in the
mptcp_destroy_common() helper, which is invoked in every msk cleanup
path.

Additionally get rid of the intermediate list_splice_init step, which
is an unneeded relic from the past.

The issue is present since before the reported root cause commit, but
any attempt to backport the fix before that hash will require a complete
rewrite.

Fixes: e16163b6e2 ("mptcp: refactor shutdown and close")
Reported-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Co-developed-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   39 +++++++++++++++------------------------
 net/mptcp/protocol.h |    2 +-
 net/mptcp/subflow.c  |    3 ++-
 3 files changed, 18 insertions(+), 26 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2805,30 +2805,16 @@ static void __mptcp_wr_shutdown(struct s
 
 static void __mptcp_destroy_sock(struct sock *sk)
 {
-	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	LIST_HEAD(conn_list);
 
 	pr_debug("msk=%p", msk);
 
 	might_sleep();
 
-	/* join list will be eventually flushed (with rst) at sock lock release time*/
-	list_splice_init(&msk->conn_list, &conn_list);
-
 	mptcp_stop_timer(sk);
 	sk_stop_timer(sk, &sk->sk_timer);
 	msk->pm.status = 0;
 
-	/* clears msk->subflow, allowing the following loop to close
-	 * even the initial subflow
-	 */
-	mptcp_dispose_initial_subflow(msk);
-	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		__mptcp_close_ssk(sk, ssk, subflow, 0);
-	}
-
 	sk->sk_prot->destroy(sk);
 
 	WARN_ON_ONCE(msk->rmem_fwd_alloc);
@@ -2920,24 +2906,20 @@ static void mptcp_copy_inaddrs(struct so
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
-	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		__mptcp_close_ssk(sk, ssk, subflow, MPTCP_CF_FASTCLOSE);
-	}
-
 	mptcp_stop_timer(sk);
 	sk_stop_timer(sk, &sk->sk_timer);
 
 	if (mptcp_sk(sk)->token)
 		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
 
-	mptcp_destroy_common(msk);
+	/* msk->subflow is still intact, the following will not free the first
+	 * subflow
+	 */
+	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
 	msk->last_snd = NULL;
 	WRITE_ONCE(msk->flags, 0);
 	msk->cb_flags = 0;
@@ -3087,12 +3069,17 @@ out:
 	return newsk;
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk)
+void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags)
 {
+	struct mptcp_subflow_context *subflow, *tmp;
 	struct sock *sk = (struct sock *)msk;
 
 	__mptcp_clear_xmit(sk);
 
+	/* join list will be eventually flushed (with rst) at sock lock release time */
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node)
+		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow), subflow, flags);
+
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
 	mptcp_data_lock(sk);
 	skb_queue_splice_tail_init(&msk->receive_queue, &sk->sk_receive_queue);
@@ -3114,7 +3101,11 @@ static void mptcp_destroy(struct sock *s
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	mptcp_destroy_common(msk);
+	/* clears msk->subflow, allowing the following to close
+	 * even the initial subflow
+	 */
+	mptcp_dispose_initial_subflow(msk);
+	mptcp_destroy_common(msk, 0);
 	sk_sockets_allocated_dec(sk);
 }
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -718,7 +718,7 @@ static inline void mptcp_write_space(str
 	}
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk);
+void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags);
 
 #define MPTCP_TOKEN_MAX_RETRIES	4
 
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -621,7 +621,8 @@ static void mptcp_sock_destruct(struct s
 		sock_orphan(sk);
 	}
 
-	mptcp_destroy_common(mptcp_sk(sk));
+	/* We don't need to clear msk->subflow, as it's still NULL at this point */
+	mptcp_destroy_common(mptcp_sk(sk), 0);
 	inet_sock_destruct(sk);
 }
 


