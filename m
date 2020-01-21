Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B301443DE
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 19:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgAUSCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 13:02:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729080AbgAUSCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 13:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579629721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SM1Q6+uA9JteDcqaEaarHrXHS5IQuFXAP10+krA66Hs=;
        b=XmkYjnHYqELwxkGcG48wdbk7oUNQcixGgVotQMMy7lcUzCjiF/xXhHdvABYuh6CIMn3A1f
        bFfmN+LOQ8Lm3kqlLiLWXqgvKTnRzJyBfB6i3qYDkZavB23aSn4rEi1IRRnjvUpljFq+Ha
        ZC3FfOSp4dxWBh0SDqJs/g0zeiExJmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-zZd0M29bO7iv8OqeP5_0Qw-1; Tue, 21 Jan 2020 13:01:59 -0500
X-MC-Unique: zZd0M29bO7iv8OqeP5_0Qw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CA8E100550E;
        Tue, 21 Jan 2020 18:01:57 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDFC35C1C3;
        Tue, 21 Jan 2020 18:01:51 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH for 4.19-stable v2 00/24] mm/memory_hotplug: backport of pending stable fixes
Date:   Tue, 21 Jan 2020 19:01:26 +0100
Message-Id: <20200121180150.37454-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the backport of the following fixes for 4.19-stable:

- d84f2f5a7552 ("drivers/base/node.c: simplify
  unregister_memory_block_under_nodes()")
-- Turned out to not only be a cleanup but also a fix
- 2c91f8fc6c99 ("mm/memory_hotplug: fix try_offline_node()")
-- Automatic stable backport failed due to missing dependencies.
- feee6b298916 ("mm/memory_hotplug: shrink zones when offlining memory")
-- Was marked as stable 5.0+ due to the backport complexity,, but it's al=
so
   relevant for 4.19/4.14. As I have to backport quite some cleanups
   already ...

All tackle memory unplug issues, especially when memory was never
onlined (or onlining failed), paired with memory unplug. When trying to
access garbage memmaps we crash the kernel (e.g., because the derviced
pgdat pointer is broken)

To minimize manual code changes, I decided to pull in quite some cleanups=
.
Still some manual code changes are necessary (indicated in the individual
patches). Especially missing arm64 hot(un)plug, missing sub-section hotad=
d
support, and missing unification of mm/hmm.c and kernel/memremap.c requir=
es
care.

Due to:
- 4e0d2e7ef14d ("mm, sparse: pass nid instead of pgdat to
  sparse_add_one_section()")
I need:
- afe9b36ca890 ("mm/memunmap: don't access uninitialized memmap in
  memunmap_pages()")

Please note that:
- 4c4b7f9ba948 ("mm/memory_hotplug: remove memory block devices
  before arch_remove_memory()")
Makes big (e.g., 32TB) machines boot up slower (e.g., 2h vs 10m). There i=
s
a performance fix in linux-next, but it does not seem to classify as a
fix for current RC / stable.

I did quite some testing with hot(un)plug, onlining/offlining of memory
blocks and memory-less/CPU-less NUMA nodes under x86_64 - the same set of
tests I run against upstream on a fairly regular basis. I compile-tested
on PowerPC, arm64, s390x, i386 and sh. I did not test any ZONE_DEVICE/HMM
thingies.

v1 -> v2:
- Fix patch authors
- Dropped "mm/memory_hotplug: make __remove_pages() and
  arch_remove_memory() never fail"
-- Only creates a minor conflict in another patch
- "mm/memory_hotplug: make remove_memory() take the device_hotplug_lock"
-- Fix wrong upstream commit id
- "mm/memory_hotplug: shrink zones when offlining memory"
- "mm/memunmap: don't access uninitialized memmap in memunmap_pages()"
-- Fix usage of wrong pfn

CCing only some people to minimize noise.

Cc: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@gmail.com>

Aneesh Kumar K.V (2):
  powerpc/mm: Fix section mismatch warning
  mm/memunmap: don't access uninitialized memmap in memunmap_pages()

Baoquan He (1):
  drivers/base/memory.c: clean up relics in function parameters

Dan Carpenter (1):
  mm, memory_hotplug: update a comment in unregister_memory()

Dan Williams (1):
  mm/hotplug: kill is_dev_zone() usage in __remove_pages()

David Hildenbrand (15):
  mm/memory_hotplug: make remove_memory() take the device_hotplug_lock
  mm, memory_hotplug: add nid parameter to arch_remove_memory
  mm/memory_hotplug: make unregister_memory_section() never fail
  mm/memory_hotplug: make __remove_section() never fail
  mm/memory_hotplug: make __remove_pages() and arch_remove_memory()
    never fail
  s390x/mm: implement arch_remove_memory()
  mm/memory_hotplug: allow arch_remove_memory() without
    CONFIG_MEMORY_HOTREMOVE
  drivers/base/memory: pass a block_id to init_memory_block()
  mm/memory_hotplug: create memory block devices after arch_add_memory()
  mm/memory_hotplug: remove memory block devices before
    arch_remove_memory()
  mm/memory_hotplug: make unregister_memory_block_under_nodes() never
    fail
  mm/memory_hotplug: remove "zone" parameter from
    sparse_remove_one_section
  drivers/base/node.c: simplify unregister_memory_block_under_nodes()
  mm/memory_hotplug: fix try_offline_node()
  mm/memory_hotplug: shrink zones when offlining memory

Oscar Salvador (1):
  mm/memory_hotplug: release memory resource after arch_remove_memory()

Wei Yang (3):
  mm, sparse: drop pgdat_resize_lock in sparse_add/remove_one_section()
  mm, sparse: pass nid instead of pgdat to sparse_add_one_section()
  drivers/base/memory.c: remove an unnecessary check on NR_MEM_SECTIONS

 arch/ia64/mm/init.c                           |  15 +-
 arch/powerpc/mm/mem.c                         |  25 +--
 arch/powerpc/platforms/powernv/memtrace.c     |   2 +-
 .../platforms/pseries/hotplug-memory.c        |   6 +-
 arch/s390/mm/init.c                           |  16 +-
 arch/sh/mm/init.c                             |  15 +-
 arch/x86/mm/init_32.c                         |   9 +-
 arch/x86/mm/init_64.c                         |  17 +-
 drivers/acpi/acpi_memhotplug.c                |   2 +-
 drivers/base/memory.c                         | 203 +++++++++++-------
 drivers/base/node.c                           |  52 ++---
 include/linux/memory.h                        |   8 +-
 include/linux/memory_hotplug.h                |  22 +-
 include/linux/mmzone.h                        |   3 +-
 include/linux/node.h                          |   7 +-
 kernel/memremap.c                             |  12 +-
 mm/hmm.c                                      |   8 +-
 mm/memory_hotplug.c                           | 166 +++++++-------
 mm/sparse.c                                   |  27 +--
 19 files changed, 303 insertions(+), 312 deletions(-)

--=20
2.24.1

