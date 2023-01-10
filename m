Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4C664970
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbjAJSVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239149AbjAJSVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:21:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC8B96119
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64D46B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F94C433D2;
        Tue, 10 Jan 2023 18:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374734;
        bh=MJ5SKjpuNXN7nTVgbqgOgg57SEOydv8nZXXmH8INOWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX9xlxloYL4+q4twjIAtqf92JOtwZdJYZEZo3hQUpcWG11Oq6L0G/Ivwe1AFAjPGC
         sxCGqGa9fNQYyTRZGA5v3IXhLt1QjddgnrvwdIvXqfkdkaHF3CRPK2KKmny+iuR7z9
         rgVreOUHTE/qS1UnNfVFVnPDUrgnezlmM4fJdgvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/159] io_uring/cancel: re-grab ctx mutex after finishing wait
Date:   Tue, 10 Jan 2023 19:04:24 +0100
Message-Id: <20230110180021.996709928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 23fffb2f09ce1145cbd751801d45ba74acaa6542 ]

If we have a signal pending during cancelations, it'll cause the
task_work run to return an error. Since we didn't run task_work, the
current task is left in TASK_INTERRUPTIBLE state when we need to
re-grab the ctx mutex, and the kernel will rightfully complain about
that.

Move the lock grabbing for the error cases outside the loop to avoid
that issue.

Reported-by: syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/0000000000003a14a905f05050b0@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 2291a53cdabd..b4f5dfacc0c3 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -288,24 +288,23 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 
 		ret = __io_sync_cancel(current->io_uring, &cd, sc.fd);
 
+		mutex_unlock(&ctx->uring_lock);
 		if (ret != -EALREADY)
 			break;
 
-		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig(ctx);
-		if (ret < 0) {
-			mutex_lock(&ctx->uring_lock);
+		if (ret < 0)
 			break;
-		}
 		ret = schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS);
-		mutex_lock(&ctx->uring_lock);
 		if (!ret) {
 			ret = -ETIME;
 			break;
 		}
+		mutex_lock(&ctx->uring_lock);
 	} while (1);
 
 	finish_wait(&ctx->cq_wait, &wait);
+	mutex_lock(&ctx->uring_lock);
 
 	if (ret == -ENOENT || ret > 0)
 		ret = 0;
-- 
2.35.1



