Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FFA2B668E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgKQOEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgKQNJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:09:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B93002468F;
        Tue, 17 Nov 2020 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618579;
        bh=t3JGyHdjsXTbb079SDqrfbvWVGSqp45TnabyFe6Jzq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQESJTiW1GFZxTBZSgMw7fyVKG85YyKgkRUePyzXQWG/ik5DFFcbOSwHS700HCxye
         npBxjO70tD/HIO3LX+kBQ9FWrSM7iN1sfpu2lg/5AWznPohd0eeE4wQhvSKjXxpEhx
         2MPmNWD6jMSd6m+RndwbghlI9eJwc9oehTh3kah8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/78] xfs: flush new eof page on truncate to avoid post-eof corruption
Date:   Tue, 17 Nov 2020 14:04:42 +0100
Message-Id: <20201117122109.897877304@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 869ae85dae64b5540e4362d7fe4cd520e10ec05c ]

It is possible to expose non-zeroed post-EOF data in XFS if the new
EOF page is dirty, backed by an unwritten block and the truncate
happens to race with writeback. iomap_truncate_page() will not zero
the post-EOF portion of the page if the underlying block is
unwritten. The subsequent call to truncate_setsize() will, but
doesn't dirty the page. Therefore, if writeback happens to complete
after iomap_truncate_page() (so it still sees the unwritten block)
but before truncate_setsize(), the cached page becomes inconsistent
with the on-disk block. A mapped read after the associated page is
reclaimed or invalidated exposes non-zero post-EOF data.

For example, consider the following sequence when run on a kernel
modified to explicitly flush the new EOF page within the race
window:

$ xfs_io -fc "falloc 0 4k" -c fsync /mnt/file
$ xfs_io -c "pwrite 0 4k" -c "truncate 1k" /mnt/file
  ...
$ xfs_io -c "mmap 0 4k" -c "mread -v 1k 8" /mnt/file
00000400:  00 00 00 00 00 00 00 00  ........
$ umount /mnt/; mount <dev> /mnt/
$ xfs_io -c "mmap 0 4k" -c "mread -v 1k 8" /mnt/file
00000400:  cd cd cd cd cd cd cd cd  ........

Update xfs_setattr_size() to explicitly flush the new EOF page prior
to the page truncate to ensure iomap has the latest state of the
underlying block.

Fixes: 68a9f5e7007c ("xfs: implement iomap based buffered write path")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iops.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 7bfddcd32d73e..0d587657056d8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -864,6 +864,16 @@ xfs_setattr_size(
 	if (newsize > oldsize) {
 		error = xfs_zero_eof(ip, newsize, oldsize, &did_zeroing);
 	} else {
+		/*
+		 * iomap won't detect a dirty page over an unwritten block (or a
+		 * cow block over a hole) and subsequently skips zeroing the
+		 * newly post-EOF portion of the page. Flush the new EOF to
+		 * convert the block before the pagecache truncate.
+		 */
+		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
+						     newsize);
+		if (error)
+			return error;
 		error = iomap_truncate_page(inode, newsize, &did_zeroing,
 				&xfs_iomap_ops);
 	}
-- 
2.27.0



