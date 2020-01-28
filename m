Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6631914B930
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbgA1O2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387511AbgA1O2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BB8F2468F;
        Tue, 28 Jan 2020 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221710;
        bh=EmbOA6+hWdsPZ/sAO+/zMX5+diva24McWvwCbOtM7VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ancw+Z1fJp0sDCKmYTLl6N/QBq10PA0BWwBf8jn86aqjgdZYcQVqMtyUGgTr6CVJk
         W756KLJ/qS9/7B/J05h2VDAWLlvXnPmzfVDZTcKJR+sizEUlaY3nujbgpPH4QuWx38
         N3jiUpJg2A+dRRILZakQ7J9wfiPkKtcMCNgFFpgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 43/92] do_last(): fetch directory ->i_mode and ->i_uid before its too late
Date:   Tue, 28 Jan 2020 15:08:11 +0100
Message-Id: <20200128135814.584735840@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit d0cb50185ae942b03c4327be322055d622dc79f6 upstream.

may_create_in_sticky() call is done when we already have dropped the
reference to dir.

Fixes: 30aba6656f61e (namei: allow restricted O_CREAT of FIFOs and regular files)
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1009,7 +1009,8 @@ static int may_linkat(struct path *link)
  * may_create_in_sticky - Check whether an O_CREAT open in a sticky directory
  *			  should be allowed, or not, on files that already
  *			  exist.
- * @dir: the sticky parent directory
+ * @dir_mode: mode bits of directory
+ * @dir_uid: owner of directory
  * @inode: the inode of the file to open
  *
  * Block an O_CREAT open of a FIFO (or a regular file) when:
@@ -1025,18 +1026,18 @@ static int may_linkat(struct path *link)
  *
  * Returns 0 if the open is allowed, -ve on error.
  */
-static int may_create_in_sticky(struct dentry * const dir,
+static int may_create_in_sticky(umode_t dir_mode, kuid_t dir_uid,
 				struct inode * const inode)
 {
 	if ((!sysctl_protected_fifos && S_ISFIFO(inode->i_mode)) ||
 	    (!sysctl_protected_regular && S_ISREG(inode->i_mode)) ||
-	    likely(!(dir->d_inode->i_mode & S_ISVTX)) ||
-	    uid_eq(inode->i_uid, dir->d_inode->i_uid) ||
+	    likely(!(dir_mode & S_ISVTX)) ||
+	    uid_eq(inode->i_uid, dir_uid) ||
 	    uid_eq(current_fsuid(), inode->i_uid))
 		return 0;
 
-	if (likely(dir->d_inode->i_mode & 0002) ||
-	    (dir->d_inode->i_mode & 0020 &&
+	if (likely(dir_mode & 0002) ||
+	    (dir_mode & 0020 &&
 	     ((sysctl_protected_fifos >= 2 && S_ISFIFO(inode->i_mode)) ||
 	      (sysctl_protected_regular >= 2 && S_ISREG(inode->i_mode))))) {
 		return -EACCES;
@@ -3258,6 +3259,8 @@ static int do_last(struct nameidata *nd,
 		   struct file *file, const struct open_flags *op)
 {
 	struct dentry *dir = nd->path.dentry;
+	kuid_t dir_uid = dir->d_inode->i_uid;
+	umode_t dir_mode = dir->d_inode->i_mode;
 	int open_flag = op->open_flag;
 	bool will_truncate = (open_flag & O_TRUNC) != 0;
 	bool got_write = false;
@@ -3393,7 +3396,7 @@ finish_open:
 		error = -EISDIR;
 		if (d_is_dir(nd->path.dentry))
 			goto out;
-		error = may_create_in_sticky(dir,
+		error = may_create_in_sticky(dir_mode, dir_uid,
 					     d_backing_inode(nd->path.dentry));
 		if (unlikely(error))
 			goto out;


