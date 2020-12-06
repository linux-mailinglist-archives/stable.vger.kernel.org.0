Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9322D07A7
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 23:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgLFW1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 17:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbgLFW1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 17:27:01 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822B1C0613D1;
        Sun,  6 Dec 2020 14:26:15 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id v14so9958594wml.1;
        Sun, 06 Dec 2020 14:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L2/MEMTfd2VanoPXuAV+bQvvdS0lO+7tGI7L0mWtxrI=;
        b=SyyF38+THU/ACXGrxjRHqvmA5dAZn4CPYIY8z/Obk5xKGAFX3lHNItssXuEAStd/lu
         UoFXZgLpf9u9UA5/7OCEOqTI1fGyufclCKxsA67ozTe7SCIDWPZTJlvdFn9kgNpbHbgW
         djqlOatKX0KoiaB543lm53USsZ98yqQQsWacA/3WHnyYbViG4MiP2zp6plnlTLTkFrou
         09mvFsp3ZMjdNd3oAEPGjE3hUvxFBxvB5ClihB95yBpx4ISUUZqDNOboJvNLIFQhi53z
         ygOZwmgtsiOTMz6/forSdVphTGpCyU3SMK/6HQ3Vo4z0gzAvqTNGFDD7X8U+EsOlV45p
         pNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L2/MEMTfd2VanoPXuAV+bQvvdS0lO+7tGI7L0mWtxrI=;
        b=Hc4t7M/s62y04N9mzQ39I1TGcEW3hzZ4UAmGG3+Tag+GFTmvXrQNMiNgh1zqL7A3Z0
         iwIxDHyQA8ew8R/dFmKzyOVpOEcn1duALQ/l73mcecFAeQ75n/1xN1QfIJFDECeybiO0
         abtJHFDxfKNYggB8obt2Ut+rLLQKUwZqLuknyR3DMOu67iR2lW+CMpwiXVQbJQ4d0wlX
         DRCaJEtk5rv5Xa9RxxGSzRcQftJHBAvpnEr3c2qirVahHNyqoeZqpe4baWyV5K8aU6Yf
         NBsZVMJY2BYzKNh0mMlAAfK0NlsTBLbZeyn2tP3DItMZycwNlga1xVQNfL5smbxcl4PR
         nXEQ==
X-Gm-Message-State: AOAM530BYpbLO32rqelhUyYsQ+BAyG/EvwHbKU0QLU6y78Xev3EuKIE4
        7igI5VLT9H+6NK4zdZ5S8CNVitHOUQx98w==
X-Google-Smtp-Source: ABdhPJzk7VFHpl0dG4xkvmfqfD0oDeEqi5IcROsSOvu73aYLjGwtHm9tK/W20vlUnKOfqXQ113YxVQ==
X-Received: by 2002:a1c:80cb:: with SMTP id b194mr15427639wmd.91.1607293574348;
        Sun, 06 Dec 2020 14:26:14 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.92])
        by smtp.gmail.com with ESMTPSA id h20sm11284917wmb.29.2020.12.06.14.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 14:26:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.10 2/5] io_uring: fix racy IOPOLL completions
Date:   Sun,  6 Dec 2020 22:22:43 +0000
Message-Id: <3a8d4b11f6cbb28c5067fd77ba35c2995f4658be.1607293068.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607293068.git.asml.silence@gmail.com>
References: <cover.1607293068.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IOPOLL allows buffer remove/provide requests, but they doesn't
synchronise by rules of IOPOLL, namely it have to hold uring_lock.

Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c895a306f919..4fac02ea5f4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3948,11 +3948,17 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
 	head = idr_find(&ctx->io_buffer_idr, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
-
-	io_ring_submit_lock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+
+	/* need to hold the lock to complete IOPOLL requests */
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		__io_req_complete(req, ret, 0, cs);
+		io_ring_submit_unlock(ctx, !force_nonblock);
+	} else {
+		io_ring_submit_unlock(ctx, !force_nonblock);
+		__io_req_complete(req, ret, 0, cs);
+	}
 	return 0;
 }
 
@@ -4037,10 +4043,17 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock,
 		}
 	}
 out:
-	io_ring_submit_unlock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+
+	/* need to hold the lock to complete IOPOLL requests */
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		__io_req_complete(req, ret, 0, cs);
+		io_ring_submit_unlock(ctx, !force_nonblock);
+	} else {
+		io_ring_submit_unlock(ctx, !force_nonblock);
+		__io_req_complete(req, ret, 0, cs);
+	}
 	return 0;
 }
 
-- 
2.24.0

