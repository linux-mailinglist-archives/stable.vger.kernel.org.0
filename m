Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0415451E8A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbhKPAg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234533AbhKOT0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E38663282;
        Mon, 15 Nov 2021 19:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003380;
        bh=4RTu6K//YrPuATqy+CdyUQVYLbV26ykOG5K722lQON0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yl2rLeyPNcEGQnDqcY9yVDAw2CXb+4XH55eqhFHHMGpGX3Ccw9sPyrByVcZ2Pxqlt
         igHcIuqtspvN0V704ihXcSZvyacJW95klt06UpfccwuSSKCf9LES0VNHx0xQPwwpSE
         IvVxdMtnyXR20WuRBYUHbXjjRJvuUVYc6HVNZ2nA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rongwei Wang <rongwei.wang@linux.alibaba.com>,
        Xu Yu <xuyu@linux.alibaba.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Song Liu <song@kernel.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Collin Fijalkovich <cfijalkovich@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 881/917] mm, thp: fix incorrect unmap behavior for private pages
Date:   Mon, 15 Nov 2021 18:06:16 +0100
Message-Id: <20211115165458.931413602@linuxfoundation.org>
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

commit 8468e937df1f31411d1e127fa38db064af051fe5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/open.c
+++ b/fs/open.c
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


