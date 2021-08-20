Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6493F294F
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 11:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhHTJh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 05:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbhHTJhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 05:37:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818C5C061756;
        Fri, 20 Aug 2021 02:37:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so5690482wml.3;
        Fri, 20 Aug 2021 02:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QaBGvgs4NzaJ+Nos61cajJwx29cfL8s8R2pgsSsDtbk=;
        b=utf4IQX3b2WsqJc3HgjIBUk1e2nWYJW7dzVTcl2w/HDhKqbheuuqQGrQEu8rvLKOvy
         4kCEHCNcwMBghvFNb0g8DkAZrJ8afnUsL9ifRGXEGDnK7DQ6axYP0K52Iz6Zi/xK5Xgu
         Kx6ezyMwKEEnd5OPKA+wDa785IXb+wc6KXtnTStTcu+QKNFfVmpZ/4vUbVYL/JjBR42x
         REFly0k/qiDOMkHqOrvr7hXjAiFzemzbHe5Vj4fKyAjy0s15OUaME/h3wPdVHE1OY7Go
         snl6coRzLLqe27jRWhZcaNo8lRc0HlOLtMM3vV5YFitrZAzbBWFwxmqV5QnOClJn/4zb
         MAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QaBGvgs4NzaJ+Nos61cajJwx29cfL8s8R2pgsSsDtbk=;
        b=Rb3vsbcePG6yKOoM4FbmiU33BabPWuf6YOey8tQYBpW4Yes82JS4Lw5sKJbyW8DjQM
         pG3PFG7ncz2UVAHD5wUJ07mI2ojqJ1oTgabcG1dLQ03Q1Op39CEU3XRFVRQCAeGU5ref
         1nO9bnutkgNbaWKGpzf6dqXSMkC96CSXhBaYSh5KvHSV37+0e/oqatvwI0rK42sI0/d9
         DFrYG0mBEuGbMCtgXqcPpEAJrXdaeRQQNi1PIb4OvlZcA8InYoixDjrOIcszLqvUy29w
         1r3mDzd0dQU9YmXpBu61YynSxDp4nuvvogwmGDLwojxZOd92CbGXk+BEVhQSsO5ugI4J
         D7eA==
X-Gm-Message-State: AOAM530DnktlbitDIKip6F5eeT9y1Hj0PstdDxB7MEaPx5HyEEAQTL8t
        z/4Tdq0HGbCXLiOZKyakHr4=
X-Google-Smtp-Source: ABdhPJwTbCKzrYuxEaKBqDfqqfD2hFSEh9x12LK/9YyFjy9/yuR47LiiU9zKHjlTJGNFCGnrOZIt7Q==
X-Received: by 2002:a1c:1f17:: with SMTP id f23mr2998040wmf.136.1629452236166;
        Fri, 20 Aug 2021 02:37:16 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.190])
        by smtp.gmail.com with ESMTPSA id z7sm9693402wmi.4.2021.08.20.02.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 02:37:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/3] io_uring: limit fixed table size by RLIMIT_NOFILE
Date:   Fri, 20 Aug 2021 10:36:35 +0100
Message-Id: <b2756c340aed7d6c0b302c26dab50c6c5907f4ce.1629451684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629451684.git.asml.silence@gmail.com>
References: <cover.1629451684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Limit the number of files in io_uring fixed tables by RLIMIT_NOFILE,
that's the first and the simpliest restriction that we should impose.

Cc: stable@vger.kernel.org
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 30edc329d803..e6301d5d03a8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7730,6 +7730,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	if (nr_args > rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
-- 
2.32.0

