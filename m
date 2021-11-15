Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA4450C58
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhKORhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238318AbhKORe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:34:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F28632C2;
        Mon, 15 Nov 2021 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996991;
        bh=0+ovwn5atvqZ7H3T3+v7ClAy51IECHTeJNNapkL+ufM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RevBz6fG7B4n8E0wSYovLfCfeSogRfch139OkCahX4lWg/jXxDRp+YaA0nWFk0IUJ
         DTaP41sDQPq7ey/7qCcfXUGAOOIglw55HzOrttZH1EKjxmV6spT87fVunGkBJAn+oa
         /kc5cDLWEEypifXCrd54UJxU7y95BBnxAMfdbg+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+579885d1a9a833336209@syzkaller.appspotmail.com
Subject: [PATCH 5.4 341/355] ovl: fix deadlock in splice write
Date:   Mon, 15 Nov 2021 18:04:25 +0100
Message-Id: <20211115165324.772046736@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 9b91b6b019fda817eb52f728eb9c79b3579760bc upstream.

There's possibility of an ABBA deadlock in case of a splice write to an
overlayfs file and a concurrent splice write to a corresponding real file.

The call chain for splice to an overlay file:

 -> do_splice                     [takes sb_writers on overlay file]
   -> do_splice_from
     -> iter_file_splice_write    [takes pipe->mutex]
       -> vfs_iter_write
         ...
         -> ovl_write_iter        [takes sb_writers on real file]

And the call chain for splice to a real file:

 -> do_splice                     [takes sb_writers on real file]
   -> do_splice_from
     -> iter_file_splice_write    [takes pipe->mutex]

Syzbot successfully bisected this to commit 82a763e61e2b ("ovl: simplify
file splice").

Fix by reverting the write part of the above commit and by adding missing
bits from ovl_write_iter() into ovl_splice_write().

Fixes: 82a763e61e2b ("ovl: simplify file splice")
Reported-and-tested-by: syzbot+579885d1a9a833336209@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -296,6 +296,51 @@ out_unlock:
 	return ret;
 }
 
+/*
+ * Calling iter_file_splice_write() directly from overlay's f_op may deadlock
+ * due to lock order inversion between pipe->mutex in iter_file_splice_write()
+ * and file_start_write(real.file) in ovl_write_iter().
+ *
+ * So do everything ovl_write_iter() does and call iter_file_splice_write() on
+ * the real file.
+ */
+static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
+				loff_t *ppos, size_t len, unsigned int flags)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	struct inode *inode = file_inode(out);
+	struct inode *realinode = ovl_inode_real(inode);
+	ssize_t ret;
+
+	inode_lock(inode);
+	/* Update mode */
+	ovl_copyattr(realinode, inode);
+	ret = file_remove_privs(out);
+	if (ret)
+		goto out_unlock;
+
+	ret = ovl_real_fdget(out, &real);
+	if (ret)
+		goto out_unlock;
+
+	old_cred = ovl_override_creds(inode->i_sb);
+	file_start_write(real.file);
+
+	ret = iter_file_splice_write(pipe, real.file, ppos, len, flags);
+
+	file_end_write(real.file);
+	/* Update size */
+	ovl_copyattr(realinode, inode);
+	revert_creds(old_cred);
+	fdput(real);
+
+out_unlock:
+	inode_unlock(inode);
+
+	return ret;
+}
+
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct fd real;
@@ -653,7 +698,7 @@ const struct file_operations ovl_file_op
 	.unlocked_ioctl	= ovl_ioctl,
 	.compat_ioctl	= ovl_compat_ioctl,
 	.splice_read    = generic_file_splice_read,
-	.splice_write   = iter_file_splice_write,
+	.splice_write   = ovl_splice_write,
 
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,


