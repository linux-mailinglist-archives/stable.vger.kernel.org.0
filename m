Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A90014F523
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 00:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAaXQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 18:16:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 18:16:44 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53552071A;
        Fri, 31 Jan 2020 23:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580512603;
        bh=jS2otkRHMlLWcZoHH//wj1/PbDGB2/gIsk87F30XNmA=;
        h=Date:From:To:Subject:From;
        b=giPu7Vb8c1AxGHbrkqyenn9FVVeXaMXPC6k6NGM2GN4dg44dAxHOTErw/QQ0S38Wc
         gs+AfFnPPPwmyK/F12LjecXJtdcsmb48PepMImy5J31UJbJA8FKrS/u5zv1SCExBJN
         hdJXYXy9qkQm32AfFCxzeUYbh2MtKZ7/Gmil8lZw=
Date:   Fri, 31 Jan 2020 15:16:42 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, stable@vger.kernel.org,
        vishal.l.verma@intel.com
Subject:  [merged]
 mm-memory_hotplug-fix-remove_memory-lockdep-splat.patch removed from -mm
 tree
Message-ID: <20200131231642.l78ZAyzTm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix remove_memory() lockdep splat
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-remove_memory-lockdep-splat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memory_hotplug: fix remove_memory() lockdep splat

The daxctl unit test for the dax_kmem driver currently triggers the (false
positive) lockdep splat below.  It results from the fact that
remove_memory_block_devices() is invoked under the mem_hotplug_lock()
causing lockdep entanglements with cpu_hotplug_lock() and sysfs (kernfs
active state tracking).  It is a false positive because the sysfs
attribute path triggering the memory remove is not the same attribute path
associated with memory-block device.

sysfs_break_active_protection() is not applicable since there is no real
deadlock conflict, instead move memory-block device removal outside the
lock.  The mem_hotplug_lock() is not needed to synchronize the
memory-block device removal vs the page online state, that is already
handled by lock_device_hotplug().  Specifically, lock_device_hotplug() is
sufficient to allow try_remove_memory() to check the offline state of the
memblocks and be assured that any in progress online attempts are flushed
/ blocked by kernfs_drain() / attribute removal.

The add_memory() path safely creates memblock devices under the
mem_hotplug_lock().  There is no kernfs active state synchronization in
the memblock device_register() path, so nothing to fix there.

This change is only possible thanks to the recent change that refactored
memory block device removal out of arch_remove_memory() (commit
4c4b7f9ba948 mm/memory_hotplug: remove memory block devices before
arch_remove_memory()), and David's due diligence tracking down the
guarantees afforded by kernfs_drain().  Not flagged for -stable since this
only impacts ongoing development and lockdep validation, not a runtime
issue.

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

No fixes tag as this has been a long standing issue that predated the
addition of kernfs lockdep annotations.

Link: http://lkml.kernel.org/r/157991441887.2763922.4770790047389427325.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-remove_memory-lockdep-splat
+++ a/mm/memory_hotplug.c
@@ -1764,8 +1764,6 @@ static int __ref try_remove_memory(int n
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
-	mem_hotplug_begin();
-
 	/*
 	 * All memory blocks must be offlined before removing memory.  Check
 	 * whether all memory blocks in question are offline and return error
@@ -1778,9 +1776,14 @@ static int __ref try_remove_memory(int n
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
-	/* remove memory block devices before removing memory */
+	/*
+	 * Memory block device removal under the device_hotplug_lock is
+	 * a barrier against racing online attempts.
+	 */
 	remove_memory_block_devices(start, size);
 
+	mem_hotplug_begin();
+
 	arch_remove_memory(nid, start, size, NULL);
 	memblock_free(start, size);
 	memblock_remove(start, size);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


