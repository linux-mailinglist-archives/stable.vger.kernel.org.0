Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2473137F5
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhBHPdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233754AbhBHPaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63B3264ECD;
        Mon,  8 Feb 2021 15:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797422;
        bh=KgOTo85NRv/jeWrQtnUac5CCENu8eNKCvVq7HV4fbXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqTbRKUVXBdKSJkVpcqpJpgVwIniEuluodjQBOUuVT/Ge0zBTymfD94GeCIp8R2VU
         35mf6Pl56f7rH6Payl3UzghoLroHUhUWqUtNr1XHFvkaVclbva2qz7EnCwdXx3Vu79
         w/o6NzUlwsT8OxOJ3t3hRa+kPGy33QwnnvXf2a/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <smuchun@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 105/120] mm/filemap: add missing mem_cgroup_uncharge() to __add_to_page_cache_locked()
Date:   Mon,  8 Feb 2021 16:01:32 +0100
Message-Id: <20210208145822.572875718@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit da74240eb3fcd806edb1643874363e954d9e948b upstream.

Commit 3fea5a499d57 ("mm: memcontrol: convert page cache to a new
mem_cgroup_charge() API") introduced a bug in __add_to_page_cache_locked()
causing the following splat:

  page dumped because: VM_BUG_ON_PAGE(page_memcg(page))
  pages's memcg:ffff8889a4116000
  ------------[ cut here ]------------
  kernel BUG at mm/memcontrol.c:2924!
  invalid opcode: 0000 [#1] SMP KASAN PTI
  CPU: 35 PID: 12345 Comm: cat Tainted: G S      W I       5.11.0-rc4-debug+ #1
  Hardware name: HP HP Z8 G4 Workstation/81C7, BIOS P60 v01.25 12/06/2017
  RIP: commit_charge+0xf4/0x130
  Call Trace:
    mem_cgroup_charge+0x175/0x770
    __add_to_page_cache_locked+0x712/0xad0
    add_to_page_cache_lru+0xc5/0x1f0
    cachefiles_read_or_alloc_pages+0x895/0x2e10 [cachefiles]
    __fscache_read_or_alloc_pages+0x6c0/0xa00 [fscache]
    __nfs_readpages_from_fscache+0x16d/0x630 [nfs]
    nfs_readpages+0x24e/0x540 [nfs]
    read_pages+0x5b1/0xc40
    page_cache_ra_unbounded+0x460/0x750
    generic_file_buffered_read_get_pages+0x290/0x1710
    generic_file_buffered_read+0x2a9/0xc30
    nfs_file_read+0x13f/0x230 [nfs]
    new_sync_read+0x3af/0x610
    vfs_read+0x339/0x4b0
    ksys_read+0xf1/0x1c0
    do_syscall_64+0x33/0x40
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Before that commit, there was a try_charge() and commit_charge() in
__add_to_page_cache_locked().  These two separated charge functions were
replaced by a single mem_cgroup_charge().  However, it forgot to add a
matching mem_cgroup_uncharge() when the xarray insertion failed with the
page released back to the pool.

Fix this by adding a mem_cgroup_uncharge() call when insertion error
happens.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
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
 


