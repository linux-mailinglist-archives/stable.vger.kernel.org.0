Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2D56045FF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiJSMyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiJSMyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:54:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1184D253;
        Wed, 19 Oct 2022 05:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8793EB82396;
        Wed, 19 Oct 2022 08:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E7DC433D6;
        Wed, 19 Oct 2022 08:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169603;
        bh=b4hXYuJD7zXZ+MCKsBqyfRKwm0ck2hRfWHoN4eDxoIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyiRtPJXKoM3XfBhqHjxuQq86v7CCe1YmAaEZX/5/2ntWMvUsA8hmB7V0H0UcXV17
         8xM+aOlfsv40yZgehsaWTvJgn+Mb+bH2FRwIIhHjn+B3GL08zNz0DSi0N+xY/4N6jc
         qXJcvkFrITkzogjmLKJyJIiiOuNk2kF/OJszifdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 337/862] af_unix: Fix memory leaks of the whole sk due to OOB skb.
Date:   Wed, 19 Oct 2022 10:27:04 +0200
Message-Id: <20221019083304.951615244@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 7a62ed61367b8fd01bae1e18e30602c25060d824 ]

syzbot reported a sequence of memory leaks, and one of them indicated we
failed to free a whole sk:

  unreferenced object 0xffff8880126e0000 (size 1088):
    comm "syz-executor419", pid 326, jiffies 4294773607 (age 12.609s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 7d 00 00 00 00 00 00 00  ........}.......
      01 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
    backtrace:
      [<000000006fefe750>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:1970
      [<0000000074006db5>] sk_alloc+0x3b/0x800 net/core/sock.c:2029
      [<00000000728cd434>] unix_create1+0xaf/0x920 net/unix/af_unix.c:928
      [<00000000a279a139>] unix_create+0x113/0x1d0 net/unix/af_unix.c:997
      [<0000000068259812>] __sock_create+0x2ab/0x550 net/socket.c:1516
      [<00000000da1521e1>] sock_create net/socket.c:1566 [inline]
      [<00000000da1521e1>] __sys_socketpair+0x1a8/0x550 net/socket.c:1698
      [<000000007ab259e1>] __do_sys_socketpair net/socket.c:1751 [inline]
      [<000000007ab259e1>] __se_sys_socketpair net/socket.c:1748 [inline]
      [<000000007ab259e1>] __x64_sys_socketpair+0x97/0x100 net/socket.c:1748
      [<000000007dedddc1>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
      [<000000007dedddc1>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
      [<000000009456679f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

We can reproduce this issue by creating two AF_UNIX SOCK_STREAM sockets,
send()ing an OOB skb to each other, and close()ing them without consuming
the OOB skbs.

  int skpair[2];

  socketpair(AF_UNIX, SOCK_STREAM, 0, skpair);

  send(skpair[0], "x", 1, MSG_OOB);
  send(skpair[1], "x", 1, MSG_OOB);

  close(skpair[0]);
  close(skpair[1]);

Currently, we free an OOB skb in unix_sock_destructor() which is called via
__sk_free(), but it's too late because the receiver's unix_sk(sk)->oob_skb
is accounted against the sender's sk->sk_wmem_alloc and __sk_free() is
called only when sk->sk_wmem_alloc is 0.

In the repro sequences, we do not consume the OOB skb, so both two sk's
sock_put() never reach __sk_free() due to the positive sk->sk_wmem_alloc.
Then, no one can consume the OOB skb nor call __sk_free(), and we finally
leak the two whole sk.

Thus, we must free the unconsumed OOB skb earlier when close()ing the
socket.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index bf338b782fc4..d686804119c9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -569,12 +569,6 @@ static void unix_sock_destructor(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 
-#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-	if (u->oob_skb) {
-		kfree_skb(u->oob_skb);
-		u->oob_skb = NULL;
-	}
-#endif
 	DEBUG_NET_WARN_ON_ONCE(refcount_read(&sk->sk_wmem_alloc));
 	DEBUG_NET_WARN_ON_ONCE(!sk_unhashed(sk));
 	DEBUG_NET_WARN_ON_ONCE(sk->sk_socket);
@@ -620,6 +614,13 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 	unix_state_unlock(sk);
 
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (u->oob_skb) {
+		kfree_skb(u->oob_skb);
+		u->oob_skb = NULL;
+	}
+#endif
+
 	wake_up_interruptible_all(&u->peer_wait);
 
 	if (skpair != NULL) {
-- 
2.35.1



