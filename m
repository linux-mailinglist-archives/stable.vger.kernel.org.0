Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653AE47AE13
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhLTO5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238632AbhLTOy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5EBC08EB50;
        Mon, 20 Dec 2021 06:47:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 483B4611A5;
        Mon, 20 Dec 2021 14:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32119C36AE7;
        Mon, 20 Dec 2021 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011677;
        bh=pLKsepRL80fZi/rO+8Dxa4NrVuYFe8uwO/gPI3MOjLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghoMn44/g+W8S0d6JfmyV8H3cn4aIVACg95tZfh6OB3sQtsRyEm8Z2SNPENksQy4I
         RImnoQQ5AoQVfx+3kmboaYzmKO/CbyFtpF+TRfPQ7+3a2Lsa8sire4tybOIs0bHByl
         vRdAhhtakAc32EQo4QjqbF72g2p+FlpdbMu0pREw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/99] inet_diag: fix kernel-infoleak for UDP sockets
Date:   Mon, 20 Dec 2021 15:34:07 +0100
Message-Id: <20211220143030.514155353@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 71ddeac8cd1d217744a0e060ff520e147c9328d1 ]

KMSAN reported a kernel-infoleak [1], that can exploited
by unpriv users.

After analysis it turned out UDP was not initializing
r->idiag_expires. Other users of inet_sk_diag_fill()
might make the same mistake in the future, so fix this
in inet_sk_diag_fill().

[1]
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in copyout lib/iov_iter.c:156 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x69d/0x25c0 lib/iov_iter.c:670
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 copyout lib/iov_iter.c:156 [inline]
 _copy_to_iter+0x69d/0x25c0 lib/iov_iter.c:670
 copy_to_iter include/linux/uio.h:155 [inline]
 simple_copy_to_iter+0xf3/0x140 net/core/datagram.c:519
 __skb_datagram_iter+0x2cb/0x1280 net/core/datagram.c:425
 skb_copy_datagram_iter+0xdc/0x270 net/core/datagram.c:533
 skb_copy_datagram_msg include/linux/skbuff.h:3657 [inline]
 netlink_recvmsg+0x660/0x1c60 net/netlink/af_netlink.c:1974
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1035
 call_read_iter include/linux/fs.h:2156 [inline]
 new_sync_read fs/read_write.c:400 [inline]
 vfs_read+0x1631/0x1980 fs/read_write.c:481
 ksys_read+0x28c/0x520 fs/read_write.c:619
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __x64_sys_read+0xdb/0x120 fs/read_write.c:627
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 netlink_dump+0x3d5/0x16a0 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0xd1c/0xee0 net/netlink/af_netlink.c:2370
 netlink_dump_start include/linux/netlink.h:254 [inline]
 inet_diag_handler_cmd+0x2e7/0x400 net/ipv4/inet_diag.c:1343
 sock_diag_rcv_msg+0x24a/0x620
 netlink_rcv_skb+0x447/0x800 net/netlink/af_netlink.c:2491
 sock_diag_rcv+0x63/0x80 net/core/sock_diag.c:276
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x1095/0x1360 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x16f3/0x1870 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_write_iter+0x594/0x690 net/socket.c:1057
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_write+0x52c/0x1500 fs/read_write.c:851
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x63f/0xe30 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Bytes 68-71 of 312 are uninitialized
Memory access of size 312 starts at ffff88812ab54000
Data copied to user address 0000000020001440

CPU: 1 PID: 6365 Comm: syz-executor801 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 3c4d05c80567 ("inet_diag: Introduce the inet socket dumping routine")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20211209185058.53917-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_diag.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 93474b1bea4e0..fa9f1de58df46 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -261,6 +261,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	r->idiag_state = sk->sk_state;
 	r->idiag_timer = 0;
 	r->idiag_retrans = 0;
+	r->idiag_expires = 0;
 
 	if (inet_diag_msg_attrs_fill(sk, skb, r, ext,
 				     sk_user_ns(NETLINK_CB(cb->skb).sk),
@@ -314,9 +315,6 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		r->idiag_retrans = icsk->icsk_probes_out;
 		r->idiag_expires =
 			jiffies_delta_to_msecs(sk->sk_timer.expires - jiffies);
-	} else {
-		r->idiag_timer = 0;
-		r->idiag_expires = 0;
 	}
 
 	if ((ext & (1 << (INET_DIAG_INFO - 1))) && handler->idiag_info_size) {
-- 
2.33.0



