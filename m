Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E36F66499C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbjAJSXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbjAJSW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF99983E8
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:20:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C16EB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617EDC433D2;
        Tue, 10 Jan 2023 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374798;
        bh=/gmXCSockekduztdxVnD82uT04lVCy1kVkawtlYBnv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AV55U/uu6U+tyPtGDzbrmJT65NW/9OYAhkg8yDENj6BHcBm5p0PhxI7HDU9u9L1G
         ZvJhK9rpz2V+bo55bHNwRgAVhh7nNMMvDHZ1+ta7kjk+3kean74fVR651TDUsC/Vki
         pNyTByf8Bx6YtmInX8YD2509l3L9JzCP8vqozFlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7bb7cd3595533513a9e7@syzkaller.appspotmail.com,
        Michael Schmitz <schmitzmic@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Wilcox <willy@infradead.org>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/159] hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling
Date:   Tue, 10 Jan 2023 19:04:16 +0100
Message-Id: <20230110180021.725907186@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit cb7a95af78d29442b8294683eca4897544b8ef46 ]

Commit 55d1cbbbb29e ("hfs/hfsplus: use WARN_ON for sanity check") fixed
a build warning by turning a comment into a WARN_ON(), but it turns out
that syzbot then complains because it can trigger said warning with a
corrupted hfs image.

The warning actually does warn about a bad situation, but we are much
better off just handling it as the error it is.  So rather than warn
about us doing bad things, stop doing the bad things and return -EIO.

While at it, also fix a memory leak that was introduced by an earlier
fix for a similar syzbot warning situation, and add a check for one case
that historically wasn't handled at all (ie neither comment nor
subsequent WARN_ON).

Reported-by: syzbot+7bb7cd3595533513a9e7@syzkaller.appspotmail.com
Fixes: 55d1cbbbb29e ("hfs/hfsplus: use WARN_ON for sanity check")
Fixes: 8d824e69d9f3 ("hfs: fix OOB Read in __hfs_brec_find")
Link: https://lore.kernel.org/lkml/000000000000dbce4e05f170f289@google.com/
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/inode.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a0746be3c1de..80d17c520d0b 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -458,15 +458,16 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		/* panic? */
 		return -EIO;
 
+	res = -EIO;
 	if (HFS_I(main_inode)->cat_key.CName.len > HFS_NAMELEN)
-		return -EIO;
+		goto out;
 	fd.search_key->cat = HFS_I(main_inode)->cat_key;
 	if (hfs_brec_find(&fd))
-		/* panic? */
 		goto out;
 
 	if (S_ISDIR(main_inode->i_mode)) {
-		WARN_ON(fd.entrylength < sizeof(struct hfs_cat_dir));
+		if (fd.entrylength < sizeof(struct hfs_cat_dir))
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_dir));
 		if (rec.type != HFS_CDR_DIR ||
@@ -479,6 +480,8 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 			    sizeof(struct hfs_cat_dir));
 	} else if (HFS_IS_RSRC(inode)) {
+		if (fd.entrylength < sizeof(struct hfs_cat_file))
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			       sizeof(struct hfs_cat_file));
 		hfs_inode_write_fork(inode, rec.file.RExtRec,
@@ -486,7 +489,8 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 				sizeof(struct hfs_cat_file));
 	} else {
-		WARN_ON(fd.entrylength < sizeof(struct hfs_cat_file));
+		if (fd.entrylength < sizeof(struct hfs_cat_file))
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_file));
 		if (rec.type != HFS_CDR_FIL ||
@@ -503,9 +507,10 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 			    sizeof(struct hfs_cat_file));
 	}
+	res = 0;
 out:
 	hfs_find_exit(&fd);
-	return 0;
+	return res;
 }
 
 static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
-- 
2.35.1



