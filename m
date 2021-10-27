Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DED43D5CF
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 23:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhJ0VeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 17:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235673AbhJ0Vdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 17:33:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07858610EA;
        Wed, 27 Oct 2021 21:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635370287;
        bh=beP3V4E9bOCt9XZs5Xr/2QNQBFfPfNth7pyeESIUaBY=;
        h=Date:From:To:Subject:From;
        b=hjGG5DUh0p5bwaRUolCIYu4g/kfiqticZPQKY0GTHINpR0rZWxzfDzKltcxNXnaQF
         GlpBp2RU8EXC2DhvlckXKnKWNAl68WgvajidzLgW+FwxFYnDo2OlJzNiFIQXUE/FWe
         /cXVBMRNxspKn8D9rVo1A8Wj3KbZ3G8mdr1YeX+Y=
Date:   Wed, 27 Oct 2021 14:31:25 -0700
From:   akpm@linux-foundation.org
To:     cfijalkovich@google.com, hughd@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rongwei.wang@linux.alibaba.com,
        shy828301@gmail.com, song@kernel.org, stable@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        xuyu@linux.alibaba.com
Subject:  +
 mm-thp-fix-incorrect-unmap-behavior-for-private-pages.patch added to -mm
 tree
Message-ID: <20211027213125.Saf_Mg-fw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, thp: fix incorrect unmap behavior for private pages
has been added to the -mm tree.  Its filename is
     mm-thp-fix-incorrect-unmap-behavior-for-private-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-incorrect-unmap-behavior-for-private-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-incorrect-unmap-behavior-for-private-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Subject: mm, thp: fix incorrect unmap behavior for private pages

When truncating pagecache on file THP, the private pages of a process
should not be unmapped mapping.  This incorrect behavior on a dynamic
shared libraries which will cause related processes to happen core dump.

A simple test for a DSO (Prerequisite is the DSO mapped in file THP):

int main(int argc, char *argv[])
{
	int fd;

	fd = open(argv[1], O_WRONLY);
	if (fd < 0) {
		perror("open");
	}

	close(fd);
	return 0;
}

The test only to open a target DSO, and do nothing.  But this operation
will lead one or more process to happen core dump.  This patch mainly to
fix this bug.

Link: https://lkml.kernel.org/r/20211025092134.18562-3-rongwei.wang@linux.alibaba.com
Fixes: eb6ecbed0aa2 ("mm, thp: relax the VM_DENYWRITE constraint on file-backed THPs")
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Tested-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Collin Fijalkovich <cfijalkovich@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/open.c~mm-thp-fix-incorrect-unmap-behavior-for-private-pages
+++ a/fs/open.c
@@ -857,8 +857,17 @@ static int do_dentry_open(struct file *f
 		 */
 		smp_mb();
 		if (filemap_nr_thps(inode->i_mapping)) {
+			struct address_space *mapping = inode->i_mapping;
+
 			filemap_invalidate_lock(inode->i_mapping);
-			truncate_pagecache(inode, 0);
+			/*
+			 * unmap_mapping_range just need to be called once
+			 * here, because the private pages is not need to be
+			 * unmapped mapping (e.g. data segment of dynamic
+			 * shared libraries here).
+			 */
+			unmap_mapping_range(mapping, 0, 0, 0);
+			truncate_inode_pages(mapping, 0);
 			filemap_invalidate_unlock(inode->i_mapping);
 		}
 	}
_

Patches currently in -mm which might be from rongwei.wang@linux.alibaba.com are

mm-thp-bail-out-early-in-collapse_file-for-writeback-page.patch
mm-thp-lock-filemap-when-truncating-page-cache.patch
mm-thp-fix-incorrect-unmap-behavior-for-private-pages.patch
mm-damon-dbgfs-remove-unnecessary-variables.patch

