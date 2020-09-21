Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442C8272EC2
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgIUQtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgIUQtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 781022388B;
        Mon, 21 Sep 2020 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706990;
        bh=hcg0xITRDx7PJvaz4JYlC8n1jzqkFTy22dae6DGDrbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMnhaE7xy7Cy24HbqAqdBPgFd3qSOkkaqBBmkzllNKY5ro5la/UYVwKHApQmkGKh+
         edfyep4Lfy4MLRUFXodFawxmREtA5CKqjtEh7o8nwmLHZQcycFrrtEC4dfL+TodkR3
         NS9l71m/9P85kTCgAIdJ7TY8HugdU9PgcWTmuaUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/72] f2fs: Return EOF on unaligned end of file DIO read
Date:   Mon, 21 Sep 2020 18:31:03 +0200
Message-Id: <20200921163123.019424071@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 20d0a107fb35f37578b919f62bd474d6d358d579 ]

Reading past end of file returns EOF for aligned reads but -EINVAL for
unaligned reads on f2fs.  While documentation is not strict about this
corner case, most filesystem returns EOF on this case, like iomap
filesystems.  This patch consolidates the behavior for f2fs, by making
it return EOF(0).

it can be verified by a read loop on a file that does a partial read
before EOF (A file that doesn't end at an aligned address).  The
following code fails on an unaligned file on f2fs, but not on
btrfs, ext4, and xfs.

  while (done < total) {
    ssize_t delta = pread(fd, buf + done, total - done, off + done);
    if (!delta)
      break;
    ...
  }

It is arguable whether filesystems should actually return EOF or
-EINVAL, but since iomap filesystems support it, and so does the
original DIO code, it seems reasonable to consolidate on that.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ec9a1f9ce2dd6..68be334afc286 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2753,6 +2753,9 @@ static int check_direct_IO(struct inode *inode, struct iov_iter *iter,
 	unsigned long align = offset | iov_iter_alignment(iter);
 	struct block_device *bdev = inode->i_sb->s_bdev;
 
+	if (iov_iter_rw(iter) == READ && offset >= i_size_read(inode))
+		return 1;
+
 	if (align & blocksize_mask) {
 		if (bdev)
 			blkbits = blksize_bits(bdev_logical_block_size(bdev));
-- 
2.25.1



