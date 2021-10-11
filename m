Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE05428FED
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbhJKOCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238347AbhJKOAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052C96113D;
        Mon, 11 Oct 2021 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960621;
        bh=+SODZdYq4qXK0fgae7Ir6+mHd7bHX0nyqruOQbtHC5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFHY28nEDDiLtnMHC2sNjlNnJLRaYgfDNGWy2iBVa1EfpXpRfHl9ABGHgAiwZfKAQ
         XWkYLKlRwmamhabDVkB5E9KmgRiP1i0cEJRZOlwFo2kn7SfoydONYGf5KT30jkvjAS
         61p/ZtxhZgDbTKUE6GZ5pXTwCC9y31U8ZAMfJ5ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Jianan <huangjianan@oppo.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.14 026/151] ovl: fix IOCB_DIRECT if underlying fs doesnt support direct IO
Date:   Mon, 11 Oct 2021 15:44:58 +0200
Message-Id: <20211011134518.691677084@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 1dc1eed46f9fa4cb8a07baa24fb44c96d6dd35c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -296,6 +296,12 @@ static ssize_t ovl_read_iter(struct kioc
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
@@ -320,7 +326,7 @@ static ssize_t ovl_read_iter(struct kioc
 out:
 	revert_creds(old_cred);
 	ovl_file_accessed(file);
-
+out_fdput:
 	fdput(real);
 
 	return ret;
@@ -349,6 +355,12 @@ static ssize_t ovl_write_iter(struct kio
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
 
@@ -384,6 +396,7 @@ static ssize_t ovl_write_iter(struct kio
 	}
 out:
 	revert_creds(old_cred);
+out_fdput:
 	fdput(real);
 
 out_unlock:


