Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AC137CEC0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbhELRGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242592AbhELQuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFB2A6023E;
        Wed, 12 May 2021 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836194;
        bh=iOjIZm6la0AL6MPmYKkwAWVBvYQyp4J7fD8nBUcb92s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xZPnRDQ3l44lO8vTOgTRc9lYkF1fYLzsHOSSqONnUni7c9WuO/gZtJqnNEu6euAe
         zrNCfuvhHEE7XN0n8+28q4BOD7bfkRB52Ms8k/jWrdIa0GY/qs2vSqWa1iv+fZD0IO
         xniy9/T0YHto/t3b6e4vRByy2Ne2IiIGrHvrZ8G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 649/677] net/sched: act_ct: fix wild memory access when clearing fragments
Date:   Wed, 12 May 2021 16:51:35 +0200
Message-Id: <20210512144858.923730385@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit f77bd544a6bbe69aa50d9ed09f13494cf36ff806 ]

while testing re-assembly/re-fragmentation using act_ct, it's possible to
observe a crash like the following one:

 KASAN: maybe wild-memory-access in range [0x0001000000000448-0x000100000000044f]
 CPU: 50 PID: 0 Comm: swapper/50 Tainted: G S                5.12.0-rc7+ #424
 Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.4.3 01/17/2017
 RIP: 0010:inet_frag_rbtree_purge+0x50/0xc0
 Code: 00 fc ff df 48 89 c3 31 ed 48 89 df e8 a9 7a 38 ff 4c 89 fe 48 89 df 49 89 c6 e8 5b 3a 38 ff 48 8d 7b 40 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00 75 59 48 8d bb d0 00 00 00 4c 8b 6b 40 48 89 f8 48
 RSP: 0018:ffff888c31449db8 EFLAGS: 00010203
 RAX: 0000200000000089 RBX: 000100000000040e RCX: ffffffff989eb960
 RDX: 0000000000000140 RSI: ffffffff97cfb977 RDI: 000100000000044e
 RBP: 0000000000000900 R08: 0000000000000000 R09: ffffed1186289350
 R10: 0000000000000003 R11: ffffed1186289350 R12: dffffc0000000000
 R13: 000100000000040e R14: 0000000000000000 R15: ffff888155e02160
 FS:  0000000000000000(0000) GS:ffff888c31440000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005600cb70a5b8 CR3: 0000000a2c014005 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  inet_frag_destroy+0xa9/0x150
  call_timer_fn+0x2d/0x180
  run_timer_softirq+0x4fe/0xe70
  __do_softirq+0x197/0x5a0
  irq_exit_rcu+0x1de/0x200
  sysvec_apic_timer_interrupt+0x6b/0x80
  </IRQ>

when act_ct temporarily stores an IP fragment, restoring the skb qdisc cb
results in putting random data in FRAG_CB(), and this causes those "wild"
memory accesses later, when the rbtree is purged. Never overwrite the skb
cb in case tcf_ct_handle_fragments() returns -EINPROGRESS.

Fixes: ae372cb1750f ("net/sched: act_ct: fix restore the qdisc_skb_cb after defrag")
Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 16e888a9601d..48fdf7293dea 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -732,7 +732,8 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 #endif
 	}
 
-	*qdisc_skb_cb(skb) = cb;
+	if (err != -EINPROGRESS)
+		*qdisc_skb_cb(skb) = cb;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -967,7 +968,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	err = tcf_ct_handle_fragments(net, skb, family, p->zone, &defrag);
 	if (err == -EINPROGRESS) {
 		retval = TC_ACT_STOLEN;
-		goto out;
+		goto out_clear;
 	}
 	if (err)
 		goto drop;
@@ -1030,7 +1031,6 @@ do_nat:
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-out:
 	qdisc_skb_cb(skb)->post_ct = true;
 out_clear:
 	tcf_action_update_bstats(&c->common, skb);
-- 
2.30.2



