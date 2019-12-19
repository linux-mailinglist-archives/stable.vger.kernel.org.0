Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80E4126D2A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfLSTJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbfLSSk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39F3206D7;
        Thu, 19 Dec 2019 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780858;
        bh=rfIC0ZStgrhv1LNPvkfYQ7AgxHcpJY0t1tyAg4iBhwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4GQpI8Gee2NgCMOPIzny2tbZ83kskPoDBgMb9OCz6DzAfjfEbKIm7tc5JWhjCXsn
         BtS3fxqnqQh2CQL8RQCRCgSZSfODydk2JlUxxX12v0YftI5ROYYK1gD1RhngkmSEOh
         E7hDdiUoXEjMIpEPzx6v7jyN3t6449ak5WTifo5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 145/162] tipc: fix ordering of tipc module init and exit routine
Date:   Thu, 19 Dec 2019 19:34:13 +0100
Message-Id: <20191219183216.594655264@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 9cf1cd8ee3ee09ef2859017df2058e2f53c5347f ]

In order to set/get/dump, the tipc uses the generic netlink
infrastructure. So, when tipc module is inserted, init function
calls genl_register_family().
After genl_register_family(), set/get/dump commands are immediately
allowed and these callbacks internally use the net_generic.
net_generic is allocated by register_pernet_device() but this
is called after genl_register_family() in the __init function.
So, these callbacks would use un-initialized net_generic.

Test commands:
    #SHELL1
    while :
    do
        modprobe tipc
        modprobe -rv tipc
    done

    #SHELL2
    while :
    do
        tipc link list
    done

Splat looks like:
[   59.616322][ T2788] kasan: CONFIG_KASAN_INLINE enabled
[   59.617234][ T2788] kasan: GPF could be caused by NULL-ptr deref or user memory access
[   59.618398][ T2788] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   59.619389][ T2788] CPU: 3 PID: 2788 Comm: tipc Not tainted 5.4.0+ #194
[   59.620231][ T2788] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   59.621428][ T2788] RIP: 0010:tipc_bcast_get_broadcast_mode+0x131/0x310 [tipc]
[   59.622379][ T2788] Code: c7 c6 ef 8b 38 c0 65 ff 0d 84 83 c9 3f e8 d7 a5 f2 e3 48 8d bb 38 11 00 00 48 b8 00 00 00 00
[   59.622550][ T2780] NET: Registered protocol family 30
[   59.624627][ T2788] RSP: 0018:ffff88804b09f578 EFLAGS: 00010202
[   59.624630][ T2788] RAX: dffffc0000000000 RBX: 0000000000000011 RCX: 000000008bc66907
[   59.624631][ T2788] RDX: 0000000000000229 RSI: 000000004b3cf4cc RDI: 0000000000001149
[   59.624633][ T2788] RBP: ffff88804b09f588 R08: 0000000000000003 R09: fffffbfff4fb3df1
[   59.624635][ T2788] R10: fffffbfff50318f8 R11: ffff888066cadc18 R12: ffffffffa6cc2f40
[   59.624637][ T2788] R13: 1ffff11009613eba R14: ffff8880662e9328 R15: ffff8880662e9328
[   59.624639][ T2788] FS:  00007f57d8f7b740(0000) GS:ffff88806cc00000(0000) knlGS:0000000000000000
[   59.624645][ T2788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.625875][ T2780] tipc: Started in single node mode
[   59.626128][ T2788] CR2: 00007f57d887a8c0 CR3: 000000004b140002 CR4: 00000000000606e0
[   59.633991][ T2788] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.635195][ T2788] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   59.636478][ T2788] Call Trace:
[   59.637025][ T2788]  tipc_nl_add_bc_link+0x179/0x1470 [tipc]
[   59.638219][ T2788]  ? lock_downgrade+0x6e0/0x6e0
[   59.638923][ T2788]  ? __tipc_nl_add_link+0xf90/0xf90 [tipc]
[   59.639533][ T2788]  ? tipc_nl_node_dump_link+0x318/0xa50 [tipc]
[   59.640160][ T2788]  ? mutex_lock_io_nested+0x1380/0x1380
[   59.640746][ T2788]  tipc_nl_node_dump_link+0x4fd/0xa50 [tipc]
[   59.641356][ T2788]  ? tipc_nl_node_reset_link_stats+0x340/0x340 [tipc]
[   59.642088][ T2788]  ? __skb_ext_del+0x270/0x270
[   59.642594][ T2788]  genl_lock_dumpit+0x85/0xb0
[   59.643050][ T2788]  netlink_dump+0x49c/0xed0
[   59.643529][ T2788]  ? __netlink_sendskb+0xc0/0xc0
[   59.644044][ T2788]  ? __netlink_dump_start+0x190/0x800
[   59.644617][ T2788]  ? __mutex_unlock_slowpath+0xd0/0x670
[   59.645177][ T2788]  __netlink_dump_start+0x5a0/0x800
[   59.645692][ T2788]  genl_rcv_msg+0xa75/0xe90
[   59.646144][ T2788]  ? __lock_acquire+0xdfe/0x3de0
[   59.646692][ T2788]  ? genl_family_rcv_msg_attrs_parse+0x320/0x320
[   59.647340][ T2788]  ? genl_lock_dumpit+0xb0/0xb0
[   59.647821][ T2788]  ? genl_unlock+0x20/0x20
[   59.648290][ T2788]  ? genl_parallel_done+0xe0/0xe0
[   59.648787][ T2788]  ? find_held_lock+0x39/0x1d0
[   59.649276][ T2788]  ? genl_rcv+0x15/0x40
[   59.649722][ T2788]  ? lock_contended+0xcd0/0xcd0
[   59.650296][ T2788]  netlink_rcv_skb+0x121/0x350
[   59.650828][ T2788]  ? genl_family_rcv_msg_attrs_parse+0x320/0x320
[   59.651491][ T2788]  ? netlink_ack+0x940/0x940
[   59.651953][ T2788]  ? lock_acquire+0x164/0x3b0
[   59.652449][ T2788]  genl_rcv+0x24/0x40
[   59.652841][ T2788]  netlink_unicast+0x421/0x600
[ ... ]

Fixes: 7e4369057806 ("tipc: fix a slab object leak")
Fixes: a62fbccecd62 ("tipc: make subscriber server support net namespace")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/core.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -117,14 +117,6 @@ static int __init tipc_init(void)
 			      TIPC_CRITICAL_IMPORTANCE;
 	sysctl_tipc_rmem[2] = TIPC_CONN_OVERLOAD_LIMIT;
 
-	err = tipc_netlink_start();
-	if (err)
-		goto out_netlink;
-
-	err = tipc_netlink_compat_start();
-	if (err)
-		goto out_netlink_compat;
-
 	err = tipc_register_sysctl();
 	if (err)
 		goto out_sysctl;
@@ -145,8 +137,21 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_bearer;
 
+	err = tipc_netlink_start();
+	if (err)
+		goto out_netlink;
+
+	err = tipc_netlink_compat_start();
+	if (err)
+		goto out_netlink_compat;
+
 	pr_info("Started in single node mode\n");
 	return 0;
+
+out_netlink_compat:
+	tipc_netlink_stop();
+out_netlink:
+	tipc_bearer_cleanup();
 out_bearer:
 	unregister_pernet_device(&tipc_topsrv_net_ops);
 out_pernet_topsrv:
@@ -156,22 +161,18 @@ out_socket:
 out_pernet:
 	tipc_unregister_sysctl();
 out_sysctl:
-	tipc_netlink_compat_stop();
-out_netlink_compat:
-	tipc_netlink_stop();
-out_netlink:
 	pr_err("Unable to start in single node mode\n");
 	return err;
 }
 
 static void __exit tipc_exit(void)
 {
+	tipc_netlink_compat_stop();
+	tipc_netlink_stop();
 	tipc_bearer_cleanup();
 	unregister_pernet_device(&tipc_topsrv_net_ops);
 	tipc_socket_stop();
 	unregister_pernet_device(&tipc_net_ops);
-	tipc_netlink_stop();
-	tipc_netlink_compat_stop();
 	tipc_unregister_sysctl();
 
 	pr_info("Deactivated\n");


