Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DB36ECF00
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjDXNh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjDXNhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0B183DE
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED674623EB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4A3C433EF;
        Mon, 24 Apr 2023 13:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343378;
        bh=x9jxZNqACXk0nMRhdzce2os/BSju+O5K8Yr6eQ+6LZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+s1l/o4J99cBpM/zImuzFMGbS9Nd9wMDf76Fmf7dfOQDPoPyy2lpc2Oi3hXAyjtA
         HvbdyuEvIAXiWFWG73Qi74gy1rY8NvD8ZyGSi9pn4enmavLjdVsxtphaPmdpyHBPnZ
         20U6NMIcsaZAYtTR2GmkTG5UVbnM3F9/2MHloN+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5.10 54/68] fuse: fix deadlock between atomic O_TRUNC and page invalidation
Date:   Mon, 24 Apr 2023 15:18:25 +0200
Message-Id: <20230424131129.732669316@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 2fdbb8dd01556e1501132b5ad3826e8f71e24a8b upstream.

fuse_finish_open() will be called with FUSE_NOWRITE set in case of atomic
O_TRUNC open(), so commit 76224355db75 ("fuse: truncate pagecache on
atomic_o_trunc") replaced invalidate_inode_pages2() by truncate_pagecache()
in such a case to avoid the A-A deadlock. However, we found another A-B-B-A
deadlock related to the case above, which will cause the xfstests
generic/464 testcase hung in our virtio-fs test environment.

For example, consider two processes concurrently open one same file, one
with O_TRUNC and another without O_TRUNC. The deadlock case is described
below, if open(O_TRUNC) is already set_nowrite(acquired A), and is trying
to lock a page (acquiring B), open() could have held the page lock
(acquired B), and waiting on the page writeback (acquiring A). This would
lead to deadlocks.

open(O_TRUNC)
----------------------------------------------------------------
fuse_open_common
  inode_lock            [C acquire]
  fuse_set_nowrite      [A acquire]

  fuse_finish_open
    truncate_pagecache
      lock_page         [B acquire]
      truncate_inode_page
      unlock_page       [B release]

  fuse_release_nowrite  [A release]
  inode_unlock          [C release]
----------------------------------------------------------------

open()
----------------------------------------------------------------
fuse_open_common
  fuse_finish_open
    invalidate_inode_pages2
      lock_page         [B acquire]
        fuse_launder_page
          fuse_wait_on_page_writeback [A acquire & release]
      unlock_page       [B release]
----------------------------------------------------------------

Besides this case, all calls of invalidate_inode_pages2() and
invalidate_inode_pages2_range() in fuse code also can deadlock with
open(O_TRUNC).

Fix by moving the truncate_pagecache() call outside the nowrite protected
region.  The nowrite protection is only for delayed writeback
(writeback_cache) case, where inode lock does not protect against
truncation racing with writes on the server.  Write syscalls racing with
page cache truncation still get the inode lock protection.

This patch also changes the order of filemap_invalidate_lock()
vs. fuse_set_nowrite() in fuse_open_common().  This new order matches the
order found in fuse_file_fallocate() and fuse_do_setattr().

Reported-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Tested-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Fixes: e4648309b85a ("fuse: truncate pending writes on O_TRUNC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c  |    5 +++++
 fs/fuse/file.c |   29 +++++++++++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -537,6 +537,7 @@ static int fuse_create_open(struct inode
 	struct fuse_entry_out outentry;
 	struct fuse_inode *fi;
 	struct fuse_file *ff;
+	bool trunc = flags & O_TRUNC;
 
 	/* Userspace expects S_IFREG in create mode */
 	BUG_ON((mode & S_IFMT) != S_IFREG);
@@ -604,6 +605,10 @@ static int fuse_create_open(struct inode
 	} else {
 		file->private_data = ff;
 		fuse_finish_open(inode, file);
+		if (fm->fc->atomic_o_trunc && trunc)
+			truncate_pagecache(inode, 0);
+		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
+			invalidate_inode_pages2(inode->i_mapping);
 	}
 	return err;
 
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -206,14 +206,10 @@ void fuse_finish_open(struct inode *inod
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, 0);
 		spin_unlock(&fi->lock);
-		truncate_pagecache(inode, 0);
 		fuse_invalidate_attr(inode);
 		if (fc->writeback_cache)
 			file_update_time(file);
-	} else if (!(ff->open_flags & FOPEN_KEEP_CACHE)) {
-		invalidate_inode_pages2(inode->i_mapping);
 	}
-
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
 		fuse_link_write_file(file);
 }
@@ -236,30 +232,39 @@ int fuse_open_common(struct inode *inode
 	if (err)
 		return err;
 
-	if (is_wb_truncate || dax_truncate) {
+	if (is_wb_truncate || dax_truncate)
 		inode_lock(inode);
-		fuse_set_nowrite(inode);
-	}
 
 	if (dax_truncate) {
 		down_write(&get_fuse_inode(inode)->i_mmap_sem);
 		err = fuse_dax_break_layouts(inode, 0, 0);
 		if (err)
-			goto out;
+			goto out_inode_unlock;
 	}
 
+	if (is_wb_truncate || dax_truncate)
+		fuse_set_nowrite(inode);
+
 	err = fuse_do_open(fm, get_node_id(inode), file, isdir);
 	if (!err)
 		fuse_finish_open(inode, file);
 
-out:
+	if (is_wb_truncate || dax_truncate)
+		fuse_release_nowrite(inode);
+	if (!err) {
+		struct fuse_file *ff = file->private_data;
+
+		if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC))
+			truncate_pagecache(inode, 0);
+		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
+			invalidate_inode_pages2(inode->i_mapping);
+	}
 	if (dax_truncate)
 		up_write(&get_fuse_inode(inode)->i_mmap_sem);
 
-	if (is_wb_truncate | dax_truncate) {
-		fuse_release_nowrite(inode);
+out_inode_unlock:
+	if (is_wb_truncate || dax_truncate)
 		inode_unlock(inode);
-	}
 
 	return err;
 }


