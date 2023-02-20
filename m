Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7518E69CEB2
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjBTOBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbjBTOBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6DD1F5DB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E2A060EB3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618DBC433D2;
        Mon, 20 Feb 2023 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901673;
        bh=7a7EM5tcmNZqOYHTP081vg2IuOgo7CkIh76mgXzFgsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbaRR+WZnQfbDIWPK6IHqzYIy7v6Ux1qVJMmBJlZCSCW3Yv3odnJ3BbiSyVlPbtJ/
         0YZvxSYpnVq4q9khQrSTZToPU65VKyQjuJZyF6nRwqNuRL32hK3KOEenduOpJeQTeg
         Us0oI4D8JMDUXVloIfYyVYgTVFgzYAOcINGkEh0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/118] net/sched: tcindex: search key must be 16 bits
Date:   Mon, 20 Feb 2023 14:37:04 +0100
Message-Id: <20230220133604.729393584@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 42018a322bd453e38b3ffee294982243e50a484f ]

Syzkaller found an issue where a handle greater than 16 bits would trigger
a null-ptr-deref in the imperfect hash area update.

general protection fault, probably for non-canonical address
0xdffffc0000000015: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
CPU: 0 PID: 5070 Comm: syz-executor456 Not tainted
6.2.0-rc7-syzkaller-00112-gc68f345b7c42 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/21/2023
RIP: 0010:tcindex_set_parms+0x1a6a/0x2990 net/sched/cls_tcindex.c:509
Code: 01 e9 e9 fe ff ff 4c 8b bd 28 fe ff ff e8 0e 57 7d f9 48 8d bb
a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c
02 00 0f 85 94 0c 00 00 48 8b 85 f8 fd ff ff 48 8b 9b a8 00
RSP: 0018:ffffc90003d3ef88 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000015 RSI: ffffffff8803a102 RDI: 00000000000000a8
RBP: ffffc90003d3f1d8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88801e2b10a8
R13: dffffc0000000000 R14: 0000000000030000 R15: ffff888017b3be00
FS: 00005555569af300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056041c6d2000 CR3: 000000002bfca000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
tcindex_change+0x1ea/0x320 net/sched/cls_tcindex.c:572
tc_new_tfilter+0x96e/0x2220 net/sched/cls_api.c:2155
rtnetlink_rcv_msg+0x959/0xca0 net/core/rtnetlink.c:6132
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xd3/0x120 net/socket.c:734
____sys_sendmsg+0x334/0x8c0 net/socket.c:2476
___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
__sys_sendmmsg+0x18f/0x460 net/socket.c:2616
__do_sys_sendmmsg net/socket.c:2645 [inline]
__se_sys_sendmmsg net/socket.c:2642 [inline]
__x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2642
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80

Fixes: ee059170b1f7 ("net/sched: tcindex: update imperfect hash filters respecting rcu")
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_tcindex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 4422b711af081..eea8e185fcdb2 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -502,7 +502,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		/* lookup the filter, guaranteed to exist */
 		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
 		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
-			if (cf->key == handle)
+			if (cf->key == (u16)handle)
 				break;
 
 		f->next = cf->next;
-- 
2.39.0



