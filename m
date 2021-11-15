Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC58450790
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 15:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhKOOxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231131AbhKOOxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 09:53:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6248A6320D;
        Mon, 15 Nov 2021 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636987845;
        bh=3p4ZY9WWvtxlXzJpcgAxgo0phx9qul5ITIw/umDu2YQ=;
        h=Subject:To:Cc:From:Date:From;
        b=2aOJPIjMM7bVKOJOq9DrxaHsgy3F+//uE8a2HJrNBJrDuUU3fwTTX2wvdiXrGqcTw
         P1oUgTwBTXO4OEVnwpWgjK2znspJBNXLT9XBy5yNmyI5S2ZQM4c7sLmtXv16CC7/4q
         GkDX7E0IffFrNquAmL1C29Uc5A7vbts4QDC0Q5IQ=
Subject: FAILED: patch "[PATCH] mm, thp: fix incorrect unmap behavior for private pages" failed to apply to 5.14-stable tree
To:     rongwei.wang@linux.alibaba.com, akpm@linux-foundation.org,
        cfijalkovich@google.com, hughd@google.com, mike.kravetz@oracle.com,
        shy828301@gmail.com, song@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, xuyu@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 15:50:43 +0100
Message-ID: <163698784378132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8468e937df1f31411d1e127fa38db064af051fe5 Mon Sep 17 00:00:00 2001
From: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Date: Fri, 5 Nov 2021 13:43:44 -0700
Subject: [PATCH] mm, thp: fix incorrect unmap behavior for private pages

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/open.c b/fs/open.c
index 9ec3cfca3b1a..e0df1536eb69 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -857,8 +857,17 @@ static int do_dentry_open(struct file *f,
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

