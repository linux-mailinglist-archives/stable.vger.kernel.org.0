Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF98D121651
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfLPS2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:28:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731094AbfLPSPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BA9D206EC;
        Mon, 16 Dec 2019 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520110;
        bh=HtZUt4Q3OJRm1tgaNWfTS9BY9ENfJu1WJyeDXyVhVlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4jxJs459lHzjeSvlGmqaHX4W5NoXv3PUl/TXnxyyH6gO4DMW35p8YjlDiTuUZhn7
         AGzEL743R4QcejBWoKfdZ8cZR72TQI7SvR1zw272rncFDSnsGqvjmtr5iyRCTTd68s
         mDL97d5yxbq2LW9Yqy1gNbNSWKw4aTCot02STTB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        David Gow <davidgow@google.com>
Subject: [PATCH 5.4 020/177] staging: exfat: fix multiple definition error of `rename_file
Date:   Mon, 16 Dec 2019 18:47:56 +0100
Message-Id: <20191216174817.169218237@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

commit 1af73a25e6e7d9f2f1e2a14259cc9ffce6d8f6d4 upstream.

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
 drivers/staging/exfat/exfat.h       |    4 ++--
 drivers/staging/exfat/exfat_core.c  |    4 ++--
 drivers/staging/exfat/exfat_super.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/exfat/exfat.h
+++ b/drivers/staging/exfat/exfat.h
@@ -943,8 +943,8 @@ s32 create_dir(struct inode *inode, stru
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
--- a/drivers/staging/exfat/exfat_core.c
+++ b/drivers/staging/exfat/exfat_core.c
@@ -3381,8 +3381,8 @@ void remove_file(struct inode *inode, st
 	fs_func->delete_dir_entry(sb, p_dir, entry, 0, num_entries);
 }
 
-s32 rename_file(struct inode *inode, struct chain_t *p_dir, s32 oldentry,
-		struct uni_name_t *p_uniname, struct file_id_t *fid)
+s32 exfat_rename_file(struct inode *inode, struct chain_t *p_dir, s32 oldentry,
+		      struct uni_name_t *p_uniname, struct file_id_t *fid)
 {
 	s32 ret, newentry = -1, num_old_entries, num_new_entries;
 	sector_t sector_old, sector_new;
--- a/drivers/staging/exfat/exfat_super.c
+++ b/drivers/staging/exfat/exfat_super.c
@@ -1308,8 +1308,8 @@ static int ffsMoveFile(struct inode *old
 	fs_set_vol_flags(sb, VOL_DIRTY);
 
 	if (olddir.dir == newdir.dir)
-		ret = rename_file(new_parent_inode, &olddir, dentry, &uni_name,
-				  fid);
+		ret = exfat_rename_file(new_parent_inode, &olddir, dentry,
+					&uni_name, fid);
 	else
 		ret = move_file(new_parent_inode, &olddir, dentry, &newdir,
 				&uni_name, fid);


