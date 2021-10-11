Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45568428F0C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhJKNyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237448AbhJKNxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9F7B610A4;
        Mon, 11 Oct 2021 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960253;
        bh=m/qMDIJaDz1w4Ulab1ddDDXme6YfMG047BWTyBMwqyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsDoFoW2MFnwGJYP/uLG0POB9pRinCN9heebZH2GhIzbMFYeG8LYue8I2ObsZVN6L
         796uMGO8IXDgZmJ/YicIyr+CAgQJsWObguKznwjzZVrTK0zrDKNRLz3qO/HiG3GFzs
         doQePJrqfkANpnHW6CdS13DZvGBe/3DdbLkO4mmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Jianan <huangjianan@oppo.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 12/83] ovl: fix IOCB_DIRECT if underlying fs doesnt support direct IO
Date:   Mon, 11 Oct 2021 15:45:32 +0200
Message-Id: <20211011134508.779317047@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
@@ -301,6 +301,12 @@ static ssize_t ovl_read_iter(struct kioc
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
@@ -325,7 +331,7 @@ static ssize_t ovl_read_iter(struct kioc
 out:
 	revert_creds(old_cred);
 	ovl_file_accessed(file);
-
+out_fdput:
 	fdput(real);
 
 	return ret;
@@ -354,6 +360,12 @@ static ssize_t ovl_write_iter(struct kio
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
 
@@ -389,6 +401,7 @@ static ssize_t ovl_write_iter(struct kio
 	}
 out:
 	revert_creds(old_cred);
+out_fdput:
 	fdput(real);
 
 out_unlock:


