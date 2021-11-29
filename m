Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F39461EB3
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379128AbhK2SjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:39:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40312 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379036AbhK2ShY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:37:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77A3DB815CF;
        Mon, 29 Nov 2021 18:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC17C53FAD;
        Mon, 29 Nov 2021 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210844;
        bh=8njxurF9jXU5xJ7shnIue9+5g91D2ScALZbIWMo76Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVo0FtMQ0h0ESjnd2YBpCqHrjHsV+F3y/MV0UaWt9X+leM1bx3ahJWdt6PxrkYZXt
         5HfduNZEnYXOlCJ0vCSFCH0+bDeIJgQsYSeKqDBf3kVeYtMI+cIcQfuJl287oShQUg
         CcskFUQTOCdgakvq20cpWK3lTAjSph1IebrLvhlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 015/179] net: nexthop: fix null pointer dereference when IPv6 is not enabled
Date:   Mon, 29 Nov 2021 19:16:49 +0100
Message-Id: <20211129181719.448141973@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit 1c743127cc54b112b155f434756bd4b5fa565a99 upstream.

When we try to add an IPv6 nexthop and IPv6 is not enabled
(!CONFIG_IPV6) we'll hit a NULL pointer dereference[1] in the error path
of nh_create_ipv6() due to calling ipv6_stub->fib6_nh_release. The bug
has been present since the beginning of IPv6 nexthop gateway support.
Commit 1aefd3de7bc6 ("ipv6: Add fib6_nh_init and release to stubs") tells
us that only fib6_nh_init has a dummy stub because fib6_nh_release should
not be called if fib6_nh_init returns an error, but the commit below added
a call to ipv6_stub->fib6_nh_release in its error path. To fix it return
the dummy stub's -EAFNOSUPPORT error directly without calling
ipv6_stub->fib6_nh_release in nh_create_ipv6()'s error path.

[1]
 Output is a bit truncated, but it clearly shows the error.
 BUG: kernel NULL pointer dereference, address: 000000000000000000
 #PF: supervisor instruction fetch in kernel modede
 #PF: error_code(0x0010) - not-present pagege
 PGD 0 P4D 0
 Oops: 0010 [#1] PREEMPT SMP NOPTI
 CPU: 4 PID: 638 Comm: ip Kdump: loaded Not tainted 5.16.0-rc1+ #446
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
 RIP: 0010:0x0
 Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
 RSP: 0018:ffff888109f5b8f0 EFLAGS: 00010286^Ac
 RAX: 0000000000000000 RBX: ffff888109f5ba28 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881008a2860
 RBP: ffff888109f5b9d8 R08: 0000000000000000 R09: 0000000000000000
 R10: ffff888109f5b978 R11: ffff888109f5b948 R12: 00000000ffffff9f
 R13: ffff8881008a2a80 R14: ffff8881008a2860 R15: ffff8881008a2840
 FS:  00007f98de70f100(0000) GS:ffff88822bf00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffffffffffd6 CR3: 0000000100efc000 CR4: 00000000000006e0
 Call Trace:
  <TASK>
  nh_create_ipv6+0xed/0x10c
  rtm_new_nexthop+0x6d7/0x13f3
  ? check_preemption_disabled+0x3d/0xf2
  ? lock_is_held_type+0xbe/0xfd
  rtnetlink_rcv_msg+0x23f/0x26a
  ? check_preemption_disabled+0x3d/0xf2
  ? rtnl_calcit.isra.0+0x147/0x147
  netlink_rcv_skb+0x61/0xb2
  netlink_unicast+0x100/0x187
  netlink_sendmsg+0x37f/0x3a0
  ? netlink_unicast+0x187/0x187
  sock_sendmsg_nosec+0x67/0x9b
  ____sys_sendmsg+0x19d/0x1f9
  ? copy_msghdr_from_user+0x4c/0x5e
  ? rcu_read_lock_any_held+0x2a/0x78
  ___sys_sendmsg+0x6c/0x8c
  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
  ? lockdep_hardirqs_on+0xd9/0x102
  ? sockfd_lookup_light+0x69/0x99
  __sys_sendmsg+0x50/0x6e
  do_syscall_64+0xcb/0xf2
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f98dea28914
 Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 48 8d 05 e9 5d 0c 00 8b 00 85 c0 75 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 41 89 d4 55 48 89 f5 53
 RSP: 002b:00007fff859f5e68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e2e
 RAX: ffffffffffffffda RBX: 00000000619cb810 RCX: 00007f98dea28914
 RDX: 0000000000000000 RSI: 00007fff859f5ed0 RDI: 0000000000000003
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000008
 R10: fffffffffffffce6 R11: 0000000000000246 R12: 0000000000000001
 R13: 000055c0097ae520 R14: 000055c0097957fd R15: 00007fff859f63a0
 </TASK>
 Modules linked in: bridge stp llc bonding virtio_net

Cc: stable@vger.kernel.org
Fixes: 53010f991a9f ("nexthop: Add support for IPv6 gateways")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2544,11 +2544,15 @@ static int nh_create_ipv6(struct net *ne
 	/* sets nh_dev if successful */
 	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
 				      extack);
-	if (err)
+	if (err) {
+		/* IPv6 is not enabled, don't call fib6_nh_release */
+		if (err == -EAFNOSUPPORT)
+			goto out;
 		ipv6_stub->fib6_nh_release(fib6_nh);
-	else
+	} else {
 		nh->nh_flags = fib6_nh->fib_nh_flags;
-
+	}
+out:
 	return err;
 }
 


