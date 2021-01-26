Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20543042AA
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 16:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392807AbhAZPdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 10:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392639AbhAZPc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 10:32:56 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E586C061D73;
        Tue, 26 Jan 2021 07:32:16 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id l9so23534809ejx.3;
        Tue, 26 Jan 2021 07:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Is5C/JkEOMY2af+h1RkUYnRL6LYJAYBl862N1tSb84M=;
        b=tNPSGnPH4C6SHvQo5Nc3tK/qNBDJY6v+8w7qYoDLPueUCXDoeM7lSOKQHj3X/lolqE
         h2YPONgOm59NhE0CC4hmUVdkpkX8G6/lxfEvXQ2TVaZr/lOlmniJ7fx6bLHR7qH/bqx1
         IJuSFVtCPi6nHwKv/RIUjXO0QDrXKmSkwHa9rDtPh7gvs1BgWywn8qaAX6PQGx+mWtGU
         FdobCPjy1plFxMHxZx+BIeL/ggiM1yHyoY1TtXUaLebzccvPTAhU3+1qQMUiVZdQV4kG
         fK3QgVfdJLMYLG3Jf/hcLgGqbK2HLXJ9k00zIwg8Tj/dqcV27z/x99hJQiTKaqanhcQw
         AvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Is5C/JkEOMY2af+h1RkUYnRL6LYJAYBl862N1tSb84M=;
        b=CorXdoejgysRiArIJtPEGUQDFL26xoaDaFuStJJJznfuRIuo2AvXpT7y/11/hnvnh/
         Hd4zZ7ttlm1WkFngASIzGomwBhHMf6vzQih7swVU4KWNFZgkcq80MnbiDw7/taruploL
         ngx2ZKy6Z6+F1PATRL98HlDqQAbXHyHI2LE1YsxwAhB+0YbOZ9OCPORhPdtFj+l9OWDU
         KCdibWmfQZWYXPtgV77h445SexE34Z3Wv0M0goqzoVntMUSlwCZVnAAG+RujkoVC0dkz
         PS+al7fgKCW+tIcULTQDgJ/dgJpOec3hudnrLnQc4Flcnb9wIyRCiZJiDkiXYDkzDX3z
         XgTA==
X-Gm-Message-State: AOAM533TqHPPGAIArXXUQM3cMU7TdhpblEE7w9ZuQh0ki+Xc4pumpgMC
        YinMw+Kgbiin333dTozS9DxA/hW5jgQ=
X-Google-Smtp-Source: ABdhPJy5f/nMtIAvKqULp2T9yTF1q8tNqjn4YOiI0MngWAElX58Zbxst/2IIEzAguB3ezOzfsBUKGA==
X-Received: by 2002:a17:906:4f0d:: with SMTP id t13mr3986375eju.10.1611675135057;
        Tue, 26 Jan 2021 07:32:15 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id k22sm12888978edv.33.2021.01.26.07.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 07:32:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
Date:   Tue, 26 Jan 2021 15:28:26 +0000
Message-Id: <565eaac3a631e81bce7094ad6fd5c7a884f53086.1611674535.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611674535.git.asml.silence@gmail.com>
References: <cover.1611674535.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the tctx inflight number haven't changed because of cancellation,
__io_uring_task_cancel() will continue leaving the task in
TASK_UNINTERRUPTIBLE state, that's not expected by
__io_uring_files_cancel(). Ensure we always call finish_wait() before
retrying.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2166c469789d..09aada153a71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9124,16 +9124,15 @@ void __io_uring_task_cancel(void)
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
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
-	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_remove_task_files(tctx);
-- 
2.24.0

