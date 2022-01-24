Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6E849896E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344267AbiAXS4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343701AbiAXSyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEFCC0613EF;
        Mon, 24 Jan 2022 10:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C27A614F4;
        Mon, 24 Jan 2022 18:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D077C340E5;
        Mon, 24 Jan 2022 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050395;
        bh=63F1nd3KDMNKL6yqbHKJOnOSr+qJ79dax9b58eVEicc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6VEFixOBZlhqrxUpNdH2awppm1YTJb3pcZdC/p7QpQSDy/Lqz1Bdeoi0hHdcdNlC
         Bp1GZuBtFFLKaVVUGuO5GQJtz4sz9L9NJ4bHz70XHwaPDI/J1LrSioEiAInzwBxmRQ
         VhzgPXgKRsqNdflw5+bFhJzdTHAqJ2QQFzGFt+94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 104/114] af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
Date:   Mon, 24 Jan 2022 19:43:19 +0100
Message-Id: <20220124183930.320576074@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 9d6d7f1cb67cdee15f1a0e85aacfb924e0e02435 upstream.

wait_for_unix_gc() reads unix_tot_inflight & gc_in_progress
without synchronization.

Adds READ_ONCE()/WRITE_ONCE() and their associated comments
to better document the intent.

BUG: KCSAN: data-race in unix_inflight / wait_for_unix_gc

write to 0xffffffff86e2b7c0 of 4 bytes by task 9380 on cpu 0:
 unix_inflight+0x1e8/0x260 net/unix/scm.c:63
 unix_attach_fds+0x10c/0x1e0 net/unix/scm.c:121
 unix_scm_to_skb net/unix/af_unix.c:1674 [inline]
 unix_dgram_sendmsg+0x679/0x16b0 net/unix/af_unix.c:1817
 unix_seqpacket_sendmsg+0xcc/0x110 net/unix/af_unix.c:2258
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffffffff86e2b7c0 of 4 bytes by task 9375 on cpu 1:
 wait_for_unix_gc+0x24/0x160 net/unix/garbage.c:196
 unix_dgram_sendmsg+0x8e/0x16b0 net/unix/af_unix.c:1772
 unix_seqpacket_sendmsg+0xcc/0x110 net/unix/af_unix.c:2258
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000002 -> 0x00000004

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 9375 Comm: syz-executor.1 Not tainted 5.16.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 9915672d4127 ("af_unix: limit unix_tot_inflight")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220114164328.2038499-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/garbage.c |   14 +++++++++++---
 net/unix/scm.c     |    6 ++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -197,8 +197,11 @@ void wait_for_unix_gc(void)
 {
 	/* If number of inflight sockets is insane,
 	 * force a garbage collect right now.
+	 * Paired with the WRITE_ONCE() in unix_inflight(),
+	 * unix_notinflight() and gc_in_progress().
 	 */
-	if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
+	if (READ_ONCE(unix_tot_inflight) > UNIX_INFLIGHT_TRIGGER_GC &&
+	    !READ_ONCE(gc_in_progress))
 		unix_gc();
 	wait_event(unix_gc_wait, gc_in_progress == false);
 }
@@ -218,7 +221,9 @@ void unix_gc(void)
 	if (gc_in_progress)
 		goto out;
 
-	gc_in_progress = true;
+	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
+	WRITE_ONCE(gc_in_progress, true);
+
 	/* First, select candidates for garbage collection.  Only
 	 * in-flight sockets are considered, and from those only ones
 	 * which don't have any external reference.
@@ -304,7 +309,10 @@ void unix_gc(void)
 
 	/* All candidates should have been detached by now. */
 	BUG_ON(!list_empty(&gc_candidates));
-	gc_in_progress = false;
+
+	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
+	WRITE_ONCE(gc_in_progress, false);
+
 	wake_up(&unix_gc_wait);
 
  out:
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -56,7 +56,8 @@ void unix_inflight(struct user_struct *u
 		} else {
 			BUG_ON(list_empty(&u->link));
 		}
-		unix_tot_inflight++;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
 	}
 	user->unix_inflight++;
 	spin_unlock(&unix_gc_lock);
@@ -76,7 +77,8 @@ void unix_notinflight(struct user_struct
 
 		if (atomic_long_dec_and_test(&u->inflight))
 			list_del_init(&u->link);
-		unix_tot_inflight--;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
 	}
 	user->unix_inflight--;
 	spin_unlock(&unix_gc_lock);


