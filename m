Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40AFC187EDF
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCQK4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgCQK4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:56:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8531120658;
        Tue, 17 Mar 2020 10:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442609;
        bh=8xlKHdXcq50TQeiNRTSWq5J8dLMcb8V8kxTFARwmYh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olPG9Jj2NkxPmKOnjPJIHVczvKWvXrzKFkEFOkvHSI2vVJI3eFW3XoOt7kQ+qOmMN
         IK55AJuXWE5m1+eN+rhd91TF42Ot2Cnjrb8TGUo1a5IPhpzmdNah7P44XZVGSIogKh
         grxkfwTWrU88nYdY23zuWtj5VwRZYN8BpEXND/Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 21/89] cgroup: memcg: net: do not associate sock with unrelated cgroup
Date:   Tue, 17 Mar 2020 11:54:30 +0100
Message-Id: <20200317103302.430176101@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit e876ecc67db80dfdb8e237f71e5b43bb88ae549c ]

We are testing network memory accounting in our setup and noticed
inconsistent network memory usage and often unrelated cgroups network
usage correlates with testing workload. On further inspection, it
seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
irq context specially for cgroup v1.

mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in irq context
and kind of assumes that this can only happen from sk_clone_lock()
and the source sock object has already associated cgroup. However in
cgroup v1, where network memory accounting is opt-in, the source sock
can be unassociated with any cgroup and the new cloned sock can get
associated with unrelated interrupted cgroup.

Cgroup v2 can also suffer if the source sock object was created by
process in the root cgroup or if sk_alloc() is called in irq context.
The fix is to just do nothing in interrupt.

WARNING: Please note that about half of the TCP sockets are allocated
from the IRQ context, so, memory used by such sockets will not be
accouted by the memcg.

The stack trace of mem_cgroup_sk_alloc() from IRQ-context:

CPU: 70 PID: 12720 Comm: ssh Tainted:  5.6.0-smp-DEV #1
Hardware name: ...
Call Trace:
 <IRQ>
 dump_stack+0x57/0x75
 mem_cgroup_sk_alloc+0xe9/0xf0
 sk_clone_lock+0x2a7/0x420
 inet_csk_clone_lock+0x1b/0x110
 tcp_create_openreq_child+0x23/0x3b0
 tcp_v6_syn_recv_sock+0x88/0x730
 tcp_check_req+0x429/0x560
 tcp_v6_rcv+0x72d/0xa40
 ip6_protocol_deliver_rcu+0xc9/0x400
 ip6_input+0x44/0xd0
 ? ip6_protocol_deliver_rcu+0x400/0x400
 ip6_rcv_finish+0x71/0x80
 ipv6_rcv+0x5b/0xe0
 ? ip6_sublist_rcv+0x2e0/0x2e0
 process_backlog+0x108/0x1e0
 net_rx_action+0x26b/0x460
 __do_softirq+0x104/0x2a6
 do_softirq_own_stack+0x2a/0x40
 </IRQ>
 do_softirq.part.19+0x40/0x50
 __local_bh_enable_ip+0x51/0x60
 ip6_finish_output2+0x23d/0x520
 ? ip6table_mangle_hook+0x55/0x160
 __ip6_finish_output+0xa1/0x100
 ip6_finish_output+0x30/0xd0
 ip6_output+0x73/0x120
 ? __ip6_finish_output+0x100/0x100
 ip6_xmit+0x2e3/0x600
 ? ipv6_anycast_cleanup+0x50/0x50
 ? inet6_csk_route_socket+0x136/0x1e0
 ? skb_free_head+0x1e/0x30
 inet6_csk_xmit+0x95/0xf0
 __tcp_transmit_skb+0x5b4/0xb20
 __tcp_send_ack.part.60+0xa3/0x110
 tcp_send_ack+0x1d/0x20
 tcp_rcv_state_process+0xe64/0xe80
 ? tcp_v6_connect+0x5d1/0x5f0
 tcp_v6_do_rcv+0x1b1/0x3f0
 ? tcp_v6_do_rcv+0x1b1/0x3f0
 __release_sock+0x7f/0xd0
 release_sock+0x30/0xa0
 __inet_stream_connect+0x1c3/0x3b0
 ? prepare_to_wait+0xb0/0xb0
 inet_stream_connect+0x3b/0x60
 __sys_connect+0x101/0x120
 ? __sys_getsockopt+0x11b/0x140
 __x64_sys_connect+0x1a/0x20
 do_syscall_64+0x51/0x200
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The stack trace of mem_cgroup_sk_alloc() from IRQ-context:
Fixes: 2d7580738345 ("mm: memcontrol: consolidate cgroup socket tracking")
Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    4 ++++
 mm/memcontrol.c        |    4 ++++
 2 files changed, 8 insertions(+)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5929,6 +5929,10 @@ void cgroup_sk_alloc(struct sock_cgroup_
 		return;
 	}
 
+	/* Don't associate the sock with unrelated interrupted task's cgroup. */
+	if (in_interrupt())
+		return;
+
 	rcu_read_lock();
 
 	while (true) {
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6321,6 +6321,10 @@ void mem_cgroup_sk_alloc(struct sock *sk
 		return;
 	}
 
+	/* Do not associate the sock with unrelated interrupted task's memcg. */
+	if (in_interrupt())
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)


