Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274DB55D4E0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbiF0LtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238309AbiF0LsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5233F59A;
        Mon, 27 Jun 2022 04:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54E0AB81123;
        Mon, 27 Jun 2022 11:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ABDC341C7;
        Mon, 27 Jun 2022 11:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330025;
        bh=ANm7NZ3p20kcA1xNI5TBb7Uyk/XbUVFrE8pqixiN7l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRNoEGdJwdHCDD2WfZfO+UNBIqaUyDOn/WIBUrnW5iUVXXVz1G6ZSms6LB+lWJMjN
         M3jde3IdzV9TYGLDzyxIwzzlv29tTXaggRpIuI50mqHMXhA6/gaRrWlwABUALAhbBp
         Wurvbb8c1RjOcCBqbbU0xVFkhSjIb7CqJpB4qlaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+47af19f3307fc9c5c82e@syzkaller.appspotmail.com,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 059/181] tipc: fix use-after-free Read in tipc_named_reinit
Date:   Mon, 27 Jun 2022 13:20:32 +0200
Message-Id: <20220627111946.278079040@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 911600bf5a5e84bfda4d33ee32acc75ecf6159f0 ]

syzbot found the following issue on:
==================================================================
BUG: KASAN: use-after-free in tipc_named_reinit+0x94f/0x9b0
net/tipc/name_distr.c:413
Read of size 8 at addr ffff88805299a000 by task kworker/1:9/23764

CPU: 1 PID: 23764 Comm: kworker/1:9 Not tainted
5.18.0-rc4-syzkaller-00878-g17d49e6e8012 #0
Hardware name: Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Workqueue: events tipc_net_finalize_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495
mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 tipc_named_reinit+0x94f/0x9b0 net/tipc/name_distr.c:413
 tipc_net_finalize+0x234/0x3d0 net/tipc/net.c:138
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
[...]
==================================================================

In the commit
d966ddcc3821 ("tipc: fix a deadlock when flushing scheduled work"),
the cancel_work_sync() function just to make sure ONLY the work
tipc_net_finalize_work() is executing/pending on any CPU completed before
tipc namespace is destroyed through tipc_exit_net(). But this function
is not guaranteed the work is the last queued. So, the destroyed instance
may be accessed in the work which will try to enqueue later.

In order to completely fix, we re-order the calling of cancel_work_sync()
to make sure the work tipc_net_finalize_work() was last queued and it
must be completed by calling cancel_work_sync().

Reported-by: syzbot+47af19f3307fc9c5c82e@syzkaller.appspotmail.com
Fixes: d966ddcc3821 ("tipc: fix a deadlock when flushing scheduled work")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 3f4542e0f065..434e70eabe08 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -109,10 +109,9 @@ static void __net_exit tipc_exit_net(struct net *net)
 	struct tipc_net *tn = tipc_net(net);
 
 	tipc_detach_loopback(net);
+	tipc_net_stop(net);
 	/* Make sure the tipc_net_finalize_work() finished */
 	cancel_work_sync(&tn->work);
-	tipc_net_stop(net);
-
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
-- 
2.35.1



