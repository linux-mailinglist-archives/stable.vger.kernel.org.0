Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7590B12C5B7
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfL2RkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbfL2Rbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:31:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030A021D7E;
        Sun, 29 Dec 2019 17:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640711;
        bh=wHSuNbaQOr9d0JXrs1QbazHeHnvK/wg9JvQeH+r/jCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEtbS8D7mT+HoWkAKdvUG1Fh47Wpt94o7G2pIb16oZmiugtV+QxObZPJzFQmT7PAP
         xucA6oM9ivjBxh+eF5YiETW85x6gGIC94BpsfvHjAVEJyurAS4quyAWwITWl2m+T/1
         iY686V9YLOHoczYPyVpnG7qoDNKhxPvTOFh7XwZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/219] libata: Ensure ata_port probe has completed before detach
Date:   Sun, 29 Dec 2019 18:18:29 +0100
Message-Id: <20191229162524.815972605@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 130f4caf145c3562108b245a576db30b916199d2 ]

With CONFIG_DEBUG_TEST_DRIVER_REMOVE set, we may find the following WARN:

[   23.452574] ------------[ cut here ]------------
[   23.457190] WARNING: CPU: 59 PID: 1 at drivers/ata/libata-core.c:6676 ata_host_detach+0x15c/0x168
[   23.466047] Modules linked in:
[   23.469092] CPU: 59 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc1-00010-g5b83fd27752b-dirty #296
[   23.477776] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0 - V1.16.01 03/15/2019
[   23.486286] pstate: a0c00009 (NzCv daif +PAN +UAO)
[   23.491065] pc : ata_host_detach+0x15c/0x168
[   23.495322] lr : ata_host_detach+0x88/0x168
[   23.499491] sp : ffff800011cabb50
[   23.502792] x29: ffff800011cabb50 x28: 0000000000000007
[   23.508091] x27: ffff80001137f068 x26: ffff8000112c0c28
[   23.513390] x25: 0000000000003848 x24: ffff0023ea185300
[   23.518689] x23: 0000000000000001 x22: 00000000000014c0
[   23.523987] x21: 0000000000013740 x20: ffff0023bdc20000
[   23.529286] x19: 0000000000000000 x18: 0000000000000004
[   23.534584] x17: 0000000000000001 x16: 00000000000000f0
[   23.539883] x15: ffff0023eac13790 x14: ffff0023eb76c408
[   23.545181] x13: 0000000000000000 x12: ffff0023eac13790
[   23.550480] x11: ffff0023eb76c228 x10: 0000000000000000
[   23.555779] x9 : ffff0023eac13798 x8 : 0000000040000000
[   23.561077] x7 : 0000000000000002 x6 : 0000000000000001
[   23.566376] x5 : 0000000000000002 x4 : 0000000000000000
[   23.571674] x3 : ffff0023bf08a0bc x2 : 0000000000000000
[   23.576972] x1 : 3099674201f72700 x0 : 0000000000400284
[   23.582272] Call trace:
[   23.584706]  ata_host_detach+0x15c/0x168
[   23.588616]  ata_pci_remove_one+0x10/0x18
[   23.592615]  ahci_remove_one+0x20/0x40
[   23.596356]  pci_device_remove+0x3c/0xe0
[   23.600267]  really_probe+0xdc/0x3e0
[   23.603830]  driver_probe_device+0x58/0x100
[   23.608000]  device_driver_attach+0x6c/0x90
[   23.612169]  __driver_attach+0x84/0xc8
[   23.615908]  bus_for_each_dev+0x74/0xc8
[   23.619730]  driver_attach+0x20/0x28
[   23.623292]  bus_add_driver+0x148/0x1f0
[   23.627115]  driver_register+0x60/0x110
[   23.630938]  __pci_register_driver+0x40/0x48
[   23.635199]  ahci_pci_driver_init+0x20/0x28
[   23.639372]  do_one_initcall+0x5c/0x1b0
[   23.643199]  kernel_init_freeable+0x1a4/0x24c
[   23.647546]  kernel_init+0x10/0x108
[   23.651023]  ret_from_fork+0x10/0x18
[   23.654590] ---[ end trace 634a14b675b71c13 ]---

With KASAN also enabled, we may also get many use-after-free reports.

The issue is that when CONFIG_DEBUG_TEST_DRIVER_REMOVE is set, we may
attempt to detach the ata_port before it has been probed.

This is because the ata_ports are async probed, meaning that there is no
guarantee that the ata_port has probed prior to detach. When the ata_port
does probe in this scenario, we get all sorts of issues as the detach may
have already happened.

Fix by ensuring synchronisation with async_synchronize_full(). We could
alternatively use the cookie returned from the ata_port probe
async_schedule() call, but that means managing the cookie, so more
complicated.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 133fed8e4a8b..85ee6c35d8e0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6726,6 +6726,9 @@ void ata_host_detach(struct ata_host *host)
 {
 	int i;
 
+	/* Ensure ata_port probe has completed */
+	async_synchronize_full();
+
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_detach(host->ports[i]);
 
-- 
2.20.1



