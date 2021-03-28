Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C6F34BD4A
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhC1Qmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 12:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhC1QmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Mar 2021 12:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A96561966;
        Sun, 28 Mar 2021 16:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616949743;
        bh=opsEW5SVADjyxq3lnUwTPLFkbpXkErZXfqSv8fQU0J4=;
        h=Date:From:To:Subject:From;
        b=ECw4q7nfAeJkYp134XgclwJfxI6sAqCDYFgFipn3FzbXk88s5KjRqAnB9cNTxDpAQ
         86y0iXsce3Xqu3zcFuEm2KyvNhI87XoQ7mUDHqflnQJHSzNxfa6y51Y/s0/tYFwhDf
         roci9HfYfk2wXJUrk2jgS9pmfsbmYh5MuvIfWp00=
Date:   Sun, 28 Mar 2021 09:42:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        sean@geanix.com, stable@vger.kernel.org
Subject:  [merged]
 squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch removed from -mm
 tree
Message-ID: <20210328164223.J1tgsEOll%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix xattr id and id lookup sanity checks
has been removed from the -mm tree.  Its filename was
     squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix xattr id and id lookup sanity checks

The checks for maximum metadata block size is missing
SQUASHFS_BLOCK_OFFSET (the two byte length count).

Link: https://lkml.kernel.org/r/2069685113.2081245.1614583677427@webmail.123-reg.co.uk
Fixes: f37aa4c7366e23f ("squashfs: add more sanity checks in id lookup")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Sean Nyekjaer <sean@geanix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/id.c       |    6 ++++--
 fs/squashfs/xattr_id.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/squashfs/id.c~squashfs-fix-xattr-id-and-id-lookup-sanity-checks
+++ a/fs/squashfs/id.c
@@ -97,14 +97,16 @@ __le64 *squashfs_read_id_index_table(str
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end || (end - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= id_table_start || (id_table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= id_table_start || (id_table_start - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
--- a/fs/squashfs/xattr_id.c~squashfs-fix-xattr-id-and-id-lookup-sanity-checks
+++ a/fs/squashfs/xattr_id.c
@@ -109,14 +109,16 @@ __le64 *squashfs_read_xattr_id_table(str
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end || (end - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= table_start || (table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= table_start || (table_start - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


