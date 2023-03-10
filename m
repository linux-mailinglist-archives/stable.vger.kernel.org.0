Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30ED66B4984
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbjCJPNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbjCJPNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5210123CF1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:04:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B5461AB3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB61C433EF;
        Fri, 10 Mar 2023 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460632;
        bh=bn8OK/+buCI53Y7MVSZGuZJ9FDYE4XFexSIR6kBTu6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+6I1buGpiw4faAPB50oN8ii3QE3CQgZClNGFO0XjaS1oNfQfca9JeQ7dhQxQhgcl
         Zi00eKXADFicpl8J5Gan2YzplG1VtE12zjnJ29sBMKknyQZPrBIuh0/NTy9t0cMH9Z
         veLx2IwDDHGMlFq0CNzA5Qr85PKW1WVdayBmCIfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 399/529] dax/kmem: Fix leak of memory-hotplug resources
Date:   Fri, 10 Mar 2023 14:39:02 +0100
Message-Id: <20230310133823.479010651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit e686c32590f40bffc45f105c04c836ffad3e531a upstream.

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
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dax/bus.c  |    2 +-
 drivers/dax/kmem.c |    4 ++--
 kernel/resource.c  |   14 --------------
 3 files changed, 3 insertions(+), 17 deletions(-)

--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -398,8 +398,8 @@ static void unregister_dev_dax(void *dev
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dev_dax(dev_dax);
-	free_dev_dax_ranges(dev_dax);
 	device_del(dev);
+	free_dev_dax_ranges(dev_dax);
 	put_device(dev);
 }
 
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -114,7 +114,7 @@ static int dev_dax_kmem_probe(struct dev
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
 					i, range.start, range.end);
-			release_resource(res);
+			remove_resource(res);
 			kfree(res);
 			data->res[i] = NULL;
 			if (mapped)
@@ -159,7 +159,7 @@ static int dev_dax_kmem_remove(struct de
 		rc = remove_memory(dev_dax->target_node, range.start,
 				range_len(&range));
 		if (rc == 0) {
-			release_resource(data->res[i]);
+			remove_resource(data->res[i]);
 			kfree(data->res[i]);
 			data->res[i] = NULL;
 			success++;
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1293,20 +1293,6 @@ retry:
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
 


