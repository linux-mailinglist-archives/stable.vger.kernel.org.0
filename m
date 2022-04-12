Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248B74FD5DE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiDLHTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351680AbiDLHMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2568414001;
        Mon, 11 Apr 2022 23:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4896614EE;
        Tue, 12 Apr 2022 06:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF59C385A1;
        Tue, 12 Apr 2022 06:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746290;
        bh=FMkKOxNXuSPaY8/85RCsgzknjKn0BHCPuz34Amk2MNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBeROiCFAV8HIGjwNpPAQEcJREhp6hIEoJ1g8nWayijtwAPa44KePyIlO9pZesBPq
         rKzHIO+ZND1o3XEnyDtGWZU+6Vv6W1g8ChjqPj5LGPfUZuKM38KdFsTWiXL7MIzrBj
         w+OK9FZr0aNiW5HpUmIDIkxalC6rS/4wROyB1V6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/277] rxrpc: fix a race in rxrpc_exit_net()
Date:   Tue, 12 Apr 2022 08:29:52 +0200
Message-Id: <20220412062947.507150156@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

[ Upstream commit 1946014ca3b19be9e485e780e862c375c6f98bad ]

Current code can lead to the following race:

CPU0                                                 CPU1

rxrpc_exit_net()
                                                     rxrpc_peer_keepalive_worker()
                                                       if (rxnet->live)

  rxnet->live = false;
  del_timer_sync(&rxnet->peer_keepalive_timer);

                                                             timer_reduce(&rxnet->peer_keepalive_timer, jiffies + delay);

  cancel_work_sync(&rxnet->peer_keepalive_work);

rxrpc_exit_net() exits while peer_keepalive_timer is still armed,
leading to use-after-free.

syzbot report was:

ODEBUG: free active (active state 0) object type: timer_list hint: rxrpc_peer_keepalive_timeout+0x0/0xb0
WARNING: CPU: 0 PID: 3660 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 3660 Comm: kworker/u4:6 Not tainted 5.17.0-syzkaller-13993-g88e6c0207623 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 00 1c 26 8a 4c 89 ee 48 c7 c7 00 10 26 8a e8 b1 e7 28 05 <0f> 0b 83 05 15 eb c5 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000353fb00 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff888029196140 RSI: ffffffff815efad8 RDI: fffff520006a7f52
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ea4ae R11: 0000000000000000 R12: ffffffff89ce23e0
R13: ffffffff8a2614e0 R14: ffffffff816628c0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe1f2908924 CR3: 0000000043720000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:992 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1023
 kfree+0xd6/0x310 mm/slab.c:3809
 ops_free_list.part.0+0x119/0x370 net/core/net_namespace.c:176
 ops_free_list net/core/net_namespace.c:174 [inline]
 cleanup_net+0x591/0xb00 net/core/net_namespace.c:598
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Fixes: ace45bec6d77 ("rxrpc: Fix firewall route keepalive")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: linux-afs@lists.infradead.org
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/net_ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 25bbc4cc8b13..f15d6942da45 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -113,8 +113,8 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 
 	rxnet->live = false;
-	del_timer_sync(&rxnet->peer_keepalive_timer);
 	cancel_work_sync(&rxnet->peer_keepalive_work);
+	del_timer_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);
 	rxrpc_destroy_all_peers(rxnet);
-- 
2.35.1



