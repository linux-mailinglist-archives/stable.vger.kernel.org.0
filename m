Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432676148C5
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiKAL3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKAL3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4060B15;
        Tue,  1 Nov 2022 04:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62A2E615D4;
        Tue,  1 Nov 2022 11:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28361C433D6;
        Tue,  1 Nov 2022 11:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302112;
        bh=zR2VOIOlFiLeKD8mLniZemC5q0Y54iEGRXSvder+ekc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZPcWEZiWHrt1EpgEzjnXqZxauOR9MN0341VlmZV/tyjDZxOlrOhzEgdEraS2+uv+
         H2K24ujmc0HIsyxCDvabWpcAIW9z28yYnd5qLGCZ3Rb9Rq+80UanoJxfSI+izZD7wd
         zMTmgHRaaS+ydsILigcgqTj64mJLE08JbVyJLvMAndtQ4QQio1KNXsWiuNKmkfY+GU
         TMSGHwkqw0Pxw7tU8/hkpfA6WUym7QAytPo84h8QTKQzcXd9IZSjn2RzpNFh8r3Ulr
         /erx/fIf7p944fl4kW17Fj9fWot8fZTqG5cJvFc6rs6doQyrLBf8k2Y+KQChtp7QtY
         G0PBlT3ocH31w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 23/34] io_uring: don't iopoll from io_ring_ctx_wait_and_kill()
Date:   Tue,  1 Nov 2022 07:27:15 -0400
Message-Id: <20221101112726.799368-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 02bac94bd8efd75f615ac7515dd2def75b43e5b9 ]

We should not be completing requests from a task context that has already
undergone io_uring cancellations, i.e. __io_uring_cancel(), as there are
some assumptions, e.g. around cached task refs draining. Remove
iopolling from io_ring_ctx_wait_and_kill() as it can be called later
after PF_EXITING is set with the last task_work run.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7c03cc91455c4a1af49c6b9cbda4e57ea467aa11.1665891182.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c5dd483a7de2..d29f397f095e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2653,15 +2653,12 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
 
-	/* failed during ring init, it couldn't have issued any requests */
-	if (ctx->rings) {
+	/*
+	 * If we failed setting up the ctx, we might not have any rings
+	 * and therefore did not submit any requests
+	 */
+	if (ctx->rings)
 		io_kill_timeouts(ctx, NULL, true);
-		/* if we failed setting up the ctx, we might not have any rings */
-		io_iopoll_try_reap_events(ctx);
-		/* drop cached put refs after potentially doing completions */
-		if (current->io_uring)
-			io_uring_drop_tctx_refs(current);
-	}
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
-- 
2.35.1

