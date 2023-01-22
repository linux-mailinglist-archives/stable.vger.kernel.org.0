Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A9D676ED4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjAVPOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjAVPOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:14:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B558C22023
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5193760BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64768C433D2;
        Sun, 22 Jan 2023 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400487;
        bh=dEA+sQ74mdbjKkQIhWClOiLp8QHK9+QdXgcQk6me6KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRk3fl+KlZxU6dYQpPDToG/l1dFQ+5mxcT8KJyP9/XGpvh/QULb5CUTCLHiWXVHBq
         KlGgdNnN3Ed5/u/xrTJUH+YIvMu5f1+R4H+ikgQjhoqhep/S45LpKVvtJky5Tm9dYc
         teV/cz0J6aIDZxewcvzw88RuBDTr+V/5VyfbjsUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 94/98] Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"
Date:   Sun, 22 Jan 2023 16:04:50 +0100
Message-Id: <20230122150233.382381486@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 80f8a66dede0a4b4e9e846765a97809c6fe49ce5 upstream.

This reverts commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293.

ieee80211_if_free() is already called from free_netdev(ndev)
because ndev->priv_destructor == ieee80211_if_free

syzbot reported:

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 10041 Comm: syz-executor.0 Not tainted 6.2.0-rc2-syzkaller-00388-g55b98837e37d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:pcpu_get_page_chunk mm/percpu.c:262 [inline]
RIP: 0010:pcpu_chunk_addr_search mm/percpu.c:1619 [inline]
RIP: 0010:free_percpu mm/percpu.c:2271 [inline]
RIP: 0010:free_percpu+0x186/0x10f0 mm/percpu.c:2254
Code: 80 3c 02 00 0f 85 f5 0e 00 00 48 8b 3b 48 01 ef e8 cf b3 0b 00 48 ba 00 00 00 00 00 fc ff df 48 8d 78 20 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 3b 0e 00 00 48 8b 58 20 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc90004ba7068 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff88823ffe2b80 RCX: 0000000000000004
RDX: dffffc0000000000 RSI: ffffffff81c1f4e7 RDI: 0000000000000020
RBP: ffffe8fffe8fc220 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff2179ab2 R12: ffff8880b983d000
R13: 0000000000000003 R14: 0000607f450fc220 R15: ffff88823ffe2988
FS: 00007fcb349de700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32220000 CR3: 000000004914f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
netdev_run_todo+0x6bf/0x1100 net/core/dev.c:10352
ieee80211_register_hw+0x2663/0x4040 net/mac80211/main.c:1411
mac80211_hwsim_new_radio+0x2537/0x4d80 drivers/net/wireless/mac80211_hwsim.c:4583
hwsim_new_radio_nl+0xa09/0x10f0 drivers/net/wireless/mac80211_hwsim.c:5176
genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xd3/0x120 net/socket.c:734
____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
__sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 13e5afd3d773 ("wifi: mac80211: fix memory leak in ieee80211_if_add()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230113124326.3533978-1-edumazet@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/iface.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2013,7 +2013,6 @@ int ieee80211_if_add(struct ieee80211_lo
 
 		ret = register_netdevice(ndev);
 		if (ret) {
-			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}


