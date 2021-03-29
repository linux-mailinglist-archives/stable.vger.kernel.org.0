Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523A334C57D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhC2IAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231469AbhC2IAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A06561974;
        Mon, 29 Mar 2021 08:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004824;
        bh=A7Dod5oX9lcDvyzu55/c1vP1GrYr53ekQ6EyH788SmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9voqCYgO6SpOFXmt9+q9tNvKIhdOlw0QcnyXSZNKiG1PVGuiiAk4H+2ex2sheSYc
         uBwrDeW/RpKNjZnQQdmAA9UsTxx/Kb4iFW8vn5XC7YDdZv2JU+zcaGToFrnhuGAkC0
         QwXkEVZjqUHUNiCJ8Lg0XrBgQtADrwnpBGOBFGZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 16/33] squashfs: fix inode lookup sanity checks
Date:   Mon, 29 Mar 2021 09:58:01 +0200
Message-Id: <20210329075605.788613551@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit c1b2028315c6b15e8d6725e0d5884b15887d3daa upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/export.c      |    8 ++++++--
 fs/squashfs/squashfs_fs.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -165,14 +165,18 @@ __le64 *squashfs_read_inode_lookup_table
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
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -30,6 +30,7 @@
 
 /* size of metadata (inode and directory) blocks */
 #define SQUASHFS_METADATA_SIZE		8192
+#define SQUASHFS_BLOCK_OFFSET		2
 
 /* default size of block device I/O */
 #ifdef CONFIG_SQUASHFS_4K_DEVBLK_SIZE


