Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428AE6A71D8
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 18:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCARKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 12:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCARKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 12:10:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21A038E88
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 09:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=WeeAqYI9r57pFrLE+XdluqVrN7zxZ34DHvFAzRFQHNM=; b=I7v+m7aJmUFD/dKTXYSrk9VPfx
        Q6uB/99hmileA6waPBXDzrEVXu2qaWWXa+0sas05Ue5Q6wpONt/kF+SzxCpweS5BfwYMPznq/XzIK
        v6m+lxZbxNPL0+fkYkmCe4uyZACHe8eiDtrudY1SlVqq5eWZAqnKWuZ3I03C9ajSwCXFSG99o0cnf
        gidcW2Mn5vJqLaIjxGvd9iXYal/nE7KRvc/8gdKdPwlXZYDvKpuIR9dafpNCCLjNKjWZvETYFwsSd
        Wpq6mZlLxZMND530zH4ZANqPmHxfPy5q6NG6Z8vN9NyI2rXQX4nrDR+oV3DULIcWAnqHhDZMv937v
        VRu0bfaA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXPy1-001lWN-Up; Wed, 01 Mar 2023 17:10:13 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>, security@kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        stable@vger.kernel.org
Subject: [PATCH] freevxfs: Fix kernel memory exposure with inline files
Date:   Wed,  1 Mar 2023 17:10:07 +0000
Message-Id: <20230301171007.420708-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The memcpy() will unconditionally copy PAGE_SIZE bytes, which far exceeds
the length of the array (96 bytes) that it's copying from.  You can't
see the results using read() because it'll be limmited by i_size (which
is less than 96 bytes), but if you mmap the file, you can load the bytes
from the page which are beyond i_size.  We need to zero the tail of the
page before marking it uptodate.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2") # actually v2.4.4.4
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/freevxfs/vxfs_immed.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/freevxfs/vxfs_immed.c b/fs/freevxfs/vxfs_immed.c
index 9b49ec36e667..c49612a24c18 100644
--- a/fs/freevxfs/vxfs_immed.c
+++ b/fs/freevxfs/vxfs_immed.c
@@ -30,15 +30,12 @@
  */
 static int vxfs_immed_read_folio(struct file *fp, struct folio *folio)
 {
-	struct vxfs_inode_info *vip = VXFS_INO(folio->mapping->host);
-	void *src = vip->vii_immed.vi_immed + folio_pos(folio);
-	unsigned long i;
-
-	for (i = 0; i < folio_nr_pages(folio); i++) {
-		memcpy_to_page(folio_page(folio, i), 0, src, PAGE_SIZE);
-		src += PAGE_SIZE;
-	}
+	struct inode *inode = folio->mapping->host;
+	struct vxfs_inode_info *vip = VXFS_INO(inode);
+	loff_t isize = i_size_read(inode);
 
+	memcpy_to_file_folio(folio, 0, vip->vii_immed.vi_immed, isize);
+	folio_zero_segment(folio, isize, folio_size(folio));
 	folio_mark_uptodate(folio);
 	folio_unlock(folio);
 
-- 
2.39.1

