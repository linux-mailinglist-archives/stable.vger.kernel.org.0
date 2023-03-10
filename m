Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DB26B40C7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCJNqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjCJNqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:46:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9497B862C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:46:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61F19B822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9408DC433D2;
        Fri, 10 Mar 2023 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455960;
        bh=c7ot3sSdNOVopSt2DM91FXrJbCi58aqgp1H+xfDdGBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8oacZbuT9hbn3bmIPrBkir3WK0HtzuddhGysXkErcujrFj4I0ojTdgyGyGhWh/H6
         5N5H3Qj4kV5z71cYQwgwhe8DuQ0IQklO14Wl9W/BVm4fTJ9OYj3ue2bydNuUOtBGXN
         VoU0TOAh4v48MbWdHnS0qDrZofooTNqgbaAQ172U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Christoph Paasch <christophpaasch@icloud.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 004/193] net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().
Date:   Fri, 10 Mar 2023 14:36:26 +0100
Message-Id: <20230310133711.067469182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 62ec33b44e0f7168ff2886520fec6fb62d03b5a3 upstream.

Christoph Paasch reported that commit b5fc29233d28 ("inet6: Remove
inet6_destroy_sock() in sk->sk_prot->destroy().") started triggering
WARN_ON_ONCE(sk->sk_forward_alloc) in sk_stream_kill_queues().  [0 - 2]
Also, we can reproduce it by a program in [3].

In the commit, we delay freeing ipv6_pinfo.pktoptions from sk->destroy()
to sk->sk_destruct(), so sk->sk_forward_alloc is no longer zero in
inet_csk_destroy_sock().

The same check has been in inet_sock_destruct() from at least v2.6,
we can just remove the WARN_ON_ONCE().  However, among the users of
sk_stream_kill_queues(), only CAIF is not calling inet_sock_destruct().
Thus, we add the same WARN_ON_ONCE() to caif_sock_destructor().

[0]: https://lore.kernel.org/netdev/39725AB4-88F1-41B3-B07F-949C5CAEFF4F@icloud.com/
[1]: https://github.com/multipath-tcp/mptcp_net-next/issues/341
[2]:
WARNING: CPU: 0 PID: 3232 at net/core/stream.c:212 sk_stream_kill_queues+0x2f9/0x3e0
Modules linked in:
CPU: 0 PID: 3232 Comm: syz-executor.0 Not tainted 6.2.0-rc5ab24eb4698afbe147b424149c529e2a43ec24eb5 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:sk_stream_kill_queues+0x2f9/0x3e0
Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ec 00 00 00 8b ab 08 01 00 00 e9 60 ff ff ff e8 d0 5f b6 fe 0f 0b eb 97 e8 c7 5f b6 fe <0f> 0b eb a0 e8 be 5f b6 fe 0f 0b e9 6a fe ff ff e8 02 07 e3 fe e9
RSP: 0018:ffff88810570fc68 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888101f38f40 RSI: ffffffff8285e529 RDI: 0000000000000005
RBP: 0000000000000ce0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000ce0 R11: 0000000000000001 R12: ffff8881009e9488
R13: ffffffff84af2cc0 R14: 0000000000000000 R15: ffff8881009e9458
FS:  00007f7fdfbd5800(0000) GS:ffff88811b600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32923000 CR3: 00000001062fc006 CR4: 0000000000170ef0
Call Trace:
 <TASK>
 inet_csk_destroy_sock+0x1a1/0x320
 __tcp_close+0xab6/0xe90
 tcp_close+0x30/0xc0
 inet_release+0xe9/0x1f0
 inet6_release+0x4c/0x70
 __sock_release+0xd2/0x280
 sock_close+0x15/0x20
 __fput+0x252/0xa20
 task_work_run+0x169/0x250
 exit_to_user_mode_prepare+0x113/0x120
 syscall_exit_to_user_mode+0x1d/0x40
 do_syscall_64+0x48/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f7fdf7ae28d
Code: c1 20 00 00 75 10 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ee fb ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 37 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00000000007dfbb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f7fdf7ae28d
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000007f338e0f R09: 0000000000000e0f
R10: 000000007f338e13 R11: 0000000000000293 R12: 00007f7fdefff000
R13: 00007f7fdefffcd8 R14: 00007f7fdefffce0 R15: 00007f7fdefffcd8
 </TASK>

[3]: https://lore.kernel.org/netdev/20230208004245.83497-1-kuniyu@amazon.com/

Fixes: b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Christoph Paasch <christophpaasch@icloud.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/caif/caif_socket.c |    1 +
 net/core/stream.c      |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1022,6 +1022,7 @@ static void caif_sock_destructor(struct
 		return;
 	}
 	sk_stream_kill_queues(&cf_sk->sk);
+	WARN_ON(sk->sk_forward_alloc);
 	caif_free_client(&cf_sk->layer);
 }
 
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -209,7 +209,6 @@ void sk_stream_kill_queues(struct sock *
 	sk_mem_reclaim(sk);
 
 	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket


