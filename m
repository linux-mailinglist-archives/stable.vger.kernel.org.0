Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9551A3FAA
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgDJDuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgDJDuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:50:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21CE920936;
        Fri, 10 Apr 2020 03:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490623;
        bh=wICh910KxheUFktrdgO5QBel8tCuwHUSsVu+8uJwrsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kH0C6WDz3tiZbYnEE81BJTgiF4wNg6i5A9wEZGYSwCW2bvgoBamT2ZBDuQJnXebH+
         gwRouUhZrMaM4cY/qPIDBl7I7pjh25NmcYwLJpKqAWT4WNGYEM68cQt75wv4GPTOgf
         /ruB8s7L/a6BqN9oePFdZmvgjkaEwfgeIQaWuCIc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/32] libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()
Date:   Thu,  9 Apr 2020 23:49:48 -0400
Message-Id: <20200410035005.9371-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410035005.9371-1-sashal@kernel.org>
References: <20200410035005.9371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 1d72f7aec3595249dbb83291ccac041a2d676c57 ]

If the call to scsi_add_host_with_dma() in ata_scsi_add_hosts() fails,
then we may get use-after-free KASAN warns:

==================================================================
BUG: KASAN: use-after-free in kobject_put+0x24/0x180
Read of size 1 at addr ffff0026b8c80364 by task swapper/0/1
CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.6.0-rc3-00004-g5a71b206ea82-dirty #1765
Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD, BIOS 2280-V2 CS V3.B160.01 02/24/2020
Call trace:
dump_backtrace+0x0/0x298
show_stack+0x14/0x20
dump_stack+0x118/0x190
print_address_description.isra.9+0x6c/0x3b8
__kasan_report+0x134/0x23c
kasan_report+0xc/0x18
__asan_load1+0x5c/0x68
kobject_put+0x24/0x180
put_device+0x10/0x20
scsi_host_put+0x10/0x18
ata_devres_release+0x74/0xb0
release_nodes+0x2d0/0x470
devres_release_all+0x50/0x78
really_probe+0x2d4/0x560
driver_probe_device+0x7c/0x148
device_driver_attach+0x94/0xa0
__driver_attach+0xa8/0x110
bus_for_each_dev+0xe8/0x158
driver_attach+0x30/0x40
bus_add_driver+0x220/0x2e0
driver_register+0xbc/0x1d0
__pci_register_driver+0xbc/0xd0
ahci_pci_driver_init+0x20/0x28
do_one_initcall+0xf0/0x608
kernel_init_freeable+0x31c/0x384
kernel_init+0x10/0x118
ret_from_fork+0x10/0x18

Allocated by task 5:
save_stack+0x28/0xc8
__kasan_kmalloc.isra.8+0xbc/0xd8
kasan_kmalloc+0xc/0x18
__kmalloc+0x1a8/0x280
scsi_host_alloc+0x44/0x678
ata_scsi_add_hosts+0x74/0x268
ata_host_register+0x228/0x488
ahci_host_activate+0x1c4/0x2a8
ahci_init_one+0xd18/0x1298
local_pci_probe+0x74/0xf0
work_for_cpu_fn+0x2c/0x48
process_one_work+0x488/0xc08
worker_thread+0x330/0x5d0
kthread+0x1c8/0x1d0
ret_from_fork+0x10/0x18

Freed by task 5:
save_stack+0x28/0xc8
__kasan_slab_free+0x118/0x180
kasan_slab_free+0x10/0x18
slab_free_freelist_hook+0xa4/0x1a0
kfree+0xd4/0x3a0
scsi_host_dev_release+0x100/0x148
device_release+0x7c/0xe0
kobject_put+0xb0/0x180
put_device+0x10/0x20
scsi_host_put+0x10/0x18
ata_scsi_add_hosts+0x210/0x268
ata_host_register+0x228/0x488
ahci_host_activate+0x1c4/0x2a8
ahci_init_one+0xd18/0x1298
local_pci_probe+0x74/0xf0
work_for_cpu_fn+0x2c/0x48
process_one_work+0x488/0xc08
worker_thread+0x330/0x5d0
kthread+0x1c8/0x1d0
ret_from_fork+0x10/0x18

There is also refcount issue, as well:
WARNING: CPU: 1 PID: 1 at lib/refcount.c:28 refcount_warn_saturate+0xf8/0x170

The issue is that we make an erroneous extra call to scsi_host_put()
for that host:

So in ahci_init_one()->ata_host_alloc_pinfo()->ata_host_alloc(), we setup
a device release method - ata_devres_release() - which intends to release
the SCSI hosts:

static void ata_devres_release(struct device *gendev, void *res)
{
	...
	for (i = 0; i < host->n_ports; i++) {
		struct ata_port *ap = host->ports[i];

		if (!ap)
			continue;

		if (ap->scsi_host)
			scsi_host_put(ap->scsi_host);

	}
	...
}

However in the ata_scsi_add_hosts() error path, we also call
scsi_host_put() for the SCSI hosts.

Fix by removing the the scsi_host_put() calls in ata_scsi_add_hosts() and
leave this to ata_devres_release().

Fixes: f31871951b38 ("libata: separate out ata_host_alloc() and ata_host_register()")
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3a64fa4aaf7e3..0c1572a1cc5ed 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4570,22 +4570,19 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked = 1;
 
-		rc = scsi_add_host_with_dma(ap->scsi_host,
-						&ap->tdev, ap->host->dev);
+		rc = scsi_add_host_with_dma(shost, &ap->tdev, ap->host->dev);
 		if (rc)
-			goto err_add;
+			goto err_alloc;
 	}
 
 	return 0;
 
- err_add:
-	scsi_host_put(host->ports[i]->scsi_host);
  err_alloc:
 	while (--i >= 0) {
 		struct Scsi_Host *shost = host->ports[i]->scsi_host;
 
+		/* scsi_host_put() is in ata_devres_release() */
 		scsi_remove_host(shost);
-		scsi_host_put(shost);
 	}
 	return rc;
 }
-- 
2.20.1

