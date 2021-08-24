Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261B43F5DBF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 14:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhHXMQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 08:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbhHXMQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 08:16:56 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5C0C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 05:16:12 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v10so19781241wrd.4
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 05:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QwAksmy8AUZUJdeuvbdlR3YPV0zYUSMKlZXkpsYFQA=;
        b=BT8nzrQeZANlRx444f/mTqxUuPqvr3q3XFm/Tz2peOUjILPBtalTy+sbxRtlZKAFsD
         icaUBapnlJWLNDA7HRyC0Gk/Vr9zrf0iUa3e9To53Vir/Om11PQI6ipgmowpjev9blPy
         F2vZ8UQokbNFhke85oEOONNZJJA6fUWDT46NVJE3f+cUpf2L3R0zm4gTwGUC+RbnZG70
         oDaiRRZQVnsaI4c3BCtaAMuoQzFKg6w0muCWOqtiLPAFC03vyZiAM+s9UGE8nwItKI2n
         bPXSADHWCtM+Ei2+BFRSTf/uYYmmJMMC5EmFqdFTn8+etWCzokj9wiVRj/s6FI4Rfm6N
         H5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QwAksmy8AUZUJdeuvbdlR3YPV0zYUSMKlZXkpsYFQA=;
        b=D5jkb4L3zS6dFARs5QoiIxxGQ89FCXMUqkLHVfYPuUWGtj+0pg0pqfz1vEyur5PPsP
         /crb9w08xRCJ/ZyHqTUGkXZSleF0CQE3H+QILB29099C7pVHGHhF7eBLfFstH3RojGqG
         pNxvuv7GoyOSVZilCrBPJWenzz6CVWRriaeN/68Zbc19ReL2/2FIdRUeXbddUOdsGd6e
         VVw+Xyq1eNb6AnIBUmJNOtUq9ujlike2+1z4oyq+keaoSbl5pkqr4mxG4Y1O1IHN4Gq1
         UXXfa6ieHb5jDdgSnJfT4ceeA9y/jevRjx49ZuxLnW7Vjmh6Z6Bd9W2hNiw6UQtPit6/
         u7Gg==
X-Gm-Message-State: AOAM532MqVFZitXp3rzI0tL8uf+Y1nACNiajwK25r1fyXPzHnYUAia2R
        lXiSiLzfm38H7X9o8DI1+YU=
X-Google-Smtp-Source: ABdhPJw2tXFTVmxpDonMvlt66ArVFVQIOPc2IL9PSJuW7rUMXcfQQSQi6GWHVyPQqouDbWcKLOs7pA==
X-Received: by 2002:a05:6000:11c5:: with SMTP id i5mr19043760wrx.183.1629807370787;
        Tue, 24 Aug 2021 05:16:10 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id f5sm2140103wmb.47.2021.08.24.05.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 05:16:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 backport] io_uring: only assign io_uring_enter() SQPOLL error in actual error case
Date:   Tue, 24 Aug 2021 13:15:31 +0100
Message-Id: <aa7b8101db24bc8639e3206439c2ff9d9dfba3e3.1629807222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ upstream commit 21f965221e7c42609521342403e8fb91b8b3e76e ]

If an SQPOLL based ring is newly created and an application issues an
io_uring_enter(2) system call on it, then we can return a spurious
-EOWNERDEAD error. This happens because there's nothing to submit, and
if the caller doesn't specify any other action, the initial error
assignment of -EOWNERDEAD never gets overwritten. This causes us to
return it directly, even if it isn't valid.

Move the error assignment into the actual failure case instead.

Cc: stable@vger.kernel.org
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
Reported-by: Sherlock Holo sherlockya@gmail.com
Link: https://github.com/axboe/liburing/issues/413
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed641dca7957..8492b4e7c4d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9078,9 +9078,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
-		ret = -EOWNERDEAD;
-		if (unlikely(ctx->sqo_dead))
+		if (unlikely(ctx->sqo_dead)) {
+			ret = -EOWNERDEAD;
 			goto out;
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
-- 
2.32.0

