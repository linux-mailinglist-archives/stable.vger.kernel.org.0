Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2B32C9A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfFCJKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfFCJKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EC4927E1E;
        Mon,  3 Jun 2019 09:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559552999;
        bh=yvSmm+w6lX77wNa90A/+99wgzkko2UVyotwyWPTNxgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B54bfRQIcgud4O8FL0iY5GHyNvWKYt1K8XlS1FUyKHAyoz/g6d/JoILki9FjFQTPD
         rbbEVAZ+N5tI2azobXmCPYVfcOoDPDC+LpxmPppabca7vp2xAk81kORM/ah0MxubI6
         AbarJHqs5km/hOs1rU/m3Z3mBedojDOnhh5ky4Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/32] llc: fix skb leak in llc_build_and_send_ui_pkt()
Date:   Mon,  3 Jun 2019 11:08:02 +0200
Message-Id: <20190603090311.145567725@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8fb44d60d4142cd2a440620cd291d346e23c131e ]

If llc_mac_hdr_init() returns an error, we must drop the skb
since no llc_build_and_send_ui_pkt() caller will take care of this.

BUG: memory leak
unreferenced object 0xffff8881202b6800 (size 2048):
  comm "syz-executor907", pid 7074, jiffies 4294943781 (age 8.590s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    1a 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<00000000e25b5abe>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<00000000e25b5abe>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000e25b5abe>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000e25b5abe>] __do_kmalloc mm/slab.c:3658 [inline]
    [<00000000e25b5abe>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
    [<00000000a1ae188a>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000a1ae188a>] sk_prot_alloc+0xd6/0x170 net/core/sock.c:1608
    [<00000000ded25bbe>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
    [<000000002ecae075>] llc_sk_alloc+0x35/0x170 net/llc/llc_conn.c:950
    [<00000000551f7c47>] llc_ui_create+0x7b/0x140 net/llc/af_llc.c:173
    [<0000000029027f0e>] __sock_create+0x164/0x250 net/socket.c:1430
    [<000000008bdec225>] sock_create net/socket.c:1481 [inline]
    [<000000008bdec225>] __sys_socket+0x69/0x110 net/socket.c:1523
    [<00000000b6439228>] __do_sys_socket net/socket.c:1532 [inline]
    [<00000000b6439228>] __se_sys_socket net/socket.c:1530 [inline]
    [<00000000b6439228>] __x64_sys_socket+0x1e/0x30 net/socket.c:1530
    [<00000000cec820c1>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<000000000c32554f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811d750d00 (size 224):
  comm "syz-executor907", pid 7074, jiffies 4294943781 (age 8.600s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 f0 0c 24 81 88 ff ff 00 68 2b 20 81 88 ff ff  ...$.....h+ ....
  backtrace:
    [<0000000053026172>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<0000000053026172>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<0000000053026172>] slab_alloc_node mm/slab.c:3269 [inline]
    [<0000000053026172>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
    [<00000000fa8f3c30>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
    [<00000000d96fdafb>] alloc_skb include/linux/skbuff.h:1058 [inline]
    [<00000000d96fdafb>] alloc_skb_with_frags+0x5f/0x250 net/core/skbuff.c:5327
    [<000000000a34a2e7>] sock_alloc_send_pskb+0x269/0x2a0 net/core/sock.c:2225
    [<00000000ee39999b>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2242
    [<00000000e034d810>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
    [<00000000c0bc8445>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000c0bc8445>] sock_sendmsg+0x54/0x70 net/socket.c:671
    [<000000003b687167>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
    [<00000000922d78d9>] __do_sys_sendto net/socket.c:1976 [inline]
    [<00000000922d78d9>] __se_sys_sendto net/socket.c:1972 [inline]
    [<00000000922d78d9>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
    [<00000000cec820c1>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<000000000c32554f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/llc_output.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/llc/llc_output.c
+++ b/net/llc/llc_output.c
@@ -72,6 +72,8 @@ int llc_build_and_send_ui_pkt(struct llc
 	rc = llc_mac_hdr_init(skb, skb->dev->dev_addr, dmac);
 	if (likely(!rc))
 		rc = dev_queue_xmit(skb);
+	else
+		kfree_skb(skb);
 	return rc;
 }
 


