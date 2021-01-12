Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76B52F3D93
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438011AbhALVhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437149AbhALVVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 16:21:54 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B982CC061794
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:13 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m4so2619229wrx.9
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y+qa4ulX/8LbLnLdrkKPDBY1Xvt6oWoJZrssS4Tn5iQ=;
        b=Cou+/DSK23qeZoP5zdMbV3NSecXiyHTxYVkFJScPbXyWEyPeaXaQlWz4inG3yYmpgx
         oP6g0T1ObmsBDNlGJ40J6w4Jp1oNxUgwGItk08rXmCIiLffdRGRUrNfi4ZMJjsbIrRy4
         OG8QupCIfrbI8mOsJlYKxgYwAmTkYCXkhS43f9rbUbeslLJqfCvbymEToRc9jAFuxrpu
         qu76Vo/6aP5dIDmHA0pa5Uv06Rh6VbFrMQHLb/Go1YfUr/YC7GyU+GmwKK7tvSjUV1Qp
         1QwKl9io3u5EfsFy1NpUzNnsYyAUElVXNMgBgea0YNwqQHrbQB6nDT/S0kGUWOI/JBSZ
         gjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y+qa4ulX/8LbLnLdrkKPDBY1Xvt6oWoJZrssS4Tn5iQ=;
        b=fyNhttxKWFHfpm54ninhqQ4jINllkUSM7rfPrld0q4aj8soDTqN9JIB0jfFFNJfWFj
         PtNAIdgnyuV4sWZAHmLD3EUKlZixEzGWkyvdgdz8deDPLhCsf6BK05IiPkC2hmYV5iee
         0/rF4Otspr1C1YBjUm5B4UKlZ4KDuIo461B5NVoRDepy6HB8UNM6aSAcWVcNofxJv5aZ
         CNW0AAtEWEsIImQjFl/Dq/TqnHWKuztPGiGI1ej8fHKr2EGvM5LLbpa5SnbrCMUSA3aU
         18ikUNQ3wmdZj0DG6O93glElMOtrAyVhq1RbaQdXDT2QvXM4L79Oz3j+WWwtQV4x7Luk
         iDPA==
X-Gm-Message-State: AOAM532KnHhC2cOrD56WDPuPwALRqNtsKx6F5wwrZx4iYO5nkd7mdw5I
        +FnWOJcPCXLDlmMKGQ8y8LY=
X-Google-Smtp-Source: ABdhPJzxwNZ+5u1YYIz3exnB8k5zQnQMxhXeXBpmNyjYy8z+PZ9UEbyNpKUyh3SxNPgBuuvw3W/eXQ==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr738473wrt.404.1610486472564;
        Tue, 12 Jan 2021 13:21:12 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id y13sm7166093wrl.63.2021.01.12.13.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:21:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10-stable 2/3] io_uring: limit {io|sq}poll submit locking scope
Date:   Tue, 12 Jan 2021 21:17:25 +0000
Message-Id: <6116edea4aeae272237f92efa106aff2181bdcab.1610485688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610485688.git.asml.silence@gmail.com>
References: <cover.1610485688.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 89448c47b8452b67c146dc6cad6f737e004c5caf upstream

We don't need to take uring_lock for SQPOLL|IOPOLL to do
io_cqring_overflow_flush() when cq_overflow_list is empty, remove it
from the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3974b4f124b6..5ba312ab9978 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9024,10 +9024,13 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
-		if (!list_empty_careful(&ctx->cq_overflow_list))
+		if (!list_empty_careful(&ctx->cq_overflow_list)) {
+			bool needs_lock = ctx->flags & IORING_SETUP_IOPOLL;
+
+			io_ring_submit_lock(ctx, needs_lock);
 			io_cqring_overflow_flush(ctx, false, NULL, NULL);
-		io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
+			io_ring_submit_unlock(ctx, needs_lock);
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
-- 
2.24.0

