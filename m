Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F4D15786B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgBJNH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbgBJMjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A7324649;
        Mon, 10 Feb 2020 12:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338380;
        bh=qWgNYt31xkyK351UxERIzVq5F2cptIJSAur4ft8dU34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wh0FltYkArFMOfY4IXNFnGJbtUZOq3Nb8Z61k2XsgZX5nenmG2HtQ/wQ6WyqVfGH0
         SoTMxQe+y1+DTIHLfXOH+UN05glY0adN7uU5fzSnBtX6H216+KGE7iPcz89de5hszl
         icZ+b555QNANr0u5IEigFxJ7SY4j4i3ea1LMlDic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 058/367] mm/memory_hotplug: fix remove_memory() lockdep splat
Date:   Mon, 10 Feb 2020 04:29:31 -0800
Message-Id: <20200210122429.451618346@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit f1037ec0cc8ac1a450974ad9754e991f72884f48 upstream.

The daxctl unit test for the dax_kmem driver currently triggers the
(false positive) lockdep splat below.  It results from the fact that
remove_memory_block_devices() is invoked under the mem_hotplug_lock()
causing lockdep entanglements with cpu_hotplug_lock() and sysfs (kernfs
active state tracking).  It is a false positive because the sysfs
attribute path triggering the memory remove is not the same attribute
path associated with memory-block device.

sysfs_break_active_protection() is not applicable since there is no real
deadlock conflict, instead move memory-block device removal outside the
lock.  The mem_hotplug_lock() is not needed to synchronize the
memory-block device removal vs the page online state, that is already
handled by lock_device_hotplug().  Specifically, lock_device_hotplug()
is sufficient to allow try_remove_memory() to check the offline state of
the memblocks and be assured that any in progress online attempts are
flushed / blocked by kernfs_drain() / attribute removal.

The add_memory() path safely creates memblock devices under the
mem_hotplug_lock().  There is no kernfs active state synchronization in
the memblock device_register() path, so nothing to fix there.

This change is only possible thanks to the recent change that refactored
memory block device removal out of arch_remove_memory() (commit
4c4b7f9ba948 "mm/memory_hotplug: remove memory block devices before
arch_remove_memory()"), and David's due diligence tracking down the
guarantees afforded by kernfs_drain().  Not flagged for -stable since
this only impacts ongoing development and lockdep validation, not a
runtime issue.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory_hotplug.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
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


