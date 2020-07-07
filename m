Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976CD2171EC
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbgGGP0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730302AbgGGP0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21972078D;
        Tue,  7 Jul 2020 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135605;
        bh=tsP8O2XrM6avr/0AZZLaqustfwT7bO1HRrcl6qYXHwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjXTO3dBsG7ESoofPKwdivqlE+VelHY13tZ7oo8jJQjBieft0vOflkqk5vUkEtcx6
         s2dpbox14RrrzBwS9ucR+WPH03rBNFt6U1PDVrKxh1PzZlxjIUQpZiS2WF8Pa4HpO1
         asqIl7JNiFERq85h0y6cguSnYg0dxNZzDVQYz6+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        Charan Teja Reddy <charante@codeaurora.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 5.7 107/112] dma-buf: Move dma_buf_release() from fops to dentry_ops
Date:   Tue,  7 Jul 2020 17:17:52 +0200
Message-Id: <20200707145806.061508327@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Semwal <sumit.semwal@linaro.org>

commit 4ab59c3c638c6c8952bf07739805d20eb6358a4d upstream.

Charan Teja reported a 'use-after-free' in dmabuffs_dname [1], which
happens if the dma_buf_release() is called while the userspace is
accessing the dma_buf pseudo fs's dmabuffs_dname() in another process,
and dma_buf_release() releases the dmabuf object when the last reference
to the struct file goes away.

I discussed with Arnd Bergmann, and he suggested that rather than tying
the dma_buf_release() to the file_operations' release(), we can tie it to
the dentry_operations' d_release(), which will be called when the last ref
to the dentry is removed.

The path exercised by __fput() calls f_op->release() first, and then calls
dput, which eventually calls d_op->d_release().

In the 'normal' case, when no userspace access is happening via dma_buf
pseudo fs, there should be exactly one fd, file, dentry and inode, so
closing the fd will kill of everything right away.

In the presented case, the dentry's d_release() will be called only when
the dentry's last ref is released.

Therefore, lets move dma_buf_release() from fops->release() to
d_ops->d_release()

Many thanks to Arnd for his FS insights :)

[1]: https://lore.kernel.org/patchwork/patch/1238278/

Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> [5.3+]
Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: Charan Teja Reddy <charante@codeaurora.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Tested-by: Charan Teja Reddy <charante@codeaurora.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200611114418.19852-1-sumit.semwal@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma-buf/dma-buf.c |   54 +++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -54,37 +54,11 @@ static char *dmabuffs_dname(struct dentr
 			     dentry->d_name.name, ret > 0 ? name : "");
 }
 
-static const struct dentry_operations dma_buf_dentry_ops = {
-	.d_dname = dmabuffs_dname,
-};
-
-static struct vfsmount *dma_buf_mnt;
-
-static int dma_buf_fs_init_context(struct fs_context *fc)
-{
-	struct pseudo_fs_context *ctx;
-
-	ctx = init_pseudo(fc, DMA_BUF_MAGIC);
-	if (!ctx)
-		return -ENOMEM;
-	ctx->dops = &dma_buf_dentry_ops;
-	return 0;
-}
-
-static struct file_system_type dma_buf_fs_type = {
-	.name = "dmabuf",
-	.init_fs_context = dma_buf_fs_init_context,
-	.kill_sb = kill_anon_super,
-};
-
-static int dma_buf_release(struct inode *inode, struct file *file)
+static void dma_buf_release(struct dentry *dentry)
 {
 	struct dma_buf *dmabuf;
 
-	if (!is_dma_buf_file(file))
-		return -EINVAL;
-
-	dmabuf = file->private_data;
+	dmabuf = dentry->d_fsdata;
 
 	BUG_ON(dmabuf->vmapping_counter);
 
@@ -110,9 +84,32 @@ static int dma_buf_release(struct inode
 	module_put(dmabuf->owner);
 	kfree(dmabuf->name);
 	kfree(dmabuf);
+}
+
+static const struct dentry_operations dma_buf_dentry_ops = {
+	.d_dname = dmabuffs_dname,
+	.d_release = dma_buf_release,
+};
+
+static struct vfsmount *dma_buf_mnt;
+
+static int dma_buf_fs_init_context(struct fs_context *fc)
+{
+	struct pseudo_fs_context *ctx;
+
+	ctx = init_pseudo(fc, DMA_BUF_MAGIC);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->dops = &dma_buf_dentry_ops;
 	return 0;
 }
 
+static struct file_system_type dma_buf_fs_type = {
+	.name = "dmabuf",
+	.init_fs_context = dma_buf_fs_init_context,
+	.kill_sb = kill_anon_super,
+};
+
 static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
 {
 	struct dma_buf *dmabuf;
@@ -412,7 +409,6 @@ static void dma_buf_show_fdinfo(struct s
 }
 
 static const struct file_operations dma_buf_fops = {
-	.release	= dma_buf_release,
 	.mmap		= dma_buf_mmap_internal,
 	.llseek		= dma_buf_llseek,
 	.poll		= dma_buf_poll,


