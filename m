Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B258B1F20B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfEOMAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbfEOLPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 758832084E;
        Wed, 15 May 2019 11:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918899;
        bh=Y7dQ3JoNXOqLMwYaqAhM/oyX57p+juN8prrUDw2nv3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDUhjj4vhdjIi03MKgXMjbGfL0RpVzu3yjC74PN5qXaQ0xvT7uF7a/3+I1epIYNOE
         DtaCzQRw0xJma5xSVBThAVUsNY+oqstCiOsa20TlklCepl0Bz0ut0UDG2rOmTjjehh
         tzIlMArtaZ2wEu4poSOtNLsLtkNHnJwvDAFd4Bb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 43/51] packet: Fix error path in packet_init
Date:   Wed, 15 May 2019 12:56:18 +0200
Message-Id: <20190515090628.491325386@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 36096f2f4fa05f7678bc87397665491700bae757 ]

kernel BUG at lib/list_debug.c:47!
invalid opcode: 0000 [#1
CPU: 0 PID: 12914 Comm: rmmod Tainted: G        W         5.1.0+ #47
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:__list_del_entry_valid+0x53/0x90
Code: 48 8b 32 48 39 fe 75 35 48 8b 50 08 48 39 f2 75 40 b8 01 00 00 00 5d c3 48
89 fe 48 89 c2 48 c7 c7 18 75 fe 82 e8 cb 34 78 ff <0f> 0b 48 89 fe 48 c7 c7 50 75 fe 82 e8 ba 34 78 ff 0f 0b 48 89 f2
RSP: 0018:ffffc90001c2fe40 EFLAGS: 00010286
RAX: 000000000000004e RBX: ffffffffa0184000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff888237a17788 RDI: 00000000ffffffff
RBP: ffffc90001c2fe40 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc90001c2fe10 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90001c2fe50 R14: ffffffffa0184000 R15: 0000000000000000
FS:  00007f3d83634540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555c350ea818 CR3: 0000000231677000 CR4: 00000000000006f0
Call Trace:
 unregister_pernet_operations+0x34/0x120
 unregister_pernet_subsys+0x1c/0x30
 packet_exit+0x1c/0x369 [af_packet
 __x64_sys_delete_module+0x156/0x260
 ? lockdep_hardirqs_on+0x133/0x1b0
 ? do_syscall_64+0x12/0x1f0
 do_syscall_64+0x6e/0x1f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

When modprobe af_packet, register_pernet_subsys
fails and does a cleanup, ops->list is set to LIST_POISON1,
but the module init is considered to success, then while rmmod it,
BUG() is triggered in __list_del_entry_valid which is called from
unregister_pernet_subsys. This patch fix error handing path in
packet_init to avoid possilbe issue if some error occur.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4624,14 +4624,29 @@ static void __exit packet_exit(void)
 
 static int __init packet_init(void)
 {
-	int rc = proto_register(&packet_proto, 0);
+	int rc;
 
-	if (rc != 0)
+	rc = proto_register(&packet_proto, 0);
+	if (rc)
 		goto out;
+	rc = sock_register(&packet_family_ops);
+	if (rc)
+		goto out_proto;
+	rc = register_pernet_subsys(&packet_net_ops);
+	if (rc)
+		goto out_sock;
+	rc = register_netdevice_notifier(&packet_netdev_notifier);
+	if (rc)
+		goto out_pernet;
 
-	sock_register(&packet_family_ops);
-	register_pernet_subsys(&packet_net_ops);
-	register_netdevice_notifier(&packet_netdev_notifier);
+	return 0;
+
+out_pernet:
+	unregister_pernet_subsys(&packet_net_ops);
+out_sock:
+	sock_unregister(PF_PACKET);
+out_proto:
+	proto_unregister(&packet_proto);
 out:
 	return rc;
 }


