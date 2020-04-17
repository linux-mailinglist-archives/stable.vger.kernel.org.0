Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A92F1AD7F7
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgDQHuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 03:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbgDQHuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 03:50:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C77C061A0C;
        Fri, 17 Apr 2020 00:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IbtRDHeXY7VovT/RwD90Ly8E9e+8aBda8njkL5CwpAc=; b=SUqGLpxhIqfIeRMBzoRt936Zlh
        bg9S/0G2P1ihadANO26/GThhpUVq1tCYjo+STsS6x8iRVOVjGe/17r7zRm8TPb9lKHT7aOi4hGmbn
        TFNPu4U598fw6FjRgUnfIG9BL/bvZwI+w3fQ+6l4pFEk/94cW0kGDSXFq9PdZORQaEpsg1venTxOl
        97bMicFbdvsxGTEXcnyJv0RL40L1tr+gsOoXMfiAh9zl0C9ohjzWIrExIuPSgGRZC+yUpC0MugT4c
        mEmjIUB6U06WzSB+cgVH1sjiiDtCU5a9IhDYsKYQxcjPDpTFx91xQSdhgVVzZm+o7Hfom7+rTUbxy
        n7uZGdBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPLlC-0005no-T7; Fri, 17 Apr 2020 07:50:02 +0000
Date:   Fri, 17 Apr 2020 00:50:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Kellermann <mk@cm4all.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, agruenba@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] fs/ext4/acl: apply umask if ACL support is
 disabled
Message-ID: <20200417075002.GB598@infradead.org>
References: <20200407142243.2032-1-mk@cm4all.com>
 <20200407142243.2032-2-mk@cm4all.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407142243.2032-2-mk@cm4all.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This looks correct (modulo some minor coding style derivations),
but I think the better fix is to reuse the poix_acl_create
functionality rather than duplicating it.  Something like this:

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 8c7bbf3e566d..6cff7cc31866 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -268,33 +268,17 @@ ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 /*
  * Initialize the ACLs of a new inode. Called from ext4_new_inode.
  *
- * dir->i_mutex: down
  * inode->i_mutex: up (access to inode is still exclusive)
  */
 int
-ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
+ext4_init_acl(handle_t *handle, struct inode *inode, int type,
+		struct posix_acl *acl)
 {
-	struct posix_acl *default_acl, *acl;
-	int error;
+	int error = 0;
 
-	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
-	if (error)
-		return error;
-
-	if (default_acl) {
-		error = __ext4_set_acl(handle, inode, ACL_TYPE_DEFAULT,
-				       default_acl, XATTR_CREATE);
-		posix_acl_release(default_acl);
-	} else {
-		inode->i_default_acl = NULL;
-	}
 	if (acl) {
-		if (!error)
-			error = __ext4_set_acl(handle, inode, ACL_TYPE_ACCESS,
-					       acl, XATTR_CREATE);
+		error = __ext4_set_acl(handle, inode, type, acl, XATTR_CREATE);
 		posix_acl_release(acl);
-	} else {
-		inode->i_acl = NULL;
 	}
 	return error;
 }
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 9b63f5416a2f..1e2927d14238 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -57,15 +57,16 @@ static inline int ext4_acl_count(size_t size)
 /* acl.c */
 struct posix_acl *ext4_get_acl(struct inode *inode, int type);
 int ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
+int ext4_init_acl(handle_t *handle, struct inode *inode, int type,
+		struct posix_acl *acl);
 
 #else  /* CONFIG_EXT4_FS_POSIX_ACL */
 #include <linux/sched.h>
 #define ext4_get_acl NULL
 #define ext4_set_acl NULL
 
-static inline int
-ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
+static inline int ext4_init_acl(handle_t *handle, struct inode *inode, int type,
+		struct posix_acl *acl)
 {
 	return 0;
 }
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b420c9dc444d..32b03f6277c1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1168,7 +1168,17 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	}
 
 	if (!(ei->i_flags & EXT4_EA_INODE_FL)) {
-		err = ext4_init_acl(handle, inode, dir);
+		struct posix_acl *default_acl, *acl;
+
+		cache_no_acl(inode);
+		err = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+		if (err)
+			goto fail_free_drop;
+		err = ext4_init_acl(handle, inode, ACL_TYPE_DEFAULT,
+				default_acl);
+		if (err)
+			goto fail_free_drop;
+		err = ext4_init_acl(handle, inode, ACL_TYPE_ACCESS, acl);
 		if (err)
 			goto fail_free_drop;
 
