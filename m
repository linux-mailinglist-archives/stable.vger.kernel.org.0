Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C84676F5C
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjAVPUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjAVPUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E726222DB
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13362B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A40C433D2;
        Sun, 22 Jan 2023 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400833;
        bh=MIsdpiXvayYb998WGQaW1Vl6GMCoCEBjOauRJRIIJpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dLdswvpulc+qbfkuIEECXZCBi0EY5nKLHCMQ4uoNrNZijMJFy/DnGP5v5wigH3Hq
         JDqkOLY9KqMWPdqQZaarphKRdoerqOvgC8LuNf7B/iWj1nbt1sjpfTsy5Rgmwep3O2
         dxT1u356NcdbBN1BDLzU6MXz8scklT33qkJEDR/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        "T.J. Mercier" <tjmercier@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/193] dma-buf: fix dma_buf_export init order v2
Date:   Sun, 22 Jan 2023 16:02:10 +0100
Message-Id: <20230122150246.388831681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit f728a5ea27c92133893590e731ce10f6561ced87 ]

The init order and resulting error handling in dma_buf_export
was pretty messy.

Subordinate objects like the file and the sysfs kernel objects
were initializing and wiring itself up with the object in the
wrong order resulting not only in complicating and partially
incorrect error handling, but also in publishing only halve
initialized DMA-buf objects.

Clean this up thoughtfully by allocating the file independent
of the DMA-buf object. Then allocate and initialize the DMA-buf
object itself, before publishing it through sysfs. If everything
works as expected the file is then connected with the DMA-buf
object and publish it through debugfs.

Also adds the missing dma_resv_fini() into the error handling.

v2: add some missing changes to dma_bug_getfile() and a missing NULL
    check in dma_buf_file_release()

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221209071535.933698-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf-sysfs-stats.c |  7 +--
 drivers/dma-buf/dma-buf-sysfs-stats.h |  4 +-
 drivers/dma-buf/dma-buf.c             | 84 +++++++++++++--------------
 3 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-sysfs-stats.c b/drivers/dma-buf/dma-buf-sysfs-stats.c
index 2bba0babcb62..4b680e10c15a 100644
--- a/drivers/dma-buf/dma-buf-sysfs-stats.c
+++ b/drivers/dma-buf/dma-buf-sysfs-stats.c
@@ -168,14 +168,11 @@ void dma_buf_uninit_sysfs_statistics(void)
 	kset_unregister(dma_buf_stats_kset);
 }
 
-int dma_buf_stats_setup(struct dma_buf *dmabuf)
+int dma_buf_stats_setup(struct dma_buf *dmabuf, struct file *file)
 {
 	struct dma_buf_sysfs_entry *sysfs_entry;
 	int ret;
 
-	if (!dmabuf || !dmabuf->file)
-		return -EINVAL;
-
 	if (!dmabuf->exp_name) {
 		pr_err("exporter name must not be empty if stats needed\n");
 		return -EINVAL;
@@ -192,7 +189,7 @@ int dma_buf_stats_setup(struct dma_buf *dmabuf)
 
 	/* create the directory for buffer stats */
 	ret = kobject_init_and_add(&sysfs_entry->kobj, &dma_buf_ktype, NULL,
-				   "%lu", file_inode(dmabuf->file)->i_ino);
+				   "%lu", file_inode(file)->i_ino);
 	if (ret)
 		goto err_sysfs_dmabuf;
 
diff --git a/drivers/dma-buf/dma-buf-sysfs-stats.h b/drivers/dma-buf/dma-buf-sysfs-stats.h
index a49c6e2650cc..7a8a995b75ba 100644
--- a/drivers/dma-buf/dma-buf-sysfs-stats.h
+++ b/drivers/dma-buf/dma-buf-sysfs-stats.h
@@ -13,7 +13,7 @@
 int dma_buf_init_sysfs_statistics(void);
 void dma_buf_uninit_sysfs_statistics(void);
 
-int dma_buf_stats_setup(struct dma_buf *dmabuf);
+int dma_buf_stats_setup(struct dma_buf *dmabuf, struct file *file);
 
 void dma_buf_stats_teardown(struct dma_buf *dmabuf);
 #else
@@ -25,7 +25,7 @@ static inline int dma_buf_init_sysfs_statistics(void)
 
 static inline void dma_buf_uninit_sysfs_statistics(void) {}
 
-static inline int dma_buf_stats_setup(struct dma_buf *dmabuf)
+static inline int dma_buf_stats_setup(struct dma_buf *dmabuf, struct file *file)
 {
 	return 0;
 }
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index e6f36c014c4c..eb6b59363c4f 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -95,10 +95,11 @@ static int dma_buf_file_release(struct inode *inode, struct file *file)
 		return -EINVAL;
 
 	dmabuf = file->private_data;
-
-	mutex_lock(&db_list.lock);
-	list_del(&dmabuf->list_node);
-	mutex_unlock(&db_list.lock);
+	if (dmabuf) {
+		mutex_lock(&db_list.lock);
+		list_del(&dmabuf->list_node);
+		mutex_unlock(&db_list.lock);
+	}
 
 	return 0;
 }
@@ -523,17 +524,17 @@ static inline int is_dma_buf_file(struct file *file)
 	return file->f_op == &dma_buf_fops;
 }
 
-static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
+static struct file *dma_buf_getfile(size_t size, int flags)
 {
 	static atomic64_t dmabuf_inode = ATOMIC64_INIT(0);
-	struct file *file;
 	struct inode *inode = alloc_anon_inode(dma_buf_mnt->mnt_sb);
+	struct file *file;
 
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-	inode->i_size = dmabuf->size;
-	inode_set_bytes(inode, dmabuf->size);
+	inode->i_size = size;
+	inode_set_bytes(inode, size);
 
 	/*
 	 * The ->i_ino acquired from get_next_ino() is not unique thus
@@ -547,8 +548,6 @@ static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
 				 flags, &dma_buf_fops);
 	if (IS_ERR(file))
 		goto err_alloc_file;
-	file->private_data = dmabuf;
-	file->f_path.dentry->d_fsdata = dmabuf;
 
 	return file;
 
@@ -614,19 +613,11 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	size_t alloc_size = sizeof(struct dma_buf);
 	int ret;
 
-	if (!exp_info->resv)
-		alloc_size += sizeof(struct dma_resv);
-	else
-		/* prevent &dma_buf[1] == dma_buf->resv */
-		alloc_size += 1;
-
-	if (WARN_ON(!exp_info->priv
-			  || !exp_info->ops
-			  || !exp_info->ops->map_dma_buf
-			  || !exp_info->ops->unmap_dma_buf
-			  || !exp_info->ops->release)) {
+	if (WARN_ON(!exp_info->priv || !exp_info->ops
+		    || !exp_info->ops->map_dma_buf
+		    || !exp_info->ops->unmap_dma_buf
+		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
-	}
 
 	if (WARN_ON(exp_info->ops->cache_sgt_mapping &&
 		    (exp_info->ops->pin || exp_info->ops->unpin)))
@@ -638,10 +629,21 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	if (!try_module_get(exp_info->owner))
 		return ERR_PTR(-ENOENT);
 
+	file = dma_buf_getfile(exp_info->size, exp_info->flags);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto err_module;
+	}
+
+	if (!exp_info->resv)
+		alloc_size += sizeof(struct dma_resv);
+	else
+		/* prevent &dma_buf[1] == dma_buf->resv */
+		alloc_size += 1;
 	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
 	if (!dmabuf) {
 		ret = -ENOMEM;
-		goto err_module;
+		goto err_file;
 	}
 
 	dmabuf->priv = exp_info->priv;
@@ -653,44 +655,36 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
 	dmabuf->cb_in.active = dmabuf->cb_out.active = 0;
+	mutex_init(&dmabuf->lock);
+	INIT_LIST_HEAD(&dmabuf->attachments);
 
 	if (!resv) {
-		resv = (struct dma_resv *)&dmabuf[1];
-		dma_resv_init(resv);
+		dmabuf->resv = (struct dma_resv *)&dmabuf[1];
+		dma_resv_init(dmabuf->resv);
+	} else {
+		dmabuf->resv = resv;
 	}
-	dmabuf->resv = resv;
 
-	file = dma_buf_getfile(dmabuf, exp_info->flags);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
+	ret = dma_buf_stats_setup(dmabuf, file);
+	if (ret)
 		goto err_dmabuf;
-	}
 
+	file->private_data = dmabuf;
+	file->f_path.dentry->d_fsdata = dmabuf;
 	dmabuf->file = file;
 
-	mutex_init(&dmabuf->lock);
-	INIT_LIST_HEAD(&dmabuf->attachments);
-
 	mutex_lock(&db_list.lock);
 	list_add(&dmabuf->list_node, &db_list.head);
 	mutex_unlock(&db_list.lock);
 
-	ret = dma_buf_stats_setup(dmabuf);
-	if (ret)
-		goto err_sysfs;
-
 	return dmabuf;
 
-err_sysfs:
-	/*
-	 * Set file->f_path.dentry->d_fsdata to NULL so that when
-	 * dma_buf_release() gets invoked by dentry_ops, it exits
-	 * early before calling the release() dma_buf op.
-	 */
-	file->f_path.dentry->d_fsdata = NULL;
-	fput(file);
 err_dmabuf:
+	if (!resv)
+		dma_resv_fini(dmabuf->resv);
 	kfree(dmabuf);
+err_file:
+	fput(file);
 err_module:
 	module_put(exp_info->owner);
 	return ERR_PTR(ret);
-- 
2.35.1



