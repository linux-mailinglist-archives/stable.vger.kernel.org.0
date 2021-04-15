Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0104360F7B
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhDOPyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:54:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:49622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhDOPyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:54:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6F47B2DD;
        Thu, 15 Apr 2021 15:54:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id A527B1F2B65; Thu, 15 Apr 2021 17:54:20 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Eric Whitney <enwlinux@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH v3] ext4: Fix occasional generic/418 failure
Date:   Thu, 15 Apr 2021 17:54:17 +0200
Message-Id: <20210415155417.4734-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric has noticed that after pagecache read rework, generic/418 is
occasionally failing for ext4 when blocksize < pagesize. In fact, the
pagecache rework just made hard to hit race in ext4 more likely. The
problem is that since ext4 conversion of direct IO writes to iomap
framework (commit 378f32bab371), we update inode size after direct IO
write only after invalidating page cache. Thus if buffered read sneaks
at unfortunate moment like:

CPU1 - write at offset 1k                       CPU2 - read from offset 0
iomap_dio_rw(..., IOMAP_DIO_FORCE_WAIT);
                                                ext4_readpage();
ext4_handle_inode_extension()

the read will zero out tail of the page as it still sees smaller inode
size and thus page cache becomes inconsistent with on-disk contents with
all the consequences.

Fix the problem by moving inode size update into end_io handler which
gets called before the page cache is invalidated.

Reported-and-tested-by: Eric Whitney <enwlinux@gmail.com>
Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 194f5d00fa32..7924634ab0bf 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -371,15 +371,32 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
 static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
 				 int error, unsigned int flags)
 {
-	loff_t offset = iocb->ki_pos;
+	loff_t pos = iocb->ki_pos;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
 	if (error)
 		return error;
 
-	if (size && flags & IOMAP_DIO_UNWRITTEN)
-		return ext4_convert_unwritten_extents(NULL, inode,
-						      offset, size);
+	if (size && flags & IOMAP_DIO_UNWRITTEN) {
+		error = ext4_convert_unwritten_extents(NULL, inode, pos, size);
+		if (error < 0)
+			return error;
+	}
+	/*
+	 * If we are extending the file, we have to update i_size here before
+	 * page cache gets invalidated in iomap_dio_rw(). Otherwise racing
+	 * buffered reads could zero out too much from page cache pages. Update
+	 * of on-disk size will happen later in ext4_dio_write_iter() where
+	 * we have enough information to also perform orphan list handling etc.
+	 * Note that we perform all extending writes synchronously under
+	 * i_rwsem held exclusively so i_size update is safe here in that case.
+	 * If the write was not extending, we cannot see pos > i_size here
+	 * because operations reducing i_size like truncate wait for all
+	 * outstanding DIO before updating i_size.
+	 */
+	pos += size;
+	if (pos > i_size_read(inode))
+		i_size_write(inode, pos);
 
 	return 0;
 }
-- 
2.26.2

