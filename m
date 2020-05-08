Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB581CA459
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 08:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEHGl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 02:41:29 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:51978 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbgEHGl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 02:41:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588920087; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=JGbArbE31FgJMYaWjsdsGR2edFKZOM0SJ0pUFigb4cY=; b=r54rmYQWkIssOczo7+4d6ttJOnxJ2q08j6rww7fQQAwesT8I8JUtlDT1bVK2hzFyVUgKqYdt
 Pdj9WxjdpP9fdw3NeuWFQH69UCXWTUO9+sLALI75KeKU7jwQiiIcJjhEIcYDxZ5oFLHwPoa2
 9H+88MezbeggbVJVkxLADEg1Y24=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb4ff0b.7fbb7575f688-smtp-out-n04;
 Fri, 08 May 2020 06:41:15 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BEBCCC4478C; Fri,  8 May 2020 06:41:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from charante-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2B60C433BA;
        Fri,  8 May 2020 06:41:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A2B60C433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=charante@codeaurora.org
From:   Charan Teja Reddy <charante@codeaurora.org>
To:     sumit.semwal@linaro.org, ghackmann@google.com, fengc@google.com
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] dma-buf: fix use-after-free in dmabuffs_dname
Date:   Fri,  8 May 2020 12:11:03 +0530
Message-Id: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following race occurs while accessing the dmabuf object exported as
file:
P1				P2
dma_buf_release()          dmabuffs_dname()
			   [say lsof reading /proc/<P1 pid>/fd/<num>]

			   read dmabuf stored in dentry->d_fsdata
Free the dmabuf object
			   Start accessing the dmabuf structure

In the above description, the dmabuf object freed in P1 is being
accessed from P2 which is resulting into the use-after-free. Below is
the dump stack reported.

We are reading the dmabuf object stored in the dentry->d_fsdata but
there is no binding between the dentry and the dmabuf which means that
the dmabuf can be freed while it is being read from ->d_fsdata and
inuse. Reviews on the patch V1 says that protecting the dmabuf inuse
with an extra refcount is not a viable solution as the exported dmabuf
is already under file's refcount and keeping the multiple refcounts on
the same object coordinated is not possible.

As we are reading the dmabuf in ->d_fsdata just to get the user passed
name, we can directly store the name in d_fsdata thus can avoid the
reading of dmabuf altogether.

Call Trace:
 kasan_report+0x12/0x20
 __asan_report_load8_noabort+0x14/0x20
 dmabuffs_dname+0x4f4/0x560
 tomoyo_realpath_from_path+0x165/0x660
 tomoyo_get_realpath
 tomoyo_check_open_permission+0x2a3/0x3e0
 tomoyo_file_open
 tomoyo_file_open+0xa9/0xd0
 security_file_open+0x71/0x300
 do_dentry_open+0x37a/0x1380
 vfs_open+0xa0/0xd0
 path_openat+0x12ee/0x3490
 do_filp_open+0x192/0x260
 do_sys_openat2+0x5eb/0x7e0
 do_sys_open+0xf2/0x180

Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> [5.3+]
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
---

Changes in v2: 

- Pass the user passed name in ->d_fsdata instead of dmabuf
- Improve the commit message

Changes in v1: (https://patchwork.kernel.org/patch/11514063/)

 drivers/dma-buf/dma-buf.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 01ce125..0071f7d 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/mount.h>
 #include <linux/pseudo_fs.h>
+#include <linux/dcache.h>
 
 #include <uapi/linux/dma-buf.h>
 #include <uapi/linux/magic.h>
@@ -40,15 +41,13 @@ struct dma_buf_list {
 
 static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
-	struct dma_buf *dmabuf;
 	char name[DMA_BUF_NAME_LEN];
 	size_t ret = 0;
 
-	dmabuf = dentry->d_fsdata;
-	dma_resv_lock(dmabuf->resv, NULL);
-	if (dmabuf->name)
-		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
-	dma_resv_unlock(dmabuf->resv);
+	spin_lock(&dentry->d_lock);
+	if (dentry->d_fsdata)
+		ret = strlcpy(name, dentry->d_fsdata, DMA_BUF_NAME_LEN);
+	spin_unlock(&dentry->d_lock);
 
 	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
 			     dentry->d_name.name, ret > 0 ? name : "");
@@ -80,12 +79,16 @@ static int dma_buf_fs_init_context(struct fs_context *fc)
 static int dma_buf_release(struct inode *inode, struct file *file)
 {
 	struct dma_buf *dmabuf;
+	struct dentry *dentry = file->f_path.dentry;
 
 	if (!is_dma_buf_file(file))
 		return -EINVAL;
 
 	dmabuf = file->private_data;
 
+	spin_lock(&dentry->d_lock);
+	dentry->d_fsdata = NULL;
+	spin_unlock(&dentry->d_lock);
 	BUG_ON(dmabuf->vmapping_counter);
 
 	/*
@@ -343,6 +346,7 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
 	}
 	kfree(dmabuf->name);
 	dmabuf->name = name;
+	dmabuf->file->f_path.dentry->d_fsdata = name;
 
 out_unlock:
 	dma_resv_unlock(dmabuf->resv);
@@ -446,7 +450,6 @@ static struct file *dma_buf_getfile(struct dma_buf *dmabuf, int flags)
 		goto err_alloc_file;
 	file->f_flags = flags & (O_ACCMODE | O_NONBLOCK);
 	file->private_data = dmabuf;
-	file->f_path.dentry->d_fsdata = dmabuf;
 
 	return file;
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
