Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298514BBA9A
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiBRO30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:29:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiBRO30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:29:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6690345054
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0350A617CB
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A16C340E9;
        Fri, 18 Feb 2022 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645194548;
        bh=3KBBjz8BBjP0LZq2VB1QL2SM6EM7lZuhDsHTFXSwOHA=;
        h=Subject:To:Cc:From:Date:From;
        b=LVz2fPEb6+AAkcCcFzVPAysdd+CWzbezNP0X/E4gI307LjUInuKMgdmP+S2q1oTA6
         51CaPgRHrtkuImZHs/ombbA4lF1auI8n4kTfYCyRUpQ/ZsnYU5DnXm+f8DSWr4J/lE
         t7B6N8glaVItPpZ3bIJ/u2fLsTQYyEwXk7XPaJ4g=
Subject: FAILED: patch "[PATCH] ipv4: fix data races in fib_alias_hw_flags_set" failed to apply to 5.10-stable tree
To:     edumazet@google.com, idosch@nvidia.com, kuba@kernel.org,
        syzkaller@googlegroups.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:29:05 +0100
Message-ID: <164519454520744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9fcf986cc4bc6a3a39f23fbcbbc3a9e52d3c24fd Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 16 Feb 2022 09:32:16 -0800
Subject: [PATCH] ipv4: fix data races in fib_alias_hw_flags_set

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

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index e184bcb19943..78e40ea42e58 100644
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
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b4589861b84c..2dd375f7407b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -525,9 +525,9 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
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
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8060524f4256..f7f74d5c14da 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1047,19 +1047,23 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
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
@@ -2297,9 +2301,9 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
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
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ff6f91cdb6c4..f33ad1f383b6 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3395,8 +3395,8 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
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

