Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CCFCA78D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406247AbfJCQwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406244AbfJCQwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:52:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00DA520865;
        Thu,  3 Oct 2019 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121569;
        bh=LDrQjUzm+CCCan4kll+92asz0BfWA/cpY2uRQAkUv6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+tH43Je7jIkl9gyrmw4FQfl250PzpNh1v5IoaFARSAERZNKSqltr0yvPY3Gxm8M2
         SGL7IqewdVJGfSmeoTCKmfOOWkyhuWLJLA6lMuueL5yjbAKQD3/gysNCeFbhj1Irbo
         1wtA00QGqFP/9+xi4K9UG7JJp9NjwWcOHjiDFmvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5.3 327/344] xfs: Fix stale data exposure when readahead races with hole punch
Date:   Thu,  3 Oct 2019 17:54:52 +0200
Message-Id: <20191003154611.119132263@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 40144e49ff84c3bd6bd091b58115257670be8803 upstream.

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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_file.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -28,6 +28,7 @@
 #include <linux/falloc.h>
 #include <linux/backing-dev.h>
 #include <linux/mman.h>
+#include <linux/fadvise.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -933,6 +934,30 @@ out_unlock:
 	return error;
 }
 
+STATIC int
+xfs_file_fadvise(
+	struct file	*file,
+	loff_t		start,
+	loff_t		end,
+	int		advice)
+{
+	struct xfs_inode *ip = XFS_I(file_inode(file));
+	int ret;
+	int lockflags = 0;
+
+	/*
+	 * Operations creating pages in page cache need protection from hole
+	 * punching and similar ops
+	 */
+	if (advice == POSIX_FADV_WILLNEED) {
+		lockflags = XFS_IOLOCK_SHARED;
+		xfs_ilock(ip, lockflags);
+	}
+	ret = generic_fadvise(file, start, end, advice);
+	if (lockflags)
+		xfs_iunlock(ip, lockflags);
+	return ret;
+}
 
 STATIC loff_t
 xfs_file_remap_range(
@@ -1232,6 +1257,7 @@ const struct file_operations xfs_file_op
 	.fsync		= xfs_file_fsync,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.fallocate	= xfs_file_fallocate,
+	.fadvise	= xfs_file_fadvise,
 	.remap_file_range = xfs_file_remap_range,
 };
 


