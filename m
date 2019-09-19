Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F9EB866E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392209AbfISW3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406532AbfISWRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 221C9217D6;
        Thu, 19 Sep 2019 22:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931468;
        bh=NFX9SeBlJI3kFLNjhMymOFTXGp/Qy3T/wRkNDUfJJrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CT56TTNE9XphFh0S2M23TgTUr6QgQBLf8BzBx+YdcJF3vc0Gwpayc6Xb4nIpdKh6a
         sDOUpMVU0Gs/IgDQfC09vZx3Ej/LIhfBuHE6lUXQ1YlmpRVSAjE6HrUNuLS3T406Dc
         7EM2LLOghmuAEpcl9NEgRsDcgJGnfqEJw+c4fIec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH 4.14 57/59] tcp: Reset send_head when removing skb from write-queue
Date:   Fri, 20 Sep 2019 00:04:12 +0200
Message-Id: <20190919214808.366745641@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>

syzkaller is not happy since commit fdfc5c8594c2 ("tcp: remove empty skb
from write queue in error cases"):

CPU: 1 PID: 13814 Comm: syz-executor.4 Not tainted 4.14.143 #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
task: ffff888040105c00 task.stack: ffff8880649c0000
RIP: 0010:tcp_sendmsg_locked+0x6b4/0x4390 net/ipv4/tcp.c:1350
RSP: 0018:ffff8880649cf718 EFLAGS: 00010206
RAX: 0000000000000014 RBX: 000000000000001e RCX: ffffc90000717000
RDX: 0000000000000077 RSI: ffffffff82e760f7 RDI: 00000000000000a0
RBP: ffff8880649cfaa8 R08: 1ffff1100c939e7a R09: ffff8880401063c8
R10: 0000000000000003 R11: 0000000000000001 R12: dffffc0000000000
R13: ffff888043d74750 R14: ffff888043d74500 R15: 000000000000001e
FS:  00007f0afcb6d700(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ca22000 CR3: 0000000040496004 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcp_sendmsg+0x2a/0x40 net/ipv4/tcp.c:1533
 inet_sendmsg+0x173/0x4e0 net/ipv4/af_inet.c:784
 sock_sendmsg_nosec net/socket.c:646 [inline]
 sock_sendmsg+0xc3/0x100 net/socket.c:656
 SYSC_sendto+0x35d/0x5e0 net/socket.c:1766
 do_syscall_64+0x241/0x680 arch/x86/entry/common.c:292
 entry_SYSCALL_64_after_hwframe+0x42/0xb7

The problem is that we are removing an skb from the write-queue that
could have been referenced by the sk_send_head. Thus, we need to check
for the send_head's sanity after removing it.

This patch needs to be backported only to 4.14 and older (among those
that applied the backport of fdfc5c8594c2).

Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cases")
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Vladimir Rutsky <rutsky@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -924,8 +924,7 @@ static void tcp_remove_empty_skb(struct
 {
 	if (skb && !skb->len) {
 		tcp_unlink_write_queue(skb, sk);
-		if (tcp_write_queue_empty(sk))
-			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
+		tcp_check_send_head(sk, skb);
 		sk_wmem_free_skb(sk, skb);
 	}
 }


