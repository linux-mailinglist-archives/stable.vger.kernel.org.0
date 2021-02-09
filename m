Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834993147BD
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBIExT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBIExK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9407CC0617A7
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:53 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y8so21894833ede.6
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kDKtB8NogjcBcGRYlYSVVRD7/e6y7AzsusjgFOXuYSA=;
        b=gdzTixrpOnMYNxShc6LecKHisla1pdkEbO30zGb7WVR+MwIxMcTIKHPOMebKKWggwV
         a+lBlZ7+qPobXbtUqNwCySRCpEeuzs1pT/pPs5qMLQwuE8jkg6IYyvhBQiyn7aYlu3ST
         fZDOII2xnmIFoZDBCS7ZFmSMveE1vGhHzu8sVGosTscbXWq0XKBaji0wTXJC4+C+ZEa7
         8CsFR+yZFNtkIFlAoehyMBMAZ/EAvA6JlJZrsKhTWTwdaVUE8UV3TP2HVqDLvX1nwcus
         ExHcvvdSlbeUBb9K5BiT/8VVph5+x6VDIcwh3zhFlX2qy+PZDO8GVKYjrNRiil7bn7Lv
         dPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kDKtB8NogjcBcGRYlYSVVRD7/e6y7AzsusjgFOXuYSA=;
        b=if0RlfB94r2Xk4MFnU4ljHgRi+X/x49OE+0SSUcb8Y8N0MYY5xtMbzMMKotGdYxSW+
         lljc7c3a57TnykxllAEL5Z3Rj8hU41506BZkuJzwLDNx54RNp/yPwlvjFiuK/BaQXGeW
         WKNDhgxYB641WMzZsF4G9shlurkSf0qlxkQqaOb+QW2JWwGzWJVLsOpXzytYfTrN/f7H
         N87z/rmFCvnDgX1wjyVcqXvBr1EYOTue1jALHYZrn/l4p10O5hhiG+JOwiCsbq/HrIn7
         je9PfSYzdFM6VvaFyjcvk7Rndtzzq8iF07DuhJsUIb6lp9DIqx7FCvwQkwZsTqVZUN2N
         Fw4Q==
X-Gm-Message-State: AOAM533B+EXJah4W5d4hhBOyc5aNdJwsZYS1HfSAHD9cyke503EymKG5
        wT5ZE9BuxWsUyIfkrjM/Lke5zT76ImY=
X-Google-Smtp-Source: ABdhPJxciNGOMl4MS5O88vNZmEJGDMwMmdOHmPHmY8FgnggIBzlCUdcWN+7vcRWleMSYh5fZAvbmkw==
X-Received: by 2002:a05:6402:35ca:: with SMTP id z10mr20758695edc.186.1612846312170;
        Mon, 08 Feb 2021 20:51:52 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Josef Grieb <josef.grieb@gmail.com>
Subject: [PATCH 08/16] io_uring: if we see flush on exit, cancel related tasks
Date:   Tue,  9 Feb 2021 04:47:42 +0000
Message-Id: <662f09ececb5e1d6c3b098fa53d5b0b666300814.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 84965ff8a84f0368b154c9b367b62e59c1193f30 ]

Ensure we match tasks that belong to a dead or dying task as well, as we
need to reap those in addition to those belonging to the exiting task.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: Josef Grieb <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9801fa9b00ba..95faa3d913b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1014,8 +1014,12 @@ static bool io_match_task(struct io_kiocb *head,
 {
 	struct io_kiocb *link;
 
-	if (task && head->task != task)
+	if (task && head->task != task) {
+		/* in terms of cancelation, always match if req task is dead */
+		if (head->task->flags & PF_EXITING)
+			return true;
 		return false;
+	}
 	if (!files)
 		return true;
 	if (__io_match_files(head, files))
@@ -8850,6 +8854,9 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx = file->private_data;
 
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_uring_cancel_task_requests(ctx, NULL);
+
 	if (!tctx)
 		return 0;
 
-- 
2.24.0

