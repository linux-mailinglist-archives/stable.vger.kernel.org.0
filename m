Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E52266D8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733077AbgGTQGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732811AbgGTQGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DB742064B;
        Mon, 20 Jul 2020 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261203;
        bh=Y8otu4S77G3sqwNTmqP5GLTNjnw8NyqohqjPLR/cagY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqwA4hka/U/tnOZJkgQHRXEzxUHCR7e5rrxLWWijLcpR6qqlgBLuUp65taEGmAwTy
         9S2fepY/7DpA4w9WYCe/471E2h4nBE4QXRZk3+p3BaTCQa20pKouPTPTlGfI0CJdNi
         syCPev8+1rjD0mk/05AWT/aZllCOkrda9cMfkpuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 030/244] net: rmnet: do not allow to add multiple bridge interfaces
Date:   Mon, 20 Jul 2020 17:35:01 +0200
Message-Id: <20200720152827.299716845@linuxfoundation.org>
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

[ Upstream commit 2fb2799a2abb39d7dbb48abb3baa1133bf5e921a ]

rmnet can have only two bridge interface.
One of them is a link interface and another one is added by
the master operation.
rmnet interface shouldn't allow adding additional
bridge interfaces by mater operation.
But, there is no code to deny additional interfaces.
So, interface leak occurs.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add dummy2 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set dummy1 master rmnet0
    ip link set dummy2 master rmnet0
    ip link del rmnet0

In the above test command, the dummy0 was attached to rmnet as VND mode.
Then, dummy1 was attached to rmnet0 as BRIDGE mode.
At this point, dummy0 mode is switched from VND to BRIDGE automatically.
Then, dummy2 is attached to rmnet as BRIDGE mode.
At this point, rmnet0 should deny this operation.
But, rmnet0 doesn't deny this.
So that below splat occurs when the rmnet0 interface is deleted.

Splat looks like:
[  186.684787][    C2] WARNING: CPU: 2 PID: 1009 at net/core/dev.c:8992 rollback_registered_many+0x986/0xcf0
[  186.684788][    C2] Modules linked in: rmnet dummy openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_x
[  186.684805][    C2] CPU: 2 PID: 1009 Comm: ip Not tainted 5.8.0-rc1+ #621
[  186.684807][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  186.684808][    C2] RIP: 0010:rollback_registered_many+0x986/0xcf0
[  186.684811][    C2] Code: 41 8b 4e cc 45 31 c0 31 d2 4c 89 ee 48 89 df e8 e0 47 ff ff 85 c0 0f 84 cd fc ff ff 5
[  186.684812][    C2] RSP: 0018:ffff8880cd9472e0 EFLAGS: 00010287
[  186.684815][    C2] RAX: ffff8880cc56da58 RBX: ffff8880ab21c000 RCX: ffffffff9329d323
[  186.684816][    C2] RDX: 1ffffffff2be6410 RSI: 0000000000000008 RDI: ffffffff95f32080
[  186.684818][    C2] RBP: dffffc0000000000 R08: fffffbfff2be6411 R09: fffffbfff2be6411
[  186.684819][    C2] R10: ffffffff95f32087 R11: 0000000000000001 R12: ffff8880cd947480
[  186.684820][    C2] R13: ffff8880ab21c0b8 R14: ffff8880cd947400 R15: ffff8880cdf10640
[  186.684822][    C2] FS:  00007f00843890c0(0000) GS:ffff8880d4e00000(0000) knlGS:0000000000000000
[  186.684823][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  186.684825][    C2] CR2: 000055b8ab1077b8 CR3: 00000000ab612006 CR4: 00000000000606e0
[  186.684826][    C2] Call Trace:
[  186.684827][    C2]  ? lockdep_hardirqs_on_prepare+0x379/0x540
[  186.684829][    C2]  ? netif_set_real_num_tx_queues+0x780/0x780
[  186.684830][    C2]  ? rmnet_unregister_real_device+0x56/0x90 [rmnet]
[  186.684831][    C2]  ? __kasan_slab_free+0x126/0x150
[  186.684832][    C2]  ? kfree+0xdc/0x320
[  186.684834][    C2]  ? rmnet_unregister_real_device+0x56/0x90 [rmnet]
[  186.684835][    C2]  unregister_netdevice_many.part.135+0x13/0x1b0
[  186.684836][    C2]  rtnl_delete_link+0xbc/0x100
[ ... ]
[  238.440071][ T1009] unregister_netdevice: waiting for rmnet0 to become free. Usage count = 1

Fixes: 037f9cdf72fb ("net: rmnet: use upper/lower device infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -434,6 +434,11 @@ int rmnet_add_bridge(struct net_device *
 		return -EINVAL;
 	}
 
+	if (port->rmnet_mode != RMNET_EPMODE_VND) {
+		NL_SET_ERR_MSG_MOD(extack, "more than one bridge dev attached");
+		return -EINVAL;
+	}
+
 	if (rmnet_is_real_dev_registered(slave_dev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "slave cannot be another rmnet dev");


