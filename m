Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B1119918B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbgCaJPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730053AbgCaJPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B0A20675;
        Tue, 31 Mar 2020 09:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646101;
        bh=1VG/tF9yU2HVXP/pl1hlDlKu/JefqFpwrgN50wgIWOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqtcPovi/uIpuxxiagzC7qJDL0CUf49h1iDypIfIA/4HOlm7kH0GdJl8D+Cu0KWKx
         K8OJpreMwjg7TVkrbBSWAQyQhmJdAWNsGIvf+CqJvRxwuJV9R10/UUs2iY+KCN7vj8
         slNfJrzAK22/N9gE1OFkp1RMzBgIYwRNsY16IypQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jason Gunthorpe <jgg@mellanox.com>,
        syzbot+da615ac67d4dbea32cbc@syzkaller.appspotmail.com
Subject: [PATCH 5.4 084/155] RDMA/nl: Do not permit empty devices names during RDMA_NLDEV_CMD_NEWLINK/SET
Date:   Tue, 31 Mar 2020 10:58:44 +0200
Message-Id: <20200331085427.687237294@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 7aefa6237cfe4a6fcf06a8656eee988b36f8fefc upstream.

Empty device names cannot be added to sysfs and crash with:

  kobject: (00000000f9de3792): attempted to be registered with empty name!
  WARNING: CPU: 1 PID: 10856 at lib/kobject.c:234 kobject_add_internal+0x7ac/0x9a0 lib/kobject.c:234
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 1 PID: 10856 Comm: syz-executor459 Not tainted 5.6.0-rc3-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x197/0x210 lib/dump_stack.c:118
   panic+0x2e3/0x75c kernel/panic.c:221
   __warn.cold+0x2f/0x3e kernel/panic.c:582
   report_bug+0x289/0x300 lib/bug.c:195
   fixup_bug arch/x86/kernel/traps.c:174 [inline]
   fixup_bug arch/x86/kernel/traps.c:169 [inline]
   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
  RIP: 0010:kobject_add_internal+0x7ac/0x9a0 lib/kobject.c:234
  Code: 7a ca ca f9 e9 f0 f8 ff ff 4c 89 f7 e8 cd ca ca f9 e9 95 f9 ff ff e8 13 25 8c f9 4c 89 e6 48 c7 c7 a0 08 1a 89 e8 a3 76 5c f9 <0f> 0b 41 bd ea ff ff ff e9 52 ff ff ff e8 f2 24 8c f9 0f 0b e8 eb
  RSP: 0018:ffffc90002006eb0 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffff815eae46 RDI: fffff52000400dc8
  RBP: ffffc90002006f08 R08: ffff8880972ac500 R09: ffffed1015d26659
  R10: ffffed1015d26658 R11: ffff8880ae9332c7 R12: ffff888093034668
  R13: 0000000000000000 R14: ffff8880a69d7600 R15: 0000000000000001
   kobject_add_varg lib/kobject.c:390 [inline]
   kobject_add+0x150/0x1c0 lib/kobject.c:442
   device_add+0x3be/0x1d00 drivers/base/core.c:2412
   ib_register_device drivers/infiniband/core/device.c:1371 [inline]
   ib_register_device+0x93e/0xe40 drivers/infiniband/core/device.c:1343
   rxe_register_device+0x52e/0x655 drivers/infiniband/sw/rxe/rxe_verbs.c:1231
   rxe_add+0x122b/0x1661 drivers/infiniband/sw/rxe/rxe.c:302
   rxe_net_add+0x91/0xf0 drivers/infiniband/sw/rxe/rxe_net.c:539
   rxe_newlink+0x39/0x90 drivers/infiniband/sw/rxe/rxe.c:318
   nldev_newlink+0x28a/0x430 drivers/infiniband/core/nldev.c:1538
   rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
   rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
   rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
   netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
   netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
   sock_sendmsg_nosec net/socket.c:652 [inline]
   sock_sendmsg+0xd7/0x130 net/socket.c:672
   ____sys_sendmsg+0x753/0x880 net/socket.c:2343
   ___sys_sendmsg+0x100/0x170 net/socket.c:2397
   __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
   __do_sys_sendmsg net/socket.c:2439 [inline]
   __se_sys_sendmsg net/socket.c:2437 [inline]
   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Prevent empty names when checking the name provided from userspace during
newlink and rename.

Fixes: 3856ec4b93c9 ("RDMA/core: Add RDMA_NLDEV_CMD_NEWLINK/DELLINK support")
Fixes: 05d940d3a3ec ("RDMA/nldev: Allow IB device rename through RDMA netlink")
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20200309191648.GA30852@ziepe.ca
Reported-and-tested-by: syzbot+da615ac67d4dbea32cbc@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/nldev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -863,6 +863,10 @@ static int nldev_set_doit(struct sk_buff
 
 		nla_strlcpy(name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
 			    IB_DEVICE_NAME_MAX);
+		if (strlen(name) == 0) {
+			err = -EINVAL;
+			goto done;
+		}
 		err = ib_device_rename(device, name);
 		goto done;
 	}
@@ -1468,7 +1472,7 @@ static int nldev_newlink(struct sk_buff
 
 	nla_strlcpy(ibdev_name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
 		    sizeof(ibdev_name));
-	if (strchr(ibdev_name, '%'))
+	if (strchr(ibdev_name, '%') || strlen(ibdev_name) == 0)
 		return -EINVAL;
 
 	nla_strlcpy(type, tb[RDMA_NLDEV_ATTR_LINK_TYPE], sizeof(type));


