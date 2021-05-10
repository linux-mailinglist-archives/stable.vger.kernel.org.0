Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3860E3786F4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhEJLMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235744AbhEJLF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 731FC61483;
        Mon, 10 May 2021 10:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644161;
        bh=DXx2Ls0t2fcGvRGK/ur0/utpc2YNDO5Cp0VN0+2jXc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CCfCN0nEHw0J9IbUTc1UQAv6p1u73uITrBmeDiihWvom1NAN1BbubhxaA4L8+GMf
         CcnSrqHSZF4x/0Xrgb0K63Ln9KA/hSJtTMDQRQZbNrOngzy9hvB/mvCO9VxUpCmXDO
         v0i4vjmNwTW+WtEb+KhlGuNFnC7rjC0KyvMg7pU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 5.11 312/342] ext4: Fix occasional generic/418 failure
Date:   Mon, 10 May 2021 12:21:42 +0200
Message-Id: <20210510102020.417240571@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -372,15 +372,32 @@ truncate:
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


