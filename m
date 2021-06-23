Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323403B1D83
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 17:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhFWPUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhFWPUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 11:20:16 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F282EC06175F
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a6so3970699ioe.0
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t4u/kAIed02Wt2quW7e3LI/PP2g01D4YOTswdqhIIpU=;
        b=0Kz+1xf251hAIyz/tmodU2ANxxhCQImhGaTGJisZQsT+f2DLwEPvIfDXQdUe9U6RBM
         MCsR9sxkasM48cgBikgv5LujHLn3XCVFuce3I5lM6ElJjnMfg69DSJkhQ6I0piB7G7Jm
         rgij5/qp/UzLhz76d5NcGnqP7Z371FpiMxGdPaTdB/c6r9TNVVdfs2OhdoJEJzwVg++z
         eU12O+nu/AnvkkkwIcIy55qTQKD7GMHGcDIc/RK1EVSNhJ0AHXjkznTPvblfFmvUQi+X
         l8Hr0n1w7dcNO/xf3a1RO0xyTmgBKkUr1fJqyOytxIyf54nc7pE9rBYFZN4jUM6DI39i
         pkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t4u/kAIed02Wt2quW7e3LI/PP2g01D4YOTswdqhIIpU=;
        b=XNdWnHGadhBP0xhzZ3vXhKQvym2zgZcQy6p/FiWM4hNTVrUfCd2fIfvZ0juZfPCNT/
         +BVhYNL4Vc6xC8N4QHK42ugu7rfVw4dKDEiIWtP6g0u5YJlxqrPb7DiNTShaNjXM6Soi
         sxIxDOqa4tgspl9UZehgji5vDEczkbtljG7lbtFP2znUxnZ+A4SjiLUpnM5wuXI8qlaW
         hC6JVAYH96MdUO4UE48hIMZHA3GF2pLkUh+kWl3BpUNxuhTF71uWGCpBzj/fz4zCNACD
         +idU3EuZTyWvr8v5zYF+hL6ofArHqKecQ7iVM96me/m2vQRJ7OwnFtfaeTcqUFdxaRsl
         hd8A==
X-Gm-Message-State: AOAM5313rZhrO35NRLw1knszXEWw21aiKYecEvLvq7O3ksB05SFMA9nA
        jFffJe1CBwtXdJMu+IzTNbRoIg==
X-Google-Smtp-Source: ABdhPJzRrS+RO4qUS2hpKc9YqL+Rp8OwAXaMyZd3Jiyk/3xYMaBIJpOPhvxUv/tadXJKszJym0cuzQ==
X-Received: by 2002:a02:c906:: with SMTP id t6mr82100jao.117.1624461477435;
        Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t6sm97967ils.72.2021.06.23.08.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     dkadashev@gmail.com, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: add IOPOLL and reserved field checks to IORING_OP_UNLINKAT
Date:   Wed, 23 Jun 2021 09:17:53 -0600
Message-Id: <20210623151753.191481-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623151753.191481-1-axboe@kernel.dk>
References: <20210623151753.191481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can't support IOPOLL with non-pollable request types, and we should
check for unused/reserved fields like we do for other request types.

Fixes: 14a1143b68ee ("io_uring: add support for IORING_OP_UNLINKAT")
Cc: stable@vger.kernel.org
Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9b6c7dad0b73..45c606846303 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3504,6 +3504,10 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 	struct io_unlink *un = &req->unlink;
 	const char __user *fname;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-- 
2.32.0

