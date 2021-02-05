Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD53102DA
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 03:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhBECd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 21:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230282AbhBECdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57EAC64FC2;
        Fri,  5 Feb 2021 02:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492367;
        bh=QB1ZdaxTR3P9QGE1uq+nTRbZqdQOxGc8pgnARUwOAgQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m1jca+IunX4b4dv/QpJrwFzHZhGgMPKzuZ7YuLTGdtA8WeDke5cQ9ymPAtkbM19wU
         O34Kfoa8Tm+eu+lmiPR4F41LFsBWnPId1eEnuNFa6xeelVhhebyWUc+CquBQySTIUf
         9Vh6SKzsH5hUUou9ueAZgSfTcm8rAW4d6yoFhXfE=
Date:   Thu, 04 Feb 2021 18:32:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, linux-mm@kvack.org,
        longman@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        smuchun@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 13/18] mm/filemap: add missing
 mem_cgroup_uncharge() to __add_to_page_cache_locked()
Message-ID: <20210205023245.2MSWh6RsL%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm/filemap: add missing mem_cgroup_uncharge() to __add_to_page_cache_locked()

commit 3fea5a499d57 ("mm: memcontrol: convert page cache to a new
mem_cgroup_charge() API") introduced a bug in __add_to_page_cache_locked()
causing the following splat:

 [ 1570.068330] page dumped because: VM_BUG_ON_PAGE(page_memcg(page))
 [ 1570.068333] pages's memcg:ffff8889a4116000
 [ 1570.068343] ------------[ cut here ]------------
 [ 1570.068346] kernel BUG at mm/memcontrol.c:2924!
 [ 1570.068355] invalid opcode: 0000 [#1] SMP KASAN PTI
 [ 1570.068359] CPU: 35 PID: 12345 Comm: cat Tainted: G S      W I       5.11.0-rc4-debug+ #1
 [ 1570.068363] Hardware name: HP HP Z8 G4 Workstation/81C7, BIOS P60 v01.25 12/06/2017
 [ 1570.068365] RIP: 0010:commit_charge+0xf4/0x130
   :
 [ 1570.068375] RSP: 0018:ffff8881b38d70e8 EFLAGS: 00010286
 [ 1570.068379] RAX: 0000000000000000 RBX: ffffea00260ddd00 RCX: 0000000000000027
 [ 1570.068382] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88907ebe05a8
 [ 1570.068384] RBP: ffffea00260ddd00 R08: ffffed120fd7c0b6 R09: ffffed120fd7c0b6
 [ 1570.068386] R10: ffff88907ebe05ab R11: ffffed120fd7c0b5 R12: ffffea00260ddd38
 [ 1570.068389] R13: ffff8889a4116000 R14: ffff8889a4116000 R15: 0000000000000001
 [ 1570.068391] FS:  00007ff039638680(0000) GS:ffff88907ea00000(0000) knlGS:0000000000000000
 [ 1570.068394] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [ 1570.068396] CR2: 00007f36f354cc20 CR3: 00000008a0126006 CR4: 00000000007706e0
 [ 1570.068398] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1570.068400] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [ 1570.068402] PKRU: 55555554
 [ 1570.068404] Call Trace:
 [ 1570.068407]  mem_cgroup_charge+0x175/0x770
 [ 1570.068413]  __add_to_page_cache_locked+0x712/0xad0
 [ 1570.068439]  add_to_page_cache_lru+0xc5/0x1f0
 [ 1570.068461]  cachefiles_read_or_alloc_pages+0x895/0x2e10 [cachefiles]
 [ 1570.068524]  __fscache_read_or_alloc_pages+0x6c0/0xa00 [fscache]
 [ 1570.068540]  __nfs_readpages_from_fscache+0x16d/0x630 [nfs]
 [ 1570.068585]  nfs_readpages+0x24e/0x540 [nfs]
 [ 1570.068693]  read_pages+0x5b1/0xc40
 [ 1570.068711]  page_cache_ra_unbounded+0x460/0x750
 [ 1570.068729]  generic_file_buffered_read_get_pages+0x290/0x1710
 [ 1570.068756]  generic_file_buffered_read+0x2a9/0xc30
 [ 1570.068832]  nfs_file_read+0x13f/0x230 [nfs]
 [ 1570.068872]  new_sync_read+0x3af/0x610
 [ 1570.068901]  vfs_read+0x339/0x4b0
 [ 1570.068909]  ksys_read+0xf1/0x1c0
 [ 1570.068920]  do_syscall_64+0x33/0x40
 [ 1570.068926]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 [ 1570.068930] RIP: 0033:0x7ff039135595

Before that commit, there was a try_charge() and commit_charge() in
__add_to_page_cache_locked().  These 2 separated charge functions were
replaced by a single mem_cgroup_charge().  However, it forgot to add a
matching mem_cgroup_uncharge() when the xarray insertion failed with the
page released back to the pool.  Fix this by adding a
mem_cgroup_uncharge() call when insertion error happens.

Link: https://lkml.kernel.org/r/20210125042441.20030-1-longman@redhat.com
Fixes: 3fea5a499d57 ("mm: memcontrol: convert page cache to a new mem_cgroup_charge() API")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <smuchun@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/filemap.c~mm-filemap-adding-missing-mem_cgroup_uncharge-to-__add_to_page_cache_locked
+++ a/mm/filemap.c
@@ -835,6 +835,7 @@ noinline int __add_to_page_cache_locked(
 	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);
 	int error;
+	bool charged = false;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
@@ -848,6 +849,7 @@ noinline int __add_to_page_cache_locked(
 		error = mem_cgroup_charge(page, current->mm, gfp);
 		if (error)
 			goto error;
+		charged = true;
 	}
 
 	gfp &= GFP_RECLAIM_MASK;
@@ -896,6 +898,8 @@ unlock:
 
 	if (xas_error(&xas)) {
 		error = xas_error(&xas);
+		if (charged)
+			mem_cgroup_uncharge(page);
 		goto error;
 	}
 
_
