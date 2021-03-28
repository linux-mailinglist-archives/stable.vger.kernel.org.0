Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B81C34BD49
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 18:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhC1Qmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 12:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231213AbhC1QmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Mar 2021 12:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D86D6193F;
        Sun, 28 Mar 2021 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616949741;
        bh=DzMX3thOaCmDGKPWTrZxKWpV86ppM8+KBxc6Qp0w9sc=;
        h=Date:From:To:Subject:From;
        b=FIhjRay0y0ML1gAsY3T6nh0QY0pW8MgOGJk+cvdOuo82myLboitMC1mLhix/sf/TM
         Ntj/zRJE1thqeUiAglm7uko5aKh+6FIr8HZJIHRGlK1GNBImzsqQwi+GOmYGOKz8MA
         j0qls9Pf5bogb1rXIwC44JTdRx1E/sbu0tvFs4c4=
Date:   Sun, 28 Mar 2021 09:42:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        sean@geanix.com, stable@vger.kernel.org
Subject:  [merged] squashfs-fix-inode-lookup-sanity-checks.patch
 removed from -mm tree
Message-ID: <20210328164221._YtRLsROU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix inode lookup sanity checks
has been removed from the -mm tree.  Its filename was
     squashfs-fix-inode-lookup-sanity-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sean Nyekjaer <sean@geanix.com>
Subject: squashfs: fix inode lookup sanity checks

When mouting a squashfs image created without inode compression it fails
with: "unable to read inode lookup table"

It turns out that the BLOCK_OFFSET is missing when checking the
SQUASHFS_METADATA_SIZE agaist the actual size.

Link: https://lkml.kernel.org/r/20210226092903.1473545-1-sean@geanix.com
Fixes: eabac19e40c0 ("squashfs: add more sanity checks in inode lookup")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/export.c      |    8 ++++++--
 fs/squashfs/squashfs_fs.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/squashfs/export.c~squashfs-fix-inode-lookup-sanity-checks
+++ a/fs/squashfs/export.c
@@ -152,14 +152,18 @@ __le64 *squashfs_read_inode_lookup_table
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end
+		    || (end - start) >
+		    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= lookup_table_start || (lookup_table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= lookup_table_start ||
+	    (lookup_table_start - start) >
+	    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
--- a/fs/squashfs/squashfs_fs.h~squashfs-fix-inode-lookup-sanity-checks
+++ a/fs/squashfs/squashfs_fs.h
@@ -17,6 +17,7 @@
 
 /* size of metadata (inode and directory) blocks */
 #define SQUASHFS_METADATA_SIZE		8192
+#define SQUASHFS_BLOCK_OFFSET		2
 
 /* default size of block device I/O */
 #ifdef CONFIG_SQUASHFS_4K_DEVBLK_SIZE
_

Patches currently in -mm which might be from sean@geanix.com are


