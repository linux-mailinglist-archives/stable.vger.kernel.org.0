Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE7303C7C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392220AbhAZMGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392338AbhAZLW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:22:58 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A1FC061786
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:04 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a10so22414811ejg.10
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=suQfLER1J7hWgKba7DAAjmsln0J3BgW+wjZ6YaOdEvs=;
        b=oc3pOW2vOm+5zQ3X6kVaTwwj1CZvObGy87BZf4qDIMnbq1/E4P1xG7/o/t/EClp8fQ
         N63ccgibgCoPUyqYMSvyY1dh2Tub1HSBwUZEJ6crZtL9jOKc21jSScQGOYcjpugqsunc
         k0DVSm4lpWii9H3sQNYa3xHwfjI5KTYChyb/MWk+TEaraEFXdYXniXNHPUlK/615MjAd
         AapDmDaRjNkZXB5oaYhM7hL181aDlPGr0Ovr3OkmjOrHZZk9Hmo8bE9h0LM+eF0AQd9M
         TbrHCHPMv1BKqVIom71nqkOixOjGf/ONXYIwZUrXtFa72V902/VikcapP1Hgo44iNnZ0
         LKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=suQfLER1J7hWgKba7DAAjmsln0J3BgW+wjZ6YaOdEvs=;
        b=CM/Y1B7eDuzDgsG2EUt1HHzqbAcz+9sK/NcFUp1aCUnH7a/6VeRAe2cFUR70cUYO4V
         Z3dFGBpkfVd0vI7YtSYSutmwKrJSBuYTV53zEUFi0BkbHZN4k4fKF7siOCAyVMUnItlO
         Ac2GiBqAUCVZ35n5r/lKHkKvaw4iyYQiJqfLVSxnCBy2SF6sWUkL5GkhtNeNF5bgd3+z
         +tI88pGUwsvexMJdnqQjK93Cb2ia+1RtSpVH+1udE2BImd/JSjTuWhvEw1UBbrcfBraB
         7BJsd9NuqX/RNe1OAi9rc/WC+o4EZBU3ahNXa4QTO7vTx9SV+cxJ/gTOuNprI/8v4uD8
         1bQw==
X-Gm-Message-State: AOAM532JcCQqcspOMAvOHCx4PEHjRbHTiIAAeWJduVs5QhN7ADb9rrCB
        GkN0CU981j9J30SEELtTEEIsaPSnFTjM7g==
X-Google-Smtp-Source: ABdhPJy5DbZqN3SYkdEdjL2bh9WRDbGn/yAddWJSzkheVJ1wW4+H1Sd4TjRayFmBJUU3jBmtguy7sw==
X-Received: by 2002:a17:906:d0c1:: with SMTP id bq1mr3060941ejb.202.1611660063132;
        Tue, 26 Jan 2021 03:21:03 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com
Subject: [PATCH stable 05/11] io_uring: fix null-deref in io_disable_sqo_submit
Date:   Tue, 26 Jan 2021 11:17:04 +0000
Message-Id: <cdec1207337932aaa7433a4abfd5f38fa4cb2de0.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b4411616c26f26c4017b8fa4d3538b1a02028733 ]

general protection fault, probably for non-canonical address
	0xdffffc0000000022: 0000 [#1] KASAN: null-ptr-deref
	in range [0x0000000000000110-0x0000000000000117]
RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
RIP: 0010:io_disable_sqo_submit+0xdb/0x130 fs/io_uring.c:8891
Call Trace:
 io_uring_create fs/io_uring.c:9711 [inline]
 io_uring_setup+0x12b1/0x38e0 fs/io_uring.c:9739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_disable_sqo_submit() might be called before user rings were
allocated, don't do io_ring_set_wakeup_flag() in those cases.

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 723e1eb5349a..f1f1de815755 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8726,7 +8726,8 @@ static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 
 	/* make sure callers enter the ring to get error */
-	io_ring_set_wakeup_flag(ctx);
+	if (ctx->rings)
+		io_ring_set_wakeup_flag(ctx);
 }
 
 /*
-- 
2.24.0

