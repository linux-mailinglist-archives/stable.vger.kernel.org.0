Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA0F4B498B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244685AbiBNKLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:11:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbiBNKJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:09:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2902B85948;
        Mon, 14 Feb 2022 01:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB9AB80DD2;
        Mon, 14 Feb 2022 09:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D95AC340E9;
        Mon, 14 Feb 2022 09:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832220;
        bh=KMZanydpN5ZzMP4ZMc7kFo32JxkD+fkWnbCNlOEFnWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnjdhKpldgAXHtwxnKXhEIbFMsWmmGpYuTIjadq9+iZEfvo8Kk4UiSYz1yNQcRmPD
         CAYB06YDkzZmbOYcOQeomMhP3ONf+mA1f5JeoM+EYC6IGhs5NtUFO6ifdk0lOPOyvT
         Mss9H09mXbl5RgdzB36b0jcGCKn0wNCrPZfJuZbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/172] ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path
Date:   Mon, 14 Feb 2022 10:26:15 +0100
Message-Id: <20220214092510.463082974@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5611a00697c8ecc5aad04392bea629e9d6a20463 ]

ip[6]mr_free_table() can only be called under RTNL lock.

RTNL: assertion failed at net/core/dev.c (10367)
WARNING: CPU: 1 PID: 5890 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Modules linked in:
CPU: 1 PID: 5890 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller-11627-g422ee58dc0ef #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Code: 0f 85 9b ee ff ff e8 69 07 4b fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 6d b1 51 06 01 e8 8c 90 d8 01 <0f> 0b e9 70 ee ff ff e8 3e 07 4b fa 4c 89 e7 e8 86 2a 59 fa e9 ee
RSP: 0018:ffffc900046ff6e0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888050f51d00 RSI: ffffffff815fa008 RDI: fffff520008dfece
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815f3d6e R11: 0000000000000000 R12: 00000000fffffff4
R13: dffffc0000000000 R14: ffffc900046ff750 R15: ffff88807b7dc000
FS:  00007f4ab736e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fee0b4f8990 CR3: 000000001e7d2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mroute_clean_tables+0x244/0xb40 net/ipv6/ip6mr.c:1509
 ip6mr_free_table net/ipv6/ip6mr.c:389 [inline]
 ip6mr_rules_init net/ipv6/ip6mr.c:246 [inline]
 ip6mr_net_init net/ipv6/ip6mr.c:1306 [inline]
 ip6mr_net_init+0x3f0/0x4e0 net/ipv6/ip6mr.c:1298
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x54f/0xbb0 net/core/net_namespace.c:331
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:475
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2e0c/0x7300 kernel/fork.c:2167
 kernel_clone+0xe7/0xab0 kernel/fork.c:2555
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2672
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4ab89f9059
Code: Unable to access opcode bytes at RIP 0x7f4ab89f902f.
RSP: 002b:00007f4ab736e118 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f4ab8b0bf60 RCX: 00007f4ab89f9059
RDX: 0000000020000280 RSI: 0000000020000270 RDI: 0000000040200000
RBP: 00007f4ab8a5308d R08: 0000000020000300 R09: 0000000020000300
R10: 00000000200002c0 R11: 0000000000000206 R12: 0000000000000000
R13: 00007ffc3977cc1f R14: 00007f4ab736e300 R15: 0000000000022000
 </TASK>

Fixes: f243e5a7859a ("ipmr,ip6mr: call ip6mr_free_table() on failure path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <cong.wang@bytedance.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220208053451.2885398-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c  | 2 ++
 net/ipv6/ip6mr.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca2602..aea29d97f8dfa 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -261,7 +261,9 @@ static int __net_init ipmr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ipmr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 36ed9efb88254..6a4065d81aa91 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -248,7 +248,9 @@ static int __net_init ip6mr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ip6mr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
-- 
2.34.1



