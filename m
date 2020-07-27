Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0899422F230
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgG0OiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbgG0OLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 049E122BEB;
        Mon, 27 Jul 2020 14:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859094;
        bh=fYcFDZ2Wx/5oUlIGGZC4gmtX7Geis69Jw+YWC2m9YpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7NMrgW/19hmUVCBNf9jcy6qmgTdDPKRu8WD45SeLCjiYUqeJr/pUMd2OWFIkipHT
         1uSghLNTVb4CsAbhE57tBS0PHbbrYOFSp4yaXzAeobiWQhRLvMjNKc3QLNr002L9Ek
         BbTxCsZ8rXHei+scr01WfpKmSmqGdIOXSBhtNuLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/86] bonding: check error value of register_netdevice() immediately
Date:   Mon, 27 Jul 2020 16:04:07 +0200
Message-Id: <20200727134916.099777793@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 544f287b84959203367cd29e16e772717612fab4 ]

If register_netdevice() is failed, net_device should not be used
because variables are uninitialized or freed.
So, the routine should be stopped immediately.
But, bond_create() doesn't check return value of register_netdevice()
immediately. That will result in a panic because of using uninitialized
or freed memory.

Test commands:
    modprobe netdev-notifier-error-inject
    echo -22 > /sys/kernel/debug/notifier-error-inject/netdev/\
actions/NETDEV_REGISTER/error
    modprobe bonding max_bonds=3

Splat looks like:
[  375.028492][  T193] general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6b6b: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[  375.033207][  T193] CPU: 2 PID: 193 Comm: kworker/2:2 Not tainted 5.8.0-rc4+ #645
[  375.036068][  T193] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  375.039673][  T193] Workqueue: events linkwatch_event
[  375.041557][  T193] RIP: 0010:dev_activate+0x4a/0x340
[  375.043381][  T193] Code: 40 a8 04 0f 85 db 00 00 00 8b 83 08 04 00 00 85 c0 0f 84 0d 01 00 00 31 d2 89 d0 48 8d 04 40 48 c1 e0 07 48 03 83 00 04 00 00 <48> 8b 48 10 f6 41 10 01 75 08 f0 80 a1 a0 01 00 00 fd 48 89 48 08
[  375.050267][  T193] RSP: 0018:ffff9f8facfcfdd8 EFLAGS: 00010202
[  375.052410][  T193] RAX: 6b6b6b6b6b6b6b6b RBX: ffff9f8fae6ea000 RCX: 0000000000000006
[  375.055178][  T193] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9f8fae6ea000
[  375.057762][  T193] RBP: ffff9f8fae6ea000 R08: 0000000000000000 R09: 0000000000000000
[  375.059810][  T193] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9f8facfcfe08
[  375.061892][  T193] R13: ffffffff883587e0 R14: 0000000000000000 R15: ffff9f8fae6ea580
[  375.063931][  T193] FS:  0000000000000000(0000) GS:ffff9f8fbae00000(0000) knlGS:0000000000000000
[  375.066239][  T193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  375.067841][  T193] CR2: 00007f2f542167a0 CR3: 000000012cee6002 CR4: 00000000003606e0
[  375.069657][  T193] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  375.071471][  T193] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  375.073269][  T193] Call Trace:
[  375.074005][  T193]  linkwatch_do_dev+0x4d/0x50
[  375.075052][  T193]  __linkwatch_run_queue+0x10b/0x200
[  375.076244][  T193]  linkwatch_event+0x21/0x30
[  375.077274][  T193]  process_one_work+0x252/0x600
[  375.078379][  T193]  ? process_one_work+0x600/0x600
[  375.079518][  T193]  worker_thread+0x3c/0x380
[  375.080534][  T193]  ? process_one_work+0x600/0x600
[  375.081668][  T193]  kthread+0x139/0x150
[  375.082567][  T193]  ? kthread_park+0x90/0x90
[  375.083567][  T193]  ret_from_fork+0x22/0x30

Fixes: e826eafa65c6 ("bonding: Call netif_carrier_off after register_netdevice")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index f57b86f1373d4..11429df743067 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4817,15 +4817,19 @@ int bond_create(struct net *net, const char *name)
 	bond_dev->rtnl_link_ops = &bond_link_ops;
 
 	res = register_netdevice(bond_dev);
+	if (res < 0) {
+		free_netdev(bond_dev);
+		rtnl_unlock();
+
+		return res;
+	}
 
 	netif_carrier_off(bond_dev);
 
 	bond_work_init_all(bond);
 
 	rtnl_unlock();
-	if (res < 0)
-		free_netdev(bond_dev);
-	return res;
+	return 0;
 }
 
 static int __net_init bond_net_init(struct net *net)
-- 
2.25.1



