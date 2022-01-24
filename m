Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549B649967D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376276AbiAXVEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52586 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443867AbiAXU7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:59:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F6D0611C8;
        Mon, 24 Jan 2022 20:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70778C340E5;
        Mon, 24 Jan 2022 20:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057963;
        bh=HfDFm7yT+3wFCLaafSOjs5CNPekh1pVIIpqUt9Zz73c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8t+AcPxp6JRMPRvAY8Ro3tF+yx6LQmy/Ya8sqmG9RRgltW3q/n1jQF92CHFj5zmf
         Y18NdnsEziQaBp1YGesuiGkf6MqOCBU5KdHKFqg7+3kEOzRmoah4LikQclDuSefLSG
         3zBwPimDE8tl3RQRHbqPDStKSoN+Fon3osg7ax0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0137/1039] fs: dlm: dont call kernel_getpeername() in error_report()
Date:   Mon, 24 Jan 2022 19:32:06 +0100
Message-Id: <20220124184129.778627014@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 4c3d90570bcc2b338f70f61f01110268e281ca3c ]

In some cases kernel_getpeername() will held the socket lock which is
already held when the socket layer calls error_report() callback. Since
commit 9dfc685e0262 ("inet: remove races in inet{6}_getname()") this
problem becomes more likely because the socket lock will be held always.
You will see something like:

bob9-u5 login: [  562.316860] BUG: spinlock recursion on CPU#7, swapper/7/0
[  562.318562]  lock: 0xffff8f2284720088, .magic: dead4ead, .owner: swapper/7/0, .owner_cpu: 7
[  562.319522] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 5.15.0+ #135
[  562.320346] Hardware name: Red Hat KVM/RHEL-AV, BIOS 1.13.0-2.module+el8.3.0+7353+9de0a3cc 04/01/2014
[  562.321277] Call Trace:
[  562.321529]  <IRQ>
[  562.321734]  dump_stack_lvl+0x33/0x42
[  562.322282]  do_raw_spin_lock+0x8b/0xc0
[  562.322674]  lock_sock_nested+0x1e/0x50
[  562.323057]  inet_getname+0x39/0x110
[  562.323425]  ? sock_def_readable+0x80/0x80
[  562.323838]  lowcomms_error_report+0x63/0x260 [dlm]
[  562.324338]  ? wait_for_completion_interruptible_timeout+0xd2/0x120
[  562.324949]  ? lock_timer_base+0x67/0x80
[  562.325330]  ? do_raw_spin_unlock+0x49/0xc0
[  562.325735]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
[  562.326218]  ? del_timer+0x54/0x80
[  562.326549]  sk_error_report+0x12/0x70
[  562.326919]  tcp_validate_incoming+0x3c8/0x530
[  562.327347]  ? kvm_clock_read+0x14/0x30
[  562.327718]  ? ktime_get+0x3b/0xa0
[  562.328055]  tcp_rcv_established+0x121/0x660
[  562.328466]  tcp_v4_do_rcv+0x132/0x260
[  562.328835]  tcp_v4_rcv+0xcea/0xe20
[  562.329173]  ip_protocol_deliver_rcu+0x35/0x1f0
[  562.329615]  ip_local_deliver_finish+0x54/0x60
[  562.330050]  ip_local_deliver+0xf7/0x110
[  562.330431]  ? inet_rtm_getroute+0x211/0x840
[  562.330848]  ? ip_protocol_deliver_rcu+0x1f0/0x1f0
[  562.331310]  ip_rcv+0xe1/0xf0
[  562.331603]  ? ip_local_deliver+0x110/0x110
[  562.332011]  __netif_receive_skb_core+0x46a/0x1040
[  562.332476]  ? inet_gro_receive+0x263/0x2e0
[  562.332885]  __netif_receive_skb_list_core+0x13b/0x2c0
[  562.333383]  netif_receive_skb_list_internal+0x1c8/0x2f0
[  562.333896]  ? update_load_avg+0x7e/0x5e0
[  562.334285]  gro_normal_list.part.149+0x19/0x40
[  562.334722]  napi_complete_done+0x67/0x160
[  562.335134]  virtnet_poll+0x2ad/0x408 [virtio_net]
[  562.335644]  __napi_poll+0x28/0x140
[  562.336012]  net_rx_action+0x23d/0x300
[  562.336414]  __do_softirq+0xf2/0x2ea
[  562.336803]  irq_exit_rcu+0xc1/0xf0
[  562.337173]  common_interrupt+0xb9/0xd0

It is and was always forbidden to call kernel_getpeername() in context
of error_report(). To get rid of the problem we access the destination
address for the peer over the socket structure. While on it we fix to
print out the destination port of the inet socket.

Fixes: 1a31833d085a ("DLM: Replace nodeid_to_addr with kernel_getpeername")
Reported-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 8f715c620e1f8..7b1c5f05a988b 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -592,8 +592,8 @@ int dlm_lowcomms_nodes_set_mark(int nodeid, unsigned int mark)
 static void lowcomms_error_report(struct sock *sk)
 {
 	struct connection *con;
-	struct sockaddr_storage saddr;
 	void (*orig_report)(struct sock *) = NULL;
+	struct inet_sock *inet;
 
 	read_lock_bh(&sk->sk_callback_lock);
 	con = sock2con(sk);
@@ -601,33 +601,31 @@ static void lowcomms_error_report(struct sock *sk)
 		goto out;
 
 	orig_report = listen_sock.sk_error_report;
-	if (kernel_getpeername(sk->sk_socket, (struct sockaddr *)&saddr) < 0) {
-		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
-				   "sending to node %d, port %d, "
-				   "sk_err=%d/%d\n", dlm_our_nodeid(),
-				   con->nodeid, dlm_config.ci_tcp_port,
-				   sk->sk_err, sk->sk_err_soft);
-	} else if (saddr.ss_family == AF_INET) {
-		struct sockaddr_in *sin4 = (struct sockaddr_in *)&saddr;
 
+	inet = inet_sk(sk);
+	switch (sk->sk_family) {
+	case AF_INET:
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
-				   "sending to node %d at %pI4, port %d, "
+				   "sending to node %d at %pI4, dport %d, "
 				   "sk_err=%d/%d\n", dlm_our_nodeid(),
-				   con->nodeid, &sin4->sin_addr.s_addr,
-				   dlm_config.ci_tcp_port, sk->sk_err,
+				   con->nodeid, &inet->inet_daddr,
+				   ntohs(inet->inet_dport), sk->sk_err,
 				   sk->sk_err_soft);
-	} else {
-		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&saddr;
-
+		break;
+	case AF_INET6:
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
-				   "sending to node %d at %u.%u.%u.%u, "
-				   "port %d, sk_err=%d/%d\n", dlm_our_nodeid(),
-				   con->nodeid, sin6->sin6_addr.s6_addr32[0],
-				   sin6->sin6_addr.s6_addr32[1],
-				   sin6->sin6_addr.s6_addr32[2],
-				   sin6->sin6_addr.s6_addr32[3],
-				   dlm_config.ci_tcp_port, sk->sk_err,
+				   "sending to node %d at %pI6c, "
+				   "dport %d, sk_err=%d/%d\n", dlm_our_nodeid(),
+				   con->nodeid, &sk->sk_v6_daddr,
+				   ntohs(inet->inet_dport), sk->sk_err,
 				   sk->sk_err_soft);
+		break;
+	default:
+		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
+				   "invalid socket family %d set, "
+				   "sk_err=%d/%d\n", dlm_our_nodeid(),
+				   sk->sk_family, sk->sk_err, sk->sk_err_soft);
+		goto out;
 	}
 
 	/* below sendcon only handling */
-- 
2.34.1



