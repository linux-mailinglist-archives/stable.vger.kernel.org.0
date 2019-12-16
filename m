Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12E112182C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfLPSlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729078AbfLPSBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:01:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D752206B7;
        Mon, 16 Dec 2019 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519263;
        bh=pJvThVF7UxbRq3U3yLReQeuAsAk3XpB2WnkGmm/W5n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJDbWJWQYSadn1HwSjt608cngyV+jT6YrL+Q9rYfYj53mqq0gXUqgZLda6kvYCPR2
         kkENLHMMRKbI/GdF3EOa+uxPI8GgPJzovZ1f6nJ2d56v0aq7QKRIBVCo2pBq9x0QOx
         TQMxjYjS/7CHD7pv9ZqTBZJWmiIOSfC10mpGSPBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 4.14 261/267] ext4: work around deleting a file with i_nlink == 0 safely
Date:   Mon, 16 Dec 2019 18:49:47 +0100
Message-Id: <20191216174917.073910129@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit c7df4a1ecb8579838ec8c56b2bb6a6716e974f37 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3065,18 +3065,17 @@ static int ext4_unlink(struct inode *dir
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
 	dir->i_ctime = dir->i_mtime = current_time(dir);
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
 	inode->i_ctime = current_time(inode);


