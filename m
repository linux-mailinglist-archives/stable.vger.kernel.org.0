Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15C82A89EF
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 23:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgKEWes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 17:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEWer (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 17:34:47 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA33C0613CF;
        Thu,  5 Nov 2020 14:34:47 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c18so3118692wme.2;
        Thu, 05 Nov 2020 14:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4sm3HrRlnJ71AFKp4V3p/GrKt1dk+1gQo/oWyUt11s=;
        b=rYpLblmSgRF73CX58czKd0ZDvoG+EYNtWKpJCV7hKC3Y6fpztqzZaxO5X620SSodPs
         DTelR9erOdQsu8ISWjEFLu2vuS7S2c/MrfL87TrgUJIlqawg9ZjipuTFXg/ukyFYQzAj
         Y80jmfK2VkVlJj8OcGV1eUG8dl44CQnpallc49LzJiEI9IuVPyqZDItwGP0Cy0YOeEJu
         cf4mlXYGaBZhj1b9W+Jv2WuoF4vYYEBSFvtqDntyX+xRYCdvJ2u8CuWkbPHSN2Ti5tAh
         MbfmpwyYD54OeOY1s1gtARWOOzNGvBir9/DUFhEiZGXapgLgO8BV4nA2qXTHFFGoCFp0
         qhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4sm3HrRlnJ71AFKp4V3p/GrKt1dk+1gQo/oWyUt11s=;
        b=sj7raneWw59vlvXTAP5CNE+SJIOrB3Yflac6rFVVBzBQRmP2vYrFrak1FU4KSkzOdp
         14pqC8jt3AhdhVN4mUxNUwF7lluki23jTuL/uCa3p5OhxRWZmdjHfFmcqVE8vTTFyxXF
         KUJSlc3ImUfNeNq8sveoSoJg5Q2pXQrz0yQ7FzZQW3exyk7BZg4NyKFoxzl7neYC1UV0
         71q+d4xyizuOO96lPvaxEoQbSeL6IAprhgw+Je2/eXHnkHRerqcvSSWFnPlv7kBfb3o+
         8NWhtGXruApK9LIXDCgW7cUP042TyLZp4tAplj9jOSl12YAS13Rj+1C6gj+TL+CmGVLM
         LK6A==
X-Gm-Message-State: AOAM531+zEx6Cx308jhceTa+53PVITEA5jDiqWx3eSWr5lxiN+qlhEgY
        4rPQyn1eqCzifqKKIEBUMz3nbhsrVa4=
X-Google-Smtp-Source: ABdhPJy2FrsEhnxVfuKDBliXlLQ9JW+UbhHlfAtmup1dJdrzWqngbrL6jmTkwfCfxEGcfEBYz4wDpw==
X-Received: by 2002:a1c:2c43:: with SMTP id s64mr4854419wms.130.1604615686347;
        Thu, 05 Nov 2020 14:34:46 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id f23sm4292322wmb.43.2020.11.05.14.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 14:34:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.10] io_uring: fix link lookup racing with link timeout
Date:   Thu,  5 Nov 2020 22:31:37 +0000
Message-Id: <c51ca0ebb562612484b248038142184572ecf2dc.1604614925.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can't just go over linked requests because it may race with linked
timeouts. Take ctx->completion_lock in that case.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 29f1417690d5..8018c7076b25 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8470,7 +8470,21 @@ static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
 
 static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
 {
-	return io_match_link(container_of(work, struct io_kiocb, work), data);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	bool ret;
+
+	if (req->flags & REQ_F_LINK_TIMEOUT) {
+		unsigned long flags;
+		struct io_ring_ctx *ctx = req->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		ret = io_match_link(req, data);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	} else {
+		ret = io_match_link(req, data);
+	}
+	return ret;
 }
 
 static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
-- 
2.24.0

