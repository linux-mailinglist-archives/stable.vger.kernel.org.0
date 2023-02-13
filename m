Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45CB694468
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjBML2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBML2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:28:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478F96A4F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:28:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F4860FC5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 11:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6EDC433D2;
        Mon, 13 Feb 2023 11:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676287679;
        bh=a1g2jRUQdivQfSLWMh4ZXD4mnxz2OJKxYojW/I20yn0=;
        h=Subject:To:Cc:From:Date:From;
        b=zSd5vNwdVpXCks6dGY/dI9bvqafnmar9xvUOIC+eYlWw8U92pIXHHY6EXGiub69NP
         Q7ngWiMNLSsTA+rqPt9jqOo53FeaQuffh5iPpZ2wjTfNc9C1hVHmXSITD/Bc1tqVb9
         OqFwOw+4cyCbdOhOtKa27qJ1cxaNS9mBULDadqD0=
Subject: FAILED: patch "[PATCH] mptcp: do not wait for bare sockets' timeout" failed to apply to 5.15-stable tree
To:     pabeni@redhat.com, davem@davemloft.net,
        matthieu.baerts@tessares.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 12:27:56 +0100
Message-ID: <167628767650163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d4e85922e3e7 ("mptcp: do not wait for bare sockets' timeout")
76a13b315709 ("mptcp: invoke MP_FAIL response when needed")
d9fb797046c5 ("mptcp: Do not traverse the subflow connection list without lock")
d42f9e4e2384 ("mptcp: Check for orphaned subflow before handling MP_FAIL timer")
d7e6f5836038 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d4e85922e3e7ef2071f91f65e61629b60f3a9cf4 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 7 Feb 2023 14:04:13 +0100
Subject: [PATCH] mptcp: do not wait for bare sockets' timeout

If the peer closes all the existing subflows for a given
mptcp socket and later the application closes it, the current
implementation let it survive until the timewait timeout expires.

While the above is allowed by the protocol specification it
consumes resources for almost no reason and additionally
causes sporadic self-tests failures.

Let's move the mptcp socket to the TCP_CLOSE state when there are
no alive subflows at close time, so that the allocated resources
will be freed immediately.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8cd6cc67c2c5..bc6c1f62a690 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2897,6 +2897,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool do_cancel_work = false;
+	int subflows_alive = 0;
 
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
@@ -2922,6 +2923,8 @@ bool __mptcp_close(struct sock *sk, long timeout)
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast_nested(ssk);
 
+		subflows_alive += ssk->sk_state != TCP_CLOSE;
+
 		/* since the close timeout takes precedence on the fail one,
 		 * cancel the latter
 		 */
@@ -2937,6 +2940,12 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	}
 	sock_orphan(sk);
 
+	/* all the subflows are closed, only timeout can change the msk
+	 * state, let's not keep resources busy for no reasons
+	 */
+	if (subflows_alive == 0)
+		inet_sk_state_store(sk, TCP_CLOSE);
+
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
 	if (msk->token)

