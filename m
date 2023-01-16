Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB7166C91E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbjAPQqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbjAPQps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916CF144A6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50245B81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A062BC433EF;
        Mon, 16 Jan 2023 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886815;
        bh=eBvSJL0O/pQyKCFYDfPLSOneEmvBbIZJomug8uc7d/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOaqkYySqpAOWWHN0HEDDUBE51cRcxvwnOsbAv+kmXyOu5gm4H6pgH8yWTyXNoPzT
         lZmHSkNdPpsZ+JK+GDsmiO/uKBqKQE1YZbRPvbIp6hDw0oybkzxo8SkkVwrTbgyVqS
         0DyqmtxtNWWcqUO4ez43w+eDig4mBQvQOPoTBCoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 572/658] net: sched: fix memory leak in tcindex_set_parms
Date:   Mon, 16 Jan 2023 16:51:00 +0100
Message-Id: <20230116154935.670132262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawkins Jiawei <yin31149@gmail.com>

[ Upstream commit 399ab7fe0fa0d846881685fd4e57e9a8ef7559f7 ]

Syzkaller reports a memory leak as follows:
====================================
BUG: memory leak
unreferenced object 0xffff88810c287f00 (size 256):
  comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
    [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
    [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
    [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
    [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
    [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
    [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
    [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
    [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
    [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
    [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
    [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
    [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
    [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
    [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
    [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
====================================

Kernel uses tcindex_change() to change an existing
filter properties.

Yet the problem is that, during the process of changing,
if `old_r` is retrieved from `p->perfect`, then
kernel uses tcindex_alloc_perfect_hash() to newly
allocate filter results, uses tcindex_filter_result_init()
to clear the old filter result, without destroying
its tcf_exts structure, which triggers the above memory leak.

To be more specific, there are only two source for the `old_r`,
according to the tcindex_lookup(). `old_r` is retrieved from
`p->perfect`, or `old_r` is retrieved from `p->h`.

  * If `old_r` is retrieved from `p->perfect`, kernel uses
tcindex_alloc_perfect_hash() to newly allocate the
filter results. Then `r` is assigned with `cp->perfect + handle`,
which is newly allocated. So condition `old_r && old_r != r` is
true in this situation, and kernel uses tcindex_filter_result_init()
to clear the old filter result, without destroying
its tcf_exts structure

  * If `old_r` is retrieved from `p->h`, then `p->perfect` is NULL
according to the tcindex_lookup(). Considering that `cp->h`
is directly copied from `p->h` and `p->perfect` is NULL,
`r` is assigned with `tcindex_lookup(cp, handle)`, whose value
should be the same as `old_r`, so condition `old_r && old_r != r`
is false in this situation, kernel ignores using
tcindex_filter_result_init() to clear the old filter result.

So only when `old_r` is retrieved from `p->perfect` does kernel use
tcindex_filter_result_init() to clear the old filter result, which
triggers the above memory leak.

Considering that there already exists a tc_filter_wq workqueue
to destroy the old tcindex_data by tcindex_partial_destroy_work()
at the end of tcindex_set_parms(), this patch solves
this memory leak bug by removing this old filter result
clearing part and delegating it to the tc_filter_wq workqueue.

Note that this patch doesn't introduce any other issues. If
`old_r` is retrieved from `p->perfect`, this patch just
delegates old filter result clearing part to the
tc_filter_wq workqueue; If `old_r` is retrieved from `p->h`,
kernel doesn't reach the old filter result clearing part, so
removing this part has no effect.

[Thanks to the suggestion from Jakub Kicinski, Cong Wang, Paolo Abeni
and Dmitry Vyukov]

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_tcindex.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 684187a1fdb9..768cf7cf65b4 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -332,7 +332,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		  struct tcindex_filter_result *r, struct nlattr **tb,
 		  struct nlattr *est, bool ovr, struct netlink_ext_ack *extack)
 {
-	struct tcindex_filter_result new_filter_result, *old_r = r;
+	struct tcindex_filter_result new_filter_result;
 	struct tcindex_data *cp = NULL, *oldp;
 	struct tcindex_filter *f = NULL; /* make gcc behave */
 	struct tcf_result cr = {};
@@ -401,7 +401,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	err = tcindex_filter_result_init(&new_filter_result, cp, net);
 	if (err < 0)
 		goto errout_alloc;
-	if (old_r)
+	if (r)
 		cr = r->res;
 
 	err = -EBUSY;
@@ -478,14 +478,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		tcf_bind_filter(tp, &cr, base);
 	}
 
-	if (old_r && old_r != r) {
-		err = tcindex_filter_result_init(old_r, cp, net);
-		if (err < 0) {
-			kfree(f);
-			goto errout_alloc;
-		}
-	}
-
 	oldp = p;
 	r->res = cr;
 	tcf_exts_change(&r->exts, &e);
-- 
2.35.1



