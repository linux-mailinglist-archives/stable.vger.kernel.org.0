Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A991566D36
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiGEMVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbiGEMRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D241838B;
        Tue,  5 Jul 2022 05:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFCE561985;
        Tue,  5 Jul 2022 12:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BFDC341C7;
        Tue,  5 Jul 2022 12:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023153;
        bh=q9bhnEFvIZsC21+a56GkhDC+EX25L8c5gcgtpFn5qyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdjKahtC75x246gMoVoXf0HP8WtnguLp6eYB/SEs7rUm0LdL5BgTnbfUJKI3lqynr
         Dkb94U6anvPG4DPGabbGqpzJZUwFtyriOUM2TCCBQGtepBYNp3VNqj1uX4HPKjEogL
         x12s0OK6F7LY1sgNo//Kqeq4EPtJqAVg/2sS9hUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 56/98] ipv6: fix lockdep splat in in6_dump_addrs()
Date:   Tue,  5 Jul 2022 13:58:14 +0200
Message-Id: <20220705115619.173684342@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 4e43e64d0f1332fcc503babad4dc31aead7131ca upstream.

As reported by syzbot, we should not use rcu_dereference()
when rcu_read_lock() is not held.

WARNING: suspicious RCU usage
5.19.0-rc2-syzkaller #0 Not tainted

net/ipv6/addrconf.c:5175 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor326/3617:
 #0: ffffffff8d5848e8 (rtnl_mutex){+.+.}-{3:3}, at: netlink_dump+0xae/0xc20 net/netlink/af_netlink.c:2223

stack backtrace:
CPU: 0 PID: 3617 Comm: syz-executor326 Not tainted 5.19.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 in6_dump_addrs+0x12d1/0x1790 net/ipv6/addrconf.c:5175
 inet6_dump_addr+0x9c1/0xb50 net/ipv6/addrconf.c:5300
 netlink_dump+0x541/0xc20 net/netlink/af_netlink.c:2275
 __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2380
 netlink_dump_start include/linux/netlink.h:245 [inline]
 rtnetlink_rcv_msg+0x73e/0xc90 net/core/rtnetlink.c:6046
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20220628121248.858695-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5166,9 +5166,9 @@ next:
 		fillargs->event = RTM_GETMULTICAST;
 
 		/* multicast address */
-		for (ifmca = rcu_dereference(idev->mc_list);
+		for (ifmca = rtnl_dereference(idev->mc_list);
 		     ifmca;
-		     ifmca = rcu_dereference(ifmca->next), ip_idx++) {
+		     ifmca = rtnl_dereference(ifmca->next), ip_idx++) {
 			if (ip_idx < s_ip_idx)
 				continue;
 			err = inet6_fill_ifmcaddr(skb, ifmca, fillargs);


