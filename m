Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1C3635BD
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 15:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhDRNwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 09:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhDRNwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 09:52:49 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511A4C06174A;
        Sun, 18 Apr 2021 06:52:20 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so16560646wmg.0;
        Sun, 18 Apr 2021 06:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wKD1FxT0pks2xiaV2Zv+XN1OoULmjBJ8hKuuLnzIsOI=;
        b=sUtv/uLmzNLH0dS9+a6iRo0e+SXcSOUZ1Cqm8+BqcXIIFMmuzTMch6XTw0ofh5UhgL
         JGzJDQvqxsrhMXo3z9JveqIl8yXhtqRyIQFi0tK53wCMWI/hNTdvJUbo9j/eKxymi7yM
         yJT8ZFsSOHdb1+6TXiPBpMctQRKYqnpUsABbncie1AJ1Cx3K2di9eme+3tszlgwhmIRd
         mboW9NY1ldP13G84JHGYcdNcno/MCEqb6d0gvlbE2CLFnDwsILL47ew6c+AvFcALG1Du
         Cm1sIsGWm3aQLVc3m1HJvXOG5QvrJlJ3AbvnY44hUKV9YAzXMXEi1H00PAR/1z+Y9Vxn
         yEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wKD1FxT0pks2xiaV2Zv+XN1OoULmjBJ8hKuuLnzIsOI=;
        b=rHiq81k4rCbMSvXbg0ucDrLDFwptDVMDEawVcwFWPR4yBKacdiNyV51/dvMxOQslP5
         YedxrGHBv9l9KbFUoOo3g2Bl6tGEi5+26m6wR2FWoqqdQJcY4EJa3GOUgkLIqoBHvc5d
         wMyzc8nXaJdSKUb3Ol/3+BzSIeKrlwG3wikqW0VM0ncTMWu9y7RedfOuTJhP36YzXNCv
         b8lMgmhv4R0pT8bi+AvJlxSJEyapZD9RlEglZI+smWSrT4aRjvZhU9CU13FsTd2w3ABR
         PGygIvVGFksmCXmbbe0jhS8uEgxizmnPjDTOeexDXTDBvwgtCFBk45GZzFHZjL95lpi9
         VCFA==
X-Gm-Message-State: AOAM531zlTFoKddHsAOi3d14ZFKxWVVT7+/XLtcYjhGVRlx9e/saprtu
        qmm96vvcigoZAT6/zKYxq7s=
X-Google-Smtp-Source: ABdhPJwf+dRhvaTT5HVJTGIBl724dZMgeGpQKSESa4chRfJX8k9wuiMv8QMFzYL6fv5CK4IHacHp7Q==
X-Received: by 2002:a7b:c303:: with SMTP id k3mr17469091wmj.100.1618753939158;
        Sun, 18 Apr 2021 06:52:19 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.62])
        by smtp.gmail.com with ESMTPSA id f11sm16320397wmc.6.2021.04.18.06.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 06:52:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Joakim Hassila <joj@mac.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: remove extra sqpoll submission halting
Date:   Sun, 18 Apr 2021 14:52:08 +0100
Message-Id: <f220c2b786ba0f9499bebc9f3cd9714d29efb6a5.1618752958.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618752958.git.asml.silence@gmail.com>
References: <cover.1618752958.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SQPOLL task won't submit requests for a context that is currently dying,
so no need to remove ctx from sqd_list prior the main loop of
io_ring_exit_work(). Kill it, will be removed by io_sq_thread_finish()
and only brings confusion and lockups.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e02a18cd287f..fb41725204f0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6744,6 +6744,10 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
+		/*
+		 * Don't submit if refs are dying, good for io_uring_register(),
+		 * but also it is relied upon by io_ring_exit_work()
+		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
@@ -8537,14 +8541,6 @@ static void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
-	/* prevent SQPOLL from submitting new requests */
-	if (ctx->sq_data) {
-		io_sq_thread_park(ctx->sq_data);
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(ctx->sq_data);
-		io_sq_thread_unpark(ctx->sq_data);
-	}
-
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while
-- 
2.31.1

