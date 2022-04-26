Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D191050F5BC
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345490AbiDZIlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345507AbiDZIkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAEB1541DF;
        Tue, 26 Apr 2022 01:32:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99761B81CF2;
        Tue, 26 Apr 2022 08:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC81C385A4;
        Tue, 26 Apr 2022 08:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961963;
        bh=JCay/nRP8oigsNZ1tInS4nlrk6nHs+AHzd/aG7CWa3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzTeBOV+SFnXQRJTT25VBlFDX0cc0vLk5Zkr2ov15ZEcHkyd+8TnH+SjFFuQDUokG
         FRpO0w8dzW77dblxnHhsZW+mtXKnO9kEVbV588LtYBXJRsDmtoYrdX+tAGSK6YDA2T
         W2L383bweIHRrS/ECtbbkymi0I8IjLi8AN4Twvyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/86] ipv6: make ip6_rt_gc_expire an atomic_t
Date:   Tue, 26 Apr 2022 10:20:54 +0200
Message-Id: <20220426081741.964618835@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9cb7c013420f98fa6fd12fc6a5dc055170c108db ]

Reads and Writes to ip6_rt_gc_expire always have been racy,
as syzbot reported lately [1]

There is a possible risk of under-flow, leading
to unexpected high value passed to fib6_run_gc(),
although I have not observed this in the field.

Hosts hitting ip6_dst_gc() very hard are under pretty bad
state anyway.

[1]
BUG: KCSAN: data-race in ip6_dst_gc / ip6_dst_gc

read-write to 0xffff888102110744 of 4 bytes by task 13165 on cpu 1:
 ip6_dst_gc+0x1f3/0x220 net/ipv6/route.c:3311
 dst_alloc+0x9b/0x160 net/core/dst.c:86
 ip6_dst_alloc net/ipv6/route.c:344 [inline]
 icmp6_dst_alloc+0xb2/0x360 net/ipv6/route.c:3261
 mld_sendpack+0x2b9/0x580 net/ipv6/mcast.c:1807
 mld_send_cr net/ipv6/mcast.c:2119 [inline]
 mld_ifc_work+0x576/0x800 net/ipv6/mcast.c:2651
 process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
 worker_thread+0x618/0xa70 kernel/workqueue.c:2436
 kthread+0x1a9/0x1e0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30

read-write to 0xffff888102110744 of 4 bytes by task 11607 on cpu 0:
 ip6_dst_gc+0x1f3/0x220 net/ipv6/route.c:3311
 dst_alloc+0x9b/0x160 net/core/dst.c:86
 ip6_dst_alloc net/ipv6/route.c:344 [inline]
 icmp6_dst_alloc+0xb2/0x360 net/ipv6/route.c:3261
 mld_sendpack+0x2b9/0x580 net/ipv6/mcast.c:1807
 mld_send_cr net/ipv6/mcast.c:2119 [inline]
 mld_ifc_work+0x576/0x800 net/ipv6/mcast.c:2651
 process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
 worker_thread+0x618/0xa70 kernel/workqueue.c:2436
 kthread+0x1a9/0x1e0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30

value changed: 0x00000bb3 -> 0x00000ba9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 11607 Comm: kworker/0:21 Not tainted 5.18.0-rc1-syzkaller-00037-g42e7a03d3bad-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220413181333.649424-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv6.h |  4 ++--
 net/ipv6/route.c         | 11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 1c0fbe3abf24..f179996c6184 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -78,8 +78,8 @@ struct netns_ipv6 {
 	struct dst_ops		ip6_dst_ops;
 	rwlock_t		fib6_walker_lock;
 	spinlock_t		fib6_gc_lock;
-	unsigned int		 ip6_rt_gc_expire;
-	unsigned long		 ip6_rt_last_gc;
+	atomic_t		ip6_rt_gc_expire;
+	unsigned long		ip6_rt_last_gc;
 	unsigned char		flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	bool			fib6_has_custom_rules;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 776b1b58c5dc..6ace9f0ac22f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3192,6 +3192,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
 	int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
 	unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
+	unsigned int val;
 	int entries;
 
 	entries = dst_entries_get_fast(ops);
@@ -3202,13 +3203,13 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	    entries <= rt_max_size)
 		goto out;
 
-	net->ipv6.ip6_rt_gc_expire++;
-	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
+	fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
 	entries = dst_entries_get_slow(ops);
 	if (entries < ops->gc_thresh)
-		net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
+		atomic_set(&net->ipv6.ip6_rt_gc_expire, rt_gc_timeout >> 1);
 out:
-	net->ipv6.ip6_rt_gc_expire -= net->ipv6.ip6_rt_gc_expire>>rt_elasticity;
+	val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
+	atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
 	return entries > rt_max_size;
 }
 
@@ -6363,7 +6364,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 	net->ipv6.sysctl.skip_notify_on_dev_down = 0;
 
-	net->ipv6.ip6_rt_gc_expire = 30*HZ;
+	atomic_set(&net->ipv6.ip6_rt_gc_expire, 30*HZ);
 
 	ret = 0;
 out:
-- 
2.35.1



