Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FCD5A9B72
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 17:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbiIAPVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 11:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiIAPVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 11:21:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD1F61D46
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 08:21:11 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb36so14549036ejc.10
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 08:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=L6o8Ey8B27Gh7XZRtc+kRJt+AbIT5WEpm5Ied9Ui2Fc=;
        b=OFa/XVYkBWmQOAwGv9KtRgJjKwyw72iQ1Hf7VkXcQazdaHNvQxhDrGKtrr3WtF6XTh
         /uHesGsy9koZxD4Z6Gm9ntUTO3DAblt+5Tut3sloqmXwLudqZvZcRedqo99+cF+aoc1W
         jFgnNP+onpZ4lf/qwajmTQVl1h5z824UbFsUy8FoV7xHjFxZjA+vQyGmM7VdRvp05nPD
         Xj1v59XbaUFKpYsmKhC1A6gW8OnG60ZoPV0IICB+scnHSx7RGZz658vr1Lafs3SixWBX
         +KJvNNgd87wEhCZtbEDA2FSUljsevX6DoNTJR/+YWL3sfnXJYt+7htt6d54oZmuNLBcg
         fwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=L6o8Ey8B27Gh7XZRtc+kRJt+AbIT5WEpm5Ied9Ui2Fc=;
        b=bll+j8dxnWXtsabhAkEN3GefBi/JNjZu0kgDqulXbmk4y8WVkDIwDAUClLfINe9Bhm
         teqDk9pGgIHt56I4Zag9oQJt8xL3yWC9gdFrTdd74vovQ/g2RPTfOKgOeDTSSZY9ZWV5
         6DcaKKsmmsT7ZoNQTJ737GIUf6p7KgWBd7SWO8vogiofMhZWz0PFdtrgFZHaTEgqflro
         r8FNfzSRUMNU87+m0PC6V7Mt1E1euQ26+8LUfro7d+tjWMbwbcej2LRnfpR/p/BAtPSd
         nr6i6b7+DK6NSDNN9MxvhckdonuhHF6l4oHi4/bUI32TDbKlpCq7f74B0bV4TTB8HGDD
         KQ9g==
X-Gm-Message-State: ACgBeo3fu6pC2zutjHiZezQiKe6jmGW5vYOxaC6giy+ZuEX0NgvQUNq5
        JFjQH8TIgyoTOeHeHHlIeEM0dpe/Zj4=
X-Google-Smtp-Source: AA6agR6K0LGXP/lRKndDdPLB0fLpsb7Bb6Lvqg2TSaadfkilj0VH2sjSIL8SlPrEUdin735fTV4Nrg==
X-Received: by 2002:a17:907:2722:b0:731:2aeb:7942 with SMTP id d2-20020a170907272200b007312aeb7942mr24187236ejl.734.1662045670065;
        Thu, 01 Sep 2022 08:21:10 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:554f])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090623ea00b00730979f568fsm8579981ejg.150.2022.09.01.08.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 08:21:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.4 1/1] io_uring: disable polling pollfree files
Date:   Thu,  1 Sep 2022 16:19:15 +0100
Message-Id: <b1893c3cbff12ea2adb66addbaf2cb0499b0e011.1662044316.git.asml.silence@gmail.com>
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
 fs/io_uring.c            | 3 +++
 fs/signalfd.c            | 1 +
 include/linux/fs.h       | 1 +
 4 files changed, 6 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index b9fb2a926944..c273d0df6939 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6083,6 +6083,7 @@ const struct file_operations binder_fops = {
 	.open = binder_open,
 	.flush = binder_flush,
 	.release = binder_release,
+	.may_pollfree = true,
 };
 
 static int __init init_binder_device(const char *name)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e73969fa96bc..501c7e14c07c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1908,6 +1908,9 @@ static int io_poll_add(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	__poll_t mask;
 	u16 events;
 
+	if (req->file->f_op->may_pollfree)
+		return -EOPNOTSUPP;
+
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->addr || sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 3e94d181930f..c3415d969ecf 100644
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
index ef118b8ba699..4ecbe12f6215 100644
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

