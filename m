Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFDD1F2466
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbgFHXVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731072AbgFHXU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 097092072F;
        Mon,  8 Jun 2020 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658456;
        bh=v3qD0Q9NpcdZ50vMTXZCz7jww7PAid5BLVnFOjLaGbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDcDY1jMp3D8oINC2fFVkAxd/uA2BJ29IbfKDu6eKbsmQ7Gcn3XOeQ0qkil3HtJHO
         1LxPwdXkh2f6u+lZbTUFTaEd0PeSJ3ZoUIMNYFZPSeemc/1uV8uvv+6t9VoY7zW+mt
         7Oz6BDCWE7pWjdg77Ldcq6mUqVQrdlWFBFLkoKoY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 097/175] powerpc/spufs: fix copy_to_user while atomic
Date:   Mon,  8 Jun 2020 19:17:30 -0400
Message-Id: <20200608231848.3366970-97-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>

[ Upstream commit 88413a6bfbbe2f648df399b62f85c934460b7a4d ]

Currently, we may perform a copy_to_user (through
simple_read_from_buffer()) while holding a context's register_lock,
while accessing the context save area.

This change uses a temporary buffer for the context save area data,
which we then pass to simple_read_from_buffer.

Includes changes from Christoph Hellwig <hch@lst.de>.

Fixes: bf1ab978be23 ("[POWERPC] coredump: Add SPU elf notes to coredump.")
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
[hch: renamed to function to avoid ___-prefixes]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/file.c | 113 +++++++++++++++--------
 1 file changed, 75 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index c0f950a3f4e1..f4a4dfb191e7 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1978,8 +1978,9 @@ static ssize_t __spufs_mbox_info_read(struct spu_context *ctx,
 static ssize_t spufs_mbox_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
-	int ret;
 	struct spu_context *ctx = file->private_data;
+	u32 stat, data;
+	int ret;
 
 	if (!access_ok(buf, len))
 		return -EFAULT;
@@ -1988,11 +1989,16 @@ static ssize_t spufs_mbox_info_read(struct file *file, char __user *buf,
 	if (ret)
 		return ret;
 	spin_lock(&ctx->csa.register_lock);
-	ret = __spufs_mbox_info_read(ctx, buf, len, pos);
+	stat = ctx->csa.prob.mb_stat_R;
+	data = ctx->csa.prob.pu_mb_R;
 	spin_unlock(&ctx->csa.register_lock);
 	spu_release_saved(ctx);
 
-	return ret;
+	/* EOF if there's no entry in the mbox */
+	if (!(stat & 0x0000ff))
+		return 0;
+
+	return simple_read_from_buffer(buf, len, pos, &data, sizeof(data));
 }
 
 static const struct file_operations spufs_mbox_info_fops = {
@@ -2019,6 +2025,7 @@ static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct spu_context *ctx = file->private_data;
+	u32 stat, data;
 	int ret;
 
 	if (!access_ok(buf, len))
@@ -2028,11 +2035,16 @@ static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,
 	if (ret)
 		return ret;
 	spin_lock(&ctx->csa.register_lock);
-	ret = __spufs_ibox_info_read(ctx, buf, len, pos);
+	stat = ctx->csa.prob.mb_stat_R;
+	data = ctx->csa.priv2.puint_mb_R;
 	spin_unlock(&ctx->csa.register_lock);
 	spu_release_saved(ctx);
 
-	return ret;
+	/* EOF if there's no entry in the ibox */
+	if (!(stat & 0xff0000))
+		return 0;
+
+	return simple_read_from_buffer(buf, len, pos, &data, sizeof(data));
 }
 
 static const struct file_operations spufs_ibox_info_fops = {
@@ -2041,6 +2053,11 @@ static const struct file_operations spufs_ibox_info_fops = {
 	.llseek  = generic_file_llseek,
 };
 
+static size_t spufs_wbox_info_cnt(struct spu_context *ctx)
+{
+	return (4 - ((ctx->csa.prob.mb_stat_R & 0x00ff00) >> 8)) * sizeof(u32);
+}
+
 static ssize_t __spufs_wbox_info_read(struct spu_context *ctx,
 			char __user *buf, size_t len, loff_t *pos)
 {
@@ -2049,7 +2066,7 @@ static ssize_t __spufs_wbox_info_read(struct spu_context *ctx,
 	u32 wbox_stat;
 
 	wbox_stat = ctx->csa.prob.mb_stat_R;
-	cnt = 4 - ((wbox_stat & 0x00ff00) >> 8);
+	cnt = spufs_wbox_info_cnt(ctx);
 	for (i = 0; i < cnt; i++) {
 		data[i] = ctx->csa.spu_mailbox_data[i];
 	}
@@ -2062,7 +2079,8 @@ static ssize_t spufs_wbox_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct spu_context *ctx = file->private_data;
-	int ret;
+	u32 data[ARRAY_SIZE(ctx->csa.spu_mailbox_data)];
+	int ret, count;
 
 	if (!access_ok(buf, len))
 		return -EFAULT;
@@ -2071,11 +2089,13 @@ static ssize_t spufs_wbox_info_read(struct file *file, char __user *buf,
 	if (ret)
 		return ret;
 	spin_lock(&ctx->csa.register_lock);
-	ret = __spufs_wbox_info_read(ctx, buf, len, pos);
+	count = spufs_wbox_info_cnt(ctx);
+	memcpy(&data, &ctx->csa.spu_mailbox_data, sizeof(data));
 	spin_unlock(&ctx->csa.register_lock);
 	spu_release_saved(ctx);
 
-	return ret;
+	return simple_read_from_buffer(buf, len, pos, &data,
+				count * sizeof(u32));
 }
 
 static const struct file_operations spufs_wbox_info_fops = {
@@ -2084,27 +2104,33 @@ static const struct file_operations spufs_wbox_info_fops = {
 	.llseek  = generic_file_llseek,
 };
 
-static ssize_t __spufs_dma_info_read(struct spu_context *ctx,
-			char __user *buf, size_t len, loff_t *pos)
+static void spufs_get_dma_info(struct spu_context *ctx,
+		struct spu_dma_info *info)
 {
-	struct spu_dma_info info;
-	struct mfc_cq_sr *qp, *spuqp;
 	int i;
 
-	info.dma_info_type = ctx->csa.priv2.spu_tag_status_query_RW;
-	info.dma_info_mask = ctx->csa.lscsa->tag_mask.slot[0];
-	info.dma_info_status = ctx->csa.spu_chnldata_RW[24];
-	info.dma_info_stall_and_notify = ctx->csa.spu_chnldata_RW[25];
-	info.dma_info_atomic_command_status = ctx->csa.spu_chnldata_RW[27];
+	info->dma_info_type = ctx->csa.priv2.spu_tag_status_query_RW;
+	info->dma_info_mask = ctx->csa.lscsa->tag_mask.slot[0];
+	info->dma_info_status = ctx->csa.spu_chnldata_RW[24];
+	info->dma_info_stall_and_notify = ctx->csa.spu_chnldata_RW[25];
+	info->dma_info_atomic_command_status = ctx->csa.spu_chnldata_RW[27];
 	for (i = 0; i < 16; i++) {
-		qp = &info.dma_info_command_data[i];
-		spuqp = &ctx->csa.priv2.spuq[i];
+		struct mfc_cq_sr *qp = &info->dma_info_command_data[i];
+		struct mfc_cq_sr *spuqp = &ctx->csa.priv2.spuq[i];
 
 		qp->mfc_cq_data0_RW = spuqp->mfc_cq_data0_RW;
 		qp->mfc_cq_data1_RW = spuqp->mfc_cq_data1_RW;
 		qp->mfc_cq_data2_RW = spuqp->mfc_cq_data2_RW;
 		qp->mfc_cq_data3_RW = spuqp->mfc_cq_data3_RW;
 	}
+}
+
+static ssize_t __spufs_dma_info_read(struct spu_context *ctx,
+			char __user *buf, size_t len, loff_t *pos)
+{
+	struct spu_dma_info info;
+
+	spufs_get_dma_info(ctx, &info);
 
 	return simple_read_from_buffer(buf, len, pos, &info,
 				sizeof info);
@@ -2114,6 +2140,7 @@ static ssize_t spufs_dma_info_read(struct file *file, char __user *buf,
 			      size_t len, loff_t *pos)
 {
 	struct spu_context *ctx = file->private_data;
+	struct spu_dma_info info;
 	int ret;
 
 	if (!access_ok(buf, len))
@@ -2123,11 +2150,12 @@ static ssize_t spufs_dma_info_read(struct file *file, char __user *buf,
 	if (ret)
 		return ret;
 	spin_lock(&ctx->csa.register_lock);
-	ret = __spufs_dma_info_read(ctx, buf, len, pos);
+	spufs_get_dma_info(ctx, &info);
 	spin_unlock(&ctx->csa.register_lock);
 	spu_release_saved(ctx);
 
-	return ret;
+	return simple_read_from_buffer(buf, len, pos, &info,
+				sizeof(info));
 }
 
 static const struct file_operations spufs_dma_info_fops = {
@@ -2136,13 +2164,31 @@ static const struct file_operations spufs_dma_info_fops = {
 	.llseek = no_llseek,
 };
 
+static void spufs_get_proxydma_info(struct spu_context *ctx,
+		struct spu_proxydma_info *info)
+{
+	int i;
+
+	info->proxydma_info_type = ctx->csa.prob.dma_querytype_RW;
+	info->proxydma_info_mask = ctx->csa.prob.dma_querymask_RW;
+	info->proxydma_info_status = ctx->csa.prob.dma_tagstatus_R;
+
+	for (i = 0; i < 8; i++) {
+		struct mfc_cq_sr *qp = &info->proxydma_info_command_data[i];
+		struct mfc_cq_sr *puqp = &ctx->csa.priv2.puq[i];
+
+		qp->mfc_cq_data0_RW = puqp->mfc_cq_data0_RW;
+		qp->mfc_cq_data1_RW = puqp->mfc_cq_data1_RW;
+		qp->mfc_cq_data2_RW = puqp->mfc_cq_data2_RW;
+		qp->mfc_cq_data3_RW = puqp->mfc_cq_data3_RW;
+	}
+}
+
 static ssize_t __spufs_proxydma_info_read(struct spu_context *ctx,
 			char __user *buf, size_t len, loff_t *pos)
 {
 	struct spu_proxydma_info info;
-	struct mfc_cq_sr *qp, *puqp;
 	int ret = sizeof info;
-	int i;
 
 	if (len < ret)
 		return -EINVAL;
@@ -2150,18 +2196,7 @@ static ssize_t __spufs_proxydma_info_read(struct spu_context *ctx,
 	if (!access_ok(buf, len))
 		return -EFAULT;
 
-	info.proxydma_info_type = ctx->csa.prob.dma_querytype_RW;
-	info.proxydma_info_mask = ctx->csa.prob.dma_querymask_RW;
-	info.proxydma_info_status = ctx->csa.prob.dma_tagstatus_R;
-	for (i = 0; i < 8; i++) {
-		qp = &info.proxydma_info_command_data[i];
-		puqp = &ctx->csa.priv2.puq[i];
-
-		qp->mfc_cq_data0_RW = puqp->mfc_cq_data0_RW;
-		qp->mfc_cq_data1_RW = puqp->mfc_cq_data1_RW;
-		qp->mfc_cq_data2_RW = puqp->mfc_cq_data2_RW;
-		qp->mfc_cq_data3_RW = puqp->mfc_cq_data3_RW;
-	}
+	spufs_get_proxydma_info(ctx, &info);
 
 	return simple_read_from_buffer(buf, len, pos, &info,
 				sizeof info);
@@ -2171,17 +2206,19 @@ static ssize_t spufs_proxydma_info_read(struct file *file, char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct spu_context *ctx = file->private_data;
+	struct spu_proxydma_info info;
 	int ret;
 
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
 	spin_lock(&ctx->csa.register_lock);
-	ret = __spufs_proxydma_info_read(ctx, buf, len, pos);
+	spufs_get_proxydma_info(ctx, &info);
 	spin_unlock(&ctx->csa.register_lock);
 	spu_release_saved(ctx);
 
-	return ret;
+	return simple_read_from_buffer(buf, len, pos, &info,
+				sizeof(info));
 }
 
 static const struct file_operations spufs_proxydma_info_fops = {
-- 
2.25.1

