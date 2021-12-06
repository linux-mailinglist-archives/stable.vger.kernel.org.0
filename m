Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A67F469D4B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356975AbhLFP26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377755AbhLFPYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2528DC08EB4B;
        Mon,  6 Dec 2021 07:15:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B44C161344;
        Mon,  6 Dec 2021 15:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956EAC341C1;
        Mon,  6 Dec 2021 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803742;
        bh=rXJNURb3QWGZip9tiCaqriBcr192K2y7MMAOeZy0vU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MABpgYG9YUA1MrWJpv7BWQRAtqH0bjf3+SMdMOlsDzIUJRjwpM3FoLIJ6PtrGfXg
         D0prjOnifcops1ld0e2O83hGLHPH2Av08WGw4k/pDcOQtGfV3K1cxSfPB8HwTPbglQ
         qJbMt0ELPIJ/cGY2+tLWVgaoLs4JQiZRuoLE7ycg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Stan Hu <stanhu@gmail.com>
Subject: [PATCH 5.10 003/130] ovl: simplify file splice
Date:   Mon,  6 Dec 2021 15:55:20 +0100
Message-Id: <20211206145559.731406260@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
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
Cc: Stan Hu <stanhu@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |   46 ++--------------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -422,48 +422,6 @@ out_unlock:
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
@@ -772,8 +730,8 @@ const struct file_operations ovl_file_op
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ovl_compat_ioctl,
 #endif
-	.splice_read    = ovl_splice_read,
-	.splice_write   = ovl_splice_write,
+	.splice_read    = generic_file_splice_read,
+	.splice_write   = iter_file_splice_write,
 
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,


