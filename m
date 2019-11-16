Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46651FEE3A
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbfKPPuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730413AbfKPPuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:07 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC3120857;
        Sat, 16 Nov 2019 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919405;
        bh=oWcwd+FN3BZWj+mOzGD/owj3Ghki+hBzbszw+PQoejY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZVD5cBWItpa/Ksuby/8zw8N2lckaVN1DDwtUXuVzQuR7ZgUnfRf65O0lwz/acagZ
         85EGHpYwwsSN1RevPncs9mByRKogmKADwHqTI2udozy2QwLOGOVeL3aKedZ79x+l2K
         FMxtzODxOgTyxIi1FmhBlSY2w/5HdjxVUndIft2o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Rashmica Gupta <rashmica.g@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mathieu Malaterre <malat@debian.org>,
        YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.14 104/150] mm/memory_hotplug: make add_memory() take the device_hotplug_lock
Date:   Sat, 16 Nov 2019 10:46:42 -0500
Message-Id: <20191116154729.9573-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 8df1d0e4a265f25dc1e7e7624ccdbcb4a6630c89 ]

add_memory() currently does not take the device_hotplug_lock, however
is aleady called under the lock from
	arch/powerpc/platforms/pseries/hotplug-memory.c
	drivers/acpi/acpi_memhotplug.c
to synchronize against CPU hot-remove and similar.

In general, we should hold the device_hotplug_lock when adding memory to
synchronize against online/offline request (e.g.  from user space) - which
already resulted in lock inversions due to device_lock() and
mem_hotplug_lock - see 30467e0b3be ("mm, hotplug: fix concurrent memory
hot-add deadlock").  add_memory()/add_memory_resource() will create memory
block devices, so this really feels like the right thing to do.

Holding the device_hotplug_lock makes sure that a memory block device
can really only be accessed (e.g. via .online/.state) from user space,
once the memory has been fully added to the system.

The lock is not held yet in
	drivers/xen/balloon.c
	arch/powerpc/platforms/powernv/memtrace.c
	drivers/s390/char/sclp_cmd.c
	drivers/hv/hv_balloon.c
So, let's either use the locked variants or take the lock.

Don't export add_memory_resource(), as it once was exported to be used by
XEN, which is never built as a module.  If somebody requires it, we also
have to export a locked variant (as device_hotplug_lock is never
exported).

Link: http://lkml.kernel.org/r/20180925091457.28651-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Rashmica Gupta <rashmica.g@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platforms/pseries/hotplug-memory.c        |  2 +-
 drivers/acpi/acpi_memhotplug.c                |  2 +-
 drivers/base/memory.c                         |  9 ++++++--
 drivers/xen/balloon.c                         |  3 +++
 include/linux/memory_hotplug.h                |  1 +
 mm/memory_hotplug.c                           | 22 ++++++++++++++++---
 6 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 93e09f108ca17..99a3cf51c5ba4 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -787,7 +787,7 @@ static int dlpar_add_lmb(struct of_drconf_cell *lmb)
 	nid = memory_add_physaddr_to_nid(lmb->base_addr);
 
 	/* Add the memory */
-	rc = add_memory(nid, lmb->base_addr, block_sz);
+	rc = __add_memory(nid, lmb->base_addr, block_sz);
 	if (rc) {
 		dlpar_remove_device_tree_lmb(lmb);
 		return rc;
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 6b0d3ef7309cb..2ccfbb61ca899 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -228,7 +228,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 		if (node < 0)
 			node = memory_add_physaddr_to_nid(info->start_addr);
 
-		result = add_memory(node, info->start_addr, info->length);
+		result = __add_memory(node, info->start_addr, info->length);
 
 		/*
 		 * If the memory block has been used by the kernel, add_memory()
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index c617e00f4361d..8e5818e735e2f 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -517,15 +517,20 @@ memory_probe_store(struct device *dev, struct device_attribute *attr,
 	if (phys_addr & ((pages_per_block << PAGE_SHIFT) - 1))
 		return -EINVAL;
 
+	ret = lock_device_hotplug_sysfs();
+	if (ret)
+		goto out;
+
 	nid = memory_add_physaddr_to_nid(phys_addr);
-	ret = add_memory(nid, phys_addr,
-			 MIN_MEMORY_BLOCK_SIZE * sections_per_block);
+	ret = __add_memory(nid, phys_addr,
+			   MIN_MEMORY_BLOCK_SIZE * sections_per_block);
 
 	if (ret)
 		goto out;
 
 	ret = count;
 out:
+	unlock_device_hotplug();
 	return ret;
 }
 
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 7d521babc020b..71a6deeb4e714 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -356,7 +356,10 @@ static enum bp_state reserve_additional_memory(void)
 	 * callers drop the mutex before trying again.
 	 */
 	mutex_unlock(&balloon_mutex);
+	/* add_memory_resource() requires the device_hotplug lock */
+	lock_device_hotplug();
 	rc = add_memory_resource(nid, resource, memhp_auto_online);
+	unlock_device_hotplug();
 	mutex_lock(&balloon_mutex);
 
 	if (rc) {
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 58e110aee7ab4..d36a029353915 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -316,6 +316,7 @@ static inline void remove_memory(int nid, u64 start, u64 size) {}
 
 extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
 		void *arg, int (*func)(struct memory_block *, void *));
+extern int __add_memory(int nid, u64 start, u64 size);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int add_memory_resource(int nid, struct resource *resource, bool online);
 extern int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c9d3a49bd4e20..4dfcee4a779f3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1110,7 +1110,12 @@ static int online_memory_block(struct memory_block *mem, void *arg)
 	return device_online(&mem->dev);
 }
 
-/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
+/*
+ * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
+ * and online/offline operations (triggered e.g. by sysfs).
+ *
+ * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
+ */
 int __ref add_memory_resource(int nid, struct resource *res, bool online)
 {
 	u64 start, size;
@@ -1203,9 +1208,9 @@ int __ref add_memory_resource(int nid, struct resource *res, bool online)
 	mem_hotplug_done();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(add_memory_resource);
 
-int __ref add_memory(int nid, u64 start, u64 size)
+/* requires device_hotplug_lock, see add_memory_resource() */
+int __ref __add_memory(int nid, u64 start, u64 size)
 {
 	struct resource *res;
 	int ret;
@@ -1219,6 +1224,17 @@ int __ref add_memory(int nid, u64 start, u64 size)
 		release_memory_resource(res);
 	return ret;
 }
+
+int add_memory(int nid, u64 start, u64 size)
+{
+	int rc;
+
+	lock_device_hotplug();
+	rc = __add_memory(nid, start, size);
+	unlock_device_hotplug();
+
+	return rc;
+}
 EXPORT_SYMBOL_GPL(add_memory);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-- 
2.20.1

