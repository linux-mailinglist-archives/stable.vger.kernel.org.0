Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FF121FB8C
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgGNS5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731120AbgGNS5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF88207F5;
        Tue, 14 Jul 2020 18:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753063;
        bh=KU9WAil+YqGeJB6dX1RxcmZ1Lyeryj+Fn1vXKePkQBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cM0Li3FWK0DrwXL0Eh+RuWFwDygAANy4zvjCzz2SWkIbqG1UULSdQAB3010IG8YgX
         dMBUMPK24AXPnAXIRQDO+f9ATVKypFjtaSLScoxrg8Jp9egEZq7jTpz5/TSfN04Ztu
         SIUCTMfezPUW3E0V82TSPXSUgld3NVIHwC4BL6lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 106/166] mlxsw: pci: Fix use-after-free in case of failed devlink reload
Date:   Tue, 14 Jul 2020 20:44:31 +0200
Message-Id: <20200714184120.919429441@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit c4317b11675b99af6641662ebcbd3c6010600e64 ]

In case devlink reload failed, it is possible to trigger a
use-after-free when querying the kernel for device info via 'devlink dev
info' [1].

This happens because as part of the reload error path the PCI command
interface is de-initialized and its mailboxes are freed. When the
devlink '->info_get()' callback is invoked the device is queried via the
command interface and the freed mailboxes are accessed.

Fix this by initializing the command interface once during probe and not
during every reload.

This is consistent with the other bus used by mlxsw (i.e., 'mlxsw_i2c')
and also allows user space to query the running firmware version (for
example) from the device after a failed reload.

[1]
BUG: KASAN: use-after-free in memcpy include/linux/string.h:406 [inline]
BUG: KASAN: use-after-free in mlxsw_pci_cmd_exec+0x177/0xa60 drivers/net/ethernet/mellanox/mlxsw/pci.c:1675
Write of size 4096 at addr ffff88810ae32000 by task syz-executor.1/2355

CPU: 1 PID: 2355 Comm: syz-executor.1 Not tainted 5.8.0-rc2+ #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1c/0x250 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x14e/0x1b0 mm/kasan/generic.c:192
 memcpy+0x39/0x60 mm/kasan/common.c:106
 memcpy include/linux/string.h:406 [inline]
 mlxsw_pci_cmd_exec+0x177/0xa60 drivers/net/ethernet/mellanox/mlxsw/pci.c:1675
 mlxsw_cmd_exec+0x249/0x550 drivers/net/ethernet/mellanox/mlxsw/core.c:2335
 mlxsw_cmd_access_reg drivers/net/ethernet/mellanox/mlxsw/cmd.h:859 [inline]
 mlxsw_core_reg_access_cmd drivers/net/ethernet/mellanox/mlxsw/core.c:1938 [inline]
 mlxsw_core_reg_access+0x2f6/0x540 drivers/net/ethernet/mellanox/mlxsw/core.c:1985
 mlxsw_reg_query drivers/net/ethernet/mellanox/mlxsw/core.c:2000 [inline]
 mlxsw_devlink_info_get+0x17f/0x6e0 drivers/net/ethernet/mellanox/mlxsw/core.c:1090
 devlink_nl_info_fill.constprop.0+0x13c/0x2d0 net/core/devlink.c:4588
 devlink_nl_cmd_info_get_dumpit+0x246/0x460 net/core/devlink.c:4648
 genl_lock_dumpit+0x85/0xc0 net/netlink/genetlink.c:575
 netlink_dump+0x515/0xe50 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x53d/0x830 net/netlink/af_netlink.c:2353
 genl_family_rcv_msg_dumpit.isra.0+0x296/0x300 net/netlink/genetlink.c:638
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0x78d/0x9d0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x152/0x440 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x53a/0x750 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x850/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0x150/0x190 net/socket.c:672
 ____sys_sendmsg+0x6d8/0x840 net/socket.c:2363
 ___sys_sendmsg+0xff/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: a9c8336f6544 ("mlxsw: core: Add support for devlink info command")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 54 ++++++++++++++++-------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index fd0e97de44e7a..c04ec1a928260 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1414,23 +1414,12 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	u16 num_pages;
 	int err;
 
-	mutex_init(&mlxsw_pci->cmd.lock);
-	init_waitqueue_head(&mlxsw_pci->cmd.wait);
-
 	mlxsw_pci->core = mlxsw_core;
 
 	mbox = mlxsw_cmd_mbox_alloc();
 	if (!mbox)
 		return -ENOMEM;
 
-	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
-	if (err)
-		goto mbox_put;
-
-	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
-	if (err)
-		goto err_out_mbox_alloc;
-
 	err = mlxsw_pci_sw_reset(mlxsw_pci, mlxsw_pci->id);
 	if (err)
 		goto err_sw_reset;
@@ -1537,9 +1526,6 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	mlxsw_pci_free_irq_vectors(mlxsw_pci);
 err_alloc_irq:
 err_sw_reset:
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
-err_out_mbox_alloc:
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
 mbox_put:
 	mlxsw_cmd_mbox_free(mbox);
 	return err;
@@ -1553,8 +1539,6 @@ static void mlxsw_pci_fini(void *bus_priv)
 	mlxsw_pci_aqs_fini(mlxsw_pci);
 	mlxsw_pci_fw_area_fini(mlxsw_pci);
 	mlxsw_pci_free_irq_vectors(mlxsw_pci);
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
 }
 
 static struct mlxsw_pci_queue *
@@ -1776,6 +1760,37 @@ static const struct mlxsw_bus mlxsw_pci_bus = {
 	.features		= MLXSW_BUS_F_TXRX | MLXSW_BUS_F_RESET,
 };
 
+static int mlxsw_pci_cmd_init(struct mlxsw_pci *mlxsw_pci)
+{
+	int err;
+
+	mutex_init(&mlxsw_pci->cmd.lock);
+	init_waitqueue_head(&mlxsw_pci->cmd.wait);
+
+	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
+	if (err)
+		goto err_in_mbox_alloc;
+
+	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
+	if (err)
+		goto err_out_mbox_alloc;
+
+	return 0;
+
+err_out_mbox_alloc:
+	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
+err_in_mbox_alloc:
+	mutex_destroy(&mlxsw_pci->cmd.lock);
+	return err;
+}
+
+static void mlxsw_pci_cmd_fini(struct mlxsw_pci *mlxsw_pci)
+{
+	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
+	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
+	mutex_destroy(&mlxsw_pci->cmd.lock);
+}
+
 static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	const char *driver_name = pdev->driver->name;
@@ -1831,6 +1846,10 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlxsw_pci->pdev = pdev;
 	pci_set_drvdata(pdev, mlxsw_pci);
 
+	err = mlxsw_pci_cmd_init(mlxsw_pci);
+	if (err)
+		goto err_pci_cmd_init;
+
 	mlxsw_pci->bus_info.device_kind = driver_name;
 	mlxsw_pci->bus_info.device_name = pci_name(mlxsw_pci->pdev);
 	mlxsw_pci->bus_info.dev = &pdev->dev;
@@ -1848,6 +1867,8 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_bus_device_register:
+	mlxsw_pci_cmd_fini(mlxsw_pci);
+err_pci_cmd_init:
 	iounmap(mlxsw_pci->hw_addr);
 err_ioremap:
 err_pci_resource_len_check:
@@ -1865,6 +1886,7 @@ static void mlxsw_pci_remove(struct pci_dev *pdev)
 	struct mlxsw_pci *mlxsw_pci = pci_get_drvdata(pdev);
 
 	mlxsw_core_bus_device_unregister(mlxsw_pci->core, false);
+	mlxsw_pci_cmd_fini(mlxsw_pci);
 	iounmap(mlxsw_pci->hw_addr);
 	pci_release_regions(mlxsw_pci->pdev);
 	pci_disable_device(mlxsw_pci->pdev);
-- 
2.25.1



