Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF314BE6A6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351480AbiBUJtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352895AbiBUJsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EBE1929D;
        Mon, 21 Feb 2022 01:21:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93321CE0E80;
        Mon, 21 Feb 2022 09:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE70C340E9;
        Mon, 21 Feb 2022 09:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435264;
        bh=xBmtmWbsm2sQPARoBdA6CTtyQDm2ivem5Sp0G8zKxLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2U6H8iYssXlriP2Fl+E5wuBTIOaEA80RR2W70rkvUSi0w/EfQ2AZLz2lE3UIsDVc
         0I9exZ3KMNlLVdqkKL79BhYWc5EK4QAjrac/XqFY0nc/89mAQbPVt/jAeoLlCPRElK
         ZUvqvN3LMUcjUTpVOzEAfXBlkefOEMvqEd/JuDzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 102/227] ipv6: fix data-race in fib6_info_hw_flags_set / fib6_purge_rt
Date:   Mon, 21 Feb 2022 09:48:41 +0100
Message-Id: <20220221084938.266353429@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit d95d6320ba7a51d61c097ffc3bcafcf70283414e upstream.

Because fib6_info_hw_flags_set() is called without any synchronization,
all accesses to gi6->offload, fi->trap and fi->offload_failed
need some basic protection like READ_ONCE()/WRITE_ONCE().

BUG: KCSAN: data-race in fib6_info_hw_flags_set / fib6_purge_rt

read to 0xffff8881087d5886 of 1 bytes by task 13953 on cpu 0:
 fib6_drop_pcpu_from net/ipv6/ip6_fib.c:1007 [inline]
 fib6_purge_rt+0x4f/0x580 net/ipv6/ip6_fib.c:1033
 fib6_del_route net/ipv6/ip6_fib.c:1983 [inline]
 fib6_del+0x696/0x890 net/ipv6/ip6_fib.c:2028
 __ip6_del_rt net/ipv6/route.c:3876 [inline]
 ip6_del_rt+0x83/0x140 net/ipv6/route.c:3891
 __ipv6_dev_ac_dec+0x2b5/0x370 net/ipv6/anycast.c:374
 ipv6_dev_ac_dec net/ipv6/anycast.c:387 [inline]
 __ipv6_sock_ac_close+0x141/0x200 net/ipv6/anycast.c:207
 ipv6_sock_ac_close+0x79/0x90 net/ipv6/anycast.c:220
 inet6_release+0x32/0x50 net/ipv6/af_inet6.c:476
 __sock_release net/socket.c:650 [inline]
 sock_close+0x6c/0x150 net/socket.c:1318
 __fput+0x295/0x520 fs/file_table.c:280
 ____fput+0x11/0x20 fs/file_table.c:313
 task_work_run+0x8e/0x110 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x160/0x190 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:300
 do_syscall_64+0x50/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff8881087d5886 of 1 bytes by task 1912 on cpu 1:
 fib6_info_hw_flags_set+0x155/0x3b0 net/ipv6/route.c:6230
 nsim_fib6_rt_hw_flags_set drivers/net/netdevsim/fib.c:668 [inline]
 nsim_fib6_rt_add drivers/net/netdevsim/fib.c:691 [inline]
 nsim_fib6_rt_insert drivers/net/netdevsim/fib.c:756 [inline]
 nsim_fib6_event drivers/net/netdevsim/fib.c:853 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:886 [inline]
 nsim_fib_event_work+0x284f/0x2cf0 drivers/net/netdevsim/fib.c:1477
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x22 -> 0x2a

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 1912 Comm: kworker/1:3 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events nsim_fib_event_work

Fixes: 0c5fcf9e249e ("IPv6: Add "offload failed" indication to routes")
Fixes: bb3c4ab93e44 ("ipv6: Add "offload" and "trap" indications to routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Amit Cohen <amcohen@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220216173217.3792411-2-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/fib.c |    4 ++--
 include/net/ip6_fib.h       |   10 ++++++----
 net/ipv6/route.c            |   19 ++++++++++---------
 3 files changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -623,14 +623,14 @@ static int nsim_fib6_rt_append(struct ns
 		if (err)
 			goto err_fib6_rt_nh_del;
 
-		fib6_event->rt_arr[i]->trap = true;
+		WRITE_ONCE(fib6_event->rt_arr[i]->trap, true);
 	}
 
 	return 0;
 
 err_fib6_rt_nh_del:
 	for (i--; i >= 0; i--) {
-		fib6_event->rt_arr[i]->trap = false;
+		WRITE_ONCE(fib6_event->rt_arr[i]->trap, false);
 		nsim_fib6_rt_nh_del(fib6_rt, fib6_event->rt_arr[i]);
 	}
 	return err;
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -189,14 +189,16 @@ struct fib6_info {
 	u32				fib6_metric;
 	u8				fib6_protocol;
 	u8				fib6_type;
+
+	u8				offload;
+	u8				trap;
+	u8				offload_failed;
+
 	u8				should_flush:1,
 					dst_nocount:1,
 					dst_nopolicy:1,
 					fib6_destroying:1,
-					offload:1,
-					trap:1,
-					offload_failed:1,
-					unused:1;
+					unused:4;
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5767,11 +5767,11 @@ static int rt6_fill_node(struct net *net
 	}
 
 	if (!dst) {
-		if (rt->offload)
+		if (READ_ONCE(rt->offload))
 			rtm->rtm_flags |= RTM_F_OFFLOAD;
-		if (rt->trap)
+		if (READ_ONCE(rt->trap))
 			rtm->rtm_flags |= RTM_F_TRAP;
-		if (rt->offload_failed)
+		if (READ_ONCE(rt->offload_failed))
 			rtm->rtm_flags |= RTM_F_OFFLOAD_FAILED;
 	}
 
@@ -6229,19 +6229,20 @@ void fib6_info_hw_flags_set(struct net *
 	struct sk_buff *skb;
 	int err;
 
-	if (f6i->offload == offload && f6i->trap == trap &&
-	    f6i->offload_failed == offload_failed)
+	if (READ_ONCE(f6i->offload) == offload &&
+	    READ_ONCE(f6i->trap) == trap &&
+	    READ_ONCE(f6i->offload_failed) == offload_failed)
 		return;
 
-	f6i->offload = offload;
-	f6i->trap = trap;
+	WRITE_ONCE(f6i->offload, offload);
+	WRITE_ONCE(f6i->trap, trap);
 
 	/* 2 means send notifications only if offload_failed was changed. */
 	if (net->ipv6.sysctl.fib_notify_on_flag_change == 2 &&
-	    f6i->offload_failed == offload_failed)
+	    READ_ONCE(f6i->offload_failed) == offload_failed)
 		return;
 
-	f6i->offload_failed = offload_failed;
+	WRITE_ONCE(f6i->offload_failed, offload_failed);
 
 	if (!rcu_access_pointer(f6i->fib6_node))
 		/* The route was removed from the tree, do not send


