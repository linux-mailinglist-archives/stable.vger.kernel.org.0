Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AFB1390E
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfEDK0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbfEDK0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C307B20862;
        Sat,  4 May 2019 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965593;
        bh=avul0cnOxwjudBm5dCBZYO/64mJrQ9Rp6WK+ScGtFBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdgK3Iy6D+thmKQ8d1rKdAHUwNr0QDTJdxvs/zCaxDSOubAeU7IEZ97mmZfmEgq41
         fLi9o3hKIuy8PaG6yQfpEv1f/5bEq2jtXojTcgpR2n/eKHW3eRw5+4VGdeBcXu27qy
         Tbi/BjHCA7dOc1WSmN3uqEUEXfX1e6Ac7+NVbFOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 03/32] ipv6: fix races in ip6_dst_destroy()
Date:   Sat,  4 May 2019 12:24:48 +0200
Message-Id: <20190504102452.638695880@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0e2338749192ce0e52e7174c5352f627632f478a ]

We had many syzbot reports that seem to be caused by use-after-free
of struct fib6_info.

ip6_dst_destroy(), fib6_drop_pcpu_from() and rt6_remove_exception()
are writers vs rt->from, and use non consistent synchronization among
themselves.

Switching to xchg() will solve the issues with no possible
lockdep issues.

BUG: KASAN: user-memory-access in atomic_dec_and_test include/asm-generic/atomic-instrumented.h:747 [inline]
BUG: KASAN: user-memory-access in fib6_info_release include/net/ip6_fib.h:294 [inline]
BUG: KASAN: user-memory-access in fib6_info_release include/net/ip6_fib.h:292 [inline]
BUG: KASAN: user-memory-access in fib6_drop_pcpu_from net/ipv6/ip6_fib.c:927 [inline]
BUG: KASAN: user-memory-access in fib6_purge_rt+0x4f6/0x670 net/ipv6/ip6_fib.c:960
Write of size 4 at addr 0000000000ffffb4 by task syz-executor.1/7649

CPU: 0 PID: 7649 Comm: syz-executor.1 Not tainted 5.1.0-rc6+ #183
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 kasan_report.cold+0x5/0x40 mm/kasan/report.c:321
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x123/0x190 mm/kasan/generic.c:191
 kasan_check_write+0x14/0x20 mm/kasan/common.c:108
 atomic_dec_and_test include/asm-generic/atomic-instrumented.h:747 [inline]
 fib6_info_release include/net/ip6_fib.h:294 [inline]
 fib6_info_release include/net/ip6_fib.h:292 [inline]
 fib6_drop_pcpu_from net/ipv6/ip6_fib.c:927 [inline]
 fib6_purge_rt+0x4f6/0x670 net/ipv6/ip6_fib.c:960
 fib6_del_route net/ipv6/ip6_fib.c:1813 [inline]
 fib6_del+0xac2/0x10a0 net/ipv6/ip6_fib.c:1844
 fib6_clean_node+0x3a8/0x590 net/ipv6/ip6_fib.c:2006
 fib6_walk_continue+0x495/0x900 net/ipv6/ip6_fib.c:1928
 fib6_walk+0x9d/0x100 net/ipv6/ip6_fib.c:1976
 fib6_clean_tree+0xe0/0x120 net/ipv6/ip6_fib.c:2055
 __fib6_clean_all+0x118/0x2a0 net/ipv6/ip6_fib.c:2071
 fib6_clean_all+0x2b/0x40 net/ipv6/ip6_fib.c:2082
 rt6_sync_down_dev+0x134/0x150 net/ipv6/route.c:4057
 rt6_disable_ip+0x27/0x5f0 net/ipv6/route.c:4062
 addrconf_ifdown+0xa2/0x1220 net/ipv6/addrconf.c:3705
 addrconf_notify+0x19a/0x2260 net/ipv6/addrconf.c:3630
 notifier_call_chain+0xc7/0x240 kernel/notifier.c:93
 __raw_notifier_call_chain kernel/notifier.c:394 [inline]
 raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:401
 call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1753
 call_netdevice_notifiers_extack net/core/dev.c:1765 [inline]
 call_netdevice_notifiers net/core/dev.c:1779 [inline]
 dev_close_many+0x33f/0x6f0 net/core/dev.c:1522
 rollback_registered_many+0x43b/0xfd0 net/core/dev.c:8177
 rollback_registered+0x109/0x1d0 net/core/dev.c:8242
 unregister_netdevice_queue net/core/dev.c:9289 [inline]
 unregister_netdevice_queue+0x1ee/0x2c0 net/core/dev.c:9282
 unregister_netdevice include/linux/netdevice.h:2658 [inline]
 __tun_detach+0xd5b/0x1000 drivers/net/tun.c:727
 tun_detach drivers/net/tun.c:744 [inline]
 tun_chr_close+0xe0/0x180 drivers/net/tun.c:3443
 __fput+0x2e5/0x8d0 fs/file_table.c:278
 ____fput+0x16/0x20 fs/file_table.c:309
 task_work_run+0x14a/0x1c0 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0x90a/0x2fa0 kernel/exit.c:876
 do_group_exit+0x135/0x370 kernel/exit.c:980
 __do_sys_exit_group kernel/exit.c:991 [inline]
 __se_sys_exit_group kernel/exit.c:989 [inline]
 __x64_sys_exit_group+0x44/0x50 kernel/exit.c:989
 do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeafc2a6a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 000000000000001c RCX: 0000000000458da9
RDX: 0000000000412a80 RSI: 0000000000a54ef0 RDI: 0000000000000043
RBP: 00000000004be552 R08: 000000000000000c R09: 000000000004c0d1
R10: 0000000002341940 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00007ffeafc2a7f0 R14: 000000000004c065 R15: 00007ffeafc2a800

Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: David Ahern <dsahern@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    4 +---
 net/ipv6/route.c   |    9 ++-------
 2 files changed, 3 insertions(+), 10 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -921,9 +921,7 @@ static void fib6_drop_pcpu_from(struct f
 		if (pcpu_rt) {
 			struct fib6_info *from;
 
-			from = rcu_dereference_protected(pcpu_rt->from,
-					     lockdep_is_held(&table->tb6_lock));
-			rcu_assign_pointer(pcpu_rt->from, NULL);
+			from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
 			fib6_info_release(from);
 		}
 	}
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -379,11 +379,8 @@ static void ip6_dst_destroy(struct dst_e
 		in6_dev_put(idev);
 	}
 
-	rcu_read_lock();
-	from = rcu_dereference(rt->from);
-	rcu_assign_pointer(rt->from, NULL);
+	from = xchg((__force struct fib6_info **)&rt->from, NULL);
 	fib6_info_release(from);
-	rcu_read_unlock();
 }
 
 static void ip6_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
@@ -1288,9 +1285,7 @@ static void rt6_remove_exception(struct
 	/* purge completely the exception to allow releasing the held resources:
 	 * some [sk] cache may keep the dst around for unlimited time
 	 */
-	from = rcu_dereference_protected(rt6_ex->rt6i->from,
-					 lockdep_is_held(&rt6_exception_lock));
-	rcu_assign_pointer(rt6_ex->rt6i->from, NULL);
+	from = xchg((__force struct fib6_info **)&rt6_ex->rt6i->from, NULL);
 	fib6_info_release(from);
 	dst_dev_put(&rt6_ex->rt6i->dst);
 


