Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCEA12EE8D
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbgABWjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731177AbgABWjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:39:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E72217F4;
        Thu,  2 Jan 2020 22:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004760;
        bh=+O2zlRv2fKp69OE2+WSiH7GwneOvEM7wrJNwqYSuv3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmXaZgTjq9O0nOpsuZT8Om1g6e8Ev3fEJPAAgY37bjhQ0+/I6a8oiuTzuY4y0htXt
         DVsotmYSr0NsSVQiOCahnlqfqRYyhR+0Rxy4FNT/MBoEWURGE0l4OXrJ6U4f2HylhR
         brr1n/PCfVmP1ooxROFu8O1/PQGkn0qLjJ6dFARM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 116/137] ext4: work around deleting a file with i_nlink == 0 safely
Date:   Thu,  2 Jan 2020 23:08:09 +0100
Message-Id: <20200102220602.757575928@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index aa08e129149d..712bf332e394 100644
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



