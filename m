Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE1422857
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbhJENwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235085AbhJENwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B402361244;
        Tue,  5 Oct 2021 13:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441822;
        bh=a1Qbzr8/zB02DQWjCUA31GrFzN2vH4OUkEx92NYCYQM=;
        h=From:To:Cc:Subject:Date:From;
        b=kzNOIpDuG6B+GB5IGl41l0ABg4LEW5KqPPjMyi3WULPMUXyTvx7mT5kX7n0/pr1f1
         tJo428opHW+SbjNYr5h/sXR21prF6f6bIebz9U2BjWu64OpWyyqdpEvnEF2SCINm9D
         BgFYdVqxQ76x+ew8klWnW35bzADIuq588n31dtlcAd5VzVd72YuE5J9++RxulYQI0P
         PCXMY3Iz/b7RJ8w9CMcqiUmZbbGXsOn0oFimzOCdjHX5O88HsFX7zv0BUJRCDUKQKr
         MKTaexeQANAjCHW+aOoMsY7k7tdNIOJdwUwrp8PJmSpoC+TK0u7lB4ADIbJbOkiRYE
         bHzu/8eCuEe4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 01/40] ext4: check and update i_disksize properly
Date:   Tue,  5 Oct 2021 09:49:40 -0400
Message-Id: <20211005135020.214291-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d8de607849df..dca8e3810443 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3084,35 +3084,37 @@ static int ext4_da_write_end(struct file *file,
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

