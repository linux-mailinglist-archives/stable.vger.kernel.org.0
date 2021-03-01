Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0538328A9B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239589AbhCASUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239291AbhCASOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:14:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6872A65125;
        Mon,  1 Mar 2021 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618187;
        bh=9LRu77Qa14saVp8Myqa9XX9jUSJL92s4Mb8pKr9mnww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3LYrRBmvAKlqdEY2nNCYwWkouSdYjCG6OAEaXVHUH7Z3uV8JhrXQ8E3GfvtZLu3W
         IODd4n5UXOXFueYK706nhrUcD1C3fYcHwv0NIq5f/jqNN5UIygL7P1pGNj6ys/R3ZA
         EG4NkHkfKt3UJkBMl9ESzWBE4asNvS4kRbka0I+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 338/340] net: sched: fix police ext initialization
Date:   Mon,  1 Mar 2021 17:14:42 +0100
Message-Id: <20210301161104.928637408@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

commit 396d7f23adf9e8c436dd81a69488b5b6a865acf8 upstream.

When police action is created by cls API tcf_exts_validate() first
conditional that calls tcf_action_init_1() directly, the action idr is not
updated according to latest changes in action API that require caller to
commit newly created action to idr with tcf_idr_insert_many(). This results
such action not being accessible through act API and causes crash reported
by syzbot:

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in __tcf_idr_release net/sched/act_api.c:178 [inline]
BUG: KASAN: null-ptr-deref in tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
Read of size 4 at addr 0000000000000010 by task kworker/u4:5/204

CPU: 0 PID: 204 Comm: kworker/u4:5 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:400 [inline]
 kasan_report.cold+0x5f/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:178 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:604
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 204 Comm: kworker/u4:5 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 end_report+0x58/0x5e mm/kasan/report.c:100
 __kasan_report mm/kasan/report.c:403 [inline]
 kasan_report.cold+0x67/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:178 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:604
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Kernel Offset: disabled

Fix the issue by calling tcf_idr_insert_many() after successful action
initialization.

Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")
Reported-by: syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h |    1 +
 net/sched/act_api.c   |    2 +-
 net/sched/cls_api.c   |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -156,6 +156,7 @@ int tcf_idr_search(struct tc_action_net
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
 		   int bind, bool cpustats);
+void tcf_idr_insert_many(struct tc_action *actions[]);
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			struct tc_action **a, int bind);
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -823,7 +823,7 @@ static const struct nla_policy tcf_actio
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
 };
 
-static void tcf_idr_insert_many(struct tc_action *actions[])
+void tcf_idr_insert_many(struct tc_action *actions[])
 {
 	int i;
 
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3026,6 +3026,7 @@ int tcf_exts_validate(struct net *net, s
 			act->type = exts->type = TCA_OLD_COMPAT;
 			exts->actions[0] = act;
 			exts->nr_actions = 1;
+			tcf_idr_insert_many(exts->actions);
 		} else if (exts->action && tb[exts->action]) {
 			int err;
 


