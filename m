Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF3A551BB1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245247AbiFTNLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343789AbiFTNJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AD21ADA1;
        Mon, 20 Jun 2022 06:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 099E861556;
        Mon, 20 Jun 2022 13:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED924C3411B;
        Mon, 20 Jun 2022 13:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730213;
        bh=bbLXzh+D70VvL97McKf6w3ga+n5B9pYKacEYkWXvfps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjfxMKG5TIr74E5IUWG1KrhNE1R2y2foxh7poTBMumTyJWg+msv+Fkmx6gtkpJ/pz
         xHJkKJ5jtc4uEwioN7QRkO5/GpXuf+lxqmW2mqHXFXGhmipO4cKZQqgy1ChOFrgvl7
         ulWHpQElwPOFRxLz15s8UIYspnu/UB6TALlcPdkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Osterried <thomas@osterried.de>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/84] net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg
Date:   Mon, 20 Jun 2022 14:51:12 +0200
Message-Id: <20220620124722.337693699@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 219b51a6f040fa5367adadd7d58c4dda0896a01d ]

The skb_recv_datagram() in ax25_recvmsg() will hold lock_sock
and block until it receives a packet from the remote. If the client
doesn`t connect to server and calls read() directly, it will not
receive any packets forever. As a result, the deadlock will happen.

The fail log caused by deadlock is shown below:

[  369.606973] INFO: task ax25_deadlock:157 blocked for more than 245 seconds.
[  369.608919] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  369.613058] Call Trace:
[  369.613315]  <TASK>
[  369.614072]  __schedule+0x2f9/0xb20
[  369.615029]  schedule+0x49/0xb0
[  369.615734]  __lock_sock+0x92/0x100
[  369.616763]  ? destroy_sched_domains_rcu+0x20/0x20
[  369.617941]  lock_sock_nested+0x6e/0x70
[  369.618809]  ax25_bind+0xaa/0x210
[  369.619736]  __sys_bind+0xca/0xf0
[  369.620039]  ? do_futex+0xae/0x1b0
[  369.620387]  ? __x64_sys_futex+0x7c/0x1c0
[  369.620601]  ? fpregs_assert_state_consistent+0x19/0x40
[  369.620613]  __x64_sys_bind+0x11/0x20
[  369.621791]  do_syscall_64+0x3b/0x90
[  369.622423]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  369.623319] RIP: 0033:0x7f43c8aa8af7
[  369.624301] RSP: 002b:00007f43c8197ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
[  369.625756] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f43c8aa8af7
[  369.626724] RDX: 0000000000000010 RSI: 000055768e2021d0 RDI: 0000000000000005
[  369.628569] RBP: 00007f43c8197f00 R08: 0000000000000011 R09: 00007f43c8198700
[  369.630208] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff845e6afe
[  369.632240] R13: 00007fff845e6aff R14: 00007f43c8197fc0 R15: 00007f43c8198700

This patch replaces skb_recv_datagram() with an open-coded variant of it
releasing the socket lock before the __skb_wait_for_more_packets() call
and re-acquiring it after such call in order that other functions that
need socket lock could be executed.

what's more, the socket lock will be released only when recvmsg() will
block and that should produce nicer overall behavior.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reported-by: Thomas Habets <thomas@@habets.se>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 5fff027f25fa..a1f4cb836fcf 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1653,9 +1653,12 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags)
 {
 	struct sock *sk = sock->sk;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *last;
+	struct sk_buff_head *sk_queue;
 	int copied;
 	int err = 0;
+	int off = 0;
+	long timeo;
 
 	lock_sock(sk);
 	/*
@@ -1667,11 +1670,29 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		goto out;
 	}
 
-	/* Now we can treat all alike */
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &err);
-	if (skb == NULL)
-		goto out;
+	/*  We need support for non-blocking reads. */
+	sk_queue = &sk->sk_receive_queue;
+	skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off, &err, &last);
+	/* If no packet is available, release_sock(sk) and try again. */
+	if (!skb) {
+		if (err != -EAGAIN)
+			goto out;
+		release_sock(sk);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+		while (timeo && !__skb_wait_for_more_packets(sk, sk_queue, &err,
+							     &timeo, last)) {
+			skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off,
+						      &err, &last);
+			if (skb)
+				break;
+
+			if (err != -EAGAIN)
+				goto done;
+		}
+		if (!skb)
+			goto done;
+		lock_sock(sk);
+	}
 
 	if (!sk_to_ax25(sk)->pidincl)
 		skb_pull(skb, 1);		/* Remove PID */
@@ -1718,6 +1739,7 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 out:
 	release_sock(sk);
 
+done:
 	return err;
 }
 
-- 
2.35.1



