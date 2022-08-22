Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D409259BB60
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiHVIXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiHVIXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:23:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57371FA
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B46B80EA3
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC74AC433C1;
        Mon, 22 Aug 2022 08:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661156590;
        bh=shO60EF0nesFQCXZd76Cn/XIwUrM2lB5cidGsqXIQNU=;
        h=Subject:To:Cc:From:Date:From;
        b=OlXWebEgO5zdtPUqj0jtNtCsl6nFuie5VJyyexvoEdnon9KeymCzwEDcXVsFWtbPi
         yyVkiNp9K4whr4A0Tf34jjJVpTfNBl3YjgqGRYX1Yd6CqzII9rRvccdtr0JkUrljqb
         ha/q8fFf8shaWq7aG4ubAyeNsHhTPc18/aRtBGzk=
Subject: FAILED: patch "[PATCH] mptcp: move subflow cleanup in mptcp_destroy_common()" failed to apply to 5.15-stable tree
To:     pabeni@redhat.com, davem@davemloft.net,
        mathew.j.martineau@linux.intel.com, phind.uet@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:23:07 +0200
Message-ID: <166115658722449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c0bf3c6aa444a5ef44acc57ef6cfa53fd4fc1c9b Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 4 Aug 2022 17:21:25 -0700
Subject: [PATCH] mptcp: move subflow cleanup in mptcp_destroy_common()

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

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a3f1c1461874..07fcc86e1fc9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2769,30 +2769,16 @@ static void __mptcp_wr_shutdown(struct sock *sk)
 
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
@@ -2884,24 +2870,20 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
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
@@ -3051,12 +3033,17 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
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
@@ -3078,7 +3065,11 @@ static void mptcp_destroy(struct sock *sk)
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
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5d6043c16b09..40881a7df5d5 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -717,7 +717,7 @@ static inline void mptcp_write_space(struct sock *sk)
 	}
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk);
+void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags);
 
 #define MPTCP_TOKEN_MAX_RETRIES	4
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 901c763dcdbb..c7d49fb6e7bd 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -621,7 +621,8 @@ static void mptcp_sock_destruct(struct sock *sk)
 		sock_orphan(sk);
 	}
 
-	mptcp_destroy_common(mptcp_sk(sk));
+	/* We don't need to clear msk->subflow, as it's still NULL at this point */
+	mptcp_destroy_common(mptcp_sk(sk), 0);
 	inet_sock_destruct(sk);
 }
 

