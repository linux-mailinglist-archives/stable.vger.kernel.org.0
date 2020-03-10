Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934C917FA6D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgCJNEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbgCJNEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAA924693;
        Tue, 10 Mar 2020 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845470;
        bh=rQIvNQZT2Nzo/nopyTzcc0rTObVU6bVxkObXxXRmo7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnhrIFxzRz5q0UWcb3qOEwX7FM8Rm1KM/kufeQk0/wRM7rzuA/9jS75QzwLxRyJPM
         Y21WrneLd8dSEsSmOaD4MZFGVcirxXN/bWrfsN7X9UvAWWKUu+qGzuUPzDoUpO6efH
         6o4uBX8gKV4JSMicdheb2cpvumCSMn+3D6UYyft8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bd4af81bc51ee0283445@syzkaller.appspotmail.com,
        Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 162/189] RDMA/nldev: Fix crash when set a QP to a new counter but QPN is missing
Date:   Tue, 10 Mar 2020 13:39:59 +0100
Message-Id: <20200310123656.413900462@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

commit 78f34a16c28654cb47791257006f90d0948f2f0c upstream.

This fixes the kernel crash when a RDMA_NLDEV_CMD_STAT_SET command is
received, but the QP number parameter is not available.

  iwpm_register_pid: Unable to send a nlmsg (client = 2)
  infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98
  general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  CPU: 0 PID: 9754 Comm: syz-executor069 Not tainted 5.6.0-rc2-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:nla_get_u32 include/net/netlink.h:1474 [inline]
  RIP: 0010:nldev_stat_set_doit+0x63c/0xb70 drivers/infiniband/core/nldev.c:1760
  Code: fc 01 0f 84 58 03 00 00 e8 41 83 bf fb 4c 8b a3 58 fd ff ff 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 6d
  RSP: 0018:ffffc900068bf350 EFLAGS: 00010247
  RAX: dffffc0000000000 RBX: ffffc900068bf728 RCX: ffffffff85b60470
  RDX: 0000000000000000 RSI: ffffffff85b6047f RDI: 0000000000000004
  RBP: ffffc900068bf750 R08: ffff88808c3ee140 R09: ffff8880a25e6010
  R10: ffffed10144bcddc R11: ffff8880a25e6ee3 R12: 0000000000000000
  R13: ffff88809acb0000 R14: ffff888092a42c80 R15: 000000009ef2e29a
  FS:  0000000001ff0880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f4733e34000 CR3: 00000000a9b27000 CR4: 00000000001406f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
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
  RIP: 0033:0x4403d9
  Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
  RSP: 002b:00007ffc0efbc5c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004403d9
  RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000004
  RBP: 00000000006ca018 R08: 0000000000000008 R09: 00000000004002c8
  R10: 000000000000004a R11: 0000000000000246 R12: 0000000000401c60
  R13: 0000000000401cf0 R14: 0000000000000000 R15: 0000000000000000

Fixes: b389327df905 ("RDMA/nldev: Allow counter manual mode configration through RDMA netlink")
Link: https://lore.kernel.org/r/20200227125111.99142-1-leon@kernel.org
Reported-by: syzbot+bd4af81bc51ee0283445@syzkaller.appspotmail.com
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/nldev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1756,6 +1756,8 @@ static int nldev_stat_set_doit(struct sk
 		if (ret)
 			goto err_msg;
 	} else {
+		if (!tb[RDMA_NLDEV_ATTR_RES_LQPN])
+			goto err_msg;
 		qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
 		if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
 			cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);


