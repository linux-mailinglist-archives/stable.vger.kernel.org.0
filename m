Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185BD698ECA
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 09:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBPIgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 03:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBPIgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 03:36:10 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F42367DA;
        Thu, 16 Feb 2023 00:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676536563; x=1708072563;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z3HOf/V6AqUmGiXNGqZnhtXn++kw0UgCfhTsbKX5VlI=;
  b=FIgSts+Ur1cPU5kH+EdQk5lQfjzbxOPloh8mo2spACj+1ckcDzIjtWHB
   9gWbErEnnLhF7PmejDD+hAnuiwv9TkOOhIfvC3LRNe83nqSsBS0S5GGdl
   /gqcR8KlqQH/o14gp0d1iYTdHa+3oB81M7+8h5MVYQRmThd87HqzIvl11
   mqIcob07Rhe9YuKYXcpuh1vOHlS1hVjGVW0YwQT7E4+h6ygUi1aUIBVtd
   9NKaRGn/dmHWhs+iQFv1jDyL90QnmvK7kpKLQ++46NhyMVDZlqsgMKVwk
   ovyObe4BsQlG1FD7s9BPG1emXEPl5Gw3Of/ekW3Lzg0ug6/vwwUy8Soto
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="329381554"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="329381554"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 00:36:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793947757"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="793947757"
Received: from smckenne-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.112.238])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 00:36:02 -0800
Subject: [PATCH] dax/kmem: Fix leak of memory-hotplug resources
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org
Date:   Thu, 16 Feb 2023 00:36:02 -0800
Message-ID: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While experimenting with CXL region removal the following corruption of
/proc/iomem appeared.

Before:
f010000000-f04fffffff : CXL Window 0
  f010000000-f02fffffff : region4
    f010000000-f02fffffff : dax4.0
      f010000000-f02fffffff : System RAM (kmem)

After (modprobe -r cxl_test):
f010000000-f02fffffff : **redacted binary garbage**
  f010000000-f02fffffff : System RAM (kmem)

...and testing further the same is visible with persistent memory
assigned to kmem:

Before:
480000000-243fffffff : Persistent Memory
  480000000-57e1fffff : namespace3.0
  580000000-243fffffff : dax3.0
    580000000-243fffffff : System RAM (kmem)

After (ndctl disable-region all):
480000000-243fffffff : Persistent Memory
  580000000-243fffffff : ***redacted binary garbage***
    580000000-243fffffff : System RAM (kmem)

The corrupted data is from a use-after-free of the "dax4.0" and "dax3.0"
resources, and it also shows that the "System RAM (kmem)" resource is
not being removed. The bug does not appear after "modprobe -r kmem", it
requires the parent of "dax4.0" and "dax3.0" to be removed which
re-parents the leaked "System RAM (kmem)" instances. Those in turn
reference the freed resource as a parent.

First up for the fix is release_mem_region_adjustable() needs to
reliably delete the resource inserted by add_memory_driver_managed().
That is thwarted by a check for IORESOURCE_SYSRAM that predates the
dax/kmem driver, from commit:

65c78784135f ("kernel, resource: check for IORESOURCE_SYSRAM in release_mem_region_adjustable")

That appears to be working around the behavior of HMM's
"MEMORY_DEVICE_PUBLIC" facility that has since been deleted. With that
check removed the "System RAM (kmem)" resource gets removed, but
corruption still occurs occasionally because the "dax" resource is not
reliably removed.

The dax range information is freed before the device is unregistered, so
the driver can not reliably recall (another use after free) what it is
meant to release. Lastly if that use after free got lucky, the driver
was covering up the leak of "System RAM (kmem)" due to its use of
release_resource() which detaches, but does not free, child resources.
The switch to remove_resource() forces remove_memory() to be responsible
for the deletion of the resource added by add_memory_driver_managed().

Fixes: c2f3011ee697 ("device-dax: add an allocation interface for device-dax instances")
Cc: <stable@vger.kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c  |    2 +-
 drivers/dax/kmem.c |    4 ++--
 kernel/resource.c  |   14 --------------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 012d576004e9..67a64f4c472d 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -441,8 +441,8 @@ static void unregister_dev_dax(void *dev)
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dev_dax(dev_dax);
-	free_dev_dax_ranges(dev_dax);
 	device_del(dev);
+	free_dev_dax_ranges(dev_dax);
 	put_device(dev);
 }
 
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 918d01d3fbaa..7b36db6f1cbd 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -146,7 +146,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
 					i, range.start, range.end);
-			release_resource(res);
+			remove_resource(res);
 			kfree(res);
 			data->res[i] = NULL;
 			if (mapped)
@@ -195,7 +195,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 
 		rc = remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
-			release_resource(data->res[i]);
+			remove_resource(data->res[i]);
 			kfree(data->res[i]);
 			data->res[i] = NULL;
 			success++;
diff --git a/kernel/resource.c b/kernel/resource.c
index ddbbacb9fb50..b1763b2fd7ef 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1343,20 +1343,6 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 			continue;
 		}
 
-		/*
-		 * All memory regions added from memory-hotplug path have the
-		 * flag IORESOURCE_SYSTEM_RAM. If the resource does not have
-		 * this flag, we know that we are dealing with a resource coming
-		 * from HMM/devm. HMM/devm use another mechanism to add/release
-		 * a resource. This goes via devm_request_mem_region and
-		 * devm_release_mem_region.
-		 * HMM/devm take care to release their resources when they want,
-		 * so if we are dealing with them, let us just back off here.
-		 */
-		if (!(res->flags & IORESOURCE_SYSRAM)) {
-			break;
-		}
-
 		if (!(res->flags & IORESOURCE_MEM))
 			break;
 

