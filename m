Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F045C431BC0
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhJRNe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233171AbhJRNdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:33:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 251F66139D;
        Mon, 18 Oct 2021 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563774;
        bh=IXYRbfJWY0jx1X38fkKwwubhQ5ijdz/nnxdaewCGGgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqEG+7G2a5aJ6VJn67GjDwd/AlHrz8LIb3JFcL+bZHxatTZ3k8XSuW6I6jlQi3QG/
         bYgJzdd514csEu2qVhmkb49PQlIdXcYG7oF7GDxbShfWLv4Lsz3KoStGbsLxKQtwM9
         78ULZhIjNu8mVULzVe/AEXyMDlia9qqA2HRnCVjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 01/69] ovl: simplify file splice
Date:   Mon, 18 Oct 2021 15:23:59 +0200
Message-Id: <20211018132329.502323802@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 82a763e61e2b601309d696d4fa514c77d64ee1be upstream.

generic_file_splice_read() and iter_file_splice_write() will call back into
f_op->iter_read() and f_op->iter_write() respectively.  These already do
the real file lookup and cred override.  So the code in ovl_splice_read()
and ovl_splice_write() is redundant.

In addition the ovl_file_accessed() call in ovl_splice_write() is
incorrect, though probably harmless.

Fix by calling generic_file_splice_read() and iter_file_splice_write()
directly.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[reported to resolve issues with 1a980b8cbf00 ("ovl: add splice file read write helper")]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |   46 ++--------------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -296,48 +296,6 @@ out_unlock:
 	return ret;
 }
 
-static ssize_t ovl_splice_read(struct file *in, loff_t *ppos,
-			 struct pipe_inode_info *pipe, size_t len,
-			 unsigned int flags)
-{
-	ssize_t ret;
-	struct fd real;
-	const struct cred *old_cred;
-
-	ret = ovl_real_fdget(in, &real);
-	if (ret)
-		return ret;
-
-	old_cred = ovl_override_creds(file_inode(in)->i_sb);
-	ret = generic_file_splice_read(real.file, ppos, pipe, len, flags);
-	revert_creds(old_cred);
-
-	ovl_file_accessed(in);
-	fdput(real);
-	return ret;
-}
-
-static ssize_t
-ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
-			  loff_t *ppos, size_t len, unsigned int flags)
-{
-	struct fd real;
-	const struct cred *old_cred;
-	ssize_t ret;
-
-	ret = ovl_real_fdget(out, &real);
-	if (ret)
-		return ret;
-
-	old_cred = ovl_override_creds(file_inode(out)->i_sb);
-	ret = iter_file_splice_write(pipe, real.file, ppos, len, flags);
-	revert_creds(old_cred);
-
-	ovl_file_accessed(out);
-	fdput(real);
-	return ret;
-}
-
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct fd real;
@@ -694,8 +652,8 @@ const struct file_operations ovl_file_op
 	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
 	.compat_ioctl	= ovl_compat_ioctl,
-	.splice_read    = ovl_splice_read,
-	.splice_write   = ovl_splice_write,
+	.splice_read    = generic_file_splice_read,
+	.splice_write   = iter_file_splice_write,
 
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,


