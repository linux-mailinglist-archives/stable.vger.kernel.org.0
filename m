Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1F2F9E8B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390779AbhARLmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390324AbhARLlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E404F222BB;
        Mon, 18 Jan 2021 11:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970065;
        bh=04UXEmDexUYFvgGbh2s6t/yGTiFneQyIYqHV+pcGiBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2u0pFiAnGOzDVLLzBXCAXo0uUtZKt/uIE6iFbFbBoDqzMvp2jqWMyJ9qBVCEF5Xw
         GAn4WC9XzenrPouq6CgsPQKdZrY/mmmX7m9XAcr09WQQjrcGnT+v4ZJlQAsTLeQc31
         Jjhqx9kcRpYxz2P8AD68EjeouZFMXn7J18CpL3YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 022/152] ext4: fix bug for rename with RENAME_WHITEOUT
Date:   Mon, 18 Jan 2021 12:33:17 +0100
Message-Id: <20210118113353.839717809@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit 6b4b8e6b4ad8553660421d6360678b3811d5deb9 upstream.

We got a "deleted inode referenced" warning cross our fsstress test. The
bug can be reproduced easily with following steps:

  cd /dev/shm
  mkdir test/
  fallocate -l 128M img
  mkfs.ext4 -b 1024 img
  mount img test/
  dd if=/dev/zero of=test/foo bs=1M count=128
  mkdir test/dir/ && cd test/dir/
  for ((i=0;i<1000;i++)); do touch file$i; done # consume all block
  cd ~ && renameat2(AT_FDCWD, /dev/shm/test/dir/file1, AT_FDCWD,
    /dev/shm/test/dir/dst_file, RENAME_WHITEOUT) # ext4_add_entry in
    ext4_rename will return ENOSPC!!
  cd /dev/shm/ && umount test/ && mount img test/ && ls -li test/dir/file1
  We will get the output:
  "ls: cannot access 'test/dir/file1': Structure needs cleaning"
  and the dmesg show:
  "EXT4-fs error (device loop0): ext4_lookup:1626: inode #2049: comm ls:
  deleted inode referenced: 139"

ext4_rename will create a special inode for whiteout and use this 'ino'
to replace the source file's dir entry 'ino'. Once error happens
latter(the error above was the ENOSPC return from ext4_add_entry in
ext4_rename since all space has been consumed), the cleanup do drop the
nlink for whiteout, but forget to restore 'ino' with source file. This
will trigger the bug describle as above.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Fixes: cd808deced43 ("ext4: support RENAME_WHITEOUT")
Link: https://lore.kernel.org/r/20210105062857.3566-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3602,9 +3602,6 @@ static int ext4_setent(handle_t *handle,
 			return retval2;
 		}
 	}
-	brelse(ent->bh);
-	ent->bh = NULL;
-
 	return retval;
 }
 
@@ -3803,6 +3800,7 @@ static int ext4_rename(struct inode *old
 		}
 	}
 
+	old_file_type = old.de->file_type;
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
 		ext4_handle_sync(handle);
 
@@ -3830,7 +3828,6 @@ static int ext4_rename(struct inode *old
 	force_reread = (new.dir->i_ino == old.dir->i_ino &&
 			ext4_test_inode_flag(new.dir, EXT4_INODE_INLINE_DATA));
 
-	old_file_type = old.de->file_type;
 	if (whiteout) {
 		/*
 		 * Do this before adding a new entry, so the old entry is sure
@@ -3928,15 +3925,19 @@ static int ext4_rename(struct inode *old
 	retval = 0;
 
 end_rename:
-	brelse(old.dir_bh);
-	brelse(old.bh);
-	brelse(new.bh);
 	if (whiteout) {
-		if (retval)
+		if (retval) {
+			ext4_setent(handle, &old,
+				old.inode->i_ino, old_file_type);
 			drop_nlink(whiteout);
+		}
 		unlock_new_inode(whiteout);
 		iput(whiteout);
+
 	}
+	brelse(old.dir_bh);
+	brelse(old.bh);
+	brelse(new.bh);
 	if (handle)
 		ext4_journal_stop(handle);
 	return retval;


