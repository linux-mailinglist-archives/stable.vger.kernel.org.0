Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5A32F3D95
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436845AbhALVhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437148AbhALVVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 16:21:53 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC320C061786
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:12 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 190so3169544wmz.0
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CDAz73ZJWZh8wN5scIZgGUH6eRmdeJv4r+mh1oZtxf8=;
        b=ACAKXD6DT0YHGelge9/GSr0NoT/tKJYwWZasy+qWXYP2RSEV5oX6zot4kLUNXSHfNZ
         PboLSJNcF4D36V3jN2rXAUMdmBFYi3OrmOaU760aRBh9+W2cl5hfTX7l35jT857HAKPq
         8qU6Zxw83hebfZERceCvaO/T2WjK3609hjejwDKZmtoag8VOFAhhzGVygrCy+Bk5Bxbf
         qo0+aWzd0Vf3iLV6NSWwIoAKbUE91RbO/WmdjcGqvWOWtsVbRxoVmU9CsSu9jfL4LgvM
         IWWcAT4ULYVz55mxL97TVsJlgyGuTJio2Ugj6pcnZS9He7/2WWR4eMIm3J2gf4k3n4UK
         8dKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CDAz73ZJWZh8wN5scIZgGUH6eRmdeJv4r+mh1oZtxf8=;
        b=MnUuEf4IuSyPhZFUxBsJIBYSO8lkkBzNepkxQQLu6O4jGb5abHudeK4FqtNzDSlYUO
         CgseX9H/3oBLgcxSemTDXD6iLuLpQkgx6d90jRNI+Rh0T/ZBOMCEnCHIVzaWFhZpHCFg
         D7g6vBJ+Ue0xPGEuwzW2fHXqadD5raAVzNeD4a542LtAvuJHXKLBjYpDNu37TrPz8edo
         KolfjyuvDQM38x9NpUiBx2ZPEf1LKxglJOFPjCLjk0SOrqKzfn8wpcFRGs4asIkRxrKH
         SJpsFUdjxaMjB/iY5zuasDZ5qV+viwxHlkKoSlbW6FTr8RZFYNVGB1QA2wsEgvyBDe7w
         KubA==
X-Gm-Message-State: AOAM533OgaRBa0lq/mlzKqt1M+9eVj/lHK2m+v+nRGVskpG913/PRS4l
        pz8uIr9jainLS9rea+9rGGo=
X-Google-Smtp-Source: ABdhPJzyNyJ231+ugZrmQm+I0uJpmV/RNU0pzPJUfi8PTmV4zSHgMsQBj9haw6drVh9ia4bQeuZ/Gg==
X-Received: by 2002:a05:600c:4101:: with SMTP id j1mr1028753wmi.55.1610486471542;
        Tue, 12 Jan 2021 13:21:11 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id y13sm7166093wrl.63.2021.01.12.13.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:21:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10-stable 1/3] io_uring: synchronise IOPOLL on task_submit fail
Date:   Tue, 12 Jan 2021 21:17:24 +0000
Message-Id: <b965dc7a6bfb1adbe5b4bcd9a363a38d662a3195.1610485688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610485688.git.asml.silence@gmail.com>
References: <cover.1610485688.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 81b6d05ccad4f3d8a9dfb091fb46ad6978ee40e4 upstream

io_req_task_submit() might be called for IOPOLL, do the fail path under
uring_lock to comply with IOPOLL synchronisation based solely on it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f798c5c4213..3974b4f124b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2047,14 +2047,15 @@ static void io_req_task_cancel(struct callback_head *cb)
 static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool fail;
 
-	if (!__io_sq_thread_acquire_mm(ctx)) {
-		mutex_lock(&ctx->uring_lock);
+	fail = __io_sq_thread_acquire_mm(ctx);
+	mutex_lock(&ctx->uring_lock);
+	if (!fail)
 		__io_queue_sqe(req, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	} else {
+	else
 		__io_req_task_cancel(req, -EFAULT);
-	}
+	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_req_task_submit(struct callback_head *cb)
-- 
2.24.0

