Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DA04469EB
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhKEUq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhKEUqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C51061362;
        Fri,  5 Nov 2021 20:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145025;
        bh=r9OzvJHxM88WnMJ5qg3JF+Fqwhxp7zsPajgRsydPK2w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J5Fb1RBCwLWb5il9M0P0V92y6s/S09842O6bKvTwul2NhhXzry/oXO5y21AzeUMIe
         sffk7rKHMkLOt5ZFRIkPjiPMLLjGqg+hKU4sz406LidHLyXRIlw04ruAILd/VNl6AN
         y8OAaQuEKiO493ldv2tEwDcPod7tZPsjg6QAYeoA=
Date:   Fri, 05 Nov 2021 13:43:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cfijalkovich@google.com,
        hughd@google.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rongwei.wang@linux.alibaba.com,
        shy828301@gmail.com, song@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, xuyu@linux.alibaba.com
Subject:  [patch 174/262] mm, thp: fix incorrect unmap behavior for
 private pages
Message-ID: <20211105204344.v9quKumgv%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
