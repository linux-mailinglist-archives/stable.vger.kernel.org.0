Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612854514CE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbhKOUNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345048AbhKOT0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8105C60E75;
        Mon, 15 Nov 2021 19:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003363;
        bh=jEqHrvJj4EkUp1+FpWu4AgdMv5dt5vED+zo7+9IGW8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZKdcuLnlHzAhejLwoM4c/psIuXOK+CVJcDoyRTdX98VYokFsdG0u2/XyHLlW9RYJ
         CFGebGC+B5K+Dy7FCUvD562RWJ98D88s65U8Za/Fzr/bo7XAfrV49Yp5TfHoKjueB0
         2hcPAjhKJbDVK/SXiLxEefuwZyMUZD4fji9jhN0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yu <xuyu@linux.alibaba.com>,
        Rongwei Wang <rongwei.wang@linux.alibaba.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Song Liu <song@kernel.org>,
        Collin Fijalkovich <cfijalkovich@google.com>,
        Hugh Dickins <hughd@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 880/917] mm, thp: lock filemap when truncating page cache
Date:   Mon, 15 Nov 2021 18:06:15 +0100
Message-Id: <20211115165458.899696411@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rongwei Wang <rongwei.wang@linux.alibaba.com>

commit 55fc0d91746759c71bc165bba62a2db64ac98e35 upstream.

Patch series "fix two bugs for file THP".

This patch (of 2):

Transparent huge page has supported read-only non-shmem files.  The
file- backed THP is collapsed by khugepaged and truncated when written
(for shared libraries).

However, there is a race when multiple writers truncate the same page
cache concurrently.

In that case, subpage(s) of file THP can be revealed by find_get_entry
in truncate_inode_pages_range, which will trigger PageTail BUG_ON in
truncate_inode_page, as follows:

    page:000000009e420ff2 refcount:1 mapcount:0 mapping:0000000000000000 index:0x7ff pfn:0x50c3ff
    head:0000000075ff816d order:9 compound_mapcount:0 compound_pincount:0
    flags: 0x37fffe0000010815(locked|uptodate|lru|arch_1|head)
    raw: 37fffe0000000000 fffffe0013108001 dead000000000122 dead000000000400
    raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
    head: 37fffe0000010815 fffffe001066bd48 ffff000404183c20 0000000000000000
    head: 0000000000000600 0000000000000000 00000001ffffffff ffff000c0345a000
    page dumped because: VM_BUG_ON_PAGE(PageTail(page))
    ------------[ cut here ]------------
    kernel BUG at mm/truncate.c:213!
    Internal error: Oops - BUG: 0 [#1] SMP
    Modules linked in: xfs(E) libcrc32c(E) rfkill(E) ...
    CPU: 14 PID: 11394 Comm: check_madvise_d Kdump: ...
    Hardware name: ECS, BIOS 0.0.0 02/06/2015
    pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
    Call trace:
     truncate_inode_page+0x64/0x70
     truncate_inode_pages_range+0x550/0x7e4
     truncate_pagecache+0x58/0x80
     do_dentry_open+0x1e4/0x3c0
     vfs_open+0x38/0x44
     do_open+0x1f0/0x310
     path_openat+0x114/0x1dc
     do_filp_open+0x84/0x134
     do_sys_openat2+0xbc/0x164
     __arm64_sys_openat+0x74/0xc0
     el0_svc_common.constprop.0+0x88/0x220
     do_el0_svc+0x30/0xa0
     el0_svc+0x20/0x30
     el0_sync_handler+0x1a4/0x1b0
     el0_sync+0x180/0x1c0
    Code: aa0103e0 900061e1 910ec021 9400d300 (d4210000)

This patch mainly to lock filemap when one enter truncate_pagecache(),
avoiding truncating the same page cache concurrently.

Link: https://lkml.kernel.org/r/20211025092134.18562-1-rongwei.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20211025092134.18562-2-rongwei.wang@linux.alibaba.com
Fixes: eb6ecbed0aa2 ("mm, thp: relax the VM_DENYWRITE constraint on file-backed THPs")
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Song Liu <song@kernel.org>
Cc: Collin Fijalkovich <cfijalkovich@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -856,8 +856,11 @@ static int do_dentry_open(struct file *f
 		 * of THPs into the page cache will fail.
 		 */
 		smp_mb();
-		if (filemap_nr_thps(inode->i_mapping))
+		if (filemap_nr_thps(inode->i_mapping)) {
+			filemap_invalidate_lock(inode->i_mapping);
 			truncate_pagecache(inode, 0);
+			filemap_invalidate_unlock(inode->i_mapping);
+		}
 	}
 
 	return 0;


