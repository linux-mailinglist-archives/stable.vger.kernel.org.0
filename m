Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92558CD812
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfJFR5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfJFRdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:33:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD27A2080F;
        Sun,  6 Oct 2019 17:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383200;
        bh=WafDeG03FZuQ8ymlh8TugRV6vjnTay+0zfMwIHrSdKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cS4YBVNqQpfvzI0547YvssVIBo6h0QES0hMWzHcJlXVrSmY/nkLsMlB85l+6oFm+L
         AGpFKo8FpuYy6yoo5fTkc4EN0bw9IxnTlwkzWyyoMNfvBVFlk8hQtzAM+qvm8cD3Oh
         zKKOQ4pbAVpsWKm/qy0ZnWfEYGIo38yl+hvZghKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 017/137] vsock: Fix a lockdep warning in __vsock_release()
Date:   Sun,  6 Oct 2019 19:20:01 +0200
Message-Id: <20191006171210.848059234@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 0d9138ffac24cf8b75366ede3a68c951e6dcc575 ]

Lockdep is unhappy if two locks from the same class are held.

Fix the below warning for hyperv and virtio sockets (vmci socket code
doesn't have the issue) by using lock_sock_nested() when __vsock_release()
is called recursively:

============================================
WARNING: possible recursive locking detected
5.3.0+ #1 Not tainted
--------------------------------------------
server/1795 is trying to acquire lock:
ffff8880c5158990 (sk_lock-AF_VSOCK){+.+.}, at: hvs_release+0x10/0x120 [hv_sock]

but task is already holding lock:
ffff8880c5158150 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x2e/0xf0 [vsock]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_VSOCK);
  lock(sk_lock-AF_VSOCK);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by server/1795:
 #0: ffff8880c5d05ff8 (&sb->s_type->i_mutex_key#10){+.+.}, at: __sock_release+0x2d/0xa0
 #1: ffff8880c5158150 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x2e/0xf0 [vsock]

stack backtrace:
CPU: 5 PID: 1795 Comm: server Not tainted 5.3.0+ #1
Call Trace:
 dump_stack+0x67/0x90
 __lock_acquire.cold.67+0xd2/0x20b
 lock_acquire+0xb5/0x1c0
 lock_sock_nested+0x6d/0x90
 hvs_release+0x10/0x120 [hv_sock]
 __vsock_release+0x24/0xf0 [vsock]
 __vsock_release+0xa0/0xf0 [vsock]
 vsock_release+0x12/0x30 [vsock]
 __sock_release+0x37/0xa0
 sock_close+0x14/0x20
 __fput+0xc1/0x250
 task_work_run+0x98/0xc0
 do_exit+0x344/0xc60
 do_group_exit+0x47/0xb0
 get_signal+0x15c/0xc50
 do_signal+0x30/0x720
 exit_to_usermode_loop+0x50/0xa0
 do_syscall_64+0x24e/0x270
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f4184e85f31

Tested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c                |   16 ++++++++++++----
 net/vmw_vsock/hyperv_transport.c        |    2 +-
 net/vmw_vsock/virtio_transport_common.c |    2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -638,7 +638,7 @@ struct sock *__vsock_create(struct net *
 }
 EXPORT_SYMBOL_GPL(__vsock_create);
 
-static void __vsock_release(struct sock *sk)
+static void __vsock_release(struct sock *sk, int level)
 {
 	if (sk) {
 		struct sk_buff *skb;
@@ -648,9 +648,17 @@ static void __vsock_release(struct sock
 		vsk = vsock_sk(sk);
 		pending = NULL;	/* Compiler warning. */
 
+		/* The release call is supposed to use lock_sock_nested()
+		 * rather than lock_sock(), if a sock lock should be acquired.
+		 */
 		transport->release(vsk);
 
-		lock_sock(sk);
+		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
+		 * version to avoid the warning "possible recursive locking
+		 * detected". When "level" is 0, lock_sock_nested(sk, level)
+		 * is the same as lock_sock(sk).
+		 */
+		lock_sock_nested(sk, level);
 		sock_orphan(sk);
 		sk->sk_shutdown = SHUTDOWN_MASK;
 
@@ -659,7 +667,7 @@ static void __vsock_release(struct sock
 
 		/* Clean up any sockets that never were accepted. */
 		while ((pending = vsock_dequeue_accept(sk)) != NULL) {
-			__vsock_release(pending);
+			__vsock_release(pending, SINGLE_DEPTH_NESTING);
 			sock_put(pending);
 		}
 
@@ -708,7 +716,7 @@ EXPORT_SYMBOL_GPL(vsock_stream_has_space
 
 static int vsock_release(struct socket *sock)
 {
-	__vsock_release(sock->sk);
+	__vsock_release(sock->sk, 0);
 	sock->sk = NULL;
 	sock->state = SS_FREE;
 
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -528,7 +528,7 @@ static void hvs_release(struct vsock_soc
 	struct sock *sk = sk_vsock(vsk);
 	bool remove_sock;
 
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	remove_sock = hvs_close_lock_held(vsk);
 	release_sock(sk);
 	if (remove_sock)
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -790,7 +790,7 @@ void virtio_transport_release(struct vso
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	if (sk->sk_type == SOCK_STREAM)
 		remove_sock = virtio_transport_close(vsk);
 


