Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACABF1E03D8
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388481AbgEXXST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 19:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388468AbgEXXST (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 May 2020 19:18:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56BC420787;
        Sun, 24 May 2020 23:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590362298;
        bh=PdYawrpSTIH1Eyzm27sgw4BMb4sh7YOuZAvAgFZyQgo=;
        h=Date:From:To:Subject:From;
        b=p6TET02aMbHqqJ4qONM1oh8FgbEH9++PzCBWRu4Wfk9U18ZdGJgF6Jh7pAH7bLzUa
         yKrWlbZnotOZKdBK8qWq8PGGE+M/ColKm73sAQPWtnsVMcL0PV+RVx6QTEGoPc+XT5
         BRqGhz7qaaeoAqPao8vFLF5pImvgqq7/CLwrBG7c=
Date:   Sun, 24 May 2020 16:18:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        dave.jiang@intel.com, david@redhat.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, stable@vger.kernel.org,
        vishal.l.verma@intel.com
Subject:  [merged]
 device-dax-dont-leak-kernel-memory-to-user-space-after-unloading-kmem.patch
 removed from -mm tree
Message-ID: <20200524231817.Yw8HV20Pm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: device-dax: don't leak kernel memory to user space after unlo=
ading kmem
has been removed from the -mm tree.  Its filename was
     device-dax-dont-leak-kernel-memory-to-user-space-after-unloading-kmem.=
patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: David Hildenbrand <david@redhat.com>
Subject: device-dax: don't leak kernel memory to user space after unloading=
 kmem

Assume we have kmem configured and loaded:
  [root@localhost ~]# cat /proc/iomem
  ...
  140000000-33fffffff : Persistent Memory$
    140000000-1481fffff : namespace0.0
    150000000-33fffffff : dax0.0
      150000000-33fffffff : System RAM

Assume we try to unload kmem. This force-unloading will work, even if
memory cannot get removed from the system.
  [root@localhost ~]# rmmod kmem
  [   86.380228] removing memory fails, because memory [0x0000000150000000-=
0x0000000157ffffff] is onlined
  ...
  [   86.431225] kmem dax0.0: DAX region [mem 0x150000000-0x33fffffff] cann=
ot be hotremoved until the next reboot

Now, we can reconfigure the namespace:
  [root@localhost ~]# ndctl create-namespace --force --reconfig=3Dnamespace=
0.0 --mode=3Ddevdax
  [  131.409351] nd_pmem namespace0.0: could not reserve region [mem 0x1400=
00000-0x33fffffff]dax
  [  131.410147] nd_pmem: probe of namespace0.0 failed with error -16namesp=
ace0.0 --mode=3Ddevdax
  ...

This fails as expected due to the busy memory resource, and the memory
cannot be used. However, the dax0.0 device is removed, and along its name.

The name of the memory resource now points at freed memory (name of the
device).
  [root@localhost ~]# cat /proc/iomem
  ...
  140000000-33fffffff : Persistent Memory
    140000000-1481fffff : namespace0.0
    150000000-33fffffff : =EF=BF=BD_=EF=BF=BD^7_=EF=BF=BD=EF=BF=BD/_=EF=BF=
=BD=EF=BF=BDwR=EF=BF=BD=EF=BF=BDWQ=EF=BF=BD=EF=BF=BD=EF=BF=BD^=EF=BF=BD=EF=
=BF=BD=EF=BF=BD ...
    150000000-33fffffff : System RAM

We have to make sure to duplicate the string.  While at it, remove the
superfluous setting of the name and fixup a stale comment.

Link: http://lkml.kernel.org/r/20200508084217.9160-2-david@redhat.com
Fixes: 9f960da72b25 ("device-dax: "Hotremove" persistent memory that is use=
d like normal RAM")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>	[5.3]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/dax/kmem.c~device-dax-dont-leak-kernel-memory-to-user-space-a=
fter-unloading-kmem
+++ a/drivers/dax/kmem.c
@@ -22,6 +22,7 @@ int dev_dax_kmem_probe(struct device *de
 	resource_size_t kmem_size;
 	resource_size_t kmem_end;
 	struct resource *new_res;
+	const char *new_res_name;
 	int numa_node;
 	int rc;
=20
@@ -48,11 +49,16 @@ int dev_dax_kmem_probe(struct device *de
 	kmem_size &=3D ~(memory_block_size_bytes() - 1);
 	kmem_end =3D kmem_start + kmem_size;
=20
-	/* Region is permanently reserved.  Hot-remove not yet implemented. */
-	new_res =3D request_mem_region(kmem_start, kmem_size, dev_name(dev));
+	new_res_name =3D kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!new_res_name)
+		return -ENOMEM;
+
+	/* Region is permanently reserved if hotremove fails. */
+	new_res =3D request_mem_region(kmem_start, kmem_size, new_res_name);
 	if (!new_res) {
 		dev_warn(dev, "could not reserve region [%pa-%pa]\n",
 			 &kmem_start, &kmem_end);
+		kfree(new_res_name);
 		return -EBUSY;
 	}
=20
@@ -63,12 +69,12 @@ int dev_dax_kmem_probe(struct device *de
 	 * unknown to us that will break add_memory() below.
 	 */
 	new_res->flags =3D IORESOURCE_SYSTEM_RAM;
-	new_res->name =3D dev_name(dev);
=20
 	rc =3D add_memory(numa_node, new_res->start, resource_size(new_res));
 	if (rc) {
 		release_resource(new_res);
 		kfree(new_res);
+		kfree(new_res_name);
 		return rc;
 	}
 	dev_dax->dax_kmem_res =3D new_res;
@@ -83,6 +89,7 @@ static int dev_dax_kmem_remove(struct de
 	struct resource *res =3D dev_dax->dax_kmem_res;
 	resource_size_t kmem_start =3D res->start;
 	resource_size_t kmem_size =3D resource_size(res);
+	const char *res_name =3D res->name;
 	int rc;
=20
 	/*
@@ -102,6 +109,7 @@ static int dev_dax_kmem_remove(struct de
 	/* Release and free dax resources */
 	release_resource(res);
 	kfree(res);
+	kfree(res_name);
 	dev_dax->dax_kmem_res =3D NULL;
=20
 	return 0;
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix=
.patch
powerpc-pseries-hotplug-memory-stop-checking-is_mem_section_removable.patch
mm-memory_hotplug-remove-is_mem_section_removable.patch
mm-memory_hotplug-set-node_start_pfn-of-hotadded-pgdat-to-0.patch
mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock.patch
mm-memory_hotplug-introduce-add_memory_driver_managed.patch
kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed.patch
device-dax-add-memory-via-add_memory_driver_managed.patch

