Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECB6C1891
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjCTPZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbjCTPZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:25:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12C12F7A8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05B67CE12EC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0270DC433D2;
        Mon, 20 Mar 2023 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325504;
        bh=Usr33Q7G7svwxIMW/0o8lW0DeqjhK2SaLNhtz4sFD/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jI8lsRwlYbczOyaKhAh8gr3wLOzY1VD8/QXdb/ozQQf/V1TROQbrwSagBldU2ElLi
         LrCJ2R3Wk/TRKtiWj38elSxVXPjxW6vwjXco4sgmbK0FEYn4+QCS6rVXGfiKdM90dj
         XVa3vWJABcAhoxXjty1P2vqaMwVEPGWVdtlQf/wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/198] bonding: restore bonds IFF_SLAVE flag if a non-eth dev enslave fails
Date:   Mon, 20 Mar 2023 15:53:50 +0100
Message-Id: <20230320145511.399693398@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit e667d469098671261d558be0cd93dca4d285ce1e ]

syzbot reported a warning[1] where the bond device itself is a slave and
we try to enslave a non-ethernet device as the first slave which fails
but then in the error path when ether_setup() restores the bond device
it also clears all flags. In my previous fix[2] I restored the
IFF_MASTER flag, but I didn't consider the case that the bond device
itself might also be a slave with IFF_SLAVE set, so we need to restore
that flag as well. Use the bond_ether_setup helper which does the right
thing and restores the bond's flags properly.

Steps to reproduce using a nlmon dev:
 $ ip l add nlmon0 type nlmon
 $ ip l add bond1 type bond
 $ ip l add bond2 type bond
 $ ip l set bond1 master bond2
 $ ip l set dev nlmon0 master bond1
 $ ip -d l sh dev bond1
 22: bond1: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noqueue master bond2 state DOWN mode DEFAULT group default qlen 1000
 (now bond1's IFF_SLAVE flag is gone and we'll hit a warning[3] if we
  try to delete it)

[1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
[2] commit 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
[3] example warning:
 [   27.008664] bond1: (slave nlmon0): The slave device specified does not support setting the MAC address
 [   27.008692] bond1: (slave nlmon0): Error -95 calling set_mac_address
 [   32.464639] bond1 (unregistering): Released all slaves
 [   32.464685] ------------[ cut here ]------------
 [   32.464686] WARNING: CPU: 1 PID: 2004 at net/core/dev.c:10829 unregister_netdevice_many+0x72a/0x780
 [   32.464694] Modules linked in: br_netfilter bridge bonding virtio_net
 [   32.464699] CPU: 1 PID: 2004 Comm: ip Kdump: loaded Not tainted 5.18.0-rc3+ #47
 [   32.464703] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc37 04/01/2014
 [   32.464704] RIP: 0010:unregister_netdevice_many+0x72a/0x780
 [   32.464707] Code: 99 fd ff ff ba 90 1a 00 00 48 c7 c6 f4 02 66 96 48 c7 c7 20 4d 35 96 c6 05 fa c7 2b 02 01 e8 be 6f 4a 00 0f 0b e9 73 fd ff ff <0f> 0b e9 5f fd ff ff 80 3d e3 c7 2b 02 00 0f 85 3b fd ff ff ba 59
 [   32.464710] RSP: 0018:ffffa006422d7820 EFLAGS: 00010206
 [   32.464712] RAX: ffff8f6e077140a0 RBX: ffffa006422d7888 RCX: 0000000000000000
 [   32.464714] RDX: ffff8f6e12edbe58 RSI: 0000000000000296 RDI: ffffffff96d4a520
 [   32.464716] RBP: ffff8f6e07714000 R08: ffffffff96d63600 R09: ffffa006422d7728
 [   32.464717] R10: 0000000000000ec0 R11: ffffffff9698c988 R12: ffff8f6e12edb140
 [   32.464719] R13: dead000000000122 R14: dead000000000100 R15: ffff8f6e12edb140
 [   32.464723] FS:  00007f297c2f1740(0000) GS:ffff8f6e5d900000(0000) knlGS:0000000000000000
 [   32.464725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [   32.464726] CR2: 00007f297bf1c800 CR3: 00000000115e8000 CR4: 0000000000350ee0
 [   32.464730] Call Trace:
 [   32.464763]  <TASK>
 [   32.464767]  rtnl_dellink+0x13e/0x380
 [   32.464776]  ? cred_has_capability.isra.0+0x68/0x100
 [   32.464780]  ? __rtnl_unlock+0x33/0x60
 [   32.464783]  ? bpf_lsm_capset+0x10/0x10
 [   32.464786]  ? security_capable+0x36/0x50
 [   32.464790]  rtnetlink_rcv_msg+0x14e/0x3b0
 [   32.464792]  ? _copy_to_iter+0xb1/0x790
 [   32.464796]  ? post_alloc_hook+0xa0/0x160
 [   32.464799]  ? rtnl_calcit.isra.0+0x110/0x110
 [   32.464802]  netlink_rcv_skb+0x50/0xf0
 [   32.464806]  netlink_unicast+0x216/0x340
 [   32.464809]  netlink_sendmsg+0x23f/0x480
 [   32.464812]  sock_sendmsg+0x5e/0x60
 [   32.464815]  ____sys_sendmsg+0x22c/0x270
 [   32.464818]  ? import_iovec+0x17/0x20
 [   32.464821]  ? sendmsg_copy_msghdr+0x59/0x90
 [   32.464823]  ? do_set_pte+0xa0/0xe0
 [   32.464828]  ___sys_sendmsg+0x81/0xc0
 [   32.464832]  ? mod_objcg_state+0xc6/0x300
 [   32.464835]  ? refill_obj_stock+0xa9/0x160
 [   32.464838]  ? memcg_slab_free_hook+0x1a5/0x1f0
 [   32.464842]  __sys_sendmsg+0x49/0x80
 [   32.464847]  do_syscall_64+0x3b/0x90
 [   32.464851]  entry_SYSCALL_64_after_hwframe+0x44/0xae
 [   32.464865] RIP: 0033:0x7f297bf2e5e7
 [   32.464868] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 [   32.464869] RSP: 002b:00007ffd96c824c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 [   32.464872] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f297bf2e5e7
 [   32.464874] RDX: 0000000000000000 RSI: 00007ffd96c82540 RDI: 0000000000000003
 [   32.464875] RBP: 00000000640f19de R08: 0000000000000001 R09: 000000000000007c
 [   32.464876] R10: 00007f297bffabe0 R11: 0000000000000246 R12: 0000000000000001
 [   32.464877] R13: 00007ffd96c82d20 R14: 00007ffd96c82610 R15: 000055bfe38a7020
 [   32.464881]  </TASK>
 [   32.464882] ---[ end trace 0000000000000000 ]---

Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 091c430547e7c..45d3cb557de73 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2299,9 +2299,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			eth_hw_addr_random(bond_dev);
 		if (bond_dev->type != ARPHRD_ETHER) {
 			dev_close(bond_dev);
-			ether_setup(bond_dev);
-			bond_dev->flags |= IFF_MASTER;
-			bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+			bond_ether_setup(bond_dev);
 		}
 	}
 
-- 
2.39.2



