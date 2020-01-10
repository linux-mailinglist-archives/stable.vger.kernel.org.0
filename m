Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E8813785C
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 22:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgAJVQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 16:16:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:59339 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgAJVQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 16:16:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 13:16:01 -0800
X-IronPort-AV: E=Sophos;i="5.69,418,1571727600"; 
   d="scan'208";a="223924571"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 13:16:01 -0800
Subject: [PATCH v3] mm/memory_hotplug: Fix remove_memory() lockdep splat
From:   Dan Williams <dan.j.williams@intel.com>
To:     akpm@linux-foundation.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 10 Jan 2020 12:59:59 -0800
Message-ID: <157868988882.2387473.11703138480034171351.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The daxctl unit test for the dax_kmem driver currently triggers the
lockdep splat below. It results from the fact that
remove_memory_block_devices() is invoked under the mem_hotplug_lock()
causing lockdep entanglements with cpu_hotplug_lock().

The mem_hotplug_lock() is not needed to synchronize the memory block
device sysfs interface vs the page online state, that is already handled
by lock_device_hotplug(). Specifically lock_device_hotplug()
is sufficient to allow try_remove_memory() to check the offline
state of the memblocks and be assured that subsequent online attempts
will be blocked. The device_online() path checks mem->section_count
before allowing any state manipulations and mem->section_count is
cleared in remove_memory_block_devices().

The add_memory() path does create memblock devices under the lock, but
there is no lockdep report on that path, and it wants to unwind the
hot-add (via arch_remove_memory()) if the memblock device creation
fails, so it is left alone for now.

This change is only possible thanks to the recent change that refactored
memory block device removal out of arch_remove_memory() (commit
4c4b7f9ba948 mm/memory_hotplug: remove memory block devices before
arch_remove_memory()).

    ======================================================
    WARNING: possible circular locking dependency detected
    5.5.0-rc3+ #230 Tainted: G           OE
    ------------------------------------------------------
    lt-daxctl/6459 is trying to acquire lock:
    ffff99c7f0003510 (kn->count#241){++++}, at: kernfs_remove_by_name_ns+0x41/0x80

    but task is already holding lock:
    ffffffffa76a5450 (mem_hotplug_lock.rw_sem){++++}, at: percpu_down_write+0x20/0xe0

    which lock already depends on the new lock.


    the existing dependency chain (in reverse order) is:

    -> #2 (mem_hotplug_lock.rw_sem){++++}:
           __lock_acquire+0x39c/0x790
           lock_acquire+0xa2/0x1b0
           get_online_mems+0x3e/0xb0
           kmem_cache_create_usercopy+0x2e/0x260
           kmem_cache_create+0x12/0x20
           ptlock_cache_init+0x20/0x28
           start_kernel+0x243/0x547
           secondary_startup_64+0xb6/0xc0

    -> #1 (cpu_hotplug_lock.rw_sem){++++}:
           __lock_acquire+0x39c/0x790
           lock_acquire+0xa2/0x1b0
           cpus_read_lock+0x3e/0xb0
           online_pages+0x37/0x300
           memory_subsys_online+0x17d/0x1c0
           device_online+0x60/0x80
           state_store+0x65/0xd0
           kernfs_fop_write+0xcf/0x1c0
           vfs_write+0xdb/0x1d0
           ksys_write+0x65/0xe0
           do_syscall_64+0x5c/0xa0
           entry_SYSCALL_64_after_hwframe+0x49/0xbe

    -> #0 (kn->count#241){++++}:
           check_prev_add+0x98/0xa40
           validate_chain+0x576/0x860
           __lock_acquire+0x39c/0x790
           lock_acquire+0xa2/0x1b0
           __kernfs_remove+0x25f/0x2e0
           kernfs_remove_by_name_ns+0x41/0x80
           remove_files.isra.0+0x30/0x70
           sysfs_remove_group+0x3d/0x80
           sysfs_remove_groups+0x29/0x40
           device_remove_attrs+0x39/0x70
           device_del+0x16a/0x3f0
           device_unregister+0x16/0x60
           remove_memory_block_devices+0x82/0xb0
           try_remove_memory+0xb5/0x130
           remove_memory+0x26/0x40
           dev_dax_kmem_remove+0x44/0x6a [kmem]
           device_release_driver_internal+0xe4/0x1c0
           unbind_store+0xef/0x120
           kernfs_fop_write+0xcf/0x1c0
           vfs_write+0xdb/0x1d0
           ksys_write+0x65/0xe0
           do_syscall_64+0x5c/0xa0
           entry_SYSCALL_64_after_hwframe+0x49/0xbe

    other info that might help us debug this:

    Chain exists of:
      kn->count#241 --> cpu_hotplug_lock.rw_sem --> mem_hotplug_lock.rw_sem

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(mem_hotplug_lock.rw_sem);
                                   lock(cpu_hotplug_lock.rw_sem);
                                   lock(mem_hotplug_lock.rw_sem);
      lock(kn->count#241);

     *** DEADLOCK ***

No fixes tag as this seems to have been a long standing issue that
likely predated the addition of kernfs lockdep annotations.

Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v2 [1]:
- Apologies I overlooked that I had local changes in my tree to fix a
  compiler error (misspelled assert_held_device_hotplug()). Now fixed
  up.

[1]: http://lore.kernel.org/r/157868867304.2306270.4899678179641333013.stgit@dwillia2-desk3.amr.corp.intel.com

 Documentation/core-api/memory-hotplug.rst |   15 +++++++++++----
 drivers/base/core.c                       |    5 +++++
 drivers/base/memory.c                     |    8 ++++++--
 include/linux/device.h                    |    1 +
 mm/memory_hotplug.c                       |   10 +++++++---
 5 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/Documentation/core-api/memory-hotplug.rst b/Documentation/core-api/memory-hotplug.rst
index de7467e48067..637b467378b7 100644
--- a/Documentation/core-api/memory-hotplug.rst
+++ b/Documentation/core-api/memory-hotplug.rst
@@ -90,12 +90,13 @@ Locking Internals
 =================
 
 When adding/removing memory that uses memory block devices (i.e. ordinary RAM),
-the device_hotplug_lock should be held to:
+the device_hotplug_lock is held to:
 
 - synchronize against online/offline requests (e.g. via sysfs). This way, memory
   block devices can only be accessed (.online/.state attributes) by user
-  space once memory has been fully added. And when removing memory, we
-  know nobody is in critical sections.
+  space once memory has been fully added. And when removing memory, the
+  memory block device is invalidated (mem->section count set to 0) under the
+  lock to abort any in-flight online requests.
 - synchronize against CPU hotplug and similar (e.g. relevant for ACPI and PPC)
 
 Especially, there is a possible lock inversion that is avoided using
@@ -112,7 +113,13 @@ can result in a lock inversion.
 
 onlining/offlining of memory should be done via device_online()/
 device_offline() - to make sure it is properly synchronized to actions
-via sysfs. Holding device_hotplug_lock is advised (to e.g. protect online_type)
+via sysfs. Holding device_hotplug_lock is required to prevent online racing
+removal. The device_hotplug_lock and memblock invalidation allows
+remove_memory_block_devices() to run outside of mem_hotplug_lock to avoid lock
+dependency conflicts with memblock-sysfs teardown. The add_memory() path
+performs create_memory_block_devices() under mem_hotplug_lock so that if it
+fails it can perform an arch_remove_memory() cleanup. There are no known lock
+dependency problems with memblock-sysfs setup.
 
 When adding/removing/onlining/offlining memory or adding/removing
 heterogeneous/device memory, we should always hold the mem_hotplug_lock in
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 42a672456432..5d5036370c92 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1146,6 +1146,11 @@ void unlock_device_hotplug(void)
 	mutex_unlock(&device_hotplug_lock);
 }
 
+void assert_held_device_hotplug(void)
+{
+	lockdep_assert_held(&device_hotplug_lock);
+}
+
 int lock_device_hotplug_sysfs(void)
 {
 	if (mutex_trylock(&device_hotplug_lock))
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 799b43191dea..91c6fbd2383e 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -280,6 +280,10 @@ static int memory_subsys_online(struct device *dev)
 	if (mem->state == MEM_ONLINE)
 		return 0;
 
+	/* online lost the race with hot-unplug, abort */
+	if (!mem->section_count)
+		return -ENXIO;
+
 	/*
 	 * If we are called from state_store(), online_type will be
 	 * set >= 0 Otherwise we were called from the device online
@@ -736,8 +740,6 @@ int create_memory_block_devices(unsigned long start, unsigned long size)
  * Remove memory block devices for the given memory area. Start and size
  * have to be aligned to memory block granularity. Memory block devices
  * have to be offline.
- *
- * Called under device_hotplug_lock.
  */
 void remove_memory_block_devices(unsigned long start, unsigned long size)
 {
@@ -746,6 +748,8 @@ void remove_memory_block_devices(unsigned long start, unsigned long size)
 	struct memory_block *mem;
 	unsigned long block_id;
 
+	assert_held_device_hotplug();
+
 	if (WARN_ON_ONCE(!IS_ALIGNED(start, memory_block_size_bytes()) ||
 			 !IS_ALIGNED(size, memory_block_size_bytes())))
 		return;
diff --git a/include/linux/device.h b/include/linux/device.h
index 96ff76731e93..e042da3b1953 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1553,6 +1553,7 @@ static inline bool device_supports_offline(struct device *dev)
 extern void lock_device_hotplug(void);
 extern void unlock_device_hotplug(void);
 extern int lock_device_hotplug_sysfs(void);
+extern void assert_held_device_hotlpug(void);
 extern int device_offline(struct device *dev);
 extern int device_online(struct device *dev);
 extern void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 55ac23ef11c1..0158cd4cca48 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1763,8 +1763,6 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
-	mem_hotplug_begin();
-
 	/*
 	 * All memory blocks must be offlined before removing memory.  Check
 	 * whether all memory blocks in question are offline and return error
@@ -1777,9 +1775,15 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
-	/* remove memory block devices before removing memory */
+	/*
+	 * Remove memory block devices before removing memory and before
+	 * mem_hotplug_begin() (see Documentation/core-api/memory-hotplug.rst
+	 * "Locking Internals").
+	 */
 	remove_memory_block_devices(start, size);
 
+	mem_hotplug_begin();
+
 	arch_remove_memory(nid, start, size, NULL);
 	memblock_free(start, size);
 	memblock_remove(start, size);

