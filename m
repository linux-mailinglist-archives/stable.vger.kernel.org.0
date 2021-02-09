Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D75F3147B4
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhBIExU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBIExL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:11 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B48C0617A9
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:55 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p20so29274800ejb.6
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XnTh1kq6yYReSLQmjbQgzSeBr0n/F6+SFtHddS6S2EA=;
        b=MB3r7wgLjONzAdTgW/85qr1LUwgnGMnfv2W8y3S8kNebKmVKJkiZvqL7MhTkWswsxd
         rQHaGMrsgpHrQAoe12yQcP3XdjxOXib8IK8ExxHHdfCW1xazNp1A90lvIU9TkRUsqpfa
         oVFrGPqmOSQT0PfFuDvbMds5fSAW5HhKJTzvlDE1iEBWlHZ0OUedNrdC/PLDTrrEs3eI
         fT0nx1AybOySW2kwoU0ugSvtLulRh/9ihtX9d93XGDRgIzFpfep8qq4KikaVIHd+8cnd
         KF8+6MDjwl9hu/7o5mg+Wl7HT/0a+WLHcMPQ7DWR++r0ipCWSvxoDeQsmNkjQq2ccrRv
         8Zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XnTh1kq6yYReSLQmjbQgzSeBr0n/F6+SFtHddS6S2EA=;
        b=V8ckqXCM5zmtIU5sQZPdX5aSDrAmca1S2HayTAEMouszXUN/krPZ3R40Jtbe2H+n0T
         GfA9Y2RcQG6nVjtn7m5QJtGdUkZuhCveoqKmRcOYXDmalN66Hc2mAEFLL7Z1yP4Mk3+2
         gCRM9IBN9qSMGpCcrdDkDR/VQuFdCQaJDZRl/fIcklP5pivNt6EMU2pOrw333jzBKQRR
         rEOxOCG5sgCpeWYE1EetMV+uwTCs9+9fh0Ww3LLqJlGg7H0xzo8jio8EmXhfQopvQ9UX
         XstR01/8RagbduQAu873yILXJyzPsQ7V6S7gPBd+IR25TMXfD+Bh8o6i4fyCJ7aLYxGC
         nE7g==
X-Gm-Message-State: AOAM5315Ixzkh2SlZrhkDhTKEhGfW/tJVh5ivm88W0T+BtwqSSqzMsRF
        glTONGNVPqclg6kJDBxqY4OOUPFVGVQ=
X-Google-Smtp-Source: ABdhPJxdoALmWeTpHLp+y5LPEQt+VAy8BDx/KV5Kfjq5Dv3GHPwZqo7P1B7fWVIj+eQlD3UcJEgGhA==
X-Received: by 2002:a17:906:3fc1:: with SMTP id k1mr21176395ejj.58.1612846313073;
        Mon, 08 Feb 2021 20:51:53 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/16] io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
Date:   Tue,  9 Feb 2021 04:47:43 +0000
Message-Id: <39d4dfb46962c4d3956f768bdf7395601d9fbae2.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a1bb3cd58913338e1b627ea6b8c03c2ae82d293f ]

If the tctx inflight number haven't changed because of cancellation,
__io_uring_task_cancel() will continue leaving the task in
TASK_UNINTERRUPTIBLE state, that's not expected by
__io_uring_files_cancel(). Ensure we always call finish_wait() before
retrying.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95faa3d913b1..170f980c3243 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8835,15 +8835,15 @@ void __io_uring_task_cancel(void)
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		/*
-		 * If we've seen completions, retry. This avoids a race where
-		 * a completion comes in before we did prepare_to_wait().
+		 * If we've seen completions, retry without waiting. This
+		 * avoids a race where a completion comes in before we did
+		 * prepare_to_wait().
 		 */
-		if (inflight != tctx_inflight(tctx))
-			continue;
-		schedule();
+		if (inflight == tctx_inflight(tctx))
+			schedule();
+		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
-	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_remove_task_files(tctx);
-- 
2.24.0

