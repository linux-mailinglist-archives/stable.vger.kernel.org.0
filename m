Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C01913F8BA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgAPQxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731229AbgAPQxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D3E222522;
        Thu, 16 Jan 2020 16:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193632;
        bh=9zH7Hd+7dnthIyy8bmCcZc4jBxbWpACJTC0vtPgfH7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRgIoem0IzBK86REm4m3nogUHCsI7Y+NjbzXdnF6HvbVcQQi4qAgmiEpRFZIxW14d
         i80pYRujm9WkwvMfQcuuXLnjlp5Zq9UuMarQcaj7BTxictG+lp2dzEt/uDX7/G0Nwh
         /QA3GuuspvJloSCCzC/hvEet+RU76FVAgYcsXz4Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 166/205] scsi: scsi_transport_sas: Fix memory leak when removing devices
Date:   Thu, 16 Jan 2020 11:42:21 -0500
Message-Id: <20200116164300.6705-166-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 82ea3e0e129e2ab913dd6684bab7a6e5e9896dee ]

Removing a non-host rphy causes a memory leak:

root@(none)$ echo 0 > /sys/devices/platform/HISI0162:01/host0/port-0:0/expander-0:0/port-0:0:10/phy-0:0:10/sas_phy/phy-0:0:10/enable
[   79.857888] hisi_sas_v2_hw HISI0162:01: dev[7:1] is gone
root@(none)$ echo scan > /sys/kernel/debug/kmemleak
[  131.656603] kmemleak: 3 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
root@(none)$ more /sys/kernel/debug/kmemleak
unreferenced object 0xffff041da5c66000 (size 256):
  comm "kworker/u128:1", pid 549, jiffies 4294898543 (age 113.728s)
  hex dump (first 32 bytes):
    00 5e c6 a5 1d 04 ff ff 01 00 00 00 00 00 00 00  .^..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<(____ptrval____)>] kmem_cache_alloc+0x188/0x260
    [<(____ptrval____)>] bsg_setup_queue+0x48/0x1a8
    [<(____ptrval____)>] sas_rphy_add+0x108/0x2d0
    [<(____ptrval____)>] sas_probe_devices+0x168/0x208
    [<(____ptrval____)>] sas_discover_domain+0x660/0x9c8
    [<(____ptrval____)>] process_one_work+0x3f8/0x690
    [<(____ptrval____)>] worker_thread+0x70/0x6a0
    [<(____ptrval____)>] kthread+0x1b8/0x1c0
    [<(____ptrval____)>] ret_from_fork+0x10/0x18
unreferenced object 0xffff041d8c075400 (size 128):
  comm "kworker/u128:1", pid 549, jiffies 4294898543 (age 113.728s)
  hex dump (first 32 bytes):
    00 40 25 97 1d 00 ff ff 00 00 00 00 00 00 00 00  .@%.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<(____ptrval____)>] __kmalloc_node+0x1a8/0x2c8
    [<(____ptrval____)>] blk_mq_realloc_tag_set_tags.part.70+0x48/0xd8
    [<(____ptrval____)>] blk_mq_alloc_tag_set+0x1dc/0x530
    [<(____ptrval____)>] bsg_setup_queue+0xe8/0x1a8
    [<(____ptrval____)>] sas_rphy_add+0x108/0x2d0
    [<(____ptrval____)>] sas_probe_devices+0x168/0x208
    [<(____ptrval____)>] sas_discover_domain+0x660/0x9c8
    [<(____ptrval____)>] process_one_work+0x3f8/0x690
    [<(____ptrval____)>] worker_thread+0x70/0x6a0
    [<(____ptrval____)>] kthread+0x1b8/0x1c0
    [<(____ptrval____)>] ret_from_fork+0x10/0x18
unreferenced object 0xffff041da5c65e00 (size 256):
  comm "kworker/u128:1", pid 549, jiffies 4294898543 (age 113.728s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<(____ptrval____)>] __kmalloc_node+0x1a8/0x2c8
    [<(____ptrval____)>] blk_mq_alloc_tag_set+0x254/0x530
    [<(____ptrval____)>] bsg_setup_queue+0xe8/0x1a8
    [<(____ptrval____)>] sas_rphy_add+0x108/0x2d0
    [<(____ptrval____)>] sas_probe_devices+0x168/0x208
    [<(____ptrval____)>] sas_discover_domain+0x660/0x9c8
    [<(____ptrval____)>] process_one_work+0x3f8/0x690
    [<(____ptrval____)>] worker_thread+0x70/0x6a0
    [<(____ptrval____)>] kthread+0x1b8/0x1c0
    [<(____ptrval____)>] ret_from_fork+0x10/0x18
root@(none)$

It turns out that we don't clean up the request queue fully for bsg
devices, as the blk mq tags for the request queue are not freed.

Fix by doing the queue removal in one place - in sas_rphy_remove() -
instead of unregistering the queue in sas_rphy_remove() and finally
cleaning up the queue in calling blk_cleanup_queue() from
sas_end_device_release() or sas_expander_release().

Function bsg_remove_queue() can handle a NULL pointer q, so remove the
precheck in sas_rphy_remove().

Fixes: 651a013649943 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
Link: https://lore.kernel.org/r/1574242755-94156-1-git-send-email-john.garry@huawei.com
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_sas.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index ef138c57e2a6..182fd25c7c43 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1391,9 +1391,6 @@ static void sas_expander_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_expander_device *edev = rphy_to_expander_device(rphy);
 
-	if (rphy->q)
-		blk_cleanup_queue(rphy->q);
-
 	put_device(dev->parent);
 	kfree(edev);
 }
@@ -1403,9 +1400,6 @@ static void sas_end_device_release(struct device *dev)
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_end_device *edev = rphy_to_end_device(rphy);
 
-	if (rphy->q)
-		blk_cleanup_queue(rphy->q);
-
 	put_device(dev->parent);
 	kfree(edev);
 }
@@ -1634,8 +1628,7 @@ sas_rphy_remove(struct sas_rphy *rphy)
 	}
 
 	sas_rphy_unlink(rphy);
-	if (rphy->q)
-		bsg_unregister_queue(rphy->q);
+	bsg_remove_queue(rphy->q);
 	transport_remove_device(dev);
 	device_del(dev);
 }
-- 
2.20.1

