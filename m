Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C474D2D07AC
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 23:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgLFW1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 17:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgLFW06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 17:26:58 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A258CC0613D4;
        Sun,  6 Dec 2020 14:26:17 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 3so11935669wmg.4;
        Sun, 06 Dec 2020 14:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sz41q27dEN+NhvetrgJqhS/NYwKThir04BgllJLnIN4=;
        b=VJkIe7flzNp7E0qyfQgADSbE5ZVMFnXOjWDTh56IZgT1lM5iUGRAySCB6FWHaDD2u0
         DoynFHVFs9z4Gk+IjvOL6hgdTMoMsMVYZPltWL75D9aG7g4x3P4/jqDahSEkz9a9zHn7
         v6u8Tl5kg6neZjfSfd9VArENyXAK+WKCstq8QuDFLixCyWcnj/pN4BYilBg/uR2jKTVS
         Gt7fcr2mAOetomlWnMH53XLAyK6bDUWb/qxJ9Cb44ksTBlMNLJPGsRbn8Bls39YLVonC
         Ss0RRGqpwNA8AWUIhuAiC+7e1UFGNtatpk5mmUCZ7Dwhpebq0bvPLb70Xt860FlSTc1p
         pckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sz41q27dEN+NhvetrgJqhS/NYwKThir04BgllJLnIN4=;
        b=OpLBCIxWt0aKwPU/9FKk7i08WUGXrxHs6vtFg+Jt2H74rdks2FywXm5ZLW01x/lslf
         5nYneL6qIK0cU5pujtmpTCQERC35PeiPBpQhPPBUvEh+uzxeaokY8pdSXd9MAmkMDazM
         kAtIzGkx4TL1EqnVRIWFzfU+C/YQZwsASPv0H3QuoMYAEF8spFI0Flk73dCm1qDNOT6S
         lBqrImTTNeI55MlYHhAW5dV9mfA/gcM9/+jVFfDvHeB9FFfS1rBYDG7StILU5YPlNCV9
         LPhTY/btA1lb+5plWRrv6Eqs2ToRsixQuHibkzZGDYFzrhN6etYu/kBLUiRzgqQdmPti
         A3Pw==
X-Gm-Message-State: AOAM5308+sktgwOsUUgLwaTlppPdF5IG5QWUo/nu1M57HB7IyB+2qPmL
        sjISJiHXlQVZ5SdtzHIwNuQ=
X-Google-Smtp-Source: ABdhPJxRvQUCVR593/iyRbpKVC/EWnFmCIBgELzyoU8fB8tjHLDba1UO/iGx1NSGKuceMhmeUULfAQ==
X-Received: by 2002:a1c:bc88:: with SMTP id m130mr15687469wmf.82.1607293576420;
        Sun, 06 Dec 2020 14:26:16 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.92])
        by smtp.gmail.com with ESMTPSA id h20sm11284917wmb.29.2020.12.06.14.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 14:26:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.10 4/5] io_uring: fix io_cqring_events()'s noflush
Date:   Sun,  6 Dec 2020 22:22:45 +0000
Message-Id: <018bb0de66981fa798da015a983e5bb6c41bae5b.1607293068.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607293068.git.asml.silence@gmail.com>
References: <cover.1607293068.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Checking !list_empty(&ctx->cq_overflow_list) around noflush in
io_cqring_events() is racy, because if it fails but a request overflowed
just after that, io_cqring_overflow_flush() still will be called.

Remove the second check, it shouldn't be a problem for performance,
because there is cq_check_overflow bit check just above.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b1ba9a738315..f707caed9f79 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2246,7 +2246,7 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
 		 * we wake up the task, and the next invocation will flush the
 		 * entries. We cannot safely to it from here.
 		 */
-		if (noflush && !list_empty(&ctx->cq_overflow_list))
+		if (noflush)
 			return -1U;
 
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
-- 
2.24.0

