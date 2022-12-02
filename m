Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC92640866
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiLBO3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiLBO3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:29:46 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46841DC853
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:29:45 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 125-20020a1c0283000000b003d076ee89d6so3917152wmc.0
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 06:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1d3vcUVTtTRifTw8WN42eCkwvKapNbg8Evl6J3weW6k=;
        b=VfbFSIXFFGJSXAHt7o3GSQEB1XvptD4UYqPEwDwyj9fatTuo2qDCFXD95OWdTcgbig
         2s6BJ2rrX7ir19iwZFQpAy56MH5PAaE6+KCFEFeoBXoifrS3m+M22zHYc8iYah99Nxs8
         0brDzM5kupqGfZSFSdAOQzwu4qQK9xl0jiGwpIKrYV1MAg/KPfTx7ddmYXVj70zWKz3M
         OIV/FI0876SY3XxzrS504sWsibeN15/AW+1PQIzmNcOVfK010iu8G04R8/4tsPtVLCwc
         P2uOIQcQhZeZ9XGZv0E0onPPG84gT/rMpuYVXCqxF1rYP5tdZOGFN3QBlq37owRcuXGZ
         fibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1d3vcUVTtTRifTw8WN42eCkwvKapNbg8Evl6J3weW6k=;
        b=oYP7JbGGMLg1jWt1yG3+6ZN43s9qyMhDPOneXi5lUiMfPr4Id4Os897ulqZ0wX2s/6
         s7cbgofpCYcYd2X6gcb9LjKAUvknHZImhnW6Htl9OgXgPyUG7otnGCLKLkEXMbZOqTzD
         QHpu3kNRhNP//mzWER7qTK2D9sq8TyOCV+U2+0VMtAY86L8Gq7uSM8DY/hWy1PIG7pGm
         Tf1gu//fKqwq4eZx2kqEAlSlOAx3Y7f9kEnOCsqrJM9tYF8bPkTUtwbsWBd53b59Xnuz
         Aj3DMHEOmuycUZremhbqMUt9CQ8i5IoFzsh1hoIS/68sGaZmuZlcOn9vZF1GC0FhXuUM
         Qveg==
X-Gm-Message-State: ANoB5plfmHcQ77qta1mRp3/wh0Z6w1Tm1ZLz+CtNfd3mLB6Oy3Kf/W/w
        GwgucSa3l7gQMDQK1kTMN/Yn2X1/u3c=
X-Google-Smtp-Source: AA0mqf6z7rKkWe88JHp4Y2BZ4kFov/BciQy8gVINL6TQ8rwfgCFuGMzz4vm32RJjUZzq5m1qcA1tJA==
X-Received: by 2002:a05:600c:354d:b0:3cf:45ff:aca with SMTP id i13-20020a05600c354d00b003cf45ff0acamr43186561wmq.53.1669991383684;
        Fri, 02 Dec 2022 06:29:43 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:2dd3])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm8956946wme.40.2022.12.02.06.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 06:29:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 1/5] io_uring: update res mask in io_poll_check_events
Date:   Fri,  2 Dec 2022 14:27:11 +0000
Message-Id: <df5d7849a63502012196a9a5f78f7d46626b846d.1669990799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669990799.git.asml.silence@gmail.com>
References: <cover.1669990799.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit b98186aee22fa593bc8c6b2c5d839c2ee518bc8c ]

When io_poll_check_events() collides with someone attempting to queue a
task work, it'll spin for one more time. However, it'll continue to use
the mask from the first iteration instead of updating it. For example,
if the first wake up was a EPOLLIN and the second EPOLLOUT, the
userspace will not get EPOLLOUT in time.

Clear the mask for all subsequent iterations to force vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2dac97e8f691231049cb259c4ae57e79e40b537c.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b8ae64df90e3..2ba42e6e0881 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5464,6 +5464,9 @@ static int io_poll_check_events(struct io_kiocb *req)
 			return 0;
 		}
 
+		/* force the next iteration to vfs_poll() */
+		req->result = 0;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
-- 
2.38.1

