Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF81338048
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 23:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhCKWda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 17:33:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhCKWd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 17:33:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34C8264F83;
        Thu, 11 Mar 2021 22:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615502008;
        bh=SWBfwG+djFRCTBtMYhlCQQc0GK3E2zHgryhljvY8JVE=;
        h=Date:From:To:Subject:From;
        b=S460eRRIXHGnIQBsN0wdcEy8rjdfUqSamXZuJPaoeBQQpOwbUsf4md/PPkEXwaoFQ
         lAaJJFziwbf9VidFOhjylc2KpVTKd9ZSFG0lP19UaAIrvAUDUqU382PU7RV7k9pskb
         Q2+IaMd7fHHmbNfAUO+5ntxHBmzgp2+akkZd7AAA=
Date:   Thu, 11 Mar 2021 14:33:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        sean@geanix.com, stable@vger.kernel.org
Subject:  + squashfs-fix-inode-lookup-sanity-checks.patch added to
 -mm tree
Message-ID: <20210311223327.im5ya6yff%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix inode lookup sanity checks
has been added to the -mm tree.  Its filename is
     squashfs-fix-inode-lookup-sanity-checks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-fix-inode-lookup-sanity-checks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-fix-inode-lookup-sanity-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

squashfs-fix-inode-lookup-sanity-checks.patch

