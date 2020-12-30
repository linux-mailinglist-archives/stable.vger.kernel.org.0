Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C272E7939
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgL3NHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727408AbgL3NFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23CAB22518;
        Wed, 30 Dec 2020 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333436;
        bh=SHB07QfCbcbmVswscL9DwuxHf9OdMw/mk9kJJpvVTLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PW2GceuGtHKw3+6KpyKFw2RKLL7VpwZ2dx2+ip0cz/PX0JodDvSavKtWNCxZLxrgv
         cgv75f4vaizM0oC8paOdz4+zFy/M60BZeI7n2NGRa0VLTcg985hQjLySaOLbpH+eiD
         tgeop1EGY1Y+Q6tJ4LDfOvADEgEZTALxk1y8vFRmmx3N88MUO+hvU8wmiF1GUM+5lP
         6T38NQAnogAERYsYxhvu03HKU6O6dU8bP/TXWU/Cge/MV5R2bTdgEktFi7m4cQE/kc
         MYTOFK741Bisypq8C2sB5ibr6x2PCAYRvjQEyy/pDgKm0yhAOwNqVA6h8WPP6nZDJ+
         FIYDzwLXWkO/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Jane Chu <jane.chu@oracle.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 5.10 31/31] device-dax: Fix range release
Date:   Wed, 30 Dec 2020 08:03:13 -0500
Message-Id: <20201230130314.3636961-31-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 6268d7da4d192af339f4d688942b9ccb45a65e04 ]

There are multiple locations that open-code the release of the last
range in a device-dax instance. Consolidate this into a new
dev_dax_trim_range() helper.

This also addresses a kmemleak report:

# cat /sys/kernel/debug/kmemleak
[..]
unreferenced object 0xffff976bd46f6240 (size 64):
   comm "ndctl", pid 23556, jiffies 4299514316 (age 5406.733s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 20 c3 37 00 00 00  .......... .7...
     ff ff ff 7f 38 00 00 00 00 00 00 00 00 00 00 00  ....8...........
   backtrace:
     [<00000000064003cf>] __kmalloc_track_caller+0x136/0x379
     [<00000000d85e3c52>] krealloc+0x67/0x92
     [<00000000d7d3ba8a>] __alloc_dev_dax_range+0x73/0x25c
     [<0000000027d58626>] devm_create_dev_dax+0x27d/0x416
     [<00000000434abd43>] __dax_pmem_probe+0x1c9/0x1000 [dax_pmem_core]
     [<0000000083726c1c>] dax_pmem_probe+0x10/0x1f [dax_pmem]
     [<00000000b5f2319c>] nvdimm_bus_probe+0x9d/0x340 [libnvdimm]
     [<00000000c055e544>] really_probe+0x230/0x48d
     [<000000006cabd38e>] driver_probe_device+0x122/0x13b
     [<0000000029c7b95a>] device_driver_attach+0x5b/0x60
     [<0000000053e5659b>] bind_store+0xb7/0xc3
     [<00000000d3bdaadc>] drv_attr_store+0x27/0x31
     [<00000000949069c5>] sysfs_kf_write+0x4a/0x57
     [<000000004a8b5adf>] kernfs_fop_write+0x150/0x1e5
     [<00000000bded60f0>] __vfs_write+0x1b/0x34
     [<00000000b92900f0>] vfs_write+0xd8/0x1d1

Reported-by: Jane Chu <jane.chu@oracle.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/160834570161.1791850.14911670304441510419.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 27513d311242e..de7b74505e75e 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -367,19 +367,28 @@ void kill_dev_dax(struct dev_dax *dev_dax)
 }
 EXPORT_SYMBOL_GPL(kill_dev_dax);
 
-static void free_dev_dax_ranges(struct dev_dax *dev_dax)
+static void trim_dev_dax_range(struct dev_dax *dev_dax)
 {
+	int i = dev_dax->nr_range - 1;
+	struct range *range = &dev_dax->ranges[i].range;
 	struct dax_region *dax_region = dev_dax->region;
-	int i;
 
 	device_lock_assert(dax_region->dev);
-	for (i = 0; i < dev_dax->nr_range; i++) {
-		struct range *range = &dev_dax->ranges[i].range;
-
-		__release_region(&dax_region->res, range->start,
-				range_len(range));
+	dev_dbg(&dev_dax->dev, "delete range[%d]: %#llx:%#llx\n", i,
+		(unsigned long long)range->start,
+		(unsigned long long)range->end);
+
+	__release_region(&dax_region->res, range->start, range_len(range));
+	if (--dev_dax->nr_range == 0) {
+		kfree(dev_dax->ranges);
+		dev_dax->ranges = NULL;
 	}
-	dev_dax->nr_range = 0;
+}
+
+static void free_dev_dax_ranges(struct dev_dax *dev_dax)
+{
+	while (dev_dax->nr_range)
+		trim_dev_dax_range(dev_dax);
 }
 
 static void unregister_dev_dax(void *dev)
@@ -804,15 +813,10 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 		return 0;
 
 	rc = devm_register_dax_mapping(dev_dax, dev_dax->nr_range - 1);
-	if (rc) {
-		dev_dbg(dev, "delete range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
-				&alloc->start, &alloc->end);
-		dev_dax->nr_range--;
-		__release_region(res, alloc->start, resource_size(alloc));
-		return rc;
-	}
+	if (rc)
+		trim_dev_dax_range(dev_dax);
 
-	return 0;
+	return rc;
 }
 
 static int adjust_dev_dax_range(struct dev_dax *dev_dax, struct resource *res, resource_size_t size)
@@ -885,12 +889,7 @@ static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
 		if (shrink >= range_len(range)) {
 			devm_release_action(dax_region->dev,
 					unregister_dax_mapping, &mapping->dev);
-			__release_region(&dax_region->res, range->start,
-					range_len(range));
-			dev_dax->nr_range--;
-			dev_dbg(dev, "delete range[%d]: %#llx:%#llx\n", i,
-					(unsigned long long) range->start,
-					(unsigned long long) range->end);
+			trim_dev_dax_range(dev_dax);
 			to_shrink -= shrink;
 			if (!to_shrink)
 				break;
@@ -1274,7 +1273,6 @@ static void dev_dax_release(struct device *dev)
 	put_dax(dax_dev);
 	free_dev_dax_id(dev_dax);
 	dax_region_put(dax_region);
-	kfree(dev_dax->ranges);
 	kfree(dev_dax->pgmap);
 	kfree(dev_dax);
 }
-- 
2.27.0

