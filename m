Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCD0631580
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 18:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKTR2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 12:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiKTR2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 12:28:13 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C4320B
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 09:28:12 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id v17so8661321plo.1
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 09:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LkqzqvF/knzjUasduD/iS7lgrm2MeIBBhxzdjzsoUM=;
        b=0rTI5eUh+faPvBoSv4jP7lKUmcnz3mFpfmdd5GeX32U49agtyEoIgRFCzRBrAH03b8
         I0kGWX2bZL5EaaELvXu1lhBUwXcmhyotwCnkNHS3cVGc6nBAZU/SkMMz3ixpiJKdRbrh
         Gay0ig17uXIXnHmbFuTehOQ0XaCej6u4SmcEJjinCVa7B2YobUSdmNf53kp5x9Yi59YM
         7Vvq7B72RNmgr1MZVHiP213rSvdoS4VIMN8mD9Dhq5qD6uQmeMdmFZ3c5pbEUNSlm/WF
         8Y61kTqXR+ANgELknP3WsgPCRNSunojGO1NSj2WWyjISg6Ox8rqtJ9UMLeYxG2Y9rBR9
         cTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1LkqzqvF/knzjUasduD/iS7lgrm2MeIBBhxzdjzsoUM=;
        b=75l3b2JOT46N1OpSAK85tO0IbCODMcSKeb0b/uWrWMjYHoEgihWKI2mxry0O8gddOB
         gok+wE02V/0eVtxHL4+g5ZS9jJEwkMJWfTRAV8DiN4DNjPXiC7+gho5zQ4/SywGClqID
         B16wxYkehD8WMmIHK9LFSjkf2aiHcnNDPE3o0WwWt9lXkbRhEiMJ4AQRz81r3OKygjNn
         qKtWq4VY6vinNA6qX91C00+t/tFoWLPZZkr7gAVpaXn1N7jIa5d3ZXzrRbTnhCTzPtzG
         1uC6xIqYhR+70uFAf0y/rUDKhUsvtoR1EBpsqdlyuRn4m7k0Qgg+yxQfY/Yh2ykh0TG2
         DI4Q==
X-Gm-Message-State: ANoB5pkdshWlfJ4vyAVJX1FGDxUSFZkP8yTE4UIS+E0OpFXo/IqMp5u1
        HAt6SKUYfqL7CkNQwKY0LjTSPahc2tKJSw==
X-Google-Smtp-Source: AA0mqf6Xc+ZETcQQ/wv3RORTymlVOWVPAn+fGhOouEcA24JHeUF4XeBZGKztuN8Kfvrq9VG+66wlkg==
X-Received: by 2002:a17:90a:c78c:b0:213:bbb4:13ce with SMTP id gn12-20020a17090ac78c00b00213bbb413cemr16452436pjb.246.1668965292339;
        Sun, 20 Nov 2022 09:28:12 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0017e9b820a1asm7876953plh.100.2022.11.20.09.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 09:28:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 2/4] eventfd: provide a eventfd_signal_mask() helper
Date:   Sun, 20 Nov 2022 10:28:05 -0700
Message-Id: <20221120172807.358868-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221120172807.358868-1-axboe@kernel.dk>
References: <20221120172807.358868-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is identical to eventfd_signal(), but it allows the caller to pass
in a mask to be used for the poll wakeup key. The use case is avoiding
repeated multishot triggers if we have a dependency between eventfd and
io_uring.

If we setup an eventfd context and register that as the io_uring eventfd,
and at the same time queue a multishot poll request for the eventfd
context, then any CQE posted will repeatedly trigger the multishot request
until it terminates when the CQ ring overflows.

In preparation for io_uring detecting this circular dependency, add the
mentioned helper so that io_uring can pass in EPOLL_URING as part of the
poll wakeup key.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventfd.c            | 37 +++++++++++++++++++++----------------
 include/linux/eventfd.h |  1 +
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index c0ffee99ad23..249ca6c0b784 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,21 +43,7 @@ struct eventfd_ctx {
 	int id;
 };
 
-/**
- * eventfd_signal - Adds @n to the eventfd counter.
- * @ctx: [in] Pointer to the eventfd context.
- * @n: [in] Value of the counter to be added to the eventfd internal counter.
- *          The value cannot be negative.
- *
- * This function is supposed to be called by the kernel in paths that do not
- * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returning a EPOLLERR
- * to poll(2).
- *
- * Returns the amount by which the counter was incremented.  This will be less
- * than @n if the counter has overflowed.
- */
-__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask)
 {
 	unsigned long flags;
 
@@ -78,12 +64,31 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
 }
+
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *          The value cannot be negative.
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returning a EPOLLERR
+ * to poll(2).
+ *
+ * Returns the amount by which the counter was incremented.  This will be less
+ * than @n if the counter has overflowed.
+ */
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+{
+	return eventfd_signal_mask(ctx, n, 0);
+}
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 30eb30d6909b..e849329ce1a8 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -40,6 +40,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
-- 
2.35.1

