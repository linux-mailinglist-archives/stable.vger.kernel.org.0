Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA6E344341
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhCVMtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhCVMrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5FC0619C8;
        Mon, 22 Mar 2021 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417016;
        bh=wlaBpyqgQ3urhn6fWh/I/9CbPTkk/7zmhnJwHuRQbMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbM3DfRg5jfy0QAEt+gAGqdNQhrYuRjBpcqh+AykGJt22uONW7NYi5klPAo4BXxGU
         PgHD6A70A8ZGDcMcB/qBlRuvO7dOou+tK6KCjG5lyBgzixQHLhRviOCww2eZ7IwZ/V
         HlmzNg5FjbJmKTQONLTyUaKxmov+WhGQPIg+6/i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 54/60] ext4: find old entry again if failed to rename whiteout
Date:   Mon, 22 Mar 2021 13:28:42 +0100
Message-Id: <20210322121924.162238740@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit b7ff91fd030dc9d72ed91b1aab36e445a003af4f upstream.

If we failed to add new entry on rename whiteout, we cannot reset the
old->de entry directly, because the old->de could have moved from under
us during make indexed dir. So find the old entry again before reset is
needed, otherwise it may corrupt the filesystem as below.

  /dev/sda: Entry '00000001' in ??? (12) has deleted/unused inode 15. CLEARED.
  /dev/sda: Unattached inode 75
  /dev/sda: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.

Fixes: 6b4b8e6b4ad ("ext4: fix bug for rename with RENAME_WHITEOUT")
Cc: stable@vger.kernel.org
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210303131703.330415-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3547,6 +3547,31 @@ static int ext4_setent(handle_t *handle,
 	return 0;
 }
 
+static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
+			  unsigned ino, unsigned file_type)
+{
+	struct ext4_renament old = *ent;
+	int retval = 0;
+
+	/*
+	 * old->de could have moved from under us during make indexed dir,
+	 * so the old->de may no longer valid and need to find it again
+	 * before reset old inode info.
+	 */
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	if (IS_ERR(old.bh))
+		retval = PTR_ERR(old.bh);
+	if (!old.bh)
+		retval = -ENOENT;
+	if (retval) {
+		ext4_std_error(old.dir->i_sb, retval);
+		return;
+	}
+
+	ext4_setent(handle, &old, ino, file_type);
+	brelse(old.bh);
+}
+
 static int ext4_find_delete_entry(handle_t *handle, struct inode *dir,
 				  const struct qstr *d_name)
 {
@@ -3843,8 +3868,8 @@ static int ext4_rename(struct inode *old
 end_rename:
 	if (whiteout) {
 		if (retval) {
-			ext4_setent(handle, &old,
-				old.inode->i_ino, old_file_type);
+			ext4_resetent(handle, &old,
+				      old.inode->i_ino, old_file_type);
 			drop_nlink(whiteout);
 		}
 		unlock_new_inode(whiteout);


