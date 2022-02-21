Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B164BE65B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349431AbiBUJ1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350115AbiBUJ1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1FB26DF;
        Mon, 21 Feb 2022 01:11:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46CFBCE0E76;
        Mon, 21 Feb 2022 09:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1B7C340E9;
        Mon, 21 Feb 2022 09:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434695;
        bh=Q1WvP5l4E9zNsEOp9b8fRB7UETmylVT8YosRUAUQ6RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pq8t28uxWaJti0sdiVEAx4F8vgwsNHtAkTzTER0Jw49jOuh1sK9hF92ZXQVKYsqzs
         S//LWhLRIOmPCkj/JGBfD6sNtU3twqdtPV3nSjNuZBbXuQhjCx0H77WQRcuN9HS97P
         R2I+p8dG1mAnAt3KKcsDMi/6J9hAlpAGegGftaWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 081/196] ipv4: fix data races in fib_alias_hw_flags_set
Date:   Mon, 21 Feb 2022 09:48:33 +0100
Message-Id: <20220221084933.650149572@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

commit 9fcf986cc4bc6a3a39f23fbcbbc3a9e52d3c24fd upstream.

fib_alias_hw_flags_set() can be used by concurrent threads,
and is only RCU protected.

We need to annotate accesses to following fields of struct fib_alias:

    offload, trap, offload_failed

Because of READ_ONCE()WRITE_ONCE() limitations, make these
field u8.

BUG: KCSAN: data-race in fib_alias_hw_flags_set / fib_alias_hw_flags_set

read to 0xffff888134224a6a of 1 bytes by task 2013 on cpu 1:
 fib_alias_hw_flags_set+0x28a/0x470 net/ipv4/fib_trie.c:1050
 nsim_fib4_rt_hw_flags_set drivers/net/netdevsim/fib.c:350 [inline]
 nsim_fib4_rt_add drivers/net/netdevsim/fib.c:367 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:429 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:461 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:881 [inline]
 nsim_fib_event_work+0x1852/0x2cf0 drivers/net/netdevsim/fib.c:1477
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 process_scheduled_works kernel/workqueue.c:2370 [inline]
 worker_thread+0x7df/0xa70 kernel/workqueue.c:2456
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

write to 0xffff888134224a6a of 1 bytes by task 4872 on cpu 0:
 fib_alias_hw_flags_set+0x2d5/0x470 net/ipv4/fib_trie.c:1054
 nsim_fib4_rt_hw_flags_set drivers/net/netdevsim/fib.c:350 [inline]
 nsim_fib4_rt_add drivers/net/netdevsim/fib.c:367 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:429 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:461 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:881 [inline]
 nsim_fib_event_work+0x1852/0x2cf0 drivers/net/netdevsim/fib.c:1477
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 process_scheduled_works kernel/workqueue.c:2370 [inline]
 worker_thread+0x7df/0xa70 kernel/workqueue.c:2456
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

value changed: 0x00 -> 0x02

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 4872 Comm: kworker/0:0 Not tainted 5.17.0-rc3-syzkaller-00188-g1d41d2e82623-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events nsim_fib_event_work

Fixes: 90b93f1b31f8 ("ipv4: Add "offload" and "trap" indications to routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220216173217.3792411-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_lookup.h    |    7 +++----
 net/ipv4/fib_semantics.c |    6 +++---
 net/ipv4/fib_trie.c      |   22 +++++++++++++---------
 net/ipv4/route.c         |    4 ++--
 4 files changed, 21 insertions(+), 18 deletions(-)

--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -16,10 +16,9 @@ struct fib_alias {
 	u8			fa_slen;
 	u32			tb_id;
 	s16			fa_default;
-	u8			offload:1,
-				trap:1,
-				offload_failed:1,
-				unused:5;
+	u8			offload;
+	u8			trap;
+	u8			offload_failed;
 	struct rcu_head		rcu;
 };
 
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -524,9 +524,9 @@ void rtmsg_fib(int event, __be32 key, st
 	fri.dst_len = dst_len;
 	fri.tos = fa->fa_tos;
 	fri.type = fa->fa_type;
-	fri.offload = fa->offload;
-	fri.trap = fa->trap;
-	fri.offload_failed = fa->offload_failed;
+	fri.offload = READ_ONCE(fa->offload);
+	fri.trap = READ_ONCE(fa->trap);
+	fri.offload_failed = READ_ONCE(fa->offload_failed);
 	err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1047,19 +1047,23 @@ void fib_alias_hw_flags_set(struct net *
 	if (!fa_match)
 		goto out;
 
-	if (fa_match->offload == fri->offload && fa_match->trap == fri->trap &&
-	    fa_match->offload_failed == fri->offload_failed)
+	/* These are paired with the WRITE_ONCE() happening in this function.
+	 * The reason is that we are only protected by RCU at this point.
+	 */
+	if (READ_ONCE(fa_match->offload) == fri->offload &&
+	    READ_ONCE(fa_match->trap) == fri->trap &&
+	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
-	fa_match->offload = fri->offload;
-	fa_match->trap = fri->trap;
+	WRITE_ONCE(fa_match->offload, fri->offload);
+	WRITE_ONCE(fa_match->trap, fri->trap);
 
 	/* 2 means send notifications only if offload_failed was changed. */
 	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
-	    fa_match->offload_failed == fri->offload_failed)
+	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
-	fa_match->offload_failed = fri->offload_failed;
+	WRITE_ONCE(fa_match->offload_failed, fri->offload_failed);
 
 	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
 		goto out;
@@ -2297,9 +2301,9 @@ static int fn_trie_dump_leaf(struct key_
 				fri.dst_len = KEYLENGTH - fa->fa_slen;
 				fri.tos = fa->fa_tos;
 				fri.type = fa->fa_type;
-				fri.offload = fa->offload;
-				fri.trap = fa->trap;
-				fri.offload_failed = fa->offload_failed;
+				fri.offload = READ_ONCE(fa->offload);
+				fri.trap = READ_ONCE(fa->trap);
+				fri.offload_failed = READ_ONCE(fa->offload_failed);
 				err = fib_dump_info(skb,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3401,8 +3401,8 @@ static int inet_rtm_getroute(struct sk_b
 				    fa->fa_tos == fri.tos &&
 				    fa->fa_info == res.fi &&
 				    fa->fa_type == fri.type) {
-					fri.offload = fa->offload;
-					fri.trap = fa->trap;
+					fri.offload = READ_ONCE(fa->offload);
+					fri.trap = READ_ONCE(fa->trap);
 					break;
 				}
 			}


