Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7119E15EF43
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389243AbgBNQCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389241AbgBNQCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B33C5217F4;
        Fri, 14 Feb 2020 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696124;
        bh=tNTO4ct9SDI8I9KV6SDwnENGAUGgcphrJePh9bylMEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjAdtUHBvNiO34SQPzA/6dBz7Cw7g3zOREQR2moJi0WGRCTMNrpmrjKZii+xMdlbY
         an+J8piknv5YE/erYGDTbtBmJOlfP/ZSVpDP7k4FknriQF9KyD+7t68kwpaVl/wZlU
         WdIwmLaur1KRhk/5Fj5HjHz2jn7zuyzT3+ya38Pc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Javier Gonzalez <javier@javigon.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Chao Yu <yuchao0@huawei.com>, Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 011/459] f2fs: preallocate DIO blocks when forcing buffered_io
Date:   Fri, 14 Feb 2020 10:54:21 -0500
Message-Id: <20200214160149.11681-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 47501f87c61ad2aa234add63e1ae231521dbc3f5 ]

The previous preallocation and DIO decision like below.

                         allow_outplace_dio              !allow_outplace_dio
f2fs_force_buffered_io   (*) No_Prealloc / Buffered_IO   Prealloc / Buffered_IO
!f2fs_force_buffered_io  No_Prealloc / DIO               Prealloc / DIO

But, Javier reported Case (*) where zoned device bypassed preallocation but
fell back to buffered writes in f2fs_direct_IO(), resulting in stale data
being read.

In order to fix the issue, actually we need to preallocate blocks whenever
we fall back to buffered IO like this. No change is made in the other cases.

                         allow_outplace_dio              !allow_outplace_dio
f2fs_force_buffered_io   (*) Prealloc / Buffered_IO      Prealloc / Buffered_IO
!f2fs_force_buffered_io  No_Prealloc / DIO               Prealloc / DIO

Reported-and-tested-by: Javier Gonzalez <javier@javigon.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: Javier González <javier@javigon.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 13 -------------
 fs/f2fs/file.c | 43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2e9c731658008..5d6fd940aab2e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1074,19 +1074,6 @@ int f2fs_preallocate_blocks(struct kiocb *iocb, struct iov_iter *from)
 	int err = 0;
 	bool direct_io = iocb->ki_flags & IOCB_DIRECT;
 
-	/* convert inline data for Direct I/O*/
-	if (direct_io) {
-		err = f2fs_convert_inline_inode(inode);
-		if (err)
-			return err;
-	}
-
-	if (direct_io && allow_outplace_dio(inode, iocb, from))
-		return 0;
-
-	if (is_inode_flag_set(inode, FI_NO_PREALLOC))
-		return 0;
-
 	map.m_lblk = F2FS_BLK_ALIGN(iocb->ki_pos);
 	map.m_len = F2FS_BYTES_TO_BLK(iocb->ki_pos + iov_iter_count(from));
 	if (map.m_len > map.m_lblk)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 72f308790a8e5..44bc5f4a9ce19 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3348,18 +3348,41 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 				ret = -EAGAIN;
 				goto out;
 			}
-		} else {
-			preallocated = true;
-			target_size = iocb->ki_pos + iov_iter_count(from);
+			goto write;
+		}
 
-			err = f2fs_preallocate_blocks(iocb, from);
-			if (err) {
-				clear_inode_flag(inode, FI_NO_PREALLOC);
-				inode_unlock(inode);
-				ret = err;
-				goto out;
-			}
+		if (is_inode_flag_set(inode, FI_NO_PREALLOC))
+			goto write;
+
+		if (iocb->ki_flags & IOCB_DIRECT) {
+			/*
+			 * Convert inline data for Direct I/O before entering
+			 * f2fs_direct_IO().
+			 */
+			err = f2fs_convert_inline_inode(inode);
+			if (err)
+				goto out_err;
+			/*
+			 * If force_buffere_io() is true, we have to allocate
+			 * blocks all the time, since f2fs_direct_IO will fall
+			 * back to buffered IO.
+			 */
+			if (!f2fs_force_buffered_io(inode, iocb, from) &&
+					allow_outplace_dio(inode, iocb, from))
+				goto write;
+		}
+		preallocated = true;
+		target_size = iocb->ki_pos + iov_iter_count(from);
+
+		err = f2fs_preallocate_blocks(iocb, from);
+		if (err) {
+out_err:
+			clear_inode_flag(inode, FI_NO_PREALLOC);
+			inode_unlock(inode);
+			ret = err;
+			goto out;
 		}
+write:
 		ret = __generic_file_write_iter(iocb, from);
 		clear_inode_flag(inode, FI_NO_PREALLOC);
 
-- 
2.20.1

