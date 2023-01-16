Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE8E66CBEE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbjAPRUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbjAPRTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE66D2CFF0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D20D61055
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07E0C433EF;
        Mon, 16 Jan 2023 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888332;
        bh=rExkZZwt2YTxtKK+sofZtNOZY/3tdC5tqD+8sAWJhsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmtNTL5DHHF/rJb4fyJXtv4e2kUu+I/HOYu9tTMNuaAcwbI4lfAY5a2PB3oQ2wPvy
         MYUu0samOM1gB5/9FJD1Vc8XS14ngVgm6eUISlHiMxzWejBT2+ZKHibdCVDR0GcYr8
         pqBBLlTpdrwgp+NvGjCKlJNDsS2ro9be6/iUcPX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 458/521] hfs/hfsplus: use WARN_ON for sanity check
Date:   Mon, 16 Jan 2023 16:52:00 +0100
Message-Id: <20230116154907.614251649@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 55d1cbbbb29e6656c662ee8f73ba1fc4777532eb upstream.

gcc warns about a couple of instances in which a sanity check exists but
the author wasn't sure how to react to it failing, which makes it look
like a possible bug:

  fs/hfsplus/inode.c: In function 'hfsplus_cat_read_inode':
  fs/hfsplus/inode.c:503:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
    503 |                         /* panic? */;
        |                                     ^
  fs/hfsplus/inode.c:524:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
    524 |                         /* panic? */;
        |                                     ^
  fs/hfsplus/inode.c: In function 'hfsplus_cat_write_inode':
  fs/hfsplus/inode.c:582:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
    582 |                         /* panic? */;
        |                                     ^
  fs/hfsplus/inode.c:608:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
    608 |                         /* panic? */;
        |                                     ^
  fs/hfs/inode.c: In function 'hfs_write_inode':
  fs/hfs/inode.c:464:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
    464 |                         /* panic? */;
        |                                     ^
  fs/hfs/inode.c:485:37: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
    485 |                         /* panic? */;
        |                                     ^

panic() is probably not the correct choice here, but a WARN_ON
seems appropriate and avoids the compile-time warning.

Link: https://lkml.kernel.org/r/20210927102149.1809384-1-arnd@kernel.org
Link: https://lore.kernel.org/all/20210322223249.2632268-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfs/inode.c     |    6 ++----
 fs/hfsplus/inode.c |   12 ++++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -461,8 +461,7 @@ int hfs_write_inode(struct inode *inode,
 		goto out;
 
 	if (S_ISDIR(main_inode->i_mode)) {
-		if (fd.entrylength < sizeof(struct hfs_cat_dir))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfs_cat_dir));
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_dir));
 		if (rec.type != HFS_CDR_DIR ||
@@ -482,8 +481,7 @@ int hfs_write_inode(struct inode *inode,
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 				sizeof(struct hfs_cat_file));
 	} else {
-		if (fd.entrylength < sizeof(struct hfs_cat_file))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfs_cat_file));
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_file));
 		if (rec.type != HFS_CDR_FIL ||
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -476,8 +476,7 @@ int hfsplus_cat_read_inode(struct inode
 	if (type == HFSPLUS_FOLDER) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		if (fd->entrylength < sizeof(struct hfsplus_cat_folder))
-			/* panic? */;
+		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_folder));
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		hfsplus_get_perms(inode, &folder->permissions, 1);
@@ -497,8 +496,7 @@ int hfsplus_cat_read_inode(struct inode
 	} else if (type == HFSPLUS_FILE) {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		if (fd->entrylength < sizeof(struct hfsplus_cat_file))
-			/* panic? */;
+		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_file));
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_file));
 
@@ -555,8 +553,7 @@ int hfsplus_cat_write_inode(struct inode
 	if (S_ISDIR(main_inode->i_mode)) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		if (fd.entrylength < sizeof(struct hfsplus_cat_folder))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_folder));
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		/* simple node checks? */
@@ -581,8 +578,7 @@ int hfsplus_cat_write_inode(struct inode
 	} else {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		if (fd.entrylength < sizeof(struct hfsplus_cat_file))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_file));
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_file));
 		hfsplus_inode_write_fork(inode, &file->data_fork);


