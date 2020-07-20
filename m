Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1342266DA
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733091AbgGTQGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733080AbgGTQGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A6AB2064B;
        Mon, 20 Jul 2020 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261206;
        bh=4hRmMQ99p7G0+IGoYbzCkOUvU2Y4ZJNvfEM6BVc9D48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOwH+6lXT8QEr6sihEhpfZvCehdbsE/E98PwSKQC9eLLoGJOK9JKl5MVfEURlHV3x
         6ilN1weIBRUMqqCE55aDuf9L3ROSy52LKMWxIbfsQKKwGEDpu+QvAh+LcZuhtYH5wv
         lPLdEQpG021GvLRhGX+GbPFtFCyS54ZCxAeevpsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7f1c020f68dab95aab59@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 031/244] hsr: fix interface leak in error path of hsr_dev_finalize()
Date:   Mon, 20 Jul 2020 17:35:02 +0200
Message-Id: <20200720152827.349895521@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit ccfc9df1352be5b2f391091e18c4b2395d30ce78 ]

To release hsr(upper) interface, it should release
its own lower interfaces first.
Then, hsr(upper) interface can be released safely.
In the current code of error path of hsr_dev_finalize(), it releases hsr
interface before releasing a lower interface.
So, a warning occurs, which warns about the leak of lower interfaces.
In order to fix this problem, changing the ordering of the error path of
hsr_dev_finalize() is needed.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add dummy2 type dummy
    ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1
    ip link add hsr1 type hsr slave1 dummy2 slave2 dummy0

Splat looks like:
[  214.923127][    C2] WARNING: CPU: 2 PID: 1093 at net/core/dev.c:8992 rollback_registered_many+0x986/0xcf0
[  214.923129][    C2] Modules linked in: hsr dummy openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipx
[  214.923154][    C2] CPU: 2 PID: 1093 Comm: ip Not tainted 5.8.0-rc2+ #623
[  214.923156][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  214.923157][    C2] RIP: 0010:rollback_registered_many+0x986/0xcf0
[  214.923160][    C2] Code: 41 8b 4e cc 45 31 c0 31 d2 4c 89 ee 48 89 df e8 e0 47 ff ff 85 c0 0f 84 cd fc ff ff 5
[  214.923162][    C2] RSP: 0018:ffff8880c5156f28 EFLAGS: 00010287
[  214.923165][    C2] RAX: ffff8880d1dad458 RBX: ffff8880bd1b9000 RCX: ffffffffb929d243
[  214.923167][    C2] RDX: 1ffffffff77e63f0 RSI: 0000000000000008 RDI: ffffffffbbf31f80
[  214.923168][    C2] RBP: dffffc0000000000 R08: fffffbfff77e63f1 R09: fffffbfff77e63f1
[  214.923170][    C2] R10: ffffffffbbf31f87 R11: 0000000000000001 R12: ffff8880c51570a0
[  214.923172][    C2] R13: ffff8880bd1b90b8 R14: ffff8880c5157048 R15: ffff8880d1dacc40
[  214.923174][    C2] FS:  00007fdd257a20c0(0000) GS:ffff8880da200000(0000) knlGS:0000000000000000
[  214.923175][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  214.923177][    C2] CR2: 00007ffd78beb038 CR3: 00000000be544005 CR4: 00000000000606e0
[  214.923179][    C2] Call Trace:
[  214.923180][    C2]  ? netif_set_real_num_tx_queues+0x780/0x780
[  214.923182][    C2]  ? dev_validate_mtu+0x140/0x140
[  214.923183][    C2]  ? synchronize_rcu.part.79+0x85/0xd0
[  214.923185][    C2]  ? synchronize_rcu_expedited+0xbb0/0xbb0
[  214.923187][    C2]  rollback_registered+0xc8/0x170
[  214.923188][    C2]  ? rollback_registered_many+0xcf0/0xcf0
[  214.923190][    C2]  unregister_netdevice_queue+0x18b/0x240
[  214.923191][    C2]  hsr_dev_finalize+0x56e/0x6e0 [hsr]
[  214.923192][    C2]  hsr_newlink+0x36b/0x450 [hsr]
[  214.923194][    C2]  ? hsr_dellink+0x70/0x70 [hsr]
[  214.923195][    C2]  ? rtnl_create_link+0x2e4/0xb00
[  214.923197][    C2]  ? __netlink_ns_capable+0xc3/0xf0
[  214.923198][    C2]  __rtnl_newlink+0xbdb/0x1270
[ ... ]

Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
Reported-by: syzbot+7f1c020f68dab95aab59@syzkaller.appspotmail.com
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_device.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -417,6 +417,7 @@ int hsr_dev_finalize(struct net_device *
 		     unsigned char multicast_spec, u8 protocol_version,
 		     struct netlink_ext_ack *extack)
 {
+	bool unregister = false;
 	struct hsr_priv *hsr;
 	int res;
 
@@ -468,25 +469,27 @@ int hsr_dev_finalize(struct net_device *
 	if (res)
 		goto err_unregister;
 
+	unregister = true;
+
 	res = hsr_add_port(hsr, slave[0], HSR_PT_SLAVE_A, extack);
 	if (res)
-		goto err_add_slaves;
+		goto err_unregister;
 
 	res = hsr_add_port(hsr, slave[1], HSR_PT_SLAVE_B, extack);
 	if (res)
-		goto err_add_slaves;
+		goto err_unregister;
 
 	hsr_debugfs_init(hsr, hsr_dev);
 	mod_timer(&hsr->prune_timer, jiffies + msecs_to_jiffies(PRUNE_PERIOD));
 
 	return 0;
 
-err_add_slaves:
-	unregister_netdevice(hsr_dev);
 err_unregister:
 	hsr_del_ports(hsr);
 err_add_master:
 	hsr_del_self_node(hsr);
 
+	if (unregister)
+		unregister_netdevice(hsr_dev);
 	return res;
 }


