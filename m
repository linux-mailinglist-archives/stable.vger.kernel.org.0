Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AF265C662
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjACSjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbjACSji (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:39:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616FC10545;
        Tue,  3 Jan 2023 10:39:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2A25614E5;
        Tue,  3 Jan 2023 18:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB33AC433D2;
        Tue,  3 Jan 2023 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771177;
        bh=MJ5SKjpuNXN7nTVgbqgOgg57SEOydv8nZXXmH8INOWQ=;
        h=From:To:Cc:Subject:Date:From;
        b=PEXg0UzIkPrjNyYc12HuJUxPgyzLUyr2n736gofQZHCLFNSqGpYyOfQaGFhPML60I
         F4q5nK7SHlGZEnbXLp5Vl2JfYMtYOnDdCQnLts3VjOnCUovVs/e0a804xPhXYLrK8m
         RRBbFGdIbbY8lc/IGBb72PFTVgw4puGaifCRYsoQjprfQm2sGR18KBM46w6gsN2ulu
         tcwZmser+dmkn7f5VWDfPhC634Pczmx55/uDvYwsa/RwwGFB9j5xzAwZESSqgMsVWJ
         ZFv9TLkEJHZp3Hjg5H1S8lOUooajDQuLXfAUo7/JUSaCCSXf0gLV9sUMeZ8xU0PW6g
         RvMkwpC68KTAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/10] io_uring/cancel: re-grab ctx mutex after finishing wait
Date:   Tue,  3 Jan 2023 13:39:25 -0500
Message-Id: <20230103183934.2022663-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

