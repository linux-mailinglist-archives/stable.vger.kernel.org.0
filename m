Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AA51B69B0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgDWXZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:25:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48174 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728046AbgDWXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zi-GX; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6fN-TS; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jan Kara" <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>
Date:   Fri, 24 Apr 2020 00:04:03 +0100
Message-ID: <lsq.1587683028.116815940@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 016/245] ext4: fix races between buffered IO and
 collapse / insert range
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.com>

commit 32ebffd3bbb4162da5ff88f9a35dd32d0a28ea70 upstream.

Current code implementing FALLOC_FL_COLLAPSE_RANGE and
FALLOC_FL_INSERT_RANGE is prone to races with buffered writes and page
faults. If buffered write or write via mmap manages to squeeze between
filemap_write_and_wait_range() and truncate_pagecache() in the fallocate
implementations, the written data is simply discarded by
truncate_pagecache() although it should have been shifted.

Fix the problem by moving filemap_write_and_wait_range() call inside
i_mutex and i_mmap_sem. That way we are protected against races with
both buffered writes and page faults.

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16: drop changes in ext4_insert_range()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5453,21 +5453,7 @@ int ext4_collapse_range(struct inode *in
 			return ret;
 	}
 
-	/*
-	 * Need to round down offset to be aligned with page size boundary
-	 * for page size > block size.
-	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-
-	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-					   LLONG_MAX);
-	if (ret)
-		return ret;
-
-	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
-
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
@@ -5492,6 +5478,27 @@ int ext4_collapse_range(struct inode *in
 	 * page cache.
 	 */
 	down_write(&EXT4_I(inode)->i_mmap_sem);
+	/*
+	 * Need to round down offset to be aligned with page size boundary
+	 * for page size > block size.
+	 */
+	ioffset = round_down(offset, PAGE_SIZE);
+	/*
+	 * Write tail of the last page before removed range since it will get
+	 * removed from the page cache below.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, offset);
+	if (ret)
+		goto out_mmap;
+	/*
+	 * Write data that will be shifted to preserve them when discarding
+	 * page cache below. We are also protected from pages becoming dirty
+	 * by i_mmap_sem.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset + len,
+					   LLONG_MAX);
+	if (ret)
+		goto out_mmap;
 	truncate_pagecache(inode, ioffset);
 
 	credits = ext4_writepage_trans_blocks(inode);

