Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981F41F66F3
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgFKLoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgFKLob (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 07:44:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791F8C08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 04:44:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e9so2427292pgo.9
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 04:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NeR4sKutcrUPwtCckv6Tmqw2IkRMLX24dUiE+CNNtLg=;
        b=AzLoTv6lnntU3TjLLEgR6fmbijpMmaW1TiVxBsvjGtDygCtFgSsOhUr/x580awC9CJ
         OWtjuYN91NakIQ0xzJBT44oS7XlppiYpQRPzAIXpeYUcqXzSpm9t2pxKcFM8ltkRm4Qy
         TviFdnkCDQhhB6Ksg6B+/zb6ZBTNWHgNi1TUJ7AYJQgRbi7MVRHjTB1c0e53WO2aIhus
         E28nJ9MuYhrO7fmnxZzxlp4KUMsOHAZ7mv4R33BjeWS8OFVUVsDdgxd+0QROsIrmHkxg
         8lSPIeygynVgxIQizbR19HoEhoM9eN3KtFFM1P8Din25DLW9W/lBzQHWmvhhVFPkIyX6
         7qjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NeR4sKutcrUPwtCckv6Tmqw2IkRMLX24dUiE+CNNtLg=;
        b=jHBUOysqtujB15QIVkGznqVsGptl2iy8x8E+gxDIR65H44VeAef92VxMb8RvbzUqph
         R17GtaGHSTwhuZ52ioUs49ruu3yYjzK8d0gpSe2UVeUlDHb3rwjzX9FbHCrEb0qcjKro
         bb/IyclmD0Cv1OwgLphz7wYLYa0q473dYgPNl1LOGoLmOUnWsQH2vRR/1WDy6psLKqhb
         zc69kTYORKg5p6a1siiVMSJsnsMM6rvx0o0MuIIqPk/t1IJPC1AlpxhYWWgnRaJlNfm7
         wLrUVas4h2+u5TgEqKZ8w/Cq2lI46NpQpqIHIbEnTzuFrbwz1kYDmhTrbNxWX1/8HUl+
         OMnQ==
X-Gm-Message-State: AOAM5330Qno2i3LpZS7gqM7OtR3U4Fpax3U9lRz+WkknW7n4AKI6sVoj
        kld6ixWZpqux1fog6d971Krq+Q==
X-Google-Smtp-Source: ABdhPJxIOHN+w6MtKWfgrA7bxJRjB7VlTmwl68jAu2JbO5beoiWKr7sP/K2kitarxzXNPDtpNL9xKg==
X-Received: by 2002:a63:4754:: with SMTP id w20mr452063pgk.255.1591875870670;
        Thu, 11 Jun 2020 04:44:30 -0700 (PDT)
Received: from nagraj.local ([49.206.21.239])
        by smtp.gmail.com with ESMTPSA id z144sm3088543pfc.195.2020.06.11.04.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:44:29 -0700 (PDT)
From:   Sumit Semwal <sumit.semwal@linaro.org>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Chenbo Feng <fengc@google.com>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] dma-buf: Move dma_buf_release() from fops to dentry_ops
Date:   Thu, 11 Jun 2020 17:14:18 +0530
Message-Id: <20200611114418.19852-1-sumit.semwal@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---
v2: per Arnd: Moved dma_buf_release() above to avoid forward declaration;
     removed dentry_ops check.
---
 drivers/dma-buf/dma-buf.c | 54 ++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 01ce125f8e8d..412629601ad3 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -54,37 +54,11 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
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
 
@@ -110,9 +84,32 @@ static int dma_buf_release(struct inode *inode, struct file *file)
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
@@ -412,7 +409,6 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
 }
 
 static const struct file_operations dma_buf_fops = {
-	.release	= dma_buf_release,
 	.mmap		= dma_buf_mmap_internal,
 	.llseek		= dma_buf_llseek,
 	.poll		= dma_buf_poll,
-- 
2.27.0

