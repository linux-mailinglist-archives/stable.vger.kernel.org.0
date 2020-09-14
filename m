Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1B6269278
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgINRF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgINNFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D4422224;
        Mon, 14 Sep 2020 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088667;
        bh=UlDZOmMEl82BvN+q3X8IemklTtPmKk+JfenhcMngvX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1IWvkgimFUR0ligA4bzBswGaQ2PmdvgMaRTAlMynnyTMMzWiVLBMFacmdSKZ2s3B
         wKcBpBA2Nl5yYRk1F+3wacicFKPg9zD4i/CNfL3IQ2gFvpt8gTS3zTYuUwW+wu9QRz
         v2JokThZ2X0taqPFBg4XJ6A6sTSNZzQlgSxhUEIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.8 24/29] f2fs: Return EOF on unaligned end of file DIO read
Date:   Mon, 14 Sep 2020 09:03:53 -0400
Message-Id: <20200914130358.1804194-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 6e9017e6a8197..403e8033c974b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3463,6 +3463,9 @@ static int check_direct_IO(struct inode *inode, struct iov_iter *iter,
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

