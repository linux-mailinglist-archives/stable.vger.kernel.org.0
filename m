Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44666A4CED
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 22:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjB0VQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 16:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB0VQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 16:16:04 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376A8241E5
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 13:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677532563; x=1709068563;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UoqAJH4+tuJ7jK/zWUubEaMmGNJ+gpwlLHDVU9znQE0=;
  b=pglCxJhM1SQWjImCeehFqHisHL+ZmAmYhqI4Ghfw8Essz/u5ZtxBhFkE
   Q4JVAe19Sjana+6P2XrNgPxPVR3ls52PToHfIWI7wiDEPNX8cBKlItRtK
   iehN5ko7Yck0lYRH56FG54o1Wx/r8vukeVZeIMr9rFDJuefKuhfdCPlW2
   M=;
X-IronPort-AV: E=Sophos;i="5.98,220,1673913600"; 
   d="scan'208";a="297607080"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 21:16:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id A790040D4B;
        Mon, 27 Feb 2023 21:15:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 27 Feb 2023 21:15:58 +0000
Received: from 88665a182662.ant.amazon.com.com (10.88.170.65) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 27 Feb 2023 21:15:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5.15.y/5.10.y/5.4.y/4.19.y/4.14.y] net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().
Date:   Mon, 27 Feb 2023 13:15:48 -0800
Message-ID: <20230227211548.13923-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.88.170.65]
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
This can be applied on 5.15.95, 5.10.170, 5.4.233, 4.19.274, and 4.14.307.

When resolving a conflict with c59f02f84867 ("net: use WARN_ON_ONCE() in
sk_stream_kill_queues()"), I have changed WARN_ON_ONCE() to WARN_ON() to
keep consistency.
---
 net/caif/caif_socket.c | 1 +
 net/core/stream.c      | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index e12fd3cad619..997c4ebdce6f 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1020,6 +1020,7 @@ static void caif_sock_destructor(struct sock *sk)
 		return;
 	}
 	sk_stream_kill_queues(&cf_sk->sk);
+	WARN_ON(sk->sk_forward_alloc);
 	caif_free_client(&cf_sk->layer);
 }
 
diff --git a/net/core/stream.c b/net/core/stream.c
index d7c5413d16d5..cd60746877b1 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -209,7 +209,6 @@ void sk_stream_kill_queues(struct sock *sk)
 	sk_mem_reclaim(sk);
 
 	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket
-- 
2.38.1

