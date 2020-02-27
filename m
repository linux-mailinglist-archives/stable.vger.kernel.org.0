Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FE7171544
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 11:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgB0KnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 05:43:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54078 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728873AbgB0KnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 05:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582800196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IrJcrhhYfiQc6y8fLPUb1oRUTJ6Fmb0iUUMWLAOf368=;
        b=TK1ucRWLSNFs+lI7ePwAHVu+01DgmsszXJ4rAA+5769L6BeJEqpZrV90XF5rrPSrZZSrqC
        uSipvkitAyXiKmyXUOar1KO2/9zVa7Sabbu+p5zK0L9x1mjdd8jEez4mcuXj2+Po1s4A7m
        062cUXR5OcYlVf/E0oFs5gFAQv7iWaE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-dgqUcBcOOJy_t-PG6hKEGg-1; Thu, 27 Feb 2020 05:43:15 -0500
X-MC-Unique: dgqUcBcOOJy_t-PG6hKEGg-1
Received: by mail-wr1-f70.google.com with SMTP id m13so1143012wrw.3
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 02:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IrJcrhhYfiQc6y8fLPUb1oRUTJ6Fmb0iUUMWLAOf368=;
        b=XmzldJOmPutjEL7dWwFn3URXbtrbS+PF90j9lUHR27ub4DYsn42iTBs76dfwmA6e3N
         jSl9BNazvgQIi7QBXsm1yp8+X9L2UNI9Bdh5GswGu3yAPVc6sgCBlCEJGjy1LjZHAVTq
         UU3/52wzK8okUouXrB9qVs7WPSjLJgk+0YYqILGB2rW6+fKXgY7ojtkO8SNspBazkys4
         25Ucft8/lJiz8O3OwHTxL3vGRE04VQqLK3eIc9w70YbE6rz5YVb9L6nrzu8owrI2zRUi
         ueIJbFeLA0KDskg0W1vjXO+G+a7Mb7MS1LQe+n7+GhWxgL36mIfbn41kflfyPA+nAISR
         U2sA==
X-Gm-Message-State: APjAAAW07oDHBMud2n0AEd2JfY0/nRCIkbmZj4dfXFUnZRY/KkBVFr8o
        zhihgQAj1r1CXLM12nHfe6+0y0Euo6ottlI5HVxAPOScIbSer1Remjz1fhhK5FZLN2+SZcCDRuz
        DVJpOAg/U6su5+oe/
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr4345566wru.55.1582800193464;
        Thu, 27 Feb 2020 02:43:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/Fgr41aGA87g7TTMig1Q0RU/cjHCqHP5TMJnPt3+vt+sWz2gzoHa0qjaXIj1I4SNYz2NVAA==
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr4345536wru.55.1582800193207;
        Thu, 27 Feb 2020 02:43:13 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id m19sm7171101wmc.34.2020.02.27.02.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 02:43:12 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, io-uring@vger.kernel.org,
        axboe@kernel.dk
Subject: [PATCH 5.4] io_uring: prevent sq_thread from spinning when it should stop
Date:   Thu, 27 Feb 2020 11:43:11 +0100
Message-Id: <20200227104311.76533-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7143b5ac5750f404ff3a594b34fdf3fc2f99f828 ]

This patch drops 'cur_mm' before calling cond_resched(), to prevent
the sq_thread from spinning even when the user process is finished.

Before this patch, if the user process ended without closing the
io_uring fd, the sq_thread continues to spin until the
'sq_thread_idle' timeout ends.

In the worst case where the 'sq_thread_idle' parameter is bigger than
INT_MAX, the sq_thread will spin forever.

Fixes: 6c271ce2f1d5 ("io_uring: add submission polling")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 709671faaed6..33a95e1ffb15 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2740,16 +2740,6 @@ static int io_sq_thread(void *data)
 
 		to_submit = io_sqring_entries(ctx);
 		if (!to_submit) {
-			/*
-			 * We're polling. If we're within the defined idle
-			 * period, then let us spin without work before going
-			 * to sleep.
-			 */
-			if (inflight || !time_after(jiffies, timeout)) {
-				cond_resched();
-				continue;
-			}
-
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -2762,6 +2752,16 @@ static int io_sq_thread(void *data)
 				cur_mm = NULL;
 			}
 
+			/*
+			 * We're polling. If we're within the defined idle
+			 * period, then let us spin without work before going
+			 * to sleep.
+			 */
+			if (inflight || !time_after(jiffies, timeout)) {
+				cond_resched();
+				continue;
+			}
+
 			prepare_to_wait(&ctx->sqo_wait, &wait,
 						TASK_INTERRUPTIBLE);
 
-- 
2.24.1

