Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00992E6DC8
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 05:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgL2EkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 23:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgL2EkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 23:40:13 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F68C0613D6
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 20:39:32 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a12so13232930wrv.8
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 20:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRJiEQFsTd/ezqp0rquLnDdonIJ9ED76KpS6ntg/hq4=;
        b=UuQqaJXk5ZjT3HaFXwCMsGDO31qqmdVgZZ9zh4ci2jxTmSFOH2mbUlANVhLnUVkfBH
         d2yHg66rJZstWuOkEawlarH4+IU8/7cIQM0as7k4Rwzbt25slBYHRNFRSYuO3kqd3IUg
         iILYOZE9b6yyHLSpS47TQSnyuSEVo18GBbFJ/UcVQfXgTryELwGOLo/1dYWiSoA0krS2
         iiGO56Snx7hVrKj+xWsueaZWV5X7kudxxzG3H1JBTpNbIisC4UPYCbDQ9TRvKaQvPdcv
         RN6dpjJkMxs6WyK4VmzS6z/Rjh9/rcdu6Djgd5+FXbZOXf9kA6sU2HBAaVnS18jReatk
         7ybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRJiEQFsTd/ezqp0rquLnDdonIJ9ED76KpS6ntg/hq4=;
        b=GEVYCkQHROy+cLpyMwUOerCHpCi9yIP2h+GrqrfZNJyf/Ffh35bqai0ERzB7q3mNm8
         sxz1ZmWgq/9eqLiKwRKYlN4FK5u7f96dNXKiiVToS/c0P08V11A2Qo6YmAyG1a07I6qC
         GdI5Ja68EMNAoCUKqS610A0TNmvAYV3BydrZPJgAROKv/zmTFN6fwQtrBejoFMvDE4yb
         j2mGUy5IrJ7YUbF2S9p93njaO1gAP6aS1sBFU9Ly5xK+Oo1yh/9RQWoLBGXTIa5C+8O+
         +YAv+/zRrSUVV/gGQhCEzw7SHWKLauRVeEi7YdjufsifRByXweoepsZ7tAq5B8JZ4yGG
         NQgw==
X-Gm-Message-State: AOAM532EG/S+WrPoZ9xQUal2KMQc3PGr/wjteQJXhW5yG/wVaUafUdba
        xb7lKl4YPj7at1E8SABkDTBGle+nl8o=
X-Google-Smtp-Source: ABdhPJyQ+dlFc2XcCjiFjPTyE/rlAukHwi1xapka4QWEeaUOYpW1yN7jucidrDM3DrSV+u2dz+2azQ==
X-Received: by 2002:adf:8503:: with SMTP id 3mr54277684wrh.56.1609216771443;
        Mon, 28 Dec 2020 20:39:31 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.61])
        by smtp.gmail.com with ESMTPSA id o8sm57751885wrm.17.2020.12.28.20.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 20:39:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH backport 5.10] io_uring: close a small race gap for files cancel
Date:   Tue, 29 Dec 2020 04:35:49 +0000
Message-Id: <c47ff9d5a4dadaaa47fa2f2ad2f6cae8c39a9b98.1609215832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609215832.git.asml.silence@gmail.com>
References: <cover.1609215832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit dfea9fce29fda6f2f91161677e0e0d9b671bc099 upstream.

The purpose of io_uring_cancel_files() is to wait for all requests
matching ->files to go/be cancelled. We should first drop files of a
request in io_req_drop_files() and only then make it undiscoverable for
io_uring_cancel_files.

First drop, then delete from list. It's ok to leave req->id->files
dangling, because it's not dereferenced by cancellation code, only
compared against. It would potentially go to sleep and be awaken by
following in io_req_drop_files() wake_up().

Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 86dac2b2e276..dfe33b0b148f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5854,15 +5854,15 @@ static void io_req_drop_files(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
+	put_files_struct(req->work.identity->files);
+	put_nsproxy(req->work.identity->nsproxy);
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
-	if (waitqueue_active(&ctx->inflight_wait))
-		wake_up(&ctx->inflight_wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
 	req->work.flags &= ~IO_WQ_WORK_FILES;
+	if (waitqueue_active(&ctx->inflight_wait))
+		wake_up(&ctx->inflight_wait);
 }
 
 static void __io_clean_op(struct io_kiocb *req)
-- 
2.24.0

