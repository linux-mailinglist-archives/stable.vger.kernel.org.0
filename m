Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD113C7CF
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgAOPdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:33:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46864 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726132AbgAOPdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:33:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Oa2rBuG91Y1TmVMsBVc/AfTmq3pNIKd/wuqkNCnThB4=;
        b=JCYV7otnEJMKkMkd3n5PNTcYP/tun4cU1ccCCe4rLaJdR+aaTfka/yi1RdihP2X+GdhTnJ
        DZIkK2sigLnAlAHbpKNEcZUc6cNGi/tOw9rcQmBOEfokp/Hkw/fd0ExXEwZ0+WP8zAllzF
        V5v727Ti5HfcgDU4qMHEw1GBNVMtx0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-19Cb1Se0O8qjNXt3gUCXFQ-1; Wed, 15 Jan 2020 10:33:43 -0500
X-MC-Unique: 19Cb1Se0O8qjNXt3gUCXFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14AA411322A9;
        Wed, 15 Jan 2020 15:33:42 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB67486CB2;
        Wed, 15 Jan 2020 15:33:39 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH for 4.19-stable 00/25] mm/memory_hotplug: backport of pending stable fixes
Date:   Wed, 15 Jan 2020 16:33:14 +0100
Message-Id: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the backport of the following fixes for 4.19-stable:

- a31b264c2b41 ("mm/memory_hotplug: make
  unregister_memory_block_under_nodes() never fail")
-- Turned out to not only be a cleanup but also a fix
- 2c91f8fc6c99 ("mm/memory_hotplug: fix try_offline_node()")
-- Automatic stable backport failed due to missing dependencies.
- feee6b298916 ("mm/memory_hotplug: shrink zones when offlining memory")
-- Was marked as stable 5.0+ due to the backport complexity,, but it's al=
so
   relevant for 4.19/4.14. As I have to backport quite some cleanups
   already ...

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
on PowerPC. I did not test any ZONE_DEVICE/HMM thingies.

Let's see what people think - it's a lot of patches. If we want this,
then I can try to prepare a similar set for 4.4-stable.

CCing only some people to minimize noise.

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Baoquan He <bhe@redhat.com>

David Hildenbrand (25):
  mm/memory_hotplug: make remove_memory() take the device_hotplug_lock
  mm, sparse: drop pgdat_resize_lock in sparse_add/remove_one_section()
  mm, sparse: pass nid instead of pgdat to sparse_add_one_section()
  drivers/base/memory.c: remove an unnecessary check on NR_MEM_SECTIONS
  mm, memory_hotplug: add nid parameter to arch_remove_memory
  mm/memory_hotplug: release memory resource after arch_remove_memory()
  drivers/base/memory.c: clean up relics in function parameters
  mm, memory_hotplug: update a comment in unregister_memory()
  mm/memory_hotplug: make unregister_memory_section() never fail
  mm/memory_hotplug: make __remove_section() never fail
  powerpc/mm: Fix section mismatch warning
  powerpc/mm: move warning from resize_hpt_for_hotplug()
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
  mm/hotplug: kill is_dev_zone() usage in __remove_pages()
  drivers/base/node.c: simplify unregister_memory_block_under_nodes()
  mm/memunmap: don't access uninitialized memmap in memunmap_pages()
  mm/memory_hotplug: fix try_offline_node()
  mm/memory_hotplug: shrink zones when offlining memory

 arch/ia64/mm/init.c                           |  15 +-
 arch/powerpc/include/asm/sparsemem.h          |   4 +-
 arch/powerpc/mm/hash_utils_64.c               |  19 +-
 arch/powerpc/mm/mem.c                         |  28 +--
 arch/powerpc/platforms/powernv/memtrace.c     |   2 +-
 .../platforms/pseries/hotplug-memory.c        |   6 +-
 arch/powerpc/platforms/pseries/lpar.c         |   3 +-
 arch/s390/mm/init.c                           |  18 +-
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
 kernel/memremap.c                             |  13 +-
 mm/hmm.c                                      |   8 +-
 mm/memory_hotplug.c                           | 166 +++++++-------
 mm/sparse.c                                   |  27 +--
 22 files changed, 318 insertions(+), 329 deletions(-)

--=20
2.24.1

