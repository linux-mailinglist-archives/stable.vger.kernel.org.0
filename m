Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B218B30FCC5
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 20:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhBDT2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 14:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbhBDT1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 14:27:20 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A2FC061786;
        Thu,  4 Feb 2021 11:26:39 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v15so4916485wrx.4;
        Thu, 04 Feb 2021 11:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cx8Y4404roqqwEi7dq7r+CFsuSQ5L0MERlxrc4PpSAA=;
        b=sj8BdzQeB3oe91efyDV7V4O3vqfmDsmd5TbdcPUhUCYC5FaKe6IWXfniSgaWDxlL24
         PU8ppoCX8yR5ArJMbu6oUhg3trpSVnCJjikodrgKSPmeWinLpJweNd7Yy5t9FEJu+CQH
         SeWn+RJFmTxyR28PO0xbjGMqFZIGvA46p+W23OypluW4v7tnphMxdhDC84vkR8E+Nbd5
         1zI2ETnx9pRk4tSZnJaAxT9gzLlq1PB35R9JQSpjEL1uJej09Tv4kbggcXS/Jdd9dfUH
         Uw21U5zCUSYi3Wre2UuVZDsoL/y980F0tqURpZsni68wJvYPQgow1oE4PNRK7g3AGhDw
         MXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cx8Y4404roqqwEi7dq7r+CFsuSQ5L0MERlxrc4PpSAA=;
        b=RUoXWCmSCVdp174HPvNRtMjWtg5bDIJ2eKgR8c4VKa99DLqx4whqeewMxVevpw6DxG
         209EYYYSsLu4VGEWw6wc2uRZaRWBgId/i5ZDO9JA5EW+Klm0VZX2Jo98Ig35ket21kUC
         2KGKGAcG4wGDMh0ZOGLFL8XnX2Dvq8TKgx4RcUVGfARxWO8Bo4DO7yBxep0tRXJoW9pM
         Xyf79K/Dxsv6gASKyAkL/GxPKoVHuzHMMYQNVYHhuwdLZGY8IgdmPgW8n6SO2jWX3oxW
         Jf7NBU6CpErzWMFHrpT7OxQSJZBA8TCYekZTL1BkWLUUBPusRijFCXyneBh878TVupAI
         BfwA==
X-Gm-Message-State: AOAM530aQpEjGzRB4If3WjX8UKy8HX9UhT5Sq5tKVOGpuieKnoiDkwSm
        OsagKjBQUZ6cfAhR9tZG6kY=
X-Google-Smtp-Source: ABdhPJyj5Rfttx/XuqmhSV37Qj3ARSb8HEM23yKbZNxwvyhv9YeE7Ab8Z1vjkv769t9d2ajb/BxtoA==
X-Received: by 2002:adf:d085:: with SMTP id y5mr991575wrh.41.1612466798258;
        Thu, 04 Feb 2021 11:26:38 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id r15sm9547175wrj.61.2021.02.04.11.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 11:26:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] io_uring: drop mm/files between task_work_submit
Date:   Thu,  4 Feb 2021 19:22:46 +0000
Message-Id: <741fe19ee895393f54d01b8f7d25242e7fa27120.1612466514.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since SQPOLL task can be shared and so task_work entries can be a mix of
them, we need to drop mm and files before trying to issue next request.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5d3348d66f06..1f68105a41ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2205,6 +2205,9 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
+
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		io_sq_thread_drop_mm_files();
 }
 
 static void io_req_task_submit(struct callback_head *cb)
-- 
2.24.0

