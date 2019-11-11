Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B79F7BAE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfKKSik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbfKKSij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38E021655;
        Mon, 11 Nov 2019 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497518;
        bh=a0YyOLp9BJGIlRbcwVhG0isF00a6whUm2Sm5dUxTKjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMqg/jGYISu6yey6vEol5II5SGA8otfVUqlKcEUVd5SxnTHIJJ3p0PgAvPZShaaAR
         B5HXIUQz2is008Y/ZgcyjMU8y7AEC3Cy8GuH/c0DJrLN426locn7n0KBigbuz+OvF7
         hX3tE/V1LiW2dJITB2bjflHsHqoEs11WNFq8xY00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 080/105] bonding: fix unexpected IFF_BONDING bit unset
Date:   Mon, 11 Nov 2019 19:28:50 +0100
Message-Id: <20191111181446.748747349@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 65de65d9033750d2cf1b336c9d6e9da3a8b5cc6e ]

The IFF_BONDING means bonding master or bonding slave device.
->ndo_add_slave() sets IFF_BONDING flag and ->ndo_del_slave() unsets
IFF_BONDING flag.

bond0<--bond1

Both bond0 and bond1 are bonding device and these should keep having
IFF_BONDING flag until they are removed.
But bond1 would lose IFF_BONDING at ->ndo_del_slave() because that routine
do not check whether the slave device is the bonding type or not.
This patch adds the interface type check routine before removing
IFF_BONDING flag.

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ip link set bond1 master bond0
    ip link set bond1 nomaster
    ip link del bond1 type bond
    ip link add bond1 type bond

Splat looks like:
[  226.665555] proc_dir_entry 'bonding/bond1' already registered
[  226.666440] WARNING: CPU: 0 PID: 737 at fs/proc/generic.c:361 proc_register+0x2a9/0x3e0
[  226.667571] Modules linked in: bonding af_packet sch_fq_codel ip_tables x_tables unix
[  226.668662] CPU: 0 PID: 737 Comm: ip Not tainted 5.4.0-rc3+ #96
[  226.669508] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  226.670652] RIP: 0010:proc_register+0x2a9/0x3e0
[  226.671612] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 39 01 00 00 48 8b 04 24 48 89 ea 48 c7 c7 a0 0b 14 9f 48 8b b0 e
0 00 00 00 e8 07 e7 88 ff <0f> 0b 48 c7 c7 40 2d a5 9f e8 59 d6 23 01 48 8b 4c 24 10 48 b8 00
[  226.675007] RSP: 0018:ffff888050e17078 EFLAGS: 00010282
[  226.675761] RAX: dffffc0000000008 RBX: ffff88805fdd0f10 RCX: ffffffff9dd344e2
[  226.676757] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff88806c9f6b8c
[  226.677751] RBP: ffff8880507160f3 R08: ffffed100d940019 R09: ffffed100d940019
[  226.678761] R10: 0000000000000001 R11: ffffed100d940018 R12: ffff888050716008
[  226.679757] R13: ffff8880507160f2 R14: dffffc0000000000 R15: ffffed100a0e2c1e
[  226.680758] FS:  00007fdc217cc0c0(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[  226.681886] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  226.682719] CR2: 00007f49313424d0 CR3: 0000000050e46001 CR4: 00000000000606f0
[  226.683727] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  226.684725] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  226.685681] Call Trace:
[  226.687089]  proc_create_seq_private+0xb3/0xf0
[  226.687778]  bond_create_proc_entry+0x1b3/0x3f0 [bonding]
[  226.691458]  bond_netdev_event+0x433/0x970 [bonding]
[  226.692139]  ? __module_text_address+0x13/0x140
[  226.692779]  notifier_call_chain+0x90/0x160
[  226.693401]  register_netdevice+0x9b3/0xd80
[  226.694010]  ? alloc_netdev_mqs+0x854/0xc10
[  226.694629]  ? netdev_change_features+0xa0/0xa0
[  226.695278]  ? rtnl_create_link+0x2ed/0xad0
[  226.695849]  bond_newlink+0x2a/0x60 [bonding]
[  226.696422]  __rtnl_newlink+0xb9f/0x11b0
[  226.696968]  ? rtnl_link_unregister+0x220/0x220
[ ... ]

Fixes: 0b680e753724 ("[PATCH] bonding: Add priv_flag to avoid event mishandling")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cf8385a22de59..5f6602cb191f2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1779,7 +1779,8 @@ err_hwaddr_unsync:
 		bond_hw_addr_flush(bond_dev, slave_dev);
 
 err_close:
-	slave_dev->priv_flags &= ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_restore_mac:
@@ -1985,7 +1986,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	else
 		dev_set_mtu(slave_dev, slave->original_mtu);
 
-	slave_dev->priv_flags &= ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &= ~IFF_BONDING;
 
 	bond_free_slave(slave);
 
-- 
2.20.1



