Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82031D863D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgERRsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgERRsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B55B020671;
        Mon, 18 May 2020 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824115;
        bh=DxDsfTkgOjqCFH1Q/5NfOZvR63TeurMxxpGVjJ6sUto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVIbj0Ehoee1YH/3B5mJxPdLTCXvs983bv0N1ofjrsEJAavJlNEVmuekCnCZ6NWCp
         3DhosmPLUmKR8QN9ASGFwN9nTjYb9vOmJeyTf8u3/2S8RHKizUlmz8+6jJzJen3RNM
         +Ujyyd0MI8tFq3oYZBM8UTybWp9OD/6mEL4B7bjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 044/114] f2fs: introduce read_xattr_block
Date:   Mon, 18 May 2020 19:36:16 +0200
Message-Id: <20200518173511.349444101@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit 63840695f68c20735df8861062343cf1faa3768d upstream.

Commit ba38c27eb93e ("f2fs: enhance lookup xattr") introduces
lookup_all_xattrs duplicating from read_all_xattrs, which leaves
lots of similar codes in between them, so introduce new help
read_xattr_block to clean up redundant codes.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |   50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -264,12 +264,31 @@ static int read_inline_xattr(struct inod
 	return 0;
 }
 
+static int read_xattr_block(struct inode *inode, void *txattr_addr)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
+	unsigned int inline_size = inline_xattr_size(inode);
+	struct page *xpage;
+	void *xattr_addr;
+
+	/* The inode already has an extended attribute block. */
+	xpage = get_node_page(sbi, xnid);
+	if (IS_ERR(xpage))
+		return PTR_ERR(xpage);
+
+	xattr_addr = page_address(xpage);
+	memcpy(txattr_addr + inline_size, xattr_addr, VALID_XATTR_BLOCK_SIZE);
+	f2fs_put_page(xpage, 1);
+
+	return 0;
+}
+
 static int lookup_all_xattrs(struct inode *inode, struct page *ipage,
 				unsigned int index, unsigned int len,
 				const char *name, struct f2fs_xattr_entry **xe,
 				void **base_addr)
 {
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	void *cur_addr, *txattr_addr, *last_addr = NULL;
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 	unsigned int size = xnid ? VALID_XATTR_BLOCK_SIZE : 0;
@@ -298,19 +317,9 @@ static int lookup_all_xattrs(struct inod
 
 	/* read from xattr node block */
 	if (xnid) {
-		struct page *xpage;
-		void *xattr_addr;
-
-		/* The inode already has an extended attribute block. */
-		xpage = get_node_page(sbi, xnid);
-		if (IS_ERR(xpage)) {
-			err = PTR_ERR(xpage);
+		err = read_xattr_block(inode, txattr_addr);
+		if (err)
 			goto out;
-		}
-
-		xattr_addr = page_address(xpage);
-		memcpy(txattr_addr + inline_size, xattr_addr, size);
-		f2fs_put_page(xpage, 1);
 	}
 
 	if (last_addr)
@@ -335,7 +344,6 @@ out:
 static int read_all_xattrs(struct inode *inode, struct page *ipage,
 							void **base_addr)
 {
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_xattr_header *header;
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 	unsigned int size = VALID_XATTR_BLOCK_SIZE;
@@ -357,19 +365,9 @@ static int read_all_xattrs(struct inode
 
 	/* read from xattr node block */
 	if (xnid) {
-		struct page *xpage;
-		void *xattr_addr;
-
-		/* The inode already has an extended attribute block. */
-		xpage = get_node_page(sbi, xnid);
-		if (IS_ERR(xpage)) {
-			err = PTR_ERR(xpage);
+		err = read_xattr_block(inode, txattr_addr);
+		if (err)
 			goto fail;
-		}
-
-		xattr_addr = page_address(xpage);
-		memcpy(txattr_addr + inline_size, xattr_addr, size);
-		f2fs_put_page(xpage, 1);
 	}
 
 	header = XATTR_HDR(txattr_addr);


