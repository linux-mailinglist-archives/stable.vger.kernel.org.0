Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E5A4F2C58
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiDEJjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243646AbiDEJJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBE1C6823;
        Tue,  5 Apr 2022 01:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C79C9B81A22;
        Tue,  5 Apr 2022 08:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C6AC385A0;
        Tue,  5 Apr 2022 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149097;
        bh=jEutgea3U4C5itwXwH/873Vfcxssgwvd1LxznxgCUKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LhBBqtdMz2wc78kwKJowJUFKh1KYT1Unyi6I/GojP7gMdR3pKWm9M1WI+obOYCm9
         Hg2BERRRWtK0x++jqKAYe1M95bJiJufjeIBD/0ShPRFYeO6kM+OZTsg+w1iYaBBWsN
         +G+tWEzEm7738RhbvB4gi0Eca0s0LFMIw0NLJwSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elza Mathew <elza.mathew@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0555/1017] xsk: Fix race at socket teardown
Date:   Tue,  5 Apr 2022 09:24:28 +0200
Message-Id: <20220405070410.757137935@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 18b1ab7aa76bde181bdb1ab19a87fa9523c32f21 ]

Fix a race in the xsk socket teardown code that can lead to a NULL pointer
dereference splat. The current xsk unbind code in xsk_unbind_dev() starts by
setting xs->state to XSK_UNBOUND, sets xs->dev to NULL and then waits for any
NAPI processing to terminate using synchronize_net(). After that, the release
code starts to tear down the socket state and free allocated memory.

  BUG: kernel NULL pointer dereference, address: 00000000000000c0
  PGD 8000000932469067 P4D 8000000932469067 PUD 0
  Oops: 0000 [#1] PREEMPT SMP PTI
  CPU: 25 PID: 69132 Comm: grpcpp_sync_ser Tainted: G          I       5.16.0+ #2
  Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.2.10 03/09/2015
  RIP: 0010:__xsk_sendmsg+0x2c/0x690
  [...]
  RSP: 0018:ffffa2348bd13d50 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 0000000000000040 RCX: ffff8d5fc632d258
  RDX: 0000000000400000 RSI: ffffa2348bd13e10 RDI: ffff8d5fc5489800
  RBP: ffffa2348bd13db0 R08: 0000000000000000 R09: 00007ffffffff000
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff8d5fc5489800
  R13: ffff8d5fcb0f5140 R14: ffff8d5fcb0f5140 R15: 0000000000000000
  FS:  00007f991cff9400(0000) GS:ffff8d6f1f700000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000c0 CR3: 0000000114888005 CR4: 00000000001706e0
  Call Trace:
  <TASK>
  ? aa_sk_perm+0x43/0x1b0
  xsk_sendmsg+0xf0/0x110
  sock_sendmsg+0x65/0x70
  __sys_sendto+0x113/0x190
  ? debug_smp_processor_id+0x17/0x20
  ? fpregs_assert_state_consistent+0x23/0x50
  ? exit_to_user_mode_prepare+0xa5/0x1d0
  __x64_sys_sendto+0x29/0x30
  do_syscall_64+0x3b/0xc0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

There are two problems with the current code. First, setting xs->dev to NULL
before waiting for all users to stop using the socket is not correct. The
entry to the data plane functions xsk_poll(), xsk_sendmsg(), and xsk_recvmsg()
are all guarded by a test that xs->state is in the state XSK_BOUND and if not,
it returns right away. But one process might have passed this test but still
have not gotten to the point in which it uses xs->dev in the code. In this
interim, a second process executing xsk_unbind_dev() might have set xs->dev to
NULL which will lead to a crash for the first process. The solution here is
just to get rid of this NULL assignment since it is not used anymore. Before
commit 42fddcc7c64b ("xsk: use state member for socket synchronization"),
xs->dev was the gatekeeper to admit processes into the data plane functions,
but it was replaced with the state variable xs->state in the aforementioned
commit.

The second problem is that synchronize_net() does not wait for any process in
xsk_poll(), xsk_sendmsg(), or xsk_recvmsg() to complete, which means that the
state they rely on might be cleaned up prematurely. This can happen when the
notifier gets called (at driver unload for example) as it uses xsk_unbind_dev().
Solve this by extending the RCU critical region from just the ndo_xsk_wakeup
to the whole functions mentioned above, so that both the test of xs->state ==
XSK_BOUND and the last use of any member of xs is covered by the RCU critical
section. This will guarantee that when synchronize_net() completes, there will
be no processes left executing xsk_poll(), xsk_sendmsg(), or xsk_recvmsg() and
state can be cleaned up safely. Note that we need to drop the RCU lock for the
skb xmit path as it uses functions that might sleep. Due to this, we have to
retest the xs->state after we grab the mutex that protects the skb xmit code
from, among a number of things, an xsk_unbind_dev() being executed from the
notifier at the same time.

Fixes: 42fddcc7c64b ("xsk: use state member for socket synchronization")
Reported-by: Elza Mathew <elza.mathew@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20220228094552.10134-1-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 69 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 19 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f16074eb53c7..468e9b7e3edf 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -403,18 +403,8 @@ EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
 static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 {
 	struct net_device *dev = xs->dev;
-	int err;
-
-	rcu_read_lock();
-	err = dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
-	rcu_read_unlock();
-
-	return err;
-}
 
-static int xsk_zc_xmit(struct xdp_sock *xs)
-{
-	return xsk_wakeup(xs, XDP_WAKEUP_TX);
+	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
 }
 
 static void xsk_destruct_skb(struct sk_buff *skb)
@@ -533,6 +523,12 @@ static int xsk_generic_xmit(struct sock *sk)
 
 	mutex_lock(&xs->mutex);
 
+	/* Since we dropped the RCU read lock, the socket state might have changed. */
+	if (unlikely(!xsk_is_bound(xs))) {
+		err = -ENXIO;
+		goto out;
+	}
+
 	if (xs->queue_id >= xs->dev->real_num_tx_queues)
 		goto out;
 
@@ -596,16 +592,26 @@ static int xsk_generic_xmit(struct sock *sk)
 	return err;
 }
 
-static int __xsk_sendmsg(struct sock *sk)
+static int xsk_xmit(struct sock *sk)
 {
 	struct xdp_sock *xs = xdp_sk(sk);
+	int ret;
 
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
 		return -ENETDOWN;
 	if (unlikely(!xs->tx))
 		return -ENOBUFS;
 
-	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
+	if (xs->zc)
+		return xsk_wakeup(xs, XDP_WAKEUP_TX);
+
+	/* Drop the RCU lock since the SKB path might sleep. */
+	rcu_read_unlock();
+	ret = xsk_generic_xmit(sk);
+	/* Reaquire RCU lock before going into common code. */
+	rcu_read_lock();
+
+	return ret;
 }
 
 static bool xsk_no_wakeup(struct sock *sk)
@@ -619,7 +625,7 @@ static bool xsk_no_wakeup(struct sock *sk)
 #endif
 }
 
-static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
@@ -639,11 +645,22 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 
 	pool = xs->pool;
 	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
-		return __xsk_sendmsg(sk);
+		return xsk_xmit(sk);
 	return 0;
 }
 
-static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = __xsk_sendmsg(sock, m, total_len);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
 {
 	bool need_wait = !(flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
@@ -669,6 +686,17 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 	return 0;
 }
 
+static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = __xsk_recvmsg(sock, m, len, flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
@@ -679,8 +707,11 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 
 	sock_poll_wait(file, sock, wait);
 
-	if (unlikely(!xsk_is_bound(xs)))
+	rcu_read_lock();
+	if (unlikely(!xsk_is_bound(xs))) {
+		rcu_read_unlock();
 		return mask;
+	}
 
 	pool = xs->pool;
 
@@ -689,7 +720,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			xsk_wakeup(xs, pool->cached_need_wakeup);
 		else
 			/* Poll needs to drive Tx also in copy mode */
-			__xsk_sendmsg(sk);
+			xsk_xmit(sk);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
@@ -697,6 +728,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 	if (xs->tx && xsk_tx_writeable(xs))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
+	rcu_read_unlock();
 	return mask;
 }
 
@@ -728,7 +760,6 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 
 	/* Wait for driver to stop using the xdp socket. */
 	xp_del_xsk(xs->pool, xs);
-	xs->dev = NULL;
 	synchronize_net();
 	dev_put(dev);
 }
-- 
2.34.1



