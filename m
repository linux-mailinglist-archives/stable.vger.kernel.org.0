Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88BD6585F
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 16:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfGKOAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 10:00:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:51082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728102AbfGKOAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 10:00:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3AB4AF57;
        Thu, 11 Jul 2019 14:00:16 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2E77A1E43CE; Thu, 11 Jul 2019 16:00:16 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] xfs: Fix stale data exposure when readahead races with hole punch
Date:   Thu, 11 Jul 2019 16:00:12 +0200
Message-Id: <20190711140012.1671-4-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190711140012.1671-1-jack@suse.cz>
References: <20190711140012.1671-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hole puching currently evicts pages from page cache and then goes on to
remove blocks from the inode. This happens under both XFS_IOLOCK_EXCL
and XFS_MMAPLOCK_EXCL which provides appropriate serialization with
racing reads or page faults. However there is currently nothing that
prevents readahead triggered by fadvise() or madvise() from racing with
the hole punch and instantiating page cache page after hole punching has
evicted page cache in xfs_flush_unmap_range() but before it has removed
blocks from the inode. This page cache page will be mapping soon to be
freed block and that can lead to returning stale data to userspace or
even filesystem corruption.

Fix the problem by protecting handling of readahead requests by
XFS_IOLOCK_SHARED similarly as we protect reads.

CC: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 76748255f843..88fe3dbb3ba2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -33,6 +33,7 @@
 #include <linux/pagevec.h>
 #include <linux/backing-dev.h>
 #include <linux/mman.h>
+#include <linux/fadvise.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -939,6 +940,24 @@ xfs_file_fallocate(
 	return error;
 }
 
+STATIC int
+xfs_file_fadvise(
+	struct file *file,
+	loff_t start,
+	loff_t end,
+	int advice)
+{
+	struct xfs_inode *ip = XFS_I(file_inode(file));
+	int ret;
+
+	/* Readahead needs protection from hole punching and similar ops */
+	if (advice == POSIX_FADV_WILLNEED)
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	ret = generic_fadvise(file, start, end, advice);
+	if (advice == POSIX_FADV_WILLNEED)
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	return ret;
+}
 
 STATIC loff_t
 xfs_file_remap_range(
@@ -1235,6 +1254,7 @@ const struct file_operations xfs_file_operations = {
 	.fsync		= xfs_file_fsync,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.fallocate	= xfs_file_fallocate,
+	.fadvise	= xfs_file_fadvise,
 	.remap_file_range = xfs_file_remap_range,
 };
 
-- 
2.16.4

