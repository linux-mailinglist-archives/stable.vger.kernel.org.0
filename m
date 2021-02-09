Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2FE3147BE
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBIExy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhBIExw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:52 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB7EC06121F
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:52:02 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id jj19so29289736ejc.4
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=01llYKpJwtPQDOvx4C0ZDJ+wp7K3FZlWdDVb3bCYMds=;
        b=UlZmShClScFKJE62LMtuvK6iZvXVPQNjCAoJ/CO8Ae7Zpf7GKwgfTJgdT40caR+CH1
         bLIOyJn6F1kcS2DdtboY6emCI/qA0cVZML3p0rEnAldLXTCtm9BKalC1b9I2IzPGxwVQ
         dFjJ5yNFnqnvBhcuVsqftlLNSjVNJyuJKVaYX2NKm0s2QBDeM0TKt0hG1GQVp2g8EnDM
         aFapKeU1grVKpMtJzadC6Ad/iuKDtjf1LKWSpYv7DLB1dRWZ5bpJjf82qVJfNzV4EPI4
         iUne3F0ei92ZKr1IazyAPVKaawCQhl/R3Z0MBwpZ5+RmVCCkoQ9LKqGTeTCKo64Ji3hX
         570Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=01llYKpJwtPQDOvx4C0ZDJ+wp7K3FZlWdDVb3bCYMds=;
        b=g11YhFHbfJuBpJoMiXJirsgiE/7tg0xC8sgVwD/BWkZ3SP+PZehlVLUkqFBi3gNZNN
         6BgCEwkStK4enxuXYAbOS9mBEoLxMpSvWfM3mmumOnthPA9ymlXm6DaTSilTEy1zrLfY
         CYLrziXcKPQf/By47PYfzrHW5Aul2aBehhoM1QJTUR+GQObBPnB+Uvq/tl/QEUS+JHnf
         e9UvklXO8VnqQHxbiMenx1jDINLA8XsqH00zD29qP7zKlHXid/3eNXJmuso7vyPsy00/
         1DHyKS7QU16+Q/y2gXdY+Q8NZjf6B//mAidgNhJ3fUqU6rJljkAHwQD2HqWUTUghmH4q
         vwOA==
X-Gm-Message-State: AOAM532TFTUrGfLWvbdkr3Hfon7DaZfjNHGjezZBUyuzUWqBqyMLP6G2
        yGLw+lDpFZ9hLwe3mJnczXZ3mLwym+w=
X-Google-Smtp-Source: ABdhPJwJppTddMDoRvAFMmqCF/aZXbPDxUxmm6i538K1BHJwKzyMsYiMnFt3jR9we0MWOvUEoGudzw==
X-Received: by 2002:a17:906:40f:: with SMTP id d15mr20795061eja.522.1612846320835;
        Mon, 08 Feb 2021 20:52:00 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:52:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/16] io_uring: drop mm/files between task_work_submit
Date:   Tue,  9 Feb 2021 04:47:50 +0000
Message-Id: <7237e22d720788f37b445ecf63403fc2c884aae2.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit aec18a57edad562d620f7d19016de1fc0cc2208c ]

Since SQPOLL task can be shared and so task_work entries can be a mix of
them, we need to drop mm and files before trying to issue next request.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5eaf3a7badcc..3c9bb7673da5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2084,6 +2084,9 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
+
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		io_sq_thread_drop_mm();
 }
 
 static void io_req_task_submit(struct callback_head *cb)
-- 
2.24.0

