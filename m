Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE82742285A
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhJENwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235277AbhJENwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BCD161503;
        Tue,  5 Oct 2021 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441823;
        bh=JEhVvELebRV5qMWPFWvfdBfG05HZp/gNYMkBz/BV8js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI3VR+OjcPMROWt/mZJWwt1xnip9ol3mZvVcikJtk16TiXEgCSwyPCAkBA8h+X2CH
         63871PQv8I1WV0kbkGeTOZOoOmS7GvKCRDPrCl+wKGDnY2hkSd3JyzGpBp5584G97H
         gn2kfmHpxthYd0fGkkiYNFW+eERfThjLzJGGsoVdMg9hMTIsPpnbk4AAtETVyCPo3a
         yNPRz55ZDyxPwQ09A7+lhL+RByXhQrlBvrt5VqZkEkc99Geq6RG9YZ6zpbPZGe5S38
         exfAlSfWQFPmOuqaXz7MztBQvVcVc0Gpazei1UU9q179/pzdc8D4H6pkZFoy2d4gOE
         SuxSa3qCWrHKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 02/40] ext4: correct the error path of ext4_write_inline_data_end()
Date:   Tue,  5 Oct 2021 09:49:41 -0400
Message-Id: <20211005135020.214291-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 55ce2f649b9e88111270333a8127e23f4f8f42d7 ]

Current error path of ext4_write_inline_data_end() is not correct.

Firstly, it should pass out the error value if ext4_get_inode_loc()
return fail, or else it could trigger infinite loop if we inject error
here. And then it's better to add inode to orphan list if it return fail
in ext4_journal_stop(), otherwise we could not restore inline xattr
entry after power failure. Finally, we need to reset the 'ret' value if
ext4_write_inline_data_end() return success in ext4_write_end() and
ext4_journalled_write_end(), otherwise we could not get the error return
value of ext4_journal_stop().

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210716122024.1105856-3-yi.zhang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 15 +++++----------
 fs/ext4/inode.c  |  7 +++++--
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 24e994e75f5c..8049448476a6 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -733,18 +733,13 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 	void *kaddr;
 	struct ext4_iloc iloc;
 
-	if (unlikely(copied < len)) {
-		if (!PageUptodate(page)) {
-			copied = 0;
-			goto out;
-		}
-	}
+	if (unlikely(copied < len) && !PageUptodate(page))
+		return 0;
 
 	ret = ext4_get_inode_loc(inode, &iloc);
 	if (ret) {
 		ext4_std_error(inode->i_sb, ret);
-		copied = 0;
-		goto out;
+		return ret;
 	}
 
 	ext4_write_lock_xattr(inode, &no_expand);
@@ -757,7 +752,7 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 	(void) ext4_find_inline_data_nolock(inode);
 
 	kaddr = kmap_atomic(page);
-	ext4_write_inline_data(inode, &iloc, kaddr, pos, len);
+	ext4_write_inline_data(inode, &iloc, kaddr, pos, copied);
 	kunmap_atomic(kaddr);
 	SetPageUptodate(page);
 	/* clear page dirty so that writepages wouldn't work for us. */
@@ -766,7 +761,7 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 	ext4_write_unlock_xattr(inode, &no_expand);
 	brelse(iloc.bh);
 	mark_inode_dirty(inode);
-out:
+
 	return copied;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dca8e3810443..5bbf9f3b8b6f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1295,6 +1295,7 @@ static int ext4_write_end(struct file *file,
 			goto errout;
 		}
 		copied = ret;
+		ret = 0;
 	} else
 		copied = block_write_end(file, mapping, pos,
 					 len, copied, page, fsdata);
@@ -1321,13 +1322,14 @@ static int ext4_write_end(struct file *file,
 	if (i_size_changed || inline_data)
 		ret = ext4_mark_inode_dirty(handle, inode);
 
+errout:
 	if (pos + len > inode->i_size && !verity && ext4_can_truncate(inode))
 		/* if we have allocated more blocks and copied
 		 * less. We will have blocks allocated outside
 		 * inode->i_size. So truncate them
 		 */
 		ext4_orphan_add(handle, inode);
-errout:
+
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
@@ -1410,6 +1412,7 @@ static int ext4_journalled_write_end(struct file *file,
 			goto errout;
 		}
 		copied = ret;
+		ret = 0;
 	} else if (unlikely(copied < len) && !PageUptodate(page)) {
 		copied = 0;
 		ext4_journalled_zero_new_buffers(handle, page, from, to);
@@ -1439,6 +1442,7 @@ static int ext4_journalled_write_end(struct file *file,
 			ret = ret2;
 	}
 
+errout:
 	if (pos + len > inode->i_size && !verity && ext4_can_truncate(inode))
 		/* if we have allocated more blocks and copied
 		 * less. We will have blocks allocated outside
@@ -1446,7 +1450,6 @@ static int ext4_journalled_write_end(struct file *file,
 		 */
 		ext4_orphan_add(handle, inode);
 
-errout:
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-- 
2.33.0

