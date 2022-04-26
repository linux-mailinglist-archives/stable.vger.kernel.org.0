Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7939050F6E3
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344561AbiDZJBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345892AbiDZI5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:57:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9411015FEC;
        Tue, 26 Apr 2022 01:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4915611B2;
        Tue, 26 Apr 2022 08:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CA0C385AE;
        Tue, 26 Apr 2022 08:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962573;
        bh=Y4o65afVrCH4UbGnOdzCqzHswk+z5MG965K5wdHXI3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqpCIBDEGv2f9ioKc7pLk5GJhuD3PEQ4tA1nUBIN3b5MhTTFQDssbWC7q7jcydARk
         zLHxEErPVvKU7/bnb9LwAh321DGGryqA8D/Pqca0lLKA5zQs0TKdcis+MGAVXxYMRo
         pcunwDsZ2Mi/IWupjsYPtQ7HMpA6JjgZbQ402nJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 007/146] net/sched: cls_u32: fix netns refcount changes in u32_change()
Date:   Tue, 26 Apr 2022 10:20:02 +0200
Message-Id: <20220426081750.269597052@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
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

commit 3db09e762dc79584a69c10d74a6b98f89a9979f8 upstream.

We are now able to detect extra put_net() at the moment
they happen, instead of much later in correct code paths.

u32_init_knode() / tcf_exts_init() populates the ->exts.net
pointer, but as mentioned in tcf_exts_init(),
the refcount on netns has not been elevated yet.

The refcount is taken only once tcf_exts_get_net()
is called.

So the two u32_destroy_key() calls from u32_change()
are attempting to release an invalid reference on the netns.

syzbot report:

refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 21708 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 21708 Comm: syz-executor.5 Not tainted 5.18.0-rc2-next-20220412-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d 14 b6 b2 09 31 ff 89 de e8 6d e9 89 fd 84 db 75 e0 e8 84 e5 89 fd 48 c7 c7 40 aa 26 8a c6 05 f4 b5 b2 09 01 e8 e5 81 2e 05 <0f> 0b eb c4 e8 68 e5 89 fd 0f b6 1d e3 b5 b2 09 31 ff 89 de e8 38
RSP: 0018:ffffc900051af1b0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8160a0c8 RDI: fffff52000a35e28
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81604a9e R11: 0000000000000000 R12: 1ffff92000a35e3b
R13: 00000000ffffffef R14: ffff8880211a0194 R15: ffff8880577d0a00
FS:  00007f25d183e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f19c859c028 CR3: 0000000051009000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 ref_tracker_free+0x535/0x6b0 lib/ref_tracker.c:118
 netns_tracker_free include/net/net_namespace.h:327 [inline]
 put_net_track include/net/net_namespace.h:341 [inline]
 tcf_exts_put_net include/net/pkt_cls.h:255 [inline]
 u32_destroy_key.isra.0+0xa7/0x2b0 net/sched/cls_u32.c:394
 u32_change+0xe01/0x3140 net/sched/cls_u32.c:909
 tc_new_tfilter+0x98d/0x2200 net/sched/cls_api.c:2148
 rtnetlink_rcv_msg+0x80d/0xb80 net/core/rtnetlink.c:6016
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2495
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f25d0689049
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f25d183e168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f25d079c030 RCX: 00007f25d0689049
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000005
RBP: 00007f25d06e308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd0b752e3f R14: 00007f25d183e300 R15: 0000000000022000
 </TASK>

Fixes: 35c55fc156d8 ("cls_u32: use tcf_exts_get_net() before call_rcu()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_u32.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -386,14 +386,19 @@ static int u32_init(struct tcf_proto *tp
 	return 0;
 }
 
-static int u32_destroy_key(struct tc_u_knode *n, bool free_pf)
+static void __u32_destroy_key(struct tc_u_knode *n)
 {
 	struct tc_u_hnode *ht = rtnl_dereference(n->ht_down);
 
 	tcf_exts_destroy(&n->exts);
-	tcf_exts_put_net(&n->exts);
 	if (ht && --ht->refcnt == 0)
 		kfree(ht);
+	kfree(n);
+}
+
+static void u32_destroy_key(struct tc_u_knode *n, bool free_pf)
+{
+	tcf_exts_put_net(&n->exts);
 #ifdef CONFIG_CLS_U32_PERF
 	if (free_pf)
 		free_percpu(n->pf);
@@ -402,8 +407,7 @@ static int u32_destroy_key(struct tc_u_k
 	if (free_pf)
 		free_percpu(n->pcpu_success);
 #endif
-	kfree(n);
-	return 0;
+	__u32_destroy_key(n);
 }
 
 /* u32_delete_key_rcu should be called when free'ing a copied
@@ -900,13 +904,13 @@ static int u32_change(struct net *net, s
 				    extack);
 
 		if (err) {
-			u32_destroy_key(new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 
 		err = u32_replace_hw_knode(tp, new, flags, extack);
 		if (err) {
-			u32_destroy_key(new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 


