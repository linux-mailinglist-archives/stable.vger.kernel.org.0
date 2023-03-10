Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2183D6B4815
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjCJO6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjCJO6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:58:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A17A26C27
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B029861962
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C36C4339C;
        Fri, 10 Mar 2023 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459865;
        bh=PSnNK2OgNgHOKzpBddjHJ4kwnLaO+G7oFvJeUkm1yPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4EBj61H6FDQPUCeNNGqwzR+9jjYsX4QORntDCLH64GJGZ1WnAVWqtvmqPOMm/SCl
         EvLHHTZsulaBXEaBm3zUESp76LAjpykmRVRQDqbteCWJ8aIXgYHKjgp8ESP4aUjmcE
         oeS2IP334y07thCblAhRNu3qvhKUwK5V3rBSzmfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cong Wang <cong.wang@bytedance.com>,
        Shigeru Yoshida <syoshida@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/529] l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()
Date:   Fri, 10 Mar 2023 14:34:47 +0100
Message-Id: <20230310133811.641189647@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 9ca5e7ecab064f1f47da07f7c1ddf40e4bc0e5ac ]

When a file descriptor of pppol2tp socket is passed as file descriptor
of UDP socket, a recursive deadlock occurs in l2tp_tunnel_register().
This situation is reproduced by the following program:

int main(void)
{
	int sock;
	struct sockaddr_pppol2tp addr;

	sock = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
	if (sock < 0) {
		perror("socket");
		return 1;
	}

	addr.sa_family = AF_PPPOX;
	addr.sa_protocol = PX_PROTO_OL2TP;
	addr.pppol2tp.pid = 0;
	addr.pppol2tp.fd = sock;
	addr.pppol2tp.addr.sin_family = PF_INET;
	addr.pppol2tp.addr.sin_port = htons(0);
	addr.pppol2tp.addr.sin_addr.s_addr = inet_addr("192.168.0.1");
	addr.pppol2tp.s_tunnel = 1;
	addr.pppol2tp.s_session = 0;
	addr.pppol2tp.d_tunnel = 0;
	addr.pppol2tp.d_session = 0;

	if (connect(sock, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
		perror("connect");
		return 1;
	}

	return 0;
}

This program causes the following lockdep warning:

 ============================================
 WARNING: possible recursive locking detected
 6.2.0-rc5-00205-gc96618275234 #56 Not tainted
 --------------------------------------------
 repro/8607 is trying to acquire lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: l2tp_tunnel_register+0x2b7/0x11c0

 but task is already holding lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(sk_lock-AF_PPPOX);
   lock(sk_lock-AF_PPPOX);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 1 lock held by repro/8607:
  #0: ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 stack backtrace:
 CPU: 0 PID: 8607 Comm: repro Not tainted 6.2.0-rc5-00205-gc96618275234 #56
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x100/0x178
  __lock_acquire.cold+0x119/0x3b9
  ? lockdep_hardirqs_on_prepare+0x410/0x410
  lock_acquire+0x1e0/0x610
  ? l2tp_tunnel_register+0x2b7/0x11c0
  ? lock_downgrade+0x710/0x710
  ? __fget_files+0x283/0x3e0
  lock_sock_nested+0x3a/0xf0
  ? l2tp_tunnel_register+0x2b7/0x11c0
  l2tp_tunnel_register+0x2b7/0x11c0
  ? sprintf+0xc4/0x100
  ? l2tp_tunnel_del_work+0x6b0/0x6b0
  ? debug_object_deactivate+0x320/0x320
  ? lockdep_init_map_type+0x16d/0x7a0
  ? lockdep_init_map_type+0x16d/0x7a0
  ? l2tp_tunnel_create+0x2bf/0x4b0
  ? l2tp_tunnel_create+0x3c6/0x4b0
  pppol2tp_connect+0x14e1/0x1a30
  ? pppol2tp_put_sk+0xd0/0xd0
  ? aa_sk_perm+0x2b7/0xa80
  ? aa_af_perm+0x260/0x260
  ? bpf_lsm_socket_connect+0x9/0x10
  ? pppol2tp_put_sk+0xd0/0xd0
  __sys_connect_file+0x14f/0x190
  __sys_connect+0x133/0x160
  ? __sys_connect_file+0x190/0x190
  ? lockdep_hardirqs_on+0x7d/0x100
  ? ktime_get_coarse_real_ts64+0x1b7/0x200
  ? ktime_get_coarse_real_ts64+0x147/0x200
  ? __audit_syscall_entry+0x396/0x500
  __x64_sys_connect+0x72/0xb0
  do_syscall_64+0x38/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

This patch fixes the issue by getting/creating the tunnel before
locking the pppol2tp socket.

Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Cc: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_ppp.c | 125 ++++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 58 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index aea85f91f0599..5ecc0f2009444 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -651,54 +651,22 @@ static int pppol2tp_tunnel_mtu(const struct l2tp_tunnel *tunnel)
 	return mtu - PPPOL2TP_HEADER_OVERHEAD;
 }
 
-/* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
- */
-static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
-			    int sockaddr_len, int flags)
+static struct l2tp_tunnel *pppol2tp_tunnel_get(struct net *net,
+					       const struct l2tp_connect_info *info,
+					       bool *new_tunnel)
 {
-	struct sock *sk = sock->sk;
-	struct pppox_sock *po = pppox_sk(sk);
-	struct l2tp_session *session = NULL;
-	struct l2tp_connect_info info;
 	struct l2tp_tunnel *tunnel;
-	struct pppol2tp_session *ps;
-	struct l2tp_session_cfg cfg = { 0, };
-	bool drop_refcnt = false;
-	bool drop_tunnel = false;
-	bool new_session = false;
-	bool new_tunnel = false;
 	int error;
 
-	error = pppol2tp_sockaddr_get_info(uservaddr, sockaddr_len, &info);
-	if (error < 0)
-		return error;
+	*new_tunnel = false;
 
-	lock_sock(sk);
-
-	/* Check for already bound sockets */
-	error = -EBUSY;
-	if (sk->sk_state & PPPOX_CONNECTED)
-		goto end;
-
-	/* We don't supporting rebinding anyway */
-	error = -EALREADY;
-	if (sk->sk_user_data)
-		goto end; /* socket is already attached */
-
-	/* Don't bind if tunnel_id is 0 */
-	error = -EINVAL;
-	if (!info.tunnel_id)
-		goto end;
-
-	tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
-	if (tunnel)
-		drop_tunnel = true;
+	tunnel = l2tp_tunnel_get(net, info->tunnel_id);
 
 	/* Special case: create tunnel context if session_id and
 	 * peer_session_id is 0. Otherwise look up tunnel using supplied
 	 * tunnel id.
 	 */
-	if (!info.session_id && !info.peer_session_id) {
+	if (!info->session_id && !info->peer_session_id) {
 		if (!tunnel) {
 			struct l2tp_tunnel_cfg tcfg = {
 				.encap = L2TP_ENCAPTYPE_UDP,
@@ -707,40 +675,82 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 			/* Prevent l2tp_tunnel_register() from trying to set up
 			 * a kernel socket.
 			 */
-			if (info.fd < 0) {
-				error = -EBADF;
-				goto end;
-			}
+			if (info->fd < 0)
+				return ERR_PTR(-EBADF);
 
-			error = l2tp_tunnel_create(info.fd,
-						   info.version,
-						   info.tunnel_id,
-						   info.peer_tunnel_id, &tcfg,
+			error = l2tp_tunnel_create(info->fd,
+						   info->version,
+						   info->tunnel_id,
+						   info->peer_tunnel_id, &tcfg,
 						   &tunnel);
 			if (error < 0)
-				goto end;
+				return ERR_PTR(error);
 
 			l2tp_tunnel_inc_refcount(tunnel);
-			error = l2tp_tunnel_register(tunnel, sock_net(sk),
-						     &tcfg);
+			error = l2tp_tunnel_register(tunnel, net, &tcfg);
 			if (error < 0) {
 				kfree(tunnel);
-				goto end;
+				return ERR_PTR(error);
 			}
-			drop_tunnel = true;
-			new_tunnel = true;
+
+			*new_tunnel = true;
 		}
 	} else {
 		/* Error if we can't find the tunnel */
-		error = -ENOENT;
 		if (!tunnel)
-			goto end;
+			return ERR_PTR(-ENOENT);
 
 		/* Error if socket is not prepped */
-		if (!tunnel->sock)
-			goto end;
+		if (!tunnel->sock) {
+			l2tp_tunnel_dec_refcount(tunnel);
+			return ERR_PTR(-ENOENT);
+		}
 	}
 
+	return tunnel;
+}
+
+/* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
+ */
+static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
+			    int sockaddr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct pppox_sock *po = pppox_sk(sk);
+	struct l2tp_session *session = NULL;
+	struct l2tp_connect_info info;
+	struct l2tp_tunnel *tunnel;
+	struct pppol2tp_session *ps;
+	struct l2tp_session_cfg cfg = { 0, };
+	bool drop_refcnt = false;
+	bool new_session = false;
+	bool new_tunnel = false;
+	int error;
+
+	error = pppol2tp_sockaddr_get_info(uservaddr, sockaddr_len, &info);
+	if (error < 0)
+		return error;
+
+	/* Don't bind if tunnel_id is 0 */
+	if (!info.tunnel_id)
+		return -EINVAL;
+
+	tunnel = pppol2tp_tunnel_get(sock_net(sk), &info, &new_tunnel);
+	if (IS_ERR(tunnel))
+		return PTR_ERR(tunnel);
+
+	lock_sock(sk);
+
+	/* Check for already bound sockets */
+	error = -EBUSY;
+	if (sk->sk_state & PPPOX_CONNECTED)
+		goto end;
+
+	/* We don't supporting rebinding anyway */
+	error = -EALREADY;
+	if (sk->sk_user_data)
+		goto end; /* socket is already attached */
+
 	if (tunnel->peer_tunnel_id == 0)
 		tunnel->peer_tunnel_id = info.peer_tunnel_id;
 
@@ -841,8 +851,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	}
 	if (drop_refcnt)
 		l2tp_session_dec_refcount(session);
-	if (drop_tunnel)
-		l2tp_tunnel_dec_refcount(tunnel);
+	l2tp_tunnel_dec_refcount(tunnel);
 	release_sock(sk);
 
 	return error;
-- 
2.39.2



