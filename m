Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E083029B96B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802467AbgJ0PtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796410AbgJ0PSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7342E22275;
        Tue, 27 Oct 2020 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811887;
        bh=WfdT05M5ASBxeU9VIdB7eIjwd+5z3IIS5pHNdGtx2y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnnwmdYtXge6ddbrt3Z3IKPbAhYXX+pt+pEG87JY4szayWN9YK4ZjK3rFA26WmH/q
         kqpYxX2vqyDlUN5Fclx+mE5OpXENiy3mAeCF0xDM2uRUGkCTcUmw7Fi3biDqOC7hKd
         F1/4cpF+enFn564XUnXP81LFiOL2rgfbN4u2r+kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Huu Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 018/757] tipc: fix NULL pointer dereference in tipc_named_rcv
Date:   Tue, 27 Oct 2020 14:44:28 +0100
Message-Id: <20201027135451.373210630@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Huu Le <hoang.h.le@dektech.com.au>

[ Upstream commit 7b50ee3dad2581dc022b4e32e55964d4fcdccf20 ]

In the function node_lost_contact(), we call __skb_queue_purge() without
grabbing the list->lock. This can cause to a race-condition why processing
the list 'namedq' in calling path tipc_named_rcv()->tipc_named_dequeue().

    [] BUG: kernel NULL pointer dereference, address: 0000000000000000
    [] #PF: supervisor read access in kernel mode
    [] #PF: error_code(0x0000) - not-present page
    [] PGD 7ca63067 P4D 7ca63067 PUD 6c553067 PMD 0
    [] Oops: 0000 [#1] SMP NOPTI
    [] CPU: 1 PID: 15 Comm: ksoftirqd/1 Tainted: G  O  5.9.0-rc6+ #2
    [] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS [...]
    [] RIP: 0010:tipc_named_rcv+0x103/0x320 [tipc]
    [] Code: 41 89 44 24 10 49 8b 16 49 8b 46 08 49 c7 06 00 00 00 [...]
    [] RSP: 0018:ffffc900000a7c58 EFLAGS: 00000282
    [] RAX: 00000000000012ec RBX: 0000000000000000 RCX: ffff88807bde1270
    [] RDX: 0000000000002c7c RSI: 0000000000002c7c RDI: ffff88807b38f1a8
    [] RBP: ffff88807b006288 R08: ffff88806a367800 R09: ffff88806a367900
    [] R10: ffff88806a367a00 R11: ffff88806a367b00 R12: ffff88807b006258
    [] R13: ffff88807b00628a R14: ffff888069334d00 R15: ffff88806a434600
    [] FS:  0000000000000000(0000) GS:ffff888079480000(0000) knlGS:0[...]
    [] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [] CR2: 0000000000000000 CR3: 0000000077320000 CR4: 00000000000006e0
    [] Call Trace:
    []  ? tipc_bcast_rcv+0x9a/0x1a0 [tipc]
    []  tipc_rcv+0x40d/0x670 [tipc]
    []  ? _raw_spin_unlock+0xa/0x20
    []  tipc_l2_rcv_msg+0x55/0x80 [tipc]
    []  __netif_receive_skb_one_core+0x8c/0xa0
    []  process_backlog+0x98/0x140
    []  net_rx_action+0x13a/0x420
    []  __do_softirq+0xdb/0x316
    []  ? smpboot_thread_fn+0x2f/0x1e0
    []  ? smpboot_thread_fn+0x74/0x1e0
    []  ? smpboot_thread_fn+0x14e/0x1e0
    []  run_ksoftirqd+0x1a/0x40
    []  smpboot_thread_fn+0x149/0x1e0
    []  ? sort_range+0x20/0x20
    []  kthread+0x131/0x150
    []  ? kthread_unuse_mm+0xa0/0xa0
    []  ret_from_fork+0x22/0x30
    [] Modules linked in: veth tipc(O) ip6_udp_tunnel udp_tunnel [...]
    [] CR2: 0000000000000000
    [] ---[ end trace 65c276a8e2e2f310 ]---

To fix this, we need to grab the lock of the 'namedq' list on both
path calling.

Fixes: cad2929dc432 ("tipc: update a binding service via broadcast")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/name_distr.c |   10 +++++++++-
 net/tipc/node.c       |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -327,8 +327,13 @@ static struct sk_buff *tipc_named_dequeu
 	struct tipc_msg *hdr;
 	u16 seqno;
 
+	spin_lock_bh(&namedq->lock);
 	skb_queue_walk_safe(namedq, skb, tmp) {
-		skb_linearize(skb);
+		if (unlikely(skb_linearize(skb))) {
+			__skb_unlink(skb, namedq);
+			kfree_skb(skb);
+			continue;
+		}
 		hdr = buf_msg(skb);
 		seqno = msg_named_seqno(hdr);
 		if (msg_is_last_bulk(hdr)) {
@@ -338,12 +343,14 @@ static struct sk_buff *tipc_named_dequeu
 
 		if (msg_is_bulk(hdr) || msg_is_legacy(hdr)) {
 			__skb_unlink(skb, namedq);
+			spin_unlock_bh(&namedq->lock);
 			return skb;
 		}
 
 		if (*open && (*rcv_nxt == seqno)) {
 			(*rcv_nxt)++;
 			__skb_unlink(skb, namedq);
+			spin_unlock_bh(&namedq->lock);
 			return skb;
 		}
 
@@ -353,6 +360,7 @@ static struct sk_buff *tipc_named_dequeu
 			continue;
 		}
 	}
+	spin_unlock_bh(&namedq->lock);
 	return NULL;
 }
 
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1485,7 +1485,7 @@ static void node_lost_contact(struct tip
 
 	/* Clean up broadcast state */
 	tipc_bcast_remove_peer(n->net, n->bc_entry.link);
-	__skb_queue_purge(&n->bc_entry.namedq);
+	skb_queue_purge(&n->bc_entry.namedq);
 
 	/* Abort any ongoing link failover */
 	for (i = 0; i < MAX_BEARERS; i++) {


