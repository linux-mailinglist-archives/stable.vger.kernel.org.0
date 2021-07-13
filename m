Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127613C6D75
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbhGMJcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:32:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10476 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhGMJcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:32:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GPFdH1w88zccym;
        Tue, 13 Jul 2021 17:26:43 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:51 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:50 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Hanjun Guo <guohanjun@huawei.com>
Subject: [Backport for 5.10.y PATCH 3/7] io_uring: simplify io_remove_personalities()
Date:   Tue, 13 Jul 2021 17:18:33 +0800
Message-ID: <1626167917-11972-4-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
References: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yejune Deng <yejune.deng@gmail.com>

commit 0bead8cd39b9c9c7c4e902018ccf129107ac50ef upstream.

The function io_remove_personalities() is very similar to
io_unregister_personality(),so implement io_remove_personalities()
calling io_unregister_personality().

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 fs/io_uring.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0138aa7..0cbf2a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8505,9 +8505,8 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &ctx->cq_fasync);
 }
 
-static int io_remove_personalities(int id, void *p, void *data)
+static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
-	struct io_ring_ctx *ctx = data;
 	struct io_identity *iod;
 
 	iod = idr_remove(&ctx->personality_idr, id);
@@ -8515,7 +8514,17 @@ static int io_remove_personalities(int id, void *p, void *data)
 		put_cred(iod->creds);
 		if (refcount_dec_and_test(&iod->count))
 			kfree(iod);
+		return 0;
 	}
+
+	return -EINVAL;
+}
+
+static int io_remove_personalities(int id, void *p, void *data)
+{
+	struct io_ring_ctx *ctx = data;
+
+	io_unregister_personality(ctx, id);
 	return 0;
 }
 
@@ -9606,21 +9615,6 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
-{
-	struct io_identity *iod;
-
-	iod = idr_remove(&ctx->personality_idr, id);
-	if (iod) {
-		put_cred(iod->creds);
-		if (refcount_dec_and_test(&iod->count))
-			kfree(iod);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 				    unsigned int nr_args)
 {
-- 
1.7.12.4

