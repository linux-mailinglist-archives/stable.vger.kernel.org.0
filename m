Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEC366CBF0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbjAPRUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbjAPRTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0E72D174
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1834EB8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D24FC433D2;
        Mon, 16 Jan 2023 16:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888334;
        bh=Oa+7z2CKRvY4h6VGcWvpZBwJOAxMJleX2mSN3Ph7FP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOXVP+UgVUrXEXcxEh7j6qWANF/1w1vvtxg10Qd6UYR0ArYCeaNvrlQeHrJE/86iI
         vAKIfod5/NOG4vaUmlUP6kh4TaC/VaSp5tna8+X5grSjZ/pDfOP9ePLl6Ofj+BvTWb
         TDSg/dzwGR9TYkow2B8AFkIvjjSr5W3yX/4qDNqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7bb7cd3595533513a9e7@syzkaller.appspotmail.com,
        Michael Schmitz <schmitzmic@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Wilcox <willy@infradead.org>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 459/521] hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling
Date:   Mon, 16 Jan 2023 16:52:01 +0100
Message-Id: <20230116154907.660594745@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit cb7a95af78d29442b8294683eca4897544b8ef46 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfs/inode.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -453,15 +453,16 @@ int hfs_write_inode(struct inode *inode,
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
@@ -474,6 +475,8 @@ int hfs_write_inode(struct inode *inode,
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 			    sizeof(struct hfs_cat_dir));
 	} else if (HFS_IS_RSRC(inode)) {
+		if (fd.entrylength < sizeof(struct hfs_cat_file))
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			       sizeof(struct hfs_cat_file));
 		hfs_inode_write_fork(inode, rec.file.RExtRec,
@@ -481,7 +484,8 @@ int hfs_write_inode(struct inode *inode,
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 				sizeof(struct hfs_cat_file));
 	} else {
-		WARN_ON(fd.entrylength < sizeof(struct hfs_cat_file));
+		if (fd.entrylength < sizeof(struct hfs_cat_file))
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_file));
 		if (rec.type != HFS_CDR_FIL ||
@@ -498,9 +502,10 @@ int hfs_write_inode(struct inode *inode,
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


