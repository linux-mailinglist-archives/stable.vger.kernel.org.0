Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7633C9F40
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhGONSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:18:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11319 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 09:18:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GQZWd6lPsz7tfB;
        Thu, 15 Jul 2021 21:11:25 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 21:15:55 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 15 Jul
 2021 21:15:55 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <axboe@kernel.dk>
Subject: [PATCH stable-5.10] io_uring: fix clear IORING_SETUP_R_DISABLED in wrong function
Date:   Thu, 15 Jul 2021 21:18:25 +0800
Message-ID: <20210715131825.2410912-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 3ebba796fa25 ("io_uring: ensure that SQPOLL thread is started for exit"),
the IORING_SETUP_R_DISABLED is cleared in io_sq_offload_start(), but when backport
it to stable-5.10, IORING_SETUP_R_DISABLED is cleared in __io_req_task_submit(),
move clearing IORING_SETUP_R_DISABLED to io_sq_offload_start() to fix this.

Fixes: 6cae8095490ca ("io_uring: ensure that SQPOLL thread is started for exit")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fdbaaf579cc60..57db1dfc35829 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2086,7 +2086,6 @@ static void __io_req_task_submit(struct io_kiocb *req)
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_sq_thread_drop_mm();
 }
@@ -7998,6 +7997,7 @@ static void io_sq_offload_start(struct io_ring_ctx *ctx)
 {
 	struct io_sq_data *sqd = ctx->sq_data;
 
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && sqd->thread)
 		wake_up_process(sqd->thread);
 }
-- 
2.25.1

