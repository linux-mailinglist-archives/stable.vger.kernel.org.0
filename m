Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0527C68A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgI2LqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730705AbgI2LqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35B1206F7;
        Tue, 29 Sep 2020 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379967;
        bh=LBUb+Ez86vd1KkvfpNSX7cCSCYDxuAlWhO/fvNvmpaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GR9WxQcwabEfehYvGJAe/Lffx2x1pEvhDYjnMLz7thkSP6FJKy4OG3M3UISfMG0q2
         bkRf8zxI5JBkOOjQCsmaXwBaWGz+3+aznv8B7xKIhMV+QOeEBF/27Lk4KyGnkMqH5x
         sE4qW1chqSfQHULy2NnMcHAfj6lBiERpp/LX8XM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.4 379/388] dmabuf: fix NULL pointer dereference in dma_buf_release()
Date:   Tue, 29 Sep 2020 13:01:50 +0200
Message-Id: <20200929110028.811862437@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Reddy <charante@codeaurora.org>

commit 19a508bd1ad8e444de86873bf2f2b2ab8edd6552 upstream.

NULL pointer dereference is observed while exporting the dmabuf but
failed to allocate the 'struct file' which results into the dropping of
the allocated dentry corresponding to this file in the dmabuf fs, which
is ending up in dma_buf_release() and accessing the uninitialzed
dentry->d_fsdata.

Call stack on 5.4 is below:
 dma_buf_release+0x2c/0x254 drivers/dma-buf/dma-buf.c:88
 __dentry_kill+0x294/0x31c fs/dcache.c:584
 dentry_kill fs/dcache.c:673 [inline]
 dput+0x250/0x380 fs/dcache.c:859
 path_put+0x24/0x40 fs/namei.c:485
 alloc_file_pseudo+0x1a4/0x200 fs/file_table.c:235
 dma_buf_getfile drivers/dma-buf/dma-buf.c:473 [inline]
 dma_buf_export+0x25c/0x3ec drivers/dma-buf/dma-buf.c:585

Fix this by checking for the valid pointer in the dentry->d_fsdata.

Fixes: 4ab59c3c638c ("dma-buf: Move dma_buf_release() from fops to dentry_ops")
Cc: <stable@vger.kernel.org> [5.7+]
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/391319/
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma-buf/dma-buf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -59,6 +59,8 @@ static void dma_buf_release(struct dentr
 	struct dma_buf *dmabuf;
 
 	dmabuf = dentry->d_fsdata;
+	if (unlikely(!dmabuf))
+		return;
 
 	BUG_ON(dmabuf->vmapping_counter);
 


