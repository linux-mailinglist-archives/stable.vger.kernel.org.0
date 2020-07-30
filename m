Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7BF232D21
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgG3IHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbgG3IHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:07:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 562EE20672;
        Thu, 30 Jul 2020 08:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096427;
        bh=jSNIV5R0+fGjTMIr3N6SvMqO4qpx1S6V4WE9RZsvBfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXYi8EE0bpZ6RR2bTsUT54QzihJva4FfDwnvKDbn8Br54ql8z/Zz7tVahYbjQZC94
         0q3i51FT3Qg1R064R0Gjy1KNW/pryr5gudGsY9vV1v+vo8TrCSkRM81p4x+2/2CAvb
         rFvxSkzFy5LTOvZvmVqzw5md5qb4Yw6J2PvqOsus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Weilong Chen <chenweilong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 16/17] rtnetlink: Fix memory(net_device) leak when ->newlink fails
Date:   Thu, 30 Jul 2020 10:04:42 +0200
Message-Id: <20200730074421.258763817@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.449233408@linuxfoundation.org>
References: <20200730074420.449233408@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weilong Chen <chenweilong@huawei.com>

[ Upstream commit cebb69754f37d68e1355a5e726fdac317bcda302 ]

When vlan_newlink call register_vlan_dev fails, it might return error
with dev->reg_state = NETREG_UNREGISTERED. The rtnl_newlink should
free the memory. But currently rtnl_newlink only free the memory which
state is NETREG_UNINITIALIZED.

BUG: memory leak
unreferenced object 0xffff8881051de000 (size 4096):
  comm "syz-executor139", pid 560, jiffies 4294745346 (age 32.445s)
  hex dump (first 32 bytes):
    76 6c 61 6e 32 00 00 00 00 00 00 00 00 00 00 00  vlan2...........
    00 45 28 03 81 88 ff ff 00 00 00 00 00 00 00 00  .E(.............
  backtrace:
    [<0000000047527e31>] kmalloc_node include/linux/slab.h:578 [inline]
    [<0000000047527e31>] kvmalloc_node+0x33/0xd0 mm/util.c:574
    [<000000002b59e3bc>] kvmalloc include/linux/mm.h:753 [inline]
    [<000000002b59e3bc>] kvzalloc include/linux/mm.h:761 [inline]
    [<000000002b59e3bc>] alloc_netdev_mqs+0x83/0xd90 net/core/dev.c:9929
    [<000000006076752a>] rtnl_create_link+0x2c0/0xa20 net/core/rtnetlink.c:3067
    [<00000000572b3be5>] __rtnl_newlink+0xc9c/0x1330 net/core/rtnetlink.c:3329
    [<00000000e84ea553>] rtnl_newlink+0x66/0x90 net/core/rtnetlink.c:3397
    [<0000000052c7c0a9>] rtnetlink_rcv_msg+0x540/0x990 net/core/rtnetlink.c:5460
    [<000000004b5cb379>] netlink_rcv_skb+0x12b/0x3a0 net/netlink/af_netlink.c:2469
    [<00000000c71c20d3>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<00000000c71c20d3>] netlink_unicast+0x4c6/0x690 net/netlink/af_netlink.c:1329
    [<00000000cca72fa9>] netlink_sendmsg+0x735/0xcc0 net/netlink/af_netlink.c:1918
    [<000000009221ebf7>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<000000009221ebf7>] sock_sendmsg+0x109/0x140 net/socket.c:672
    [<000000001c30ffe4>] ____sys_sendmsg+0x5f5/0x780 net/socket.c:2352
    [<00000000b71ca6f3>] ___sys_sendmsg+0x11d/0x1a0 net/socket.c:2406
    [<0000000007297384>] __sys_sendmsg+0xeb/0x1b0 net/socket.c:2439
    [<000000000eb29b11>] do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
    [<000000006839b4d0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: cb626bf566eb ("net-sysfs: Fix reference count leak")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Weilong Chen <chenweilong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3146,7 +3146,8 @@ replay:
 			 */
 			if (err < 0) {
 				/* If device is not registered at all, free it now */
-				if (dev->reg_state == NETREG_UNINITIALIZED)
+				if (dev->reg_state == NETREG_UNINITIALIZED ||
+				    dev->reg_state == NETREG_UNREGISTERED)
 					free_netdev(dev);
 				goto out;
 			}


