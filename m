Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81784266127
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgIKO0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgIKNMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B992D2245F;
        Fri, 11 Sep 2020 13:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829233;
        bh=9FMYo2bufVujsHw85HNr708jaQ3F376AuTAIpj9bjuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNWME/k1O/d7VwmZGjF8r4hGgwpjLbu41LG+SFXxc5JnKEBJr/UPOjx7v2knLvZv7
         5LLL09ilmh5MaHgEdOfJniDWbjCTp7TtqCKv2/DDFI3XWIP4DGpnjg01ZeGM3YKM7E
         +w2qi1kLWm1PkdjBPnBBBUpsKwK2U0aVKYKNF1ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 1/8] ipv4: Silence suspicious RCU usage warning
Date:   Fri, 11 Sep 2020 14:54:39 +0200
Message-Id: <20200911125420.653876365@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911125420.580564179@linuxfoundation.org>
References: <20200911125420.580564179@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 7f6f32bb7d3355cd78ebf1dece9a6ea7a0ca8158 ]

fib_info_notify_update() is always called with RTNL held, but not from
an RCU read-side critical section. This leads to the following warning
[1] when the FIB table list is traversed with
hlist_for_each_entry_rcu(), but without a proper lockdep expression.

Since modification of the list is protected by RTNL, silence the warning
by adding a lockdep expression which verifies RTNL is held.

[1]
 =============================
 WARNING: suspicious RCU usage
 5.9.0-rc1-custom-14233-g2f26e122d62f #129 Not tainted
 -----------------------------
 net/ipv4/fib_trie.c:2124 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by ip/834:
  #0: ffffffff85a3b6b0 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x49a/0xbd0

 stack backtrace:
 CPU: 0 PID: 834 Comm: ip Not tainted 5.9.0-rc1-custom-14233-g2f26e122d62f #129
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
 Call Trace:
  dump_stack+0x100/0x184
  lockdep_rcu_suspicious+0x143/0x14d
  fib_info_notify_update+0x8d1/0xa60
  __nexthop_replace_notify+0xd2/0x290
  rtm_new_nexthop+0x35e2/0x5946
  rtnetlink_rcv_msg+0x4f7/0xbd0
  netlink_rcv_skb+0x17a/0x480
  rtnetlink_rcv+0x22/0x30
  netlink_unicast+0x5ae/0x890
  netlink_sendmsg+0x98a/0xf40
  ____sys_sendmsg+0x879/0xa00
  ___sys_sendmsg+0x122/0x190
  __sys_sendmsg+0x103/0x1d0
  __x64_sys_sendmsg+0x7d/0xb0
  do_syscall_64+0x32/0x50
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fde28c3be57
 Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51
c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
RSP: 002b:00007ffc09330028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fde28c3be57
RDX: 0000000000000000 RSI: 00007ffc09330090 RDI: 0000000000000003
RBP: 000000005f45f911 R08: 0000000000000001 R09: 00007ffc0933012c
R10: 0000000000000076 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffc09330290 R14: 00007ffc09330eee R15: 00005610e48ed020

Fixes: 1bff1a0c9bbd ("ipv4: Add function to send route updates")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2010,7 +2010,8 @@ void fib_info_notify_update(struct net *
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
 		struct fib_table *tb;
 
-		hlist_for_each_entry_rcu(tb, head, tb_hlist)
+		hlist_for_each_entry_rcu(tb, head, tb_hlist,
+					 lockdep_rtnl_is_held())
 			__fib_info_notify_update(net, tb, info);
 	}
 }


