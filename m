Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AC6412634
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354903AbhITS4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385370AbhITSuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACE0863374;
        Mon, 20 Sep 2021 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159270;
        bh=8fR27W3LwFwfJofhmLkrZT1JT2M2NajNDXYUWX4vJ1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jls16joNCJV4rGqTq9xk9BRigeYqkSkHZixoNDYEZkDAQPIBg6rXvXcJXuW1RD7+b
         nPrUKyKX0wifVR8l+FiE3hupKntxV3TT8svZwMZ4GjPTTDQAzvwE0r1TJo/ZcBJKSp
         aquMB/zQZk9PdaBHRYI+q58TMcXfF9J6oXz4Lp+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliangtang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 154/168] mptcp: Only send extra TCP acks in eligible socket states
Date:   Mon, 20 Sep 2021 18:44:52 +0200
Message-Id: <20210920163926.730134578@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

[ Upstream commit 340fa6667a696338e707cd5531a9631093d1be29 ]

Recent changes exposed a bug where specifically-timed requests to the
path manager netlink API could trigger a divide-by-zero in
__tcp_select_window(), as syzkaller does:

divide error: 0000 [#1] SMP KASAN NOPTI
CPU: 0 PID: 9667 Comm: syz-executor.0 Not tainted 5.14.0-rc6+ #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:__tcp_select_window+0x509/0xa60 net/ipv4/tcp_output.c:3016
Code: 44 89 ff e8 c9 29 e9 fd 45 39 e7 0f 8d 20 ff ff ff e8 db 28 e9 fd 44 89 e3 e9 13 ff ff ff e8 ce 28 e9 fd 44 89 e0 44 89 e3 99 <f7> 7c 24 04 29 d3 e9 fc fe ff ff e8 b7 28 e9 fd 44 89 f1 48 89 ea
RSP: 0018:ffff888031ccf020 EFLAGS: 00010216
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000040000
RDX: 0000000000000000 RSI: ffff88811532c080 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff835807c2 R09: 0000000000000000
R10: 0000000000000004 R11: ffffed1020b92441 R12: 0000000000000000
R13: 1ffff11006399e08 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fa4c8344700(0000) GS:ffff88811ae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f424000 CR3: 000000003e4e2003 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 tcp_select_window net/ipv4/tcp_output.c:264 [inline]
 __tcp_transmit_skb+0xc00/0x37a0 net/ipv4/tcp_output.c:1351
 __tcp_send_ack.part.0+0x3ec/0x760 net/ipv4/tcp_output.c:3972
 __tcp_send_ack net/ipv4/tcp_output.c:3978 [inline]
 tcp_send_ack+0x7d/0xa0 net/ipv4/tcp_output.c:3978
 mptcp_pm_nl_addr_send_ack+0x1ab/0x380 net/mptcp/pm_netlink.c:654
 mptcp_pm_remove_addr+0x161/0x200 net/mptcp/pm.c:58
 mptcp_nl_remove_id_zero_address+0x197/0x460 net/mptcp/pm_netlink.c:1328
 mptcp_nl_cmd_del_addr+0x98b/0xd40 net/mptcp/pm_netlink.c:1359
 genl_family_rcv_msg_doit.isra.0+0x225/0x340 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x341/0x5b0 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x148/0x430 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x537/0x750 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x846/0xd80 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0x14e/0x190 net/socket.c:724
 ____sys_sendmsg+0x709/0x870 net/socket.c:2403
 ___sys_sendmsg+0xff/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

mptcp_pm_nl_addr_send_ack() was attempting to send a TCP ACK on the
first subflow in the MPTCP socket's connection list without validating
that the subflow was in a suitable connection state. To address this,
always validate subflow state when sending extra ACKs on subflows
for address advertisement or subflow priority change.

Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/229
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 10 ++--------
 net/mptcp/protocol.c   | 21 ++++++++++++---------
 net/mptcp/protocol.h   |  1 +
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7b3794459783..89251cbe9f1a 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -540,7 +540,6 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
 	if (subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow;
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for %s%s%s",
@@ -548,9 +547,7 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 			 mptcp_pm_should_add_signal_ipv6(msk) ? " [ipv6]" : "",
 			 mptcp_pm_should_add_signal_port(msk) ? " [port]" : "");
 
-		slow = lock_sock_fast(ssk);
-		tcp_send_ack(ssk);
-		unlock_sock_fast(ssk, slow);
+		mptcp_subflow_send_ack(ssk);
 		spin_lock_bh(&msk->pm.lock);
 	}
 }
@@ -567,7 +564,6 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
-		bool slow;
 
 		local_address((struct sock_common *)ssk, &local);
 		if (!addresses_equal(&local, addr, addr->port))
@@ -580,9 +576,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for mp_prio");
-		slow = lock_sock_fast(ssk);
-		tcp_send_ack(ssk);
-		unlock_sock_fast(ssk, slow);
+		mptcp_subflow_send_ack(ssk);
 		spin_lock_bh(&msk->pm.lock);
 
 		return 0;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c018b591db0b..acbead7cf50f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -427,19 +427,22 @@ static bool tcp_can_send_ack(const struct sock *ssk)
 	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE | TCPF_LISTEN));
 }
 
+void mptcp_subflow_send_ack(struct sock *ssk)
+{
+	bool slow;
+
+	slow = lock_sock_fast(ssk);
+	if (tcp_can_send_ack(ssk))
+		tcp_send_ack(ssk);
+	unlock_sock_fast(ssk, slow);
+}
+
 static void mptcp_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow;
-
-		slow = lock_sock_fast(ssk);
-		if (tcp_can_send_ack(ssk))
-			tcp_send_ack(ssk);
-		unlock_sock_fast(ssk, slow);
-	}
+	mptcp_for_each_subflow(msk, subflow)
+		mptcp_subflow_send_ack(mptcp_subflow_tcp_sock(subflow));
 }
 
 static void mptcp_subflow_cleanup_rbuf(struct sock *ssk)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0f0c026c5f8b..6ac564d584c1 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -560,6 +560,7 @@ void __init mptcp_subflow_init(void);
 void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
+void mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
-- 
2.30.2



