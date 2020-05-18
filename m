Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA86E1D863B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgERRsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgERRsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AFF72083E;
        Mon, 18 May 2020 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824117;
        bh=RAvgjnVXsakFDxcTUUHiNuDQ0vgrga+i4T28wI2mmI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SU/hgxKkG6rjtchHpsvGxty0XasYRHnc0DNpn6KIU6+mRy/iV563uRjP7sSQyHjfX
         4g1qYWJCQEtMlEN3MpTJeS3SxZBBa6n9HYugG5/y58o3Dbs7aqh+2ERoifqjOzRoPr
         Nsn4RGv1AVBasQC5QITkMixaW4jHO6nmUKSCg+NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 045/114] f2fs: sanity check of xattr entry size
Date:   Mon, 18 May 2020 19:36:17 +0200
Message-Id: <20200518173511.504367204@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 64beba0558fce7b59e9a8a7afd77290e82a22163 upstream.

There is a security report where f2fs_getxattr() has a hole to expose wrong
memory region when the image is malformed like this.

f2fs_getxattr: entry->e_name_len: 4, size: 12288, buffer_size: 16384, len: 4

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[bwh: Backported to 4.14: Keep using kzalloc()]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -287,7 +287,7 @@ static int read_xattr_block(struct inode
 static int lookup_all_xattrs(struct inode *inode, struct page *ipage,
 				unsigned int index, unsigned int len,
 				const char *name, struct f2fs_xattr_entry **xe,
-				void **base_addr)
+				void **base_addr, int *base_size)
 {
 	void *cur_addr, *txattr_addr, *last_addr = NULL;
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
@@ -298,8 +298,8 @@ static int lookup_all_xattrs(struct inod
 	if (!size && !inline_size)
 		return -ENODATA;
 
-	txattr_addr = kzalloc(inline_size + size + XATTR_PADDING_SIZE,
-							GFP_F2FS_ZERO);
+	*base_size = inline_size + size + XATTR_PADDING_SIZE;
+	txattr_addr = kzalloc(*base_size, GFP_F2FS_ZERO);
 	if (!txattr_addr)
 		return -ENOMEM;
 
@@ -311,8 +311,10 @@ static int lookup_all_xattrs(struct inod
 
 		*xe = __find_inline_xattr(txattr_addr, &last_addr,
 						index, len, name);
-		if (*xe)
+		if (*xe) {
+			*base_size = inline_size;
 			goto check;
+		}
 	}
 
 	/* read from xattr node block */
@@ -462,6 +464,7 @@ int f2fs_getxattr(struct inode *inode, i
 	int error = 0;
 	unsigned int size, len;
 	void *base_addr = NULL;
+	int base_size;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -472,7 +475,7 @@ int f2fs_getxattr(struct inode *inode, i
 
 	down_read(&F2FS_I(inode)->i_xattr_sem);
 	error = lookup_all_xattrs(inode, ipage, index, len, name,
-				&entry, &base_addr);
+				&entry, &base_addr, &base_size);
 	up_read(&F2FS_I(inode)->i_xattr_sem);
 	if (error)
 		return error;
@@ -486,6 +489,11 @@ int f2fs_getxattr(struct inode *inode, i
 
 	if (buffer) {
 		char *pval = entry->e_name + entry->e_name_len;
+
+		if (base_size - (pval - (char *)base_addr) < size) {
+			error = -ERANGE;
+			goto out;
+		}
 		memcpy(buffer, pval, size);
 	}
 	error = size;


