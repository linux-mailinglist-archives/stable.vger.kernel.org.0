Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF28E3ECF0A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhHPHNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:23 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13428 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhHPHNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:21 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gp4yn1TWczdbLS;
        Mon, 16 Aug 2021 15:09:05 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:45 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:44 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Wang Hai" <wanghai38@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Chen Huang <chenhuang5@huawei.com>
Subject: [PATCH 5.10.y 00/11] mm: memcontrol: fix nullptr in __mod_lruvec_page_state()
Date:   Mon, 16 Aug 2021 07:21:36 +0000
Message-ID: <20210816072147.3481782-1-chenhuang5@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema756-chm.china.huawei.com (10.1.198.198)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found a nullptr in __mod_lruvec_page_state(),
  UIO driver:
        kmalloc(PAGE_SIZE)
  UIO user:
        mmap() then read, but before user read the page, others may alloc the
page that belong to the same compound page and modify the head page's obj_cgroups
likes that:
[   94.845687]  memcg_alloc_page_obj_cgroups+0x50/0xa0
[   94.846334]  slab_post_alloc_hook+0xc8/0x184
[   94.846852]  kmem_cache_alloc+0x148/0x2a4
[   94.847346]  __d_alloc+0x30/0x2e4
[   94.847809]  d_alloc+0x30/0xc0

Then when the user reads the page, in __mod_lruvec_page_state(), it will get the
nullptr in head->mem_cgroup.

[   94.882699] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000080
[   94.882773] Mem abort info:
[   94.882819]   ESR = 0x96000006
[   94.882953]   EC = 0x25: DABT (current EL), IL = 32 bits
[   94.883000]   SET = 0, FnV = 0
[   94.883043]   EA = 0, S1PTW = 0
[   94.883089] Data abort info:
[   94.883134]   ISV = 0, ISS = 0x00000006
[   94.883179]   CM = 0, WnR = 0
[   94.883402] user pgtable: 4k pages, 48-bit VAs, pgdp=000000010c355000
[   94.883495] [0000000000000080] pgd=000000010c046003, p4d=000000010c046003, pud=000000010c368003, pmd=0000000000000000
[   94.884225] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[   94.884480] Modules linked in:
[   94.884788] CPU: 0 PID: 250 Comm: uio_user_mmap Tainted: G    B             5.10.0-07799-ged92fcf8d408-dirty #112
[   94.884837] Hardware name: linux,dummy-virt (DT)
[   94.885052] pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
[   94.885169] pc : __mod_lruvec_page_state+0x118/0x180
[   94.885249] lr : __mod_lruvec_page_state+0x118/0x180
[   94.885297] sp : ffff2872ce25fb40
[   94.885402] x29: ffff2872ce25fb40 x28: 0000000000000254
[   94.885572] x27: 0000000000000000 x26: ffff2872fe2d7c38
[   94.885724] x25: ffffa000242e7dc0 x24: 0000000000000001
[   94.885872] x23: 0000000000000012 x22: ffffa00022bcfc60
[   94.886030] x21: ffff2872fffeb380 x20: 0000000000000144
[   94.886169] x19: 0000000000000000 x18: 0000000000000000
[   94.886331] x17: 0000000000000000 x16: 0000000000000000
[   94.886476] x15: 0000000000000000 x14: 3078303a7865646e
[   94.886625] x13: 6920303030303030 x12: 1fffe50e5b713f20
[   94.886765] x11: ffff850e5b713f20 x10: 616d20303a746e75
[   94.886947] x9 : dfffa00000000000 x8 : 3266666666203d20
[   94.887095] x7 : ffff2872db89f903 x6 : 0000000000000000
[   94.887236] x5 : 0000000000000000 x4 : dfffa00000000000
[   94.887381] x3 : ffffa00021e6c5dc x2 : 0000000000000000
[   94.887515] x1 : 0000000000000008 x0 : 0000000000000000
[   94.887702] Call trace:
[   94.887840]  __mod_lruvec_page_state+0x118/0x180
[   94.887919]  page_add_file_rmap+0xa8/0xe0
[   94.887998]  alloc_set_pte+0x2c4/0x2d0
[   94.888074]  finish_fault+0x94/0xcc
[   94.888157]  handle_mm_fault+0x7c8/0x1094
[   94.888230]  do_page_fault+0x358/0x490
[   94.888300]  do_translation_fault+0x38/0x54
[   94.888370]  do_mem_abort+0x5c/0xe4
[   94.888435]  el0_da+0x3c/0x4c
[   94.888506]  el0_sync_handler+0xd8/0x14c
[   94.888573]  el0_sync+0x148/0x180
[   94.888963] Code: d2835101 8b0102b3 91020260 9400e8da (f9404260)
[   94.889860] ---[ end trace 1de53a0bd9084cde ]---
[   94.890244] Kernel panic - not syncing: Oops: Fatal exception
[   94.890620] SMP: stopping secondary CPUs
[   94.891117] Kernel Offset: 0x11c00000 from 0xffffa00010000000
[   94.891179] PHYS_OFFSET: 0xffffd78e40000000
[   94.891293] CPU features: 0x0660012,41002000
[   94.891365] Memory Limit: none
[   94.927552] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---

1. Roman Gushchin's 4 patch remove this limitation by moving the PageKmemcg 
flag into one of the free bits of the page->mem_cgroup pointer. Also it
formalizes accesses to the page->mem_cgroup and page->obj_cgroups
using new helpers, adds several checks and removes a couple of obsolete
functions.
Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com

2. Muchun Song's patchset aim to make those kmem pages to drop the reference 
to memory cgroup by using the APIs of obj_cgroup.
Link: https://lkml.kernel.org/r/20210319163821.20704-1-songmuchun@bytedance.com

3. Wang Hai's patch is a bugfix for "mm: memcontrol/slab: Use helpers to 
access slab page's memcg_data"
Link: https://lkml.kernel.org/r/20210728145655.274476-1-wanghai38@huawei.com

Muchun Song (6):
  mm: memcontrol: introduce obj_cgroup_{un}charge_pages
  mm: memcontrol: directly access page->memcg_data in mm/page_alloc.c
  mm: memcontrol: change ug->dummy_page only if memcg changed
  mm: memcontrol: use obj_cgroup APIs to charge kmem pages
	Conflict for commit c47d5032ed3002311a4188eae51f4641ec436beb not merged
  mm: memcontrol: inline __memcg_kmem_{un}charge() into
    obj_cgroup_{un}charge_pages()
  mm: memcontrol: move PageMemcgKmem to the scope of CONFIG_MEMCG_KMEM

Roman Gushchin (4):
  mm: memcontrol: Use helpers to read page's memcg data
	Conflict function:split_page_memcg(), for commit 002ea848d7fd3bdcb6281e75bdde28095c2cd549
  mm: memcontrol/slab: Use helpers to access slab page's memcg_data
  mm: Introduce page memcg flags
  mm: Convert page kmemcg type to a page memcg flag

Wang Hai (1):
  mm/memcg: fix NULL pointer dereference in memcg_slab_free_hook()

 fs/buffer.c                      |   2 +-
 fs/iomap/buffered-io.c           |   2 +-
 include/linux/memcontrol.h       | 320 +++++++++++++++++++++++++++--
 include/linux/mm.h               |  22 --
 include/linux/mm_types.h         |   5 +-
 include/linux/page-flags.h       |  11 +-
 include/trace/events/writeback.h |   2 +-
 kernel/fork.c                    |   7 +-
 mm/debug.c                       |   4 +-
 mm/huge_memory.c                 |   4 +-
 mm/memcontrol.c                  | 336 +++++++++++++++----------------
 mm/page_alloc.c                  |   8 +-
 mm/page_io.c                     |   6 +-
 mm/slab.h                        |  38 +---
 mm/workingset.c                  |   2 +-
 15 files changed, 493 insertions(+), 276 deletions(-)

-- 
2.18.0.huawei.25

