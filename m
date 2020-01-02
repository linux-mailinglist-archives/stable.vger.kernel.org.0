Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5163A12ED33
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgABWZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:25:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729334AbgABWZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:25:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367FB20863;
        Thu,  2 Jan 2020 22:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003951;
        bh=b/KwFZ07DpEj6OWIHnQKcIq3IybnsxcbJgAuNQzc85w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxXIMJaLJtmljSwFOfyBMxErelpLwQFdicJ/W4j1ZJHel37czvIRT8u33fKhMUcQL
         /NS3Wa4p9tm/+VFP+d0SEcUeREsPjCQ5TxxbhvkYP1bHgvC2O/kbfNoudMVMyhEHRg
         fVx6V4JfNOVVEpuT8dfJgF25GwJxEnV3GNTyHQBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 68/91] net: add a READ_ONCE() in skb_peek_tail()
Date:   Thu,  2 Jan 2020 23:07:50 +0100
Message-Id: <20200102220444.875000284@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit f8cc62ca3e660ae3fdaee533b1d554297cd2ae82 upstream.

skb_peek_tail() can be used without protection of a lock,
as spotted by KCSAN [1]

In order to avoid load-stearing, add a READ_ONCE()

Note that the corresponding WRITE_ONCE() are already there.

[1]
BUG: KCSAN: data-race in sk_wait_data / skb_queue_tail

read to 0xffff8880b36a4118 of 8 bytes by task 20426 on cpu 1:
 skb_peek_tail include/linux/skbuff.h:1784 [inline]
 sk_wait_data+0x15b/0x250 net/core/sock.c:2477
 kcm_wait_data+0x112/0x1f0 net/kcm/kcmsock.c:1103
 kcm_recvmsg+0xac/0x320 net/kcm/kcmsock.c:1130
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 ___sys_recvmsg+0x1a0/0x3e0 net/socket.c:2480
 do_recvmmsg+0x19a/0x5c0 net/socket.c:2601
 __sys_recvmmsg+0x1ef/0x200 net/socket.c:2680
 __do_sys_recvmmsg net/socket.c:2703 [inline]
 __se_sys_recvmmsg net/socket.c:2696 [inline]
 __x64_sys_recvmmsg+0x89/0xb0 net/socket.c:2696
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880b36a4118 of 8 bytes by task 451 on cpu 0:
 __skb_insert include/linux/skbuff.h:1852 [inline]
 __skb_queue_before include/linux/skbuff.h:1958 [inline]
 __skb_queue_tail include/linux/skbuff.h:1991 [inline]
 skb_queue_tail+0x7e/0xc0 net/core/skbuff.c:3145
 kcm_queue_rcv_skb+0x202/0x310 net/kcm/kcmsock.c:206
 kcm_rcv_strparser+0x74/0x4b0 net/kcm/kcmsock.c:370
 __strp_recv+0x348/0xf50 net/strparser/strparser.c:309
 strp_recv+0x84/0xa0 net/strparser/strparser.c:343
 tcp_read_sock+0x174/0x5c0 net/ipv4/tcp.c:1639
 strp_read_sock+0xd4/0x140 net/strparser/strparser.c:366
 do_strp_work net/strparser/strparser.c:414 [inline]
 strp_work+0x9a/0xe0 net/strparser/strparser.c:423
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 451 Comm: kworker/u4:3 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: kstrp strp_work

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/skbuff.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1655,7 +1655,7 @@ static inline struct sk_buff *skb_peek_n
  */
 static inline struct sk_buff *skb_peek_tail(const struct sk_buff_head *list_)
 {
-	struct sk_buff *skb = list_->prev;
+	struct sk_buff *skb = READ_ONCE(list_->prev);
 
 	if (skb == (struct sk_buff *)list_)
 		skb = NULL;
@@ -1723,7 +1723,9 @@ static inline void __skb_insert(struct s
 				struct sk_buff *prev, struct sk_buff *next,
 				struct sk_buff_head *list)
 {
-	/* see skb_queue_empty_lockless() for the opposite READ_ONCE() */
+	/* See skb_queue_empty_lockless() and skb_peek_tail()
+	 * for the opposite READ_ONCE()
+	 */
 	WRITE_ONCE(newsk->next, next);
 	WRITE_ONCE(newsk->prev, prev);
 	WRITE_ONCE(next->prev, newsk);


