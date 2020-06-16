Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81A11FBAD6
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgFPPmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731623AbgFPPmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:42:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AA80214DB;
        Tue, 16 Jun 2020 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322128;
        bh=iI/BZKi97QLx0JPtrtFK7ox1FG7npbhQVMDwhtTaRYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeWOlSO8zPXAeJgKIbdUgI16cio2151cOlDmhnKgi1q2xKzFrMtYIX5oQNN5TnU8Y
         bbXJKY8VRhlWLpoiDFEwoo1cb8UJkDs/oESM2qIie5GkEwFw2OU8BVAucvBIskWDUN
         EoR1/4nPr+Y4cxXjtDyryAUXTlo5lY7ETcrwfLOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com,
        Jon Maloy <jmaloy@redhat.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 012/163] tipc: fix NULL pointer dereference in streaming
Date:   Tue, 16 Jun 2020 17:33:06 +0200
Message-Id: <20200616153107.461137968@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 5e9eeccc58f3e6bcc99b929670665d2ce047e9c9 ]

syzbot found the following crash:

general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
CPU: 1 PID: 7060 Comm: syz-executor394 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__tipc_sendstream+0xbde/0x11f0 net/tipc/socket.c:1591
Code: 00 00 00 00 48 39 5c 24 28 48 0f 44 d8 e8 fa 3e db f9 48 b8 00 00 00 00 00 fc ff df 48 8d bb c8 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e2 04 00 00 48 8b 9b c8 00 00 00 48 b8 00 00 00
RSP: 0018:ffffc90003ef7818 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8797fd9d
RDX: 0000000000000019 RSI: ffffffff8797fde6 RDI: 00000000000000c8
RBP: ffff888099848040 R08: ffff88809a5f6440 R09: fffffbfff1860b4c
R10: ffffffff8c305a5f R11: fffffbfff1860b4b R12: ffff88809984857e
R13: 0000000000000000 R14: ffff888086aa4000 R15: 0000000000000000
FS:  00000000009b4880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 00000000a7fdf000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tipc_sendstream+0x4c/0x70 net/tipc/socket.c:1533
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x32f/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440199
...

This bug was bisected to commit 0a3e060f340d ("tipc: add test for Nagle
algorithm effectiveness"). However, it is not the case, the trouble was
from the base in the case of zero data length message sending, we would
unexpectedly make an empty 'txq' queue after the 'tipc_msg_append()' in
Nagle mode.

A similar crash can be generated even without the bisected patch but at
the link layer when it accesses the empty queue.

We solve the issues by building at least one buffer to go with socket's
header and an optional data section that may be empty like what we had
with the 'tipc_msg_build()'.

Note: the previous commit 4c21daae3dbc ("tipc: Fix NULL pointer
dereference in __tipc_sendstream()") is obsoleted by this one since the
'txq' will be never empty and the check of 'skb != NULL' is unnecessary
but it is safe anyway.

Reported-by: syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com
Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/msg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -221,7 +221,7 @@ int tipc_msg_append(struct tipc_msg *_hd
 	accounted = skb ? msg_blocks(buf_msg(skb)) : 0;
 	total = accounted;
 
-	while (rem) {
+	do {
 		if (!skb || skb->len >= mss) {
 			prev = skb;
 			skb = tipc_buf_acquire(mss, GFP_KERNEL);
@@ -249,7 +249,7 @@ int tipc_msg_append(struct tipc_msg *_hd
 		skb_put(skb, cpy);
 		rem -= cpy;
 		total += msg_blocks(hdr) - curr;
-	}
+	} while (rem);
 	return total - accounted;
 }
 


