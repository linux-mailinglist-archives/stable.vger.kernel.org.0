Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4E0145683
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAVN1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731505AbgAVN1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:30 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83AED205F4;
        Wed, 22 Jan 2020 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699649;
        bh=4yD1R+pFhDL9C4bL1QzVzvgSM2HNYuoVeKThpzCZuLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCE8ZXaCa3OwrE4SF9fXfJtbE2PAlzfrldff0C1xpA+OB4plY2rsKj+CxzEalgy5P
         mY18YplW/OKTZy+x6qVXnQrtm0GpWlezAXxJqBkH5IVio1u+HVJRGG9/B+l3gnlNCz
         ZCvUCf0CRPzqLjGvE45Ge8WAlEALE1tagMmDhWGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 207/222] scsi: scsi_transport_sas: Fix memory leak when removing devices
Date:   Wed, 22 Jan 2020 10:29:53 +0100
Message-Id: <20200122092848.520088601@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit 82ea3e0e129e2ab913dd6684bab7a6e5e9896dee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_transport_sas.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1391,9 +1391,6 @@ static void sas_expander_release(struct
 	struct sas_rphy *rphy = dev_to_rphy(dev);
 	struct sas_expander_device *edev = rphy_to_expander_device(rphy);
 
-	if (rphy->q)
-		blk_cleanup_queue(rphy->q);
-
 	put_device(dev->parent);
 	kfree(edev);
 }
@@ -1403,9 +1400,6 @@ static void sas_end_device_release(struc
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


