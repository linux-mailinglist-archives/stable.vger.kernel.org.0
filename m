Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23015427AB5
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 15:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhJIN5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 09:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233822AbhJIN5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 09:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5149960F6F;
        Sat,  9 Oct 2021 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633787748;
        bh=kgADj4Fk7J9fZ/L9Z0oNHdRi3BTygHpmzzwI00Bs/rg=;
        h=Subject:To:Cc:From:Date:From;
        b=faf/bi3bAhzM1cftHHiRUo0BBQffKQdvBpCoFsoUIwyVnf8xRmzqxVIswBh1F/Ykm
         giNnIY3ABtBN6zuI4PmS6jSMr5VyjLARi/ctkchMQGvYmUsAceHTnOz7UgtnHfUO/v
         GTG1WttcSuC1k6K6VYoe2tddoexh8XbmOOKL3BTs=
Subject: FAILED: patch "[PATCH] ovl: fix IOCB_DIRECT if underlying fs doesn't support direct" failed to apply to 4.19-stable tree
To:     mszeredi@redhat.com, huangjianan@oppo.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Oct 2021 15:55:46 +0200
Message-ID: <163378774612018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1dc1eed46f9fa4cb8a07baa24fb44c96d6dd35c9 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 27 Sep 2021 11:23:57 +0200
Subject: [PATCH] ovl: fix IOCB_DIRECT if underlying fs doesn't support direct
 IO

Normally the check at open time suffices, but e.g loop device does set
IOCB_DIRECT after doing its own checks (which are not sufficent for
overlayfs).

Make sure we don't call the underlying filesystem read/write method with
the IOCB_DIRECT if it's not supported.

Reported-by: Huang Jianan <huangjianan@oppo.com>
Fixes: 16914e6fc7e1 ("ovl: add ovl_read_iter()")
Cc: <stable@vger.kernel.org> # v4.19
Tested-by: Huang Jianan <huangjianan@oppo.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index d081faa55e83..c88ac571593d 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -296,6 +296,12 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret)
 		return ret;
 
+	ret = -EINVAL;
+	if (iocb->ki_flags & IOCB_DIRECT &&
+	    (!real.file->f_mapping->a_ops ||
+	     !real.file->f_mapping->a_ops->direct_IO))
+		goto out_fdput;
+
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	if (is_sync_kiocb(iocb)) {
 		ret = vfs_iter_read(real.file, iter, &iocb->ki_pos,
@@ -320,7 +326,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 out:
 	revert_creds(old_cred);
 	ovl_file_accessed(file);
-
+out_fdput:
 	fdput(real);
 
 	return ret;
@@ -349,6 +355,12 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret)
 		goto out_unlock;
 
+	ret = -EINVAL;
+	if (iocb->ki_flags & IOCB_DIRECT &&
+	    (!real.file->f_mapping->a_ops ||
+	     !real.file->f_mapping->a_ops->direct_IO))
+		goto out_fdput;
+
 	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
 		ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
 
@@ -384,6 +396,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	}
 out:
 	revert_creds(old_cred);
+out_fdput:
 	fdput(real);
 
 out_unlock:

