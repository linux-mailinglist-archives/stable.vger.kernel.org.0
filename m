Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5791E378932
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbhEJLZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhEJLRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 320C6617C9;
        Mon, 10 May 2021 11:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645167;
        bh=6/u0QOMQDWtozjw/I88axVNFLSUoHDVCC2plP3hy8OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xy6xSYBt4Hcp9GNfd+oaKDbtvmR47kHCdqvxfvHEyxWAiHyL0WClvXzdvrmZXnW6p
         MT75Rs3+obypcFCkSCRVl4nJLN2aGIphlgbqP/GT0pwt5KJoAdqjA90iWtbl4loowC
         NoQdNRCBJiyufODraPL9CfuQ4j5UB2BrvN667RY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 5.12 345/384] ext4: Fix occasional generic/418 failure
Date:   Mon, 10 May 2021 12:22:14 +0200
Message-Id: <20210510102026.143638843@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 5899593f51e63dde2f07c67358bd65a641585abb upstream.

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
Acked-by: Dave Chinner <dchinner@redhat.com>
Link: https://lore.kernel.org/r/20210415155417.4734-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/file.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -371,15 +371,32 @@ truncate:
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


