Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC475A9B62
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 17:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiIAPSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 11:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiIAPSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 11:18:07 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8FC86061
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 08:18:06 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id se27so27664251ejb.8
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 08:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=TOaHOLQnFqvnzUiS319uxuR7CQHPBsaxAZncnYNsBTw=;
        b=ZsVc7Q2x8FBqksmrclwo4l2ygsyxeOJ52FCvDAbuRIg2rkdSShcoYHfTXQKo5NBXhJ
         mGvPJK1kQh6cBu5U8Sy1qco/7QxHBNNeq/jliFclbWiomb5hzQhbuTkyq9WPy8NOOkQ8
         mzsegLx/jdKCIIWaWvZ65O6pqAvdz9Wb9ps42MQhFZY9AW+WAzNruHpUAEWltKPjASuT
         gvLKoWIYdNK6tFG7izCbDW6ZFh45APanzQLjUsWyUq2xqvkc9IgcmWbGGL7yLxK2QxUH
         2k6x3TD6TfvxVRLeYXot4MBA3xk2c0VF4HiR+XpCuFeOelJzy8qfkWTa4Ek8D7ZYdrnn
         gJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=TOaHOLQnFqvnzUiS319uxuR7CQHPBsaxAZncnYNsBTw=;
        b=BWMmLSBO1oMkMPJfUiDm3hPdx+aBSANfD1gFSOCD3Q7xvLtgYggK2ZxBHJGYw7l2X9
         4YfObhYu7n37a9NBFE5sypziGUCA1NLBgiLodcd8DSnS27iFaRZtZxVQRoi5rmH2ChTH
         Ex7OdrjGWp/HZMijqv1YifhpjjwK1jSXF4Ns+OI96WE0R3BimB1BP5/ndHu2cqDC+3E9
         IOHm8zfUMB+7vY6UMy9To14tMGeUIvdQpf1MRyJM2NKGVbyaEVKIteoVkiwUhQJl8LNy
         PFD04jcC1pWK5QxAGmKVu2aPNpZ3e2hqgVCpdgyS6nnllF8Wrov5UjJpbbLqmyKQ2E/b
         N1/A==
X-Gm-Message-State: ACgBeo0FIV4qAfnsp8WO86EgxNFLyhXVOj0iQ0b+UBmS4oO4RgfSVG5e
        N6mR/pyHYPnRmekRfvBEK1FU6QEGS7o=
X-Google-Smtp-Source: AA6agR5UKVtym3XZbF3wQDXQSbLBZA/tyVJe21He49maMfPDGxf2oNZ1LeNKAGhyogo+zFUZPCBfSw==
X-Received: by 2002:a17:906:11d:b0:712:abf:3210 with SMTP id 29-20020a170906011d00b007120abf3210mr23834093eje.292.1662045484301;
        Thu, 01 Sep 2022 08:18:04 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:554f])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906218100b007081282cbd8sm8559183eju.76.2022.09.01.08.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 08:18:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.10 1/1] io_uring: disable polling pollfree files
Date:   Thu,  1 Sep 2022 16:16:10 +0100
Message-Id: <4f4668f469baa8f1387e746fd2533ec662500f3a.1662042761.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Older kernels lack io_uring POLLFREE handling. As only affected files
are signalfd and android binder the safest option would be to disable
polling those files via io_uring and hope there are no users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/android/binder.c | 1 +
 fs/io_uring.c            | 5 +++++
 fs/signalfd.c            | 1 +
 include/linux/fs.h       | 1 +
 4 files changed, 8 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 366b12405708..a5d5247c4f3e 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6069,6 +6069,7 @@ const struct file_operations binder_fops = {
 	.open = binder_open,
 	.flush = binder_flush,
 	.release = binder_release,
+	.may_pollfree = true,
 };
 
 static int __init init_binder_device(const char *name)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index a952288b2ab8..9654b60a06a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5198,6 +5198,11 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	struct io_ring_ctx *ctx = req->ctx;
 	bool cancel = false;
 
+	if (req->file->f_op->may_pollfree) {
+		spin_lock_irq(&ctx->completion_lock);
+		return -EOPNOTSUPP;
+	}
+
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, wake_func);
 	poll->file = req->file;
diff --git a/fs/signalfd.c b/fs/signalfd.c
index b94fb5f81797..41dc597b78cc 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -248,6 +248,7 @@ static const struct file_operations signalfd_fops = {
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
 	.llseek		= noop_llseek,
+	.may_pollfree	= true,
 };
 
 static int do_signalfd4(int ufd, sigset_t *mask, int flags)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 42d246a94228..c8f887641878 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1859,6 +1859,7 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	bool may_pollfree;
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.37.2

