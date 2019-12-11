Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1AAF11B2EC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387667AbfLKPjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388247AbfLKPim (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6FF921556;
        Wed, 11 Dec 2019 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078722;
        bh=g/Di7A63JQjwJJFCpgmt3I2PfrtgBLTLmE5qIZShGPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2Q1cJzYWQOgpIe/ohj+mLt7ADyCANwdKU+MCqHSGfykTVjtLbmcxlVnDVUP58oXW
         PVYdkrmBJBLxY3XGI5qsv1PPNRrJaM7GeSEPrYsah28klZsOjfYrebPtnIoj4E/qmr
         jQLoNzARnXBy22HwMyUdIxGscs2kcMCGqjzSgxnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, stable@kernel.org,
        Andreas Dilger <adilger@dilger.ca>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 27/37] ext4: work around deleting a file with i_nlink == 0 safely
Date:   Wed, 11 Dec 2019 10:38:03 -0500
Message-Id: <20191211153813.24126-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit c7df4a1ecb8579838ec8c56b2bb6a6716e974f37 ]

If the file system is corrupted such that a file's i_links_count is
too small, then it's possible that when unlinking that file, i_nlink
will already be zero.  Previously we were working around this kind of
corruption by forcing i_nlink to one; but we were doing this before
trying to delete the directory entry --- and if the file system is
corrupted enough that ext4_delete_entry() fails, then we exit with
i_nlink elevated, and this causes the orphan inode list handling to be
FUBAR'ed, such that when we unmount the file system, the orphan inode
list can get corrupted.

A better way to fix this is to simply skip trying to call drop_nlink()
if i_nlink is already zero, thus moving the check to the place where
it makes the most sense.

https://bugzilla.kernel.org/show_bug.cgi?id=205433

Link: https://lore.kernel.org/r/20191112032903.8828-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index aa08e129149dc..712bf332e3948 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3040,18 +3040,17 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	if (inode->i_nlink == 0) {
-		ext4_warning_inode(inode, "Deleting file '%.*s' with no links",
-				   dentry->d_name.len, dentry->d_name.name);
-		set_nlink(inode, 1);
-	}
 	retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
-	drop_nlink(inode);
+	if (inode->i_nlink == 0)
+		ext4_warning_inode(inode, "Deleting file '%.*s' with no links",
+				   dentry->d_name.len, dentry->d_name.name);
+	else
+		drop_nlink(inode);
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = ext4_current_time(inode);
-- 
2.20.1

