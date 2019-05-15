Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B851EF91
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfEOLcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733048AbfEOLcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:32:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198082053B;
        Wed, 15 May 2019 11:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919952;
        bh=w0GHWwAugBhRjsJKO18Xs7KdslOVfCTcVmSyA8o/OJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDMzeSxoRS6GXaORQ6rPYtaH2GDVLpx7hIARceRVbXJkViro4kv24JDqpj/VuWW3z
         qK18b81F2keXnB9HHZSKK+u9XynftNfCemUKLj/oeVJet0Tt1AaOhVBi9CFL5Xr8tM
         CTkidXq7GtvDYzX3jNyHITnYVmkPsp1oM3xWAGts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 19/46] net: dsa: Fix error cleanup path in dsa_init_module
Date:   Wed, 15 May 2019 12:56:43 +0200
Message-Id: <20190515090623.607888279@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 68be930249d051fd54d3d99156b3dcadcb2a1f9b ]

BUG: unable to handle kernel paging request at ffffffffa01c5430
PGD 3270067 P4D 3270067 PUD 3271063 PMD 230bc5067 PTE 0
Oops: 0000 [#1
CPU: 0 PID: 6159 Comm: modprobe Not tainted 5.1.0+ #33
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:raw_notifier_chain_register+0x16/0x40
Code: 63 f8 66 90 e9 5d ff ff ff 90 90 90 90 90 90 90 90 90 90 90 55 48 8b 07 48 89 e5 48 85 c0 74 1c 8b 56 10 3b 50 10 7e 07 eb 12 <39> 50 10 7c 0d 48 8d 78 08 48 8b 40 08 48 85 c0 75 ee 48 89 46 08
RSP: 0018:ffffc90001c33c08 EFLAGS: 00010282
RAX: ffffffffa01c5420 RBX: ffffffffa01db420 RCX: 4fcef45928070a8b
RDX: 0000000000000000 RSI: ffffffffa01db420 RDI: ffffffffa01b0068
RBP: ffffc90001c33c08 R08: 000000003e0a33d0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000094443661 R12: ffff88822c320700
R13: ffff88823109be80 R14: 0000000000000000 R15: ffffc90001c33e78
FS:  00007fab8bd08540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa01c5430 CR3: 00000002297ea000 CR4: 00000000000006f0
Call Trace:
 register_netdevice_notifier+0x43/0x250
 ? 0xffffffffa01e0000
 dsa_slave_register_notifier+0x13/0x70 [dsa_core
 ? 0xffffffffa01e0000
 dsa_init_module+0x2e/0x1000 [dsa_core
 do_one_initcall+0x6c/0x3cc
 ? do_init_module+0x22/0x1f1
 ? rcu_read_lock_sched_held+0x97/0xb0
 ? kmem_cache_alloc_trace+0x325/0x3b0
 do_init_module+0x5b/0x1f1
 load_module+0x1db1/0x2690
 ? m_show+0x1d0/0x1d0
 __do_sys_finit_module+0xc5/0xd0
 __x64_sys_finit_module+0x15/0x20
 do_syscall_64+0x6b/0x1d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Cleanup allocated resourses if there are errors,
otherwise it will trgger memleak.

Fixes: c9eb3e0f8701 ("net: dsa: Add support for learning FDB through notification")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -344,15 +344,22 @@ static int __init dsa_init_module(void)
 
 	rc = dsa_slave_register_notifier();
 	if (rc)
-		return rc;
+		goto register_notifier_fail;
 
 	rc = dsa_legacy_register();
 	if (rc)
-		return rc;
+		goto legacy_register_fail;
 
 	dev_add_pack(&dsa_pack_type);
 
 	return 0;
+
+legacy_register_fail:
+	dsa_slave_unregister_notifier();
+register_notifier_fail:
+	destroy_workqueue(dsa_owq);
+
+	return rc;
 }
 module_init(dsa_init_module);
 


