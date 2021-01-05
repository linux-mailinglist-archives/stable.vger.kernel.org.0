Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A1C2EAD72
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 15:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbhAEOhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 09:37:53 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:51380 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbhAEOhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 09:37:53 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609857450; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=4DiNJfGzzRCDF2FL02HtG0SOdr7LDb46DzlmbUJfV6s=; b=Lz26u2rd/E3hTD/PY5/ofCao2JEuH9TaLlXIeiOTmthYAnihG82KoXDHzXQUwmwuvjEeiwJU
 Dmuej2Rrl7ipGnnQ4w59sx4ZRzsx6EvVux9momSBCC1Aik07VHACcb13mgecIgfRi2ZUWHjp
 xe70rN882EhT03KfY3PRFFO0lyA=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5ff47988b73be0303d2da1d1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Jan 2021 14:36:56
 GMT
Sender: charante=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF37CC433C6; Tue,  5 Jan 2021 14:36:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from charante-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E3526C433CA;
        Tue,  5 Jan 2021 14:36:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E3526C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=charante@codeaurora.org
From:   Charan Teja Reddy <charante@codeaurora.org>
To:     sumit.semwal@linaro.org, christian.koenig@amd.com, arnd@arndb.de
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        "# 5 . 4+" <stable@vger.kernel.org>
Subject: [PATCH V2] dmabuf: fix use-after-free of dmabuf's file->f_inode
Date:   Tue,  5 Jan 2021 20:06:39 +0530
Message-Id: <1609857399-31549-1-git-send-email-charante@codeaurora.org>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is observed 'use-after-free' on the dmabuf's file->f_inode with the
race between closing the dmabuf file and reading the dmabuf's debug
info.

Consider the below scenario where P1 is closing the dma_buf file
and P2 is reading the dma_buf's debug info in the system:

P1						P2
					dma_buf_debug_show()
dma_buf_put()
  __fput()
    file->f_op->release()
    dput()
    ....
      dentry_unlink_inode()
        iput(dentry->d_inode)
        (where the inode is freed)
					mutex_lock(&db_list.lock)
					read 'dma_buf->file->f_inode'
					(the same inode is freed by P1)
					mutex_unlock(&db_list.lock)
      dentry->d_op->d_release()-->
        dma_buf_release()
          .....
          mutex_lock(&db_list.lock)
          removes the dmabuf from the list
          mutex_unlock(&db_list.lock)

In the above scenario, when dma_buf_put() is called on a dma_buf, it
first frees the dma_buf's file->f_inode(=dentry->d_inode) and then
removes this dma_buf from the system db_list. In between P2 traversing
the db_list tries to access this dma_buf's file->f_inode that was freed
by P1 which is a use-after-free case.

Since, __fput() calls f_op->release first and then later calls the
d_op->d_release, move the dma_buf's db_list removal from d_release() to
f_op->release(). This ensures that dma_buf's file->f_inode is not
accessed after it is released.

Cc: <stable@vger.kernel.org> # 5.4+
Fixes: 4ab59c3c638c ("dma-buf: Move dma_buf_release() from fops to dentry_ops")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
---
 V2: Resending with stable tags and Acks

 V1: https://lore.kernel.org/patchwork/patch/1360118/

 drivers/dma-buf/dma-buf.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 0eb80c1..a14dcbb 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -76,10 +76,6 @@ static void dma_buf_release(struct dentry *dentry)
 
 	dmabuf->ops->release(dmabuf);
 
-	mutex_lock(&db_list.lock);
-	list_del(&dmabuf->list_node);
-	mutex_unlock(&db_list.lock);
-
 	if (dmabuf->resv == (struct dma_resv *)&dmabuf[1])
 		dma_resv_fini(dmabuf->resv);
 
@@ -88,6 +84,22 @@ static void dma_buf_release(struct dentry *dentry)
 	kfree(dmabuf);
 }
 
+static int dma_buf_file_release(struct inode *inode, struct file *file)
+{
+	struct dma_buf *dmabuf;
+
+	if (!is_dma_buf_file(file))
+		return -EINVAL;
+
+	dmabuf = file->private_data;
+
+	mutex_lock(&db_list.lock);
+	list_del(&dmabuf->list_node);
+	mutex_unlock(&db_list.lock);
+
+	return 0;
+}
+
 static const struct dentry_operations dma_buf_dentry_ops = {
 	.d_dname = dmabuffs_dname,
 	.d_release = dma_buf_release,
@@ -413,6 +425,7 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
 }
 
 static const struct file_operations dma_buf_fops = {
+	.release	= dma_buf_file_release,
 	.mmap		= dma_buf_mmap_internal,
 	.llseek		= dma_buf_llseek,
 	.poll		= dma_buf_poll,
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

