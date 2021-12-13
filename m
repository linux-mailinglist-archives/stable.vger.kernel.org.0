Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299854723FE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhLMJdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbhLMJdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:33:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22B5C061574;
        Mon, 13 Dec 2021 01:33:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B941AB80E18;
        Mon, 13 Dec 2021 09:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA36DC341C8;
        Mon, 13 Dec 2021 09:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639387983;
        bh=S6Po3pdzAe0BAloUMvVjpVbztRWNyjIqHPRk7NcW/tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXYQdkGelxWzn/hRMqlkmrkdrmVPs8A+fGzm0RvclK0PXCRXD8f9ytxNl04nQ+ZOa
         ot3oBaa6Tb9LLyKSnMpJEY1iC5TcZm/FRMqnPHCwV/W9bQN96+kddiuy38GIOBoaFE
         s+oHTyIbUab8r0JgNYJlP1E6KOfYW22IDz3N/9GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 26/37] net, neigh: clear whole pneigh_entry at alloc time
Date:   Mon, 13 Dec 2021 10:30:04 +0100
Message-Id: <20211213092926.228189418@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit e195e9b5dee6459d8c8e6a314cc71a644a0537fd upstream.

Commit 2c611ad97a82 ("net, neigh: Extend neigh->flags to 32 bit
to allow for extensions") enables a new KMSAM warning [1]

I think the bug is actually older, because the following intruction
only occurred if ndm->ndm_flags had NTF_PROXY set.

	pn->flags = ndm->ndm_flags;

Let's clear all pneigh_entry fields at alloc time.

[1]
BUG: KMSAN: uninit-value in pneigh_fill_info+0x986/0xb30 net/core/neighbour.c:2593
 pneigh_fill_info+0x986/0xb30 net/core/neighbour.c:2593
 pneigh_dump_table net/core/neighbour.c:2715 [inline]
 neigh_dump_info+0x1e3f/0x2c60 net/core/neighbour.c:2832
 netlink_dump+0xaca/0x16a0 net/netlink/af_netlink.c:2265
 __netlink_dump_start+0xd1c/0xee0 net/netlink/af_netlink.c:2370
 netlink_dump_start include/linux/netlink.h:254 [inline]
 rtnetlink_rcv_msg+0x181b/0x18c0 net/core/rtnetlink.c:5534
 netlink_rcv_skb+0x447/0x800 net/netlink/af_netlink.c:2491
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5589
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x1095/0x1360 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x16f3/0x1870 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_write_iter+0x594/0x690 net/socket.c:1057
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0x1318/0x2030 fs/read_write.c:590
 ksys_write+0x28c/0x520 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0xdb/0x120 fs/read_write.c:652
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 slab_alloc mm/slub.c:3259 [inline]
 __kmalloc+0xc3c/0x12d0 mm/slub.c:4437
 kmalloc include/linux/slab.h:595 [inline]
 pneigh_lookup+0x60f/0xd70 net/core/neighbour.c:766
 arp_req_set_public net/ipv4/arp.c:1016 [inline]
 arp_req_set+0x430/0x10a0 net/ipv4/arp.c:1032
 arp_ioctl+0x8d4/0xb60 net/ipv4/arp.c:1232
 inet_ioctl+0x4ef/0x820 net/ipv4/af_inet.c:947
 sock_do_ioctl net/socket.c:1118 [inline]
 sock_ioctl+0xa3f/0x13e0 net/socket.c:1235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0x2df/0x4a0 fs/ioctl.c:860
 __x64_sys_ioctl+0xd8/0x110 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 1 PID: 20001 Comm: syz-executor.0 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 62dd93181aaa ("[IPV6] NDISC: Set per-entry is_router flag in Proxy NA.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211206165329.1049835-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -597,7 +597,7 @@ struct pneigh_entry * pneigh_lookup(stru
 
 	ASSERT_RTNL();
 
-	n = kmalloc(sizeof(*n) + key_len, GFP_KERNEL);
+	n = kzalloc(sizeof(*n) + key_len, GFP_KERNEL);
 	if (!n)
 		goto out;
 


