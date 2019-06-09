Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FDB3A983
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388086AbfFIRBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388083AbfFIRBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:01:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B29AE206DF;
        Sun,  9 Jun 2019 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099691;
        bh=2cvWBn5ekjpwb6jjno5Kkwnr+/fdv1uRWuAFPtX2mso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLH/HeSNI4W41EF+bYZ4+FXZOXSvH1SYaTSC5g37Rap+kSbnkF8U2tCGhoMnCpr+K
         KwpeQn003ejId1ycXOevYsUWMMOygPkIEVfhvuExhxx+Fvb+YFrMDGzPnDgiuqc7QJ
         LNZtwOmDmzIei1o9fYcuHF+7YChjHJ/KFJbpYJMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 094/241] cxgb4: Fix error path in cxgb4_init_module
Date:   Sun,  9 Jun 2019 18:40:36 +0200
Message-Id: <20190609164150.509383836@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a3147770bea76c8dbad73eca3a24c2118da5e719 ]

BUG: unable to handle kernel paging request at ffffffffa016a270
PGD 3270067 P4D 3270067 PUD 3271063 PMD 230bbd067 PTE 0
Oops: 0000 [#1
CPU: 0 PID: 6134 Comm: modprobe Not tainted 5.1.0+ #33
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:atomic_notifier_chain_register+0x24/0x60
Code: 1f 80 00 00 00 00 55 48 89 e5 41 54 49 89 f4 53 48 89 fb e8 ae b4 38 01 48 8b 53 38 48 8d 4b 38 48 85 d2 74 20 45 8b 44 24 10 <44> 3b 42 10 7e 08 eb 13 44 39 42 10 7c 0d 48 8d 4a 08 48 8b 52 08
RSP: 0018:ffffc90000e2bc60 EFLAGS: 00010086
RAX: 0000000000000292 RBX: ffffffff83467240 RCX: ffffffff83467278
RDX: ffffffffa016a260 RSI: ffffffff83752140 RDI: ffffffff83467240
RBP: ffffc90000e2bc70 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 00000000014fa61f R12: ffffffffa01c8260
R13: ffff888231091e00 R14: 0000000000000000 R15: ffffc90000e2be78
FS:  00007fbd8d7cd540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa016a270 CR3: 000000022c7e3000 CR4: 00000000000006f0
Call Trace:
 register_inet6addr_notifier+0x13/0x20
 cxgb4_init_module+0x6c/0x1000 [cxgb4
 ? 0xffffffffa01d7000
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

If pci_register_driver fails, register inet6addr_notifier is
pointless. This patch fix the error path in cxgb4_init_module.

Fixes: b5a02f503caa ("cxgb4 : Update ipv6 address handling api")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a3e1498ca67ce..3b96622de8ff2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5061,15 +5061,24 @@ static int __init cxgb4_init_module(void)
 
 	ret = pci_register_driver(&cxgb4_driver);
 	if (ret < 0)
-		debugfs_remove(cxgb4_debugfs_root);
+		goto err_pci;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (!inet6addr_registered) {
-		register_inet6addr_notifier(&cxgb4_inet6addr_notifier);
-		inet6addr_registered = true;
+		ret = register_inet6addr_notifier(&cxgb4_inet6addr_notifier);
+		if (ret)
+			pci_unregister_driver(&cxgb4_driver);
+		else
+			inet6addr_registered = true;
 	}
 #endif
 
+	if (ret == 0)
+		return ret;
+
+err_pci:
+	debugfs_remove(cxgb4_debugfs_root);
+
 	return ret;
 }
 
-- 
2.20.1



