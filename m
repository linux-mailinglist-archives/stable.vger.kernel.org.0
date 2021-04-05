Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD76354030
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240685AbhDEJQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240689AbhDEJQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0103A61394;
        Mon,  5 Apr 2021 09:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614175;
        bh=8kZFrXXt+qMEunjQCL0PsUuOTgHRxVoh7kUsTHjRKGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlrVGlk773vbcCIFyaaYsrrotzG5nW94yGSrIG0+jzBl/1M0I91TTcLRdZdAoQIIq
         LyGTrTnx+mvOqI9NiUtYzri0N/Q302b9BHdxhD4Ss6KA/Cv2yxHtLX9/CQ1k87j9/F
         PQZ1Jv+fxqpavw7IhDSZWyCcHqfUtqX/AcsD2EzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 065/152] net: wan/lmc: unregister device when no matching device is found
Date:   Mon,  5 Apr 2021 10:53:34 +0200
Message-Id: <20210405085036.384218354@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 62e69bc419772638369eff8ff81340bde8aceb61 ]

lmc set sc->lmc_media pointer when there is a matching device.
However, when no matching device is found, this pointer is NULL
and the following dereference will result in a null-ptr-deref.

To fix this issue, unregister the hdlc device and return an error.

[    4.569359] BUG: KASAN: null-ptr-deref in lmc_init_one.cold+0x2b6/0x55d [lmc]
[    4.569748] Read of size 8 at addr 0000000000000008 by task modprobe/95
[    4.570102]
[    4.570187] CPU: 0 PID: 95 Comm: modprobe Not tainted 5.11.0-rc7 #94
[    4.570527] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-preb4
[    4.571125] Call Trace:
[    4.571261]  dump_stack+0x7d/0xa3
[    4.571445]  kasan_report.cold+0x10c/0x10e
[    4.571667]  ? lmc_init_one.cold+0x2b6/0x55d [lmc]
[    4.571932]  lmc_init_one.cold+0x2b6/0x55d [lmc]
[    4.572186]  ? lmc_mii_readreg+0xa0/0xa0 [lmc]
[    4.572432]  local_pci_probe+0x6f/0xb0
[    4.572639]  pci_device_probe+0x171/0x240
[    4.572857]  ? pci_device_remove+0xe0/0xe0
[    4.573080]  ? kernfs_create_link+0xb6/0x110
[    4.573315]  ? sysfs_do_create_link_sd.isra.0+0x76/0xe0
[    4.573598]  really_probe+0x161/0x420
[    4.573799]  driver_probe_device+0x6d/0xd0
[    4.574022]  device_driver_attach+0x82/0x90
[    4.574249]  ? device_driver_attach+0x90/0x90
[    4.574485]  __driver_attach+0x60/0x100
[    4.574694]  ? device_driver_attach+0x90/0x90
[    4.574931]  bus_for_each_dev+0xe1/0x140
[    4.575146]  ? subsys_dev_iter_exit+0x10/0x10
[    4.575387]  ? klist_node_init+0x61/0x80
[    4.575602]  bus_add_driver+0x254/0x2a0
[    4.575812]  driver_register+0xd3/0x150
[    4.576021]  ? 0xffffffffc0018000
[    4.576202]  do_one_initcall+0x84/0x250
[    4.576411]  ? trace_event_raw_event_initcall_finish+0x150/0x150
[    4.576733]  ? unpoison_range+0xf/0x30
[    4.576938]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    4.577219]  ? unpoison_range+0xf/0x30
[    4.577423]  ? unpoison_range+0xf/0x30
[    4.577628]  do_init_module+0xf8/0x350
[    4.577833]  load_module+0x3fe6/0x4340
[    4.578038]  ? vm_unmap_ram+0x1d0/0x1d0
[    4.578247]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    4.578526]  ? module_frob_arch_sections+0x20/0x20
[    4.578787]  ? __do_sys_finit_module+0x108/0x170
[    4.579037]  __do_sys_finit_module+0x108/0x170
[    4.579278]  ? __ia32_sys_init_module+0x40/0x40
[    4.579523]  ? file_open_root+0x200/0x200
[    4.579742]  ? do_sys_open+0x85/0xe0
[    4.579938]  ? filp_open+0x50/0x50
[    4.580125]  ? exit_to_user_mode_prepare+0xfc/0x130
[    4.580390]  do_syscall_64+0x33/0x40
[    4.580586]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    4.580859] RIP: 0033:0x7f1a724c3cf7
[    4.581054] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00 48 89 f8 48 89 f7 48 89 d6 48 891
[    4.582043] RSP: 002b:00007fff44941c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    4.582447] RAX: ffffffffffffffda RBX: 00000000012ada70 RCX: 00007f1a724c3cf7
[    4.582827] RDX: 0000000000000000 RSI: 00000000012ac9e0 RDI: 0000000000000003
[    4.583207] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
[    4.583587] R10: 00007f1a72527300 R11: 0000000000000246 R12: 00000000012ac9e0
[    4.583968] R13: 0000000000000000 R14: 00000000012acc90 R15: 0000000000000001
[    4.584349] ==================================================================

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lmc/lmc_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 93c7e8502845..ebb568f9bc66 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -899,6 +899,8 @@ static int lmc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
         break;
     default:
 	printk(KERN_WARNING "%s: LMC UNKNOWN CARD!\n", dev->name);
+	unregister_hdlc_device(dev);
+	return -EIO;
         break;
     }
 
-- 
2.30.1



