Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4139A11844D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 11:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfLJKF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 05:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfLJKF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 05:05:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6500D20663;
        Tue, 10 Dec 2019 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575972358;
        bh=d+8FCBbPzNFyGO/MMYhB8t0S0yqfdATCjMoF/2Pb0Bw=;
        h=Subject:To:From:Date:From;
        b=TCp/fn1ruogHkgvLCxJUDDgNmZC6ZTskbUL7D1S1++0SZ3Ihm3ePPE+77K2FMk8v4
         n8TZaGFF93KmGkYrE+1xjC5mNUYS+bCxv3/fuluDsAOviDf6ewUMUlVOUXxtbOnysJ
         HOxYG038eYfbPqu89fyifz50groSAD5w3D/zcDwM=
Subject: patch "staging: exfat: fix multiple definition error of `rename_file'" added to staging-linus
To:     brendanhiggins@google.com, davidgow@google.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        valdis.kletnieks@vt.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 11:05:39 +0100
Message-ID: <15759723395294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: exfat: fix multiple definition error of `rename_file'

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1af73a25e6e7d9f2f1e2a14259cc9ffce6d8f6d4 Mon Sep 17 00:00:00 2001
From: Brendan Higgins <brendanhiggins@google.com>
Date: Wed, 4 Dec 2019 15:45:22 -0800
Subject: staging: exfat: fix multiple definition error of `rename_file'

`rename_file' was exported but not properly namespaced causing a
multiple definition error because `rename_file' is already defined in
fs/hostfs/hostfs_user.c:

ld: drivers/staging/exfat/exfat_core.o: in function `rename_file':
drivers/staging/exfat/exfat_core.c:2327: multiple definition of
`rename_file'; fs/hostfs/hostfs_user.o:fs/hostfs/hostfs_user.c:350:
first defined here
make: *** [Makefile:1077: vmlinux] Error 1

This error can be reproduced on ARCH=um by selecting:

CONFIG_EXFAT_FS=y
CONFIG_HOSTFS=y

Add a namespace prefix exfat_* to fix this error.

Reported-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Cc: stable <stable@vger.kernel.org>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Tested-by: David Gow <davidgow@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/r/20191204234522.42855-1-brendanhiggins@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/exfat/exfat.h       | 4 ++--
 drivers/staging/exfat/exfat_core.c  | 4 ++--
 drivers/staging/exfat/exfat_super.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/exfat/exfat.h b/drivers/staging/exfat/exfat.h
index 2aac1e000977..51c665a924b7 100644
--- a/drivers/staging/exfat/exfat.h
+++ b/drivers/staging/exfat/exfat.h
@@ -805,8 +805,8 @@ s32 create_dir(struct inode *inode, struct chain_t *p_dir,
 s32 create_file(struct inode *inode, struct chain_t *p_dir,
 		struct uni_name_t *p_uniname, u8 mode, struct file_id_t *fid);
 void remove_file(struct inode *inode, struct chain_t *p_dir, s32 entry);
-s32 rename_file(struct inode *inode, struct chain_t *p_dir, s32 old_entry,
-		struct uni_name_t *p_uniname, struct file_id_t *fid);
+s32 exfat_rename_file(struct inode *inode, struct chain_t *p_dir, s32 old_entry,
+		      struct uni_name_t *p_uniname, struct file_id_t *fid);
 s32 move_file(struct inode *inode, struct chain_t *p_olddir, s32 oldentry,
 	      struct chain_t *p_newdir, struct uni_name_t *p_uniname,
 	      struct file_id_t *fid);
diff --git a/drivers/staging/exfat/exfat_core.c b/drivers/staging/exfat/exfat_core.c
index 463eb89c676a..794000e7bc6f 100644
--- a/drivers/staging/exfat/exfat_core.c
+++ b/drivers/staging/exfat/exfat_core.c
@@ -2324,8 +2324,8 @@ void remove_file(struct inode *inode, struct chain_t *p_dir, s32 entry)
 	fs_func->delete_dir_entry(sb, p_dir, entry, 0, num_entries);
 }
 
-s32 rename_file(struct inode *inode, struct chain_t *p_dir, s32 oldentry,
-		struct uni_name_t *p_uniname, struct file_id_t *fid)
+s32 exfat_rename_file(struct inode *inode, struct chain_t *p_dir, s32 oldentry,
+		      struct uni_name_t *p_uniname, struct file_id_t *fid)
 {
 	s32 ret, newentry = -1, num_old_entries, num_new_entries;
 	sector_t sector_old, sector_new;
diff --git a/drivers/staging/exfat/exfat_super.c b/drivers/staging/exfat/exfat_super.c
index 6e481908c59f..9f91853b189b 100644
--- a/drivers/staging/exfat/exfat_super.c
+++ b/drivers/staging/exfat/exfat_super.c
@@ -1262,8 +1262,8 @@ static int ffsMoveFile(struct inode *old_parent_inode, struct file_id_t *fid,
 	fs_set_vol_flags(sb, VOL_DIRTY);
 
 	if (olddir.dir == newdir.dir)
-		ret = rename_file(new_parent_inode, &olddir, dentry, &uni_name,
-				  fid);
+		ret = exfat_rename_file(new_parent_inode, &olddir, dentry,
+					&uni_name, fid);
 	else
 		ret = move_file(new_parent_inode, &olddir, dentry, &newdir,
 				&uni_name, fid);
-- 
2.24.0


