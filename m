Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22860FDC1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbiJ0Q6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbiJ0Q6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D229F17536F
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 842AAB826F9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC819C433D6;
        Thu, 27 Oct 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889920;
        bh=Kl7yxqcZC4HNypVMkazIIYvR/JBA0T2AZP3qPpGhXtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSFKcoR/wI29rZ/c27jYuzDdbjL7HEBgtB8AJXyHMKqulDShDI3I1NJvCdHz/R3IU
         kYs5q/gQDzb5MeyR5LbBdymQW1N7B1BzMAiJPeUolPBmP6EtS0nvXPc7ebSUHrEd/8
         qpAV75SYas5dtbS+HtvkqgHWFda0pbyMJ8iOKJC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 48/94] skmsg: pass gfp argument to alloc_sk_msg()
Date:   Thu, 27 Oct 2022 18:54:50 +0200
Message-Id: <20221027165059.088053486@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2d1f274b95c6e4ba6a813b3b8e7a1a38d54a0a08 ]

syzbot found that alloc_sk_msg() could be called from a
non sleepable context. sk_psock_verdict_recv() uses
rcu_read_lock() protection.

We need the callers to pass a gfp_t argument to avoid issues.

syzbot report was:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3613, name: syz-executor414
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
CPU: 0 PID: 3613 Comm: syz-executor414 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
__might_resched+0x538/0x6a0 kernel/sched/core.c:9877
might_alloc include/linux/sched/mm.h:274 [inline]
slab_pre_alloc_hook mm/slab.h:700 [inline]
slab_alloc_node mm/slub.c:3162 [inline]
slab_alloc mm/slub.c:3256 [inline]
kmem_cache_alloc_trace+0x59/0x310 mm/slub.c:3287
kmalloc include/linux/slab.h:600 [inline]
kzalloc include/linux/slab.h:733 [inline]
alloc_sk_msg net/core/skmsg.c:507 [inline]
sk_psock_skb_ingress_self+0x5c/0x330 net/core/skmsg.c:600
sk_psock_verdict_apply+0x395/0x440 net/core/skmsg.c:1014
sk_psock_verdict_recv+0x34d/0x560 net/core/skmsg.c:1201
tcp_read_skb+0x4a1/0x790 net/ipv4/tcp.c:1770
tcp_rcv_established+0x129d/0x1a10 net/ipv4/tcp_input.c:5971
tcp_v4_do_rcv+0x479/0xac0 net/ipv4/tcp_ipv4.c:1681
sk_backlog_rcv include/net/sock.h:1109 [inline]
__release_sock+0x1d8/0x4c0 net/core/sock.c:2906
release_sock+0x5d/0x1c0 net/core/sock.c:3462
tcp_sendmsg+0x36/0x40 net/ipv4/tcp.c:1483
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
__sys_sendto+0x46d/0x5f0 net/socket.c:2117
__do_sys_sendto net/socket.c:2129 [inline]
__se_sys_sendto net/socket.c:2125 [inline]
__x64_sys_sendto+0xda/0xf0 net/socket.c:2125
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 43312915b5ba ("skmsg: Get rid of unncessary memset()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ca70525621c7..1efdc47a999b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -500,11 +500,11 @@ bool sk_msg_is_readable(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sk_msg_is_readable);
 
-static struct sk_msg *alloc_sk_msg(void)
+static struct sk_msg *alloc_sk_msg(gfp_t gfp)
 {
 	struct sk_msg *msg;
 
-	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
+	msg = kzalloc(sizeof(*msg), gfp | __GFP_NOWARN);
 	if (unlikely(!msg))
 		return NULL;
 	sg_init_marker(msg->sg.data, NR_MSG_FRAG_IDS);
@@ -520,7 +520,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 	if (!sk_rmem_schedule(sk, skb, skb->truesize))
 		return NULL;
 
-	return alloc_sk_msg();
+	return alloc_sk_msg(GFP_KERNEL);
 }
 
 static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
@@ -597,7 +597,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb,
 static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
 				     u32 off, u32 len)
 {
-	struct sk_msg *msg = alloc_sk_msg();
+	struct sk_msg *msg = alloc_sk_msg(GFP_ATOMIC);
 	struct sock *sk = psock->sk;
 	int err;
 
-- 
2.35.1



