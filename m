Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5A22DEFAB
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgLSNHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbgLSM6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:41 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 05/49] mac80211: mesh: fix mesh_pathtbl_init() error path
Date:   Sat, 19 Dec 2020 13:58:09 +0100
Message-Id: <20201219125344.943408387@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 905b2032fa424f253d9126271439cc1db2b01130 ]

If tbl_mpp can not be allocated, we call mesh_table_free(tbl_path)
while tbl_path rhashtable has not yet been initialized, which causes
panics.

Simply factorize the rhashtable_init() call into mesh_table_alloc()

WARNING: CPU: 1 PID: 8474 at kernel/workqueue.c:3040 __flush_work kernel/workqueue.c:3040 [inline]
WARNING: CPU: 1 PID: 8474 at kernel/workqueue.c:3040 __cancel_work_timer+0x514/0x540 kernel/workqueue.c:3136
Modules linked in:
CPU: 1 PID: 8474 Comm: syz-executor663 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__flush_work kernel/workqueue.c:3040 [inline]
RIP: 0010:__cancel_work_timer+0x514/0x540 kernel/workqueue.c:3136
Code: 5d c3 e8 bf ae 29 00 0f 0b e9 f0 fd ff ff e8 b3 ae 29 00 0f 0b 43 80 3c 3e 00 0f 85 31 ff ff ff e9 34 ff ff ff e8 9c ae 29 00 <0f> 0b e9 dc fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 7d fd ff
RSP: 0018:ffffc9000165f5a0 EFLAGS: 00010293
RAX: ffffffff814b7064 RBX: 0000000000000001 RCX: ffff888021c80000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888024039ca0 R08: dffffc0000000000 R09: fffffbfff1dd3e64
R10: fffffbfff1dd3e64 R11: 0000000000000000 R12: 1ffff920002cbebd
R13: ffff888024039c88 R14: 1ffff11004807391 R15: dffffc0000000000
FS:  0000000001347880(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 000000002cc0a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rhashtable_free_and_destroy+0x25/0x9c0 lib/rhashtable.c:1137
 mesh_table_free net/mac80211/mesh_pathtbl.c:69 [inline]
 mesh_pathtbl_init+0x287/0x2e0 net/mac80211/mesh_pathtbl.c:785
 ieee80211_mesh_init_sdata+0x2ee/0x530 net/mac80211/mesh.c:1591
 ieee80211_setup_sdata+0x733/0xc40 net/mac80211/iface.c:1569
 ieee80211_if_add+0xd5c/0x1cd0 net/mac80211/iface.c:1987
 ieee80211_add_iface+0x59/0x130 net/mac80211/cfg.c:125
 rdev_add_virtual_intf net/wireless/rdev-ops.h:45 [inline]
 nl80211_new_interface+0x563/0xb40 net/wireless/nl80211.c:3855
 genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x780/0x930 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x9a8/0xd40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Link: https://lore.kernel.org/r/20201204162428.2583119-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_pathtbl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -60,6 +60,7 @@ static struct mesh_table *mesh_table_all
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 	spin_lock_init(&newtbl->walk_lock);
+	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
 
 	return newtbl;
 }
@@ -773,9 +774,6 @@ int mesh_pathtbl_init(struct ieee80211_s
 		goto free_path;
 	}
 
-	rhashtable_init(&tbl_path->rhead, &mesh_rht_params);
-	rhashtable_init(&tbl_mpp->rhead, &mesh_rht_params);
-
 	sdata->u.mesh.mesh_paths = tbl_path;
 	sdata->u.mesh.mpp_paths = tbl_mpp;
 


