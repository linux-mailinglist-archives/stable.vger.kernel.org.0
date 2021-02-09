Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7413147B9
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBIExR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhBIExK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:10 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB739C061797
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:52 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id lg21so29292945ejb.3
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pynK/xnd+nC2KvWAKX/Qo0kFMdqW3cOoRzYMswrz2gk=;
        b=h5wOOFeDtkZdPQHuRmtJB4zPGxqymzhC/Utfao/yf8cqUM9wYY/Km+UrHadNGqNx7k
         EeU1Tk1elcTLEtn87yQQh4km8MXR6K5NcIfFFmoysgJp0gJlMeSgdtPMxl+sCPSmia0P
         WZiR1ILrb1eQKM/IWvbOXbO7eQshnwBd48Yo5WcuW2eLz6lidSkghcko7VDww7oYW0ac
         TuidNpJjTobyYIAA0Q6huUFDuraV+hAzrM7RS/SpJhZb5Ci5vo4MqJyuQwXbOaiAIiqT
         OVsPNSJlTANM/BLlq0qxG3Fv7S5n40/0VbHSbIu4ZTHo7T+rwgoOfVEFyoCZJ4/N7yug
         Q4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pynK/xnd+nC2KvWAKX/Qo0kFMdqW3cOoRzYMswrz2gk=;
        b=WZzt98eR44J+BW9ZwzWmQRfWDGuDxX+Xmg/xjdawping2sr/bVdCwtWUHRYVOeZBek
         H8s8SY1qxNwk3Q9P0cIgu6xoV8gY2HUBibqsT+M90SB49aPtUxLvY33iBxCKAUK0XZxV
         0gpQnvQVltVlVUXtppkvjR3UfesBeXOIePV9yrIh4cIAmFaIrItoxLlwklZl0N6lx1VH
         m9Aoj/SJQLDUZCWPNN6ZPab5agUmArZrfr5Qu5V4XAtL7He566jR9qfGlLS8VPPSoWEf
         9nPKJNI+EBd2vIRhF+YBA5n1TPFQYQzSseJOZGr9HCWUW6xgpClSUVZ7Wyqrj6ernwjc
         /7MA==
X-Gm-Message-State: AOAM531PPg167vZpgX8ptCUo/oal2CzvRAiqoXt1U5R/QahjjjhcVY11
        nLo+amDTf2VJKPwv1D2HHL+7ThBHIgs=
X-Google-Smtp-Source: ABdhPJyQbQqZzqAFofm451aVDi+xWTQpJVaNYAV53iM7HPVkQ96RjV335oNtxvPgqaNKjP3WLult2Q==
X-Received: by 2002:a17:906:1d51:: with SMTP id o17mr20467646ejh.85.1612846311219;
        Mon, 08 Feb 2021 20:51:51 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/16] io_uring: account io_uring internal files as REQ_F_INFLIGHT
Date:   Tue,  9 Feb 2021 04:47:41 +0000
Message-Id: <9c1d1608c20fad5b92196b550ec0b7463046590f.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 02a13674fa0e8dd326de8b9f4514b41b03d99003 ]

We need to actively cancel anything that introduces a potential circular
loop, where io_uring holds a reference to itself. If the file in question
is an io_uring file, then add the request to the inflight list.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a40ee81e6438..9801fa9b00ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1000,6 +1000,9 @@ static inline void io_clean_op(struct io_kiocb *req)
 static inline bool __io_match_files(struct io_kiocb *req,
 				    struct files_struct *files)
 {
+	if (req->file && req->file->f_op == &io_uring_fops)
+		return true;
+
 	return ((req->flags & REQ_F_WORK_INITIALIZED) &&
 	        (req->work.flags & IO_WQ_WORK_FILES)) &&
 		req->work.identity->files == files;
@@ -1398,11 +1401,14 @@ static bool io_grab_identity(struct io_kiocb *req)
 			return false;
 		atomic_inc(&id->files->count);
 		get_nsproxy(id->nsproxy);
-		req->flags |= REQ_F_INFLIGHT;
 
-		spin_lock_irq(&ctx->inflight_lock);
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		spin_unlock_irq(&ctx->inflight_lock);
+		if (!(req->flags & REQ_F_INFLIGHT)) {
+			req->flags |= REQ_F_INFLIGHT;
+
+			spin_lock_irq(&ctx->inflight_lock);
+			list_add(&req->inflight_entry, &ctx->inflight_list);
+			spin_unlock_irq(&ctx->inflight_lock);
+		}
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
 	if (!(req->work.flags & IO_WQ_WORK_MM) &&
@@ -5886,8 +5892,10 @@ static void io_req_drop_files(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
+	if (req->work.flags & IO_WQ_WORK_FILES) {
+		put_files_struct(req->work.identity->files);
+		put_nsproxy(req->work.identity->nsproxy);
+	}
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
@@ -6159,6 +6167,15 @@ static struct file *io_file_get(struct io_submit_state *state,
 		file = __io_file_get(state, fd);
 	}
 
+	if (file && file->f_op == &io_uring_fops) {
+		io_req_init_async(req);
+		req->flags |= REQ_F_INFLIGHT;
+
+		spin_lock_irq(&ctx->inflight_lock);
+		list_add(&req->inflight_entry, &ctx->inflight_list);
+		spin_unlock_irq(&ctx->inflight_lock);
+	}
+
 	return file;
 }
 
@@ -8578,8 +8595,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task != task ||
-			    req->work.identity->files != files)
+			if (!io_match_task(req, task, files))
 				continue;
 			found = true;
 			break;
-- 
2.24.0

