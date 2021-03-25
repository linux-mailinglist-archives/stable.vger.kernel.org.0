Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE043487FA
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 05:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhCYEhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 00:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhCYEhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 00:37:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F0461A1A;
        Thu, 25 Mar 2021 04:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647053;
        bh=LkqPU0Xs+GuDXq/TXAmDRaqyB1zG7HUkB8TOhmvZeWA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h3hStT+2KA5G+g68PzQcG+MFdoM7k6VZKUD+6DGBOSJSHOrL0KUVOJAsj5B79IlLe
         9wQOfLDYEPJAg7+FcMHnsP5HLTG26xxpuI9QLT3wBr/9PgWoInx1n7TbWtqaEJxyaF
         jkJ4r5xMp/fcyCvrcXMVGHUtIhEyJgXsYtoB6HpI=
Date:   Wed, 24 Mar 2021 21:37:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        sean@geanix.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/14] squashfs: fix inode lookup sanity checks
Message-ID: <20210325043732.s0qOxEFN9%akpm@linux-foundation.org>
In-Reply-To: <20210324213644.bf03a529aec4ef9580e17dbc@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
