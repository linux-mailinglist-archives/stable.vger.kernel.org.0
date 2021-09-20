Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E77C411B1D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhITQzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234184AbhITQxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FCE761354;
        Mon, 20 Sep 2021 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156617;
        bh=v2r22YBvxh0zpRCZOYUG91OOe0HyL2AOVDysnjfkIYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1yGcaAe9c2ExtsXHDcaDuobTUQqfrPYBknEXwYhTuMb9iwl/1t+sc0WsVfbTb8yx
         Fi+93qbf0XKX+loPjZrtjtA0plY1iX0NNir5t9zzfds3Y5ZEUZ1pk14V0LEFdYYXDD
         VjzYrnc3nLJ7mRHpiWtPiJUmvXGaZ9F5VrFxIeBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 125/133] net/af_unix: fix a data-race in unix_dgram_poll
Date:   Mon, 20 Sep 2021 18:43:23 +0200
Message-Id: <20210920163916.716424386@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 04f08eb44b5011493d77b602fdec29ff0f5c6cd5 upstream.

syzbot reported another data-race in af_unix [1]

Lets change __skb_insert() to use WRITE_ONCE() when changing
skb head qlen.

Also, change unix_dgram_poll() to use lockless version
of unix_recvq_full()

It is verry possible we can switch all/most unix_recvq_full()
to the lockless version, this will be done in a future kernel version.

[1] HEAD commit: 8596e589b787732c8346f0482919e83cc9362db1

BUG: KCSAN: data-race in skb_queue_tail / unix_dgram_poll

write to 0xffff88814eeb24e0 of 4 bytes by task 25815 on cpu 0:
 __skb_insert include/linux/skbuff.h:1938 [inline]
 __skb_queue_before include/linux/skbuff.h:2043 [inline]
 __skb_queue_tail include/linux/skbuff.h:2076 [inline]
 skb_queue_tail+0x80/0xa0 net/core/skbuff.c:3264
 unix_dgram_sendmsg+0xff2/0x1600 net/unix/af_unix.c:1850
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
 ___sys_sendmsg net/socket.c:2446 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2532
 __do_sys_sendmmsg net/socket.c:2561 [inline]
 __se_sys_sendmmsg net/socket.c:2558 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2558
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88814eeb24e0 of 4 bytes by task 25834 on cpu 1:
 skb_queue_len include/linux/skbuff.h:1869 [inline]
 unix_recvq_full net/unix/af_unix.c:194 [inline]
 unix_dgram_poll+0x2bc/0x3e0 net/unix/af_unix.c:2777
 sock_poll+0x23e/0x260 net/socket.c:1288
 vfs_poll include/linux/poll.h:90 [inline]
 ep_item_poll fs/eventpoll.c:846 [inline]
 ep_send_events fs/eventpoll.c:1683 [inline]
 ep_poll fs/eventpoll.c:1798 [inline]
 do_epoll_wait+0x6ad/0xf00 fs/eventpoll.c:2226
 __do_sys_epoll_wait fs/eventpoll.c:2238 [inline]
 __se_sys_epoll_wait fs/eventpoll.c:2233 [inline]
 __x64_sys_epoll_wait+0xf6/0x120 fs/eventpoll.c:2233
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000001b -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 25834 Comm: syz-executor.1 Tainted: G        W         5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 86b18aaa2b5b ("skbuff: fix a data race in skb_queue_len()")
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    2 +-
 net/unix/af_unix.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1502,7 +1502,7 @@ static inline void __skb_insert(struct s
 	newsk->next = next;
 	newsk->prev = prev;
 	next->prev  = prev->next = newsk;
-	list->qlen++;
+	WRITE_ONCE(list->qlen, list->qlen + 1);
 }
 
 static inline void __skb_queue_splice(const struct sk_buff_head *list,
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2700,7 +2700,7 @@ static unsigned int unix_dgram_poll(stru
 
 		other = unix_peer(sk);
 		if (other && unix_peer(other) != sk &&
-		    unix_recvq_full(other) &&
+		    unix_recvq_full_lockless(other) &&
 		    unix_dgram_peer_wake_me(sk, other))
 			writable = 0;
 


