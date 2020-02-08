Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2132156659
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBHSeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:34:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34226 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003fX-9d; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CSL-RU; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andreas Dilger" <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Date:   Sat, 08 Feb 2020 18:20:46 +0000
Message-ID: <lsq.1581185940.469092499@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 107/148] ext4: work around deleting a file with
 i_nlink == 0 safely
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
[bwh: Backported to 3.16: Log message and function are different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2830,19 +2830,18 @@ static int ext4_unlink(struct inode *dir
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	if (!inode->i_nlink) {
-		ext4_warning(inode->i_sb,
-			     "Deleting nonexistent file (%lu), %d",
-			     inode->i_ino, inode->i_nlink);
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
+		ext4_warning(inode->i_sb,
+			     "Deleting nonexistent file (%lu), %d",
+			     inode->i_ino, inode->i_nlink);
+	else
+		drop_nlink(inode);
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = ext4_current_time(inode);

