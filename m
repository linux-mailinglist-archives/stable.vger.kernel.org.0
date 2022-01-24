Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D0D49A9F1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323856AbiAYD3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446066AbiAXVGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9C8C0604FD;
        Mon, 24 Jan 2022 12:07:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AF32B810AF;
        Mon, 24 Jan 2022 20:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A00C340E5;
        Mon, 24 Jan 2022 20:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054827;
        bh=vaHrpZuT0SEiaCkxFuZmfH+VWUjcQY23cDzjyVIvb5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmjRCnDqMNKXHZHGGL9ys7GmDTC9HkXYWKDqZ49x43eubHlXnOgvNhUMS/vFyCULN
         7yeKMOW4rs133ln6QRERmFcGxddFsCQoTkkzHvj7/k2FVTSnnhAMWf1drMmFBMcXvW
         ynh0d51ccSE7NbL/Iwhm/DClP1be5zR7jfP8Ss8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 516/563] af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
Date:   Mon, 24 Jan 2022 19:44:41 +0100
Message-Id: <20220124184042.291857701@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -192,8 +192,11 @@ void wait_for_unix_gc(void)
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
@@ -213,7 +216,9 @@ void unix_gc(void)
 	if (gc_in_progress)
 		goto out;
 
-	gc_in_progress = true;
+	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
+	WRITE_ONCE(gc_in_progress, true);
+
 	/* First, select candidates for garbage collection.  Only
 	 * in-flight sockets are considered, and from those only ones
 	 * which don't have any external reference.
@@ -299,7 +304,10 @@ void unix_gc(void)
 
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
@@ -60,7 +60,8 @@ void unix_inflight(struct user_struct *u
 		} else {
 			BUG_ON(list_empty(&u->link));
 		}
-		unix_tot_inflight++;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
 	}
 	user->unix_inflight++;
 	spin_unlock(&unix_gc_lock);
@@ -80,7 +81,8 @@ void unix_notinflight(struct user_struct
 
 		if (atomic_long_dec_and_test(&u->inflight))
 			list_del_init(&u->link);
-		unix_tot_inflight--;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
 	}
 	user->unix_inflight--;
 	spin_unlock(&unix_gc_lock);


