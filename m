Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1605D23EA
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389450AbfJJIrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389443AbfJJIrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CF8E208C3;
        Thu, 10 Oct 2019 08:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697236;
        bh=7ch7fa8xt7m9sTjItZKKm7VWiIT1JOyRua/JC9oQ76s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlyFfhjN6Yq78Cn1nzLp/ZhHx+Ipf2MIDgVtz2nF1n9fqxOHe3sbIMIhw6grNlaJy
         F7Ipc+magZVGoqypIpbS4HhPaeh3pbv6p1de9CtUmJWxgs4VWJ0Mtv/Br9txuicbGX
         rvdhOmLxVZhgZ03fWwEHSsI8Ie6rpGb9xaLg+fYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/114] libnvdimm/region: Initialize bad block for volatile namespaces
Date:   Thu, 10 Oct 2019 10:36:14 +0200
Message-Id: <20191010083610.792337498@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit c42adf87e4e7ed77f6ffe288dc90f980d07d68df ]

We do check for a bad block during namespace init and that use
region bad block list. We need to initialize the bad block
for volatile regions for this to work. We also observe a lockdep
warning as below because the lock is not initialized correctly
since we skip bad block init for volatile regions.

 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.
 CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.3.0-rc1-15699-g3dee241c937e #149
 Call Trace:
 [c0000000f95cb250] [c00000000147dd84] dump_stack+0xe8/0x164 (unreliable)
 [c0000000f95cb2a0] [c00000000022ccd8] register_lock_class+0x308/0xa60
 [c0000000f95cb3a0] [c000000000229cc0] __lock_acquire+0x170/0x1ff0
 [c0000000f95cb4c0] [c00000000022c740] lock_acquire+0x220/0x270
 [c0000000f95cb580] [c000000000a93230] badblocks_check+0xc0/0x290
 [c0000000f95cb5f0] [c000000000d97540] nd_pfn_validate+0x5c0/0x7f0
 [c0000000f95cb6d0] [c000000000d98300] nd_dax_probe+0xd0/0x1f0
 [c0000000f95cb760] [c000000000d9b66c] nd_pmem_probe+0x10c/0x160
 [c0000000f95cb790] [c000000000d7f5ec] nvdimm_bus_probe+0x10c/0x240
 [c0000000f95cb820] [c000000000d0f844] really_probe+0x254/0x4e0
 [c0000000f95cb8b0] [c000000000d0fdfc] driver_probe_device+0x16c/0x1e0
 [c0000000f95cb930] [c000000000d10238] device_driver_attach+0x68/0xa0
 [c0000000f95cb970] [c000000000d1040c] __driver_attach+0x19c/0x1c0
 [c0000000f95cb9f0] [c000000000d0c4c4] bus_for_each_dev+0x94/0x130
 [c0000000f95cba50] [c000000000d0f014] driver_attach+0x34/0x50
 [c0000000f95cba70] [c000000000d0e208] bus_add_driver+0x178/0x2f0
 [c0000000f95cbb00] [c000000000d117c8] driver_register+0x108/0x170
 [c0000000f95cbb70] [c000000000d7edb0] __nd_driver_register+0xe0/0x100
 [c0000000f95cbbd0] [c000000001a6baa4] nd_pmem_driver_init+0x34/0x48
 [c0000000f95cbbf0] [c0000000000106f4] do_one_initcall+0x1d4/0x4b0
 [c0000000f95cbcd0] [c0000000019f499c] kernel_init_freeable+0x544/0x65c
 [c0000000f95cbdb0] [c000000000010d6c] kernel_init+0x2c/0x180
 [c0000000f95cbe20] [c00000000000b954] ret_from_kernel_thread+0x5c/0x68

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Link: https://lore.kernel.org/r/20190919083355.26340-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/bus.c         | 2 +-
 drivers/nvdimm/region.c      | 4 ++--
 drivers/nvdimm/region_devs.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 2ba22cd1331b0..54a633e8cb5d2 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -189,7 +189,7 @@ static int nvdimm_clear_badblocks_region(struct device *dev, void *data)
 	sector_t sector;
 
 	/* make sure device is a region */
-	if (!is_nd_pmem(dev))
+	if (!is_memory(dev))
 		return 0;
 
 	nd_region = to_nd_region(dev);
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index f9130cc157e83..22224b21c34df 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -42,7 +42,7 @@ static int nd_region_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (is_nd_pmem(&nd_region->dev)) {
+	if (is_memory(&nd_region->dev)) {
 		struct resource ndr_res;
 
 		if (devm_init_badblocks(dev, &nd_region->bb))
@@ -131,7 +131,7 @@ static void nd_region_notify(struct device *dev, enum nvdimm_event event)
 		struct nd_region *nd_region = to_nd_region(dev);
 		struct resource res;
 
-		if (is_nd_pmem(&nd_region->dev)) {
+		if (is_memory(&nd_region->dev)) {
 			res.start = nd_region->ndr_start;
 			res.end = nd_region->ndr_start +
 				nd_region->ndr_size - 1;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 0303296e6d5b6..609fc450522a1 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -633,11 +633,11 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_memory(dev) && a == &dev_attr_dax_seed.attr)
 		return 0;
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_badblocks.attr)
+	if (!is_memory(dev) && a == &dev_attr_badblocks.attr)
 		return 0;
 
 	if (a == &dev_attr_resource.attr) {
-		if (is_nd_pmem(dev))
+		if (is_memory(dev))
 			return 0400;
 		else
 			return 0;
-- 
2.20.1



