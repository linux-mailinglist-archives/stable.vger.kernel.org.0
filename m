Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA35472744
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240063AbhLMJ7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbhLMJ5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:57:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D30EC0698C9;
        Mon, 13 Dec 2021 01:47:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 58EC5CE0E77;
        Mon, 13 Dec 2021 09:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02721C00446;
        Mon, 13 Dec 2021 09:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388870;
        bh=ZCi3VYGLr++m2kLUiC9I153EB7GFabp2p1TjFz4z43w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtaKqppimHnPoZoP1bm4pF3h50ZYCDEb0/HASPbHwkBQkVIOkXmiYi7RvoLL2Y/WG
         ucrnODzjfj6QI2rgRQCnEFNjMRV0FX86bCHT+6vQEf4oQg9dkywqLwrGLeHzwxoOTJ
         F/8nXRwQtZF/qq58TTN8bwymPDk6lRM/IrIo62Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 037/132] netfilter: conntrack: annotate data-races around ct->timeout
Date:   Mon, 13 Dec 2021 10:29:38 +0100
Message-Id: <20211213092940.399992034@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 802a7dc5cf1bef06f7b290ce76d478138408d6b1 upstream.

(struct nf_conn)->timeout can be read/written locklessly,
add READ_ONCE()/WRITE_ONCE() to prevent load/store tearing.

BUG: KCSAN: data-race in __nf_conntrack_alloc / __nf_conntrack_find_get

write to 0xffff888132e78c08 of 4 bytes by task 6029 on cpu 0:
 __nf_conntrack_alloc+0x158/0x280 net/netfilter/nf_conntrack_core.c:1563
 init_conntrack+0x1da/0xb30 net/netfilter/nf_conntrack_core.c:1635
 resolve_normal_ct+0x502/0x610 net/netfilter/nf_conntrack_core.c:1746
 nf_conntrack_in+0x1c5/0x88f net/netfilter/nf_conntrack_core.c:1901
 ipv6_conntrack_local+0x19/0x20 net/netfilter/nf_conntrack_proto.c:414
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0x72/0x170 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0xa3a/0xa60 net/ipv6/ip6_output.c:324
 inet6_csk_xmit+0x1a2/0x1e0 net/ipv6/inet6_connection_sock.c:135
 __tcp_transmit_skb+0x132a/0x1840 net/ipv4/tcp_output.c:1402
 tcp_transmit_skb net/ipv4/tcp_output.c:1420 [inline]
 tcp_write_xmit+0x1450/0x4460 net/ipv4/tcp_output.c:2680
 __tcp_push_pending_frames+0x68/0x1c0 net/ipv4/tcp_output.c:2864
 tcp_push_pending_frames include/net/tcp.h:1897 [inline]
 tcp_data_snd_check+0x62/0x2e0 net/ipv4/tcp_input.c:5452
 tcp_rcv_established+0x880/0x10e0 net/ipv4/tcp_input.c:5947
 tcp_v6_do_rcv+0x36e/0xa50 net/ipv6/tcp_ipv6.c:1521
 sk_backlog_rcv include/net/sock.h:1030 [inline]
 __release_sock+0xf2/0x270 net/core/sock.c:2768
 release_sock+0x40/0x110 net/core/sock.c:3300
 sk_stream_wait_memory+0x435/0x700 net/core/stream.c:145
 tcp_sendmsg_locked+0xb85/0x25a0 net/ipv4/tcp.c:1402
 tcp_sendmsg+0x2c/0x40 net/ipv4/tcp.c:1440
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:644
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 __sys_sendto+0x21e/0x2c0 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0x74/0x90 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888132e78c08 of 4 bytes by task 17446 on cpu 1:
 nf_ct_is_expired include/net/netfilter/nf_conntrack.h:286 [inline]
 ____nf_conntrack_find net/netfilter/nf_conntrack_core.c:776 [inline]
 __nf_conntrack_find_get+0x1c7/0xac0 net/netfilter/nf_conntrack_core.c:807
 resolve_normal_ct+0x273/0x610 net/netfilter/nf_conntrack_core.c:1734
 nf_conntrack_in+0x1c5/0x88f net/netfilter/nf_conntrack_core.c:1901
 ipv6_conntrack_local+0x19/0x20 net/netfilter/nf_conntrack_proto.c:414
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0x72/0x170 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0xa3a/0xa60 net/ipv6/ip6_output.c:324
 inet6_csk_xmit+0x1a2/0x1e0 net/ipv6/inet6_connection_sock.c:135
 __tcp_transmit_skb+0x132a/0x1840 net/ipv4/tcp_output.c:1402
 __tcp_send_ack+0x1fd/0x300 net/ipv4/tcp_output.c:3956
 tcp_send_ack+0x23/0x30 net/ipv4/tcp_output.c:3962
 __tcp_ack_snd_check+0x2d8/0x510 net/ipv4/tcp_input.c:5478
 tcp_ack_snd_check net/ipv4/tcp_input.c:5523 [inline]
 tcp_rcv_established+0x8c2/0x10e0 net/ipv4/tcp_input.c:5948
 tcp_v6_do_rcv+0x36e/0xa50 net/ipv6/tcp_ipv6.c:1521
 sk_backlog_rcv include/net/sock.h:1030 [inline]
 __release_sock+0xf2/0x270 net/core/sock.c:2768
 release_sock+0x40/0x110 net/core/sock.c:3300
 tcp_sendpage+0x94/0xb0 net/ipv4/tcp.c:1114
 inet_sendpage+0x7f/0xc0 net/ipv4/af_inet.c:833
 rds_tcp_xmit+0x376/0x5f0 net/rds/tcp_send.c:118
 rds_send_xmit+0xbed/0x1500 net/rds/send.c:367
 rds_send_worker+0x43/0x200 net/rds/threads.c:200
 process_one_work+0x3fc/0x980 kernel/workqueue.c:2298
 worker_thread+0x616/0xa70 kernel/workqueue.c:2445
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x00027cc2 -> 0x00000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 17446 Comm: kworker/u4:5 Tainted: G        W         5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: krdsd rds_send_worker

Note: I chose an arbitrary commit for the Fixes: tag,
because I do not think we need to backport this fix to very old kernels.

Fixes: e37542ba111f ("netfilter: conntrack: avoid possible false sharing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_conntrack.h |    6 +++---
 net/netfilter/nf_conntrack_core.c    |    6 +++---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 net/netfilter/nf_flow_table_core.c   |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -262,14 +262,14 @@ static inline bool nf_is_loopback_packet
 /* jiffies until ct expires, 0 if already expired */
 static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
 {
-	s32 timeout = ct->timeout - nfct_time_stamp;
+	s32 timeout = READ_ONCE(ct->timeout) - nfct_time_stamp;
 
 	return timeout > 0 ? timeout : 0;
 }
 
 static inline bool nf_ct_is_expired(const struct nf_conn *ct)
 {
-	return (__s32)(ct->timeout - nfct_time_stamp) <= 0;
+	return (__s32)(READ_ONCE(ct->timeout) - nfct_time_stamp) <= 0;
 }
 
 /* use after obtaining a reference count */
@@ -288,7 +288,7 @@ static inline bool nf_ct_should_gc(const
 static inline void nf_ct_offload_timeout(struct nf_conn *ct)
 {
 	if (nf_ct_expires(ct) < NF_CT_DAY / 2)
-		ct->timeout = nfct_time_stamp + NF_CT_DAY;
+		WRITE_ONCE(ct->timeout, nfct_time_stamp + NF_CT_DAY);
 }
 
 struct kernel_param;
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -660,7 +660,7 @@ bool nf_ct_delete(struct nf_conn *ct, u3
 
 	tstamp = nf_conn_tstamp_find(ct);
 	if (tstamp) {
-		s32 timeout = ct->timeout - nfct_time_stamp;
+		s32 timeout = READ_ONCE(ct->timeout) - nfct_time_stamp;
 
 		tstamp->stop = ktime_get_real_ns();
 		if (timeout < 0)
@@ -980,7 +980,7 @@ static int nf_ct_resolve_clash_harder(st
 	}
 
 	/* We want the clashing entry to go away real soon: 1 second timeout. */
-	loser_ct->timeout = nfct_time_stamp + HZ;
+	WRITE_ONCE(loser_ct->timeout, nfct_time_stamp + HZ);
 
 	/* IPS_NAT_CLASH removes the entry automatically on the first
 	 * reply.  Also prevents UDP tracker from moving the entry to
@@ -1487,7 +1487,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* save hash for reusing when confirming */
 	*(unsigned long *)(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev) = hash;
 	ct->status = 0;
-	ct->timeout = 0;
+	WRITE_ONCE(ct->timeout, 0);
 	write_pnet(&ct->ct_net, net);
 	memset(&ct->__nfct_init_offset, 0,
 	       offsetof(struct nf_conn, proto) -
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1971,7 +1971,7 @@ static int ctnetlink_change_timeout(stru
 
 	if (timeout > INT_MAX)
 		timeout = INT_MAX;
-	ct->timeout = nfct_time_stamp + (u32)timeout;
+	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
 
 	if (test_bit(IPS_DYING_BIT, &ct->status))
 		return -ETIME;
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -151,8 +151,8 @@ static void flow_offload_fixup_ct_timeou
 	else
 		return;
 
-	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
-		ct->timeout = nfct_time_stamp + timeout;
+	if (nf_flow_timeout_delta(READ_ONCE(ct->timeout)) > (__s32)timeout)
+		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
 }
 
 static void flow_offload_fixup_ct_state(struct nf_conn *ct)


