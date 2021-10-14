Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7119642DD09
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhJNPDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhJNPCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D89161213;
        Thu, 14 Oct 2021 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223573;
        bh=k6lBR4/y3fkaS5nGWhR9R4qf/QCjtp+95GeKhYMgTB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLs7p+CmwRS3RRAc+p/A+C8S9M8rEeYeSpM4I2n3OL57TJeBK6Efw6DCOxPrQ9/1N
         Qv80w94GOq89Lla7Nf7UbOFUUcssZ8EQs+Tc6pntDpxe+tFbE5nqYTlm1rfhFor9eg
         7AwInBsmHYeh14Re37mL300PYg2sbl3kep869vvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/22] ext4: check and update i_disksize properly
Date:   Thu, 14 Oct 2021 16:54:07 +0200
Message-Id: <20211014145208.032762384@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 4df031ff5876d94b48dd9ee486ba5522382a06b2 ]

After commit 3da40c7b0898 ("ext4: only call ext4_truncate when size <=
isize"), i_disksize could always be updated to i_size in ext4_setattr(),
and we could sure that i_disksize <= i_size since holding inode lock and
if i_disksize < i_size there are delalloc writes pending in the range
upto i_size. If the end of the current write is <= i_size, there's no
need to touch i_disksize since writeback will push i_disksize upto
i_size eventually. So we can switch to check i_size instead of
i_disksize in ext4_da_write_end() when write to the end of the file.
we also could remove ext4_mark_inode_dirty() together because we defer
inode dirtying to generic_write_end() or ext4_da_write_inline_data_end().

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210716122024.1105856-2-yi.zhang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 63a292db7587..f0dcc09e220b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3090,35 +3090,37 @@ static int ext4_da_write_end(struct file *file,
 	end = start + copied - 1;
 
 	/*
-	 * generic_write_end() will run mark_inode_dirty() if i_size
-	 * changes.  So let's piggyback the i_disksize mark_inode_dirty
-	 * into that.
+	 * Since we are holding inode lock, we are sure i_disksize <=
+	 * i_size. We also know that if i_disksize < i_size, there are
+	 * delalloc writes pending in the range upto i_size. If the end of
+	 * the current write is <= i_size, there's no need to touch
+	 * i_disksize since writeback will push i_disksize upto i_size
+	 * eventually. If the end of the current write is > i_size and
+	 * inside an allocated block (ext4_da_should_update_i_disksize()
+	 * check), we need to update i_disksize here as neither
+	 * ext4_writepage() nor certain ext4_writepages() paths not
+	 * allocating blocks update i_disksize.
+	 *
+	 * Note that we defer inode dirtying to generic_write_end() /
+	 * ext4_da_write_inline_data_end().
 	 */
 	new_i_size = pos + copied;
-	if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
+	if (copied && new_i_size > inode->i_size) {
 		if (ext4_has_inline_data(inode) ||
-		    ext4_da_should_update_i_disksize(page, end)) {
+		    ext4_da_should_update_i_disksize(page, end))
 			ext4_update_i_disksize(inode, new_i_size);
-			/* We need to mark inode dirty even if
-			 * new_i_size is less that inode->i_size
-			 * bu greater than i_disksize.(hint delalloc)
-			 */
-			ret = ext4_mark_inode_dirty(handle, inode);
-		}
 	}
 
 	if (write_mode != CONVERT_INLINE_DATA &&
 	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
 	    ext4_has_inline_data(inode))
-		ret2 = ext4_da_write_inline_data_end(inode, pos, len, copied,
+		ret = ext4_da_write_inline_data_end(inode, pos, len, copied,
 						     page);
 	else
-		ret2 = generic_write_end(file, mapping, pos, len, copied,
+		ret = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 
-	copied = ret2;
-	if (ret2 < 0)
-		ret = ret2;
+	copied = ret;
 	ret2 = ext4_journal_stop(handle);
 	if (unlikely(ret2 && !ret))
 		ret = ret2;
-- 
2.33.0



