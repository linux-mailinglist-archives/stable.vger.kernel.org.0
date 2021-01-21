Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9A2FE9A2
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 13:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbhAUMJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 07:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730917AbhAUMFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 07:05:20 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CDCC0613C1;
        Thu, 21 Jan 2021 04:05:04 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id 7so1493875wrz.0;
        Thu, 21 Jan 2021 04:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AS44Rkt96UHiyPOxzRje4xpFE3MFKfgU7cCzpEQimRo=;
        b=raFEO/3+zFUgcz+a7PrzLQ26+O7kzxZ+qd/ZrCdwHWhbkmTphQ2KfbdWeR9dIHEriB
         3xWVWBrrwTAuH7h68iKZZPhKhgZdJW2iptd9lzagGYmat8JjuJIw1uQTeDstuYRWTzkN
         GVCe+H+xMKhtvyliT2N5ZD58bJkMUWDj5j+58d/zikP+mRW9DIcpO5GZHbuFsk1P/PpR
         cJs9Uj7jUtMbc630H+wReLaos9Dy5C/rGEw31u2nEFGHFzgc+NEzq3oT5p83OMd53soX
         hanve0e2KF3tiVwrMgqC5HHrtiAZ9aGzLJXzuH+vquLom5+PulQbZ5+vDcr9fTeDO8kz
         8PSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AS44Rkt96UHiyPOxzRje4xpFE3MFKfgU7cCzpEQimRo=;
        b=aTPKVGLmFTglm/qPqEpX/zOzMwIf3KUZkqpRsuivzz18faoMvapcIzzd2DyHLiBRQo
         G5K3HnHLDMpjewdFzKwokCdrRRUmiYtw4eQ8TtYaAD7ZzV1jfuoe9Qf4YTde5SIctPcv
         nHW22OLnrg5Tjs5EdU9QqNo4bDeB86Rg4apsuTmQPD2XiAA3jpJXd3rc2lVYuqK3i9L3
         4UHhm0iTA4RNrtO04ULNeYMJMJixKt3mPRDFMn7oaVYhwEDre5ECx6OMUhc2Jeh7lbc9
         yQAcwdGdEmYvk8hJrYMsRrckctmh/7eUNRYccYNjckDVaTYWKab4tZ4GnVD+c8v7Azz/
         /ycg==
X-Gm-Message-State: AOAM533fDOvdRH2ov8rfKScSrzronSfs4uWkLkPbmrD6A9D+ZncLhdXA
        bdeet+f1HUnjveUw4qPVuzk5PYPccio=
X-Google-Smtp-Source: ABdhPJzPKZBcLlAOxD1ng03CkL8NwemUOm0JT64RSng7IKG3Ldgt1QpAA8nX7h1EjcElVYegQkRNRg==
X-Received: by 2002:adf:a319:: with SMTP id c25mr14205135wrb.262.1611230703372;
        Thu, 21 Jan 2021 04:05:03 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.228])
        by smtp.gmail.com with ESMTPSA id s19sm9505401wrf.72.2021.01.21.04.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 04:05:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] io_uring: fix short read retries for non-reg files
Date:   Thu, 21 Jan 2021 12:01:08 +0000
Message-Id: <99c647189104206e8391419d8267a82753883bbb.1611230356.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sockets and other non-regular files may actually expect short reads to
happen, don't retry reads for them. Because non-reg files don't set
FMODE_BUF_RASYNC and so it won't do second/retry do_read, we can filter
out those cases after first do_read() attempt with ret>0.

Cc: stable@vger.kernel.org # 5.9+
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: essentially same, but a bit cleaner check placement and
    extended commit message

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f6f1e48954e..18920f9785d2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3552,7 +3552,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 
 	/* read it all, or we did blocking attempt. no retry. */
 	if (!iov_iter_count(iter) || !force_nonblock ||
-	    (req->file->f_flags & O_NONBLOCK))
+	    (req->file->f_flags & O_NONBLOCK) || !(req->flags & REQ_F_ISREG))
 		goto done;
 
 	io_size -= ret;
-- 
2.24.0

