Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BB23A4AF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgHCM3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728929AbgHCM3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:29:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 826A5208B3;
        Mon,  3 Aug 2020 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457773;
        bh=2p0RX5zCSgS9Ba6CF+WarrcyVNe21ABsL3/IG4LdK54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jw4U8oPYnD3qrmBlK2ET7yvxDWlzkVcvnnLENPWaVfVwjMP9WHesGfMYddKrG7pQB
         BSkb7Ri7j7qYb2qPZBToD4XiTbQiMXfPPfqtAhzUl/E1NWyvrHOMfTxL4NQ1PEZZ5v
         QGQYLKQF+3aXWzEAR2t+L77tEhwyRC4cei4g3yZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 69/90] vxlan: fix memleak of fdb
Date:   Mon,  3 Aug 2020 14:19:31 +0200
Message-Id: <20200803121900.958223920@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit fda2ec62cf1aa7cbee52289dc8059cd3662795da ]

When vxlan interface is deleted, all fdbs are deleted by vxlan_flush().
vxlan_flush() flushes fdbs but it doesn't delete fdb, which contains
all-zeros-mac because it is deleted by vxlan_uninit().
But vxlan_uninit() deletes only the fdb, which contains both all-zeros-mac
and default vni.
So, the fdb, which contains both all-zeros-mac and non-default vni
will not be deleted.

Test commands:
    ip link add vxlan0 type vxlan dstport 4789 external
    ip link set vxlan0 up
    bridge fdb add to 00:00:00:00:00:00 dst 172.0.0.1 dev vxlan0 via lo \
	    src_vni 10000 self permanent
    ip link del vxlan0

kmemleak reports as follows:
unreferenced object 0xffff9486b25ced88 (size 96):
  comm "bridge", pid 2151, jiffies 4294701712 (age 35506.901s)
  hex dump (first 32 bytes):
    02 00 00 00 ac 00 00 01 40 00 09 b1 86 94 ff ff  ........@.......
    46 02 00 00 00 00 00 00 a7 03 00 00 12 b5 6a 6b  F.............jk
  backtrace:
    [<00000000c10cf651>] vxlan_fdb_append.part.51+0x3c/0xf0 [vxlan]
    [<000000006b31a8d9>] vxlan_fdb_create+0x184/0x1a0 [vxlan]
    [<0000000049399045>] vxlan_fdb_update+0x12f/0x220 [vxlan]
    [<0000000090b1ef00>] vxlan_fdb_add+0x12a/0x1b0 [vxlan]
    [<0000000056633c2c>] rtnl_fdb_add+0x187/0x270
    [<00000000dd5dfb6b>] rtnetlink_rcv_msg+0x264/0x490
    [<00000000fc44dd54>] netlink_rcv_skb+0x4a/0x110
    [<00000000dff433e7>] netlink_unicast+0x18e/0x250
    [<00000000b87fb421>] netlink_sendmsg+0x2e9/0x400
    [<000000002ed55153>] ____sys_sendmsg+0x237/0x260
    [<00000000faa51c66>] ___sys_sendmsg+0x88/0xd0
    [<000000006c3982f1>] __sys_sendmsg+0x4e/0x80
    [<00000000a8f875d2>] do_syscall_64+0x56/0xe0
    [<000000003610eefa>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff9486b1c40080 (size 128):
  comm "bridge", pid 2157, jiffies 4294701754 (age 35506.866s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f8 dc 42 b2 86 94 ff ff  ..........B.....
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<00000000a2981b60>] vxlan_fdb_create+0x67/0x1a0 [vxlan]
    [<0000000049399045>] vxlan_fdb_update+0x12f/0x220 [vxlan]
    [<0000000090b1ef00>] vxlan_fdb_add+0x12a/0x1b0 [vxlan]
    [<0000000056633c2c>] rtnl_fdb_add+0x187/0x270
    [<00000000dd5dfb6b>] rtnetlink_rcv_msg+0x264/0x490
    [<00000000fc44dd54>] netlink_rcv_skb+0x4a/0x110
    [<00000000dff433e7>] netlink_unicast+0x18e/0x250
    [<00000000b87fb421>] netlink_sendmsg+0x2e9/0x400
    [<000000002ed55153>] ____sys_sendmsg+0x237/0x260
    [<00000000faa51c66>] ___sys_sendmsg+0x88/0xd0
    [<000000006c3982f1>] __sys_sendmsg+0x4e/0x80
    [<00000000a8f875d2>] do_syscall_64+0x56/0xe0
    [<000000003610eefa>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 3ad7a4b141eb ("vxlan: support fdb and learning in COLLECT_METADATA mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 03434db36b5c7..b49b6f0cee500 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2863,8 +2863,10 @@ static void vxlan_flush(struct vxlan_dev *vxlan, bool do_all)
 			if (!do_all && (f->state & (NUD_PERMANENT | NUD_NOARP)))
 				continue;
 			/* the all_zeros_mac entry is deleted at vxlan_uninit */
-			if (!is_zero_ether_addr(f->eth_addr))
-				vxlan_fdb_destroy(vxlan, f, true, true);
+			if (is_zero_ether_addr(f->eth_addr) &&
+			    f->vni == vxlan->cfg.vni)
+				continue;
+			vxlan_fdb_destroy(vxlan, f, true, true);
 		}
 		spin_unlock_bh(&vxlan->hash_lock[h]);
 	}
-- 
2.25.1



