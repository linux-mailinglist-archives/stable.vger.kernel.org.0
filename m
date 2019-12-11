Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E34511B83C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfLKPIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbfLKPIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:08:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E255224680;
        Wed, 11 Dec 2019 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076879;
        bh=DM87xZb71YxE/mN+bBErGuthvuytuq1S3I8vLgnKNjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNYTI7JH6RX3VT4qFQIIsPJ/21VqNUNxGhdtya0ovvNPS6afdcXoWnFD2YAGFY1qb
         628zbfEphHns1RbKsjZ74XAuBEWu0s6zzYRCpgHZdqbdJcmDmPq8SevO2SI26h1cgo
         2iN2ruBYTmkYdfNY9bKLM+o45ycQcaJrbpss25eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arijit Banerjee <arijit@rubrik.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 25/92] fuse: verify attributes
Date:   Wed, 11 Dec 2019 16:05:16 +0100
Message-Id: <20191211150230.493866269@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit eb59bd17d2fa6e5e84fba61a5ebdea984222e6d5 upstream.

If a filesystem returns negative inode sizes, future reads on the file were
causing the cpu to spin on truncate_pagecache.

Create a helper to validate the attributes.  This now does two things:

 - check the file mode
 - check if the file size fits in i_size without overflowing

Reported-by: Arijit Banerjee <arijit@rubrik.com>
Fixes: d8a5ba45457e ("[PATCH] FUSE - core")
Cc: <stable@vger.kernel.org> # v2.6.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c     |   22 ++++++++++++++++------
 fs/fuse/fuse_i.h  |    2 ++
 fs/fuse/readdir.c |    2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -248,7 +248,8 @@ static int fuse_dentry_revalidate(struct
 		kfree(forget);
 		if (ret == -ENOMEM)
 			goto out;
-		if (ret || (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
+		if (ret || fuse_invalid_attr(&outarg.attr) ||
+		    (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
 			goto invalid;
 
 		forget_all_cached_acls(inode);
@@ -319,6 +320,12 @@ int fuse_valid_type(int m)
 		S_ISBLK(m) || S_ISFIFO(m) || S_ISSOCK(m);
 }
 
+bool fuse_invalid_attr(struct fuse_attr *attr)
+{
+	return !fuse_valid_type(attr->mode) ||
+		attr->size > LLONG_MAX;
+}
+
 int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode)
 {
@@ -350,7 +357,7 @@ int fuse_lookup_name(struct super_block
 	err = -EIO;
 	if (!outarg->nodeid)
 		goto out_put_forget;
-	if (!fuse_valid_type(outarg->attr.mode))
+	if (fuse_invalid_attr(&outarg->attr))
 		goto out_put_forget;
 
 	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
@@ -475,7 +482,8 @@ static int fuse_create_open(struct inode
 		goto out_free_ff;
 
 	err = -EIO;
-	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid))
+	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid) ||
+	    fuse_invalid_attr(&outentry.attr))
 		goto out_free_ff;
 
 	ff->fh = outopen.fh;
@@ -583,7 +591,7 @@ static int create_new_entry(struct fuse_
 		goto out_put_forget_req;
 
 	err = -EIO;
-	if (invalid_nodeid(outarg.nodeid))
+	if (invalid_nodeid(outarg.nodeid) || fuse_invalid_attr(&outarg.attr))
 		goto out_put_forget_req;
 
 	if ((outarg.attr.mode ^ mode) & S_IFMT)
@@ -943,7 +951,8 @@ static int fuse_do_getattr(struct inode
 	args.out_args[0].value = &outarg;
 	err = fuse_simple_request(fc, &args);
 	if (!err) {
-		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		if (fuse_invalid_attr(&outarg.attr) ||
+		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 			make_bad_inode(inode);
 			err = -EIO;
 		} else {
@@ -1564,7 +1573,8 @@ int fuse_do_setattr(struct dentry *dentr
 		goto error;
 	}
 
-	if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+	if (fuse_invalid_attr(&outarg.attr) ||
+	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 		make_bad_inode(inode);
 		err = -EIO;
 		goto error;
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -989,6 +989,8 @@ void fuse_ctl_remove_conn(struct fuse_co
  */
 int fuse_valid_type(int m);
 
+bool fuse_invalid_attr(struct fuse_attr *attr);
+
 /**
  * Is current process allowed to perform filesystem operation?
  */
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -184,7 +184,7 @@ static int fuse_direntplus_link(struct f
 
 	if (invalid_nodeid(o->nodeid))
 		return -EIO;
-	if (!fuse_valid_type(o->attr.mode))
+	if (fuse_invalid_attr(&o->attr))
 		return -EIO;
 
 	fc = get_fuse_conn(dir);


