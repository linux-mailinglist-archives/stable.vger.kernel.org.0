Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD26A3723
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjB0CHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjB0CGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:06:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BC2166EA;
        Sun, 26 Feb 2023 18:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D028B80CB1;
        Mon, 27 Feb 2023 02:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715FDC433A0;
        Mon, 27 Feb 2023 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463490;
        bh=5rQ76zL1A5K1wFraI3r4TvTnALCgd/RxsLGArs/sTog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=An1SsGieYb2EO0V5n9bclCprDYG6A9iv0ZgLyXbbmfJ59+do3OxJdRFPPuczU1KEY
         e7F1VzuFBBwNhTPCpyjpnaawD4vMUuZlLWxRjAfApOWM0MfWfuCa00oDh+gMBmuJCA
         uU6dhbEeN4qgUc2YRI4LFZy38I4seE+eT+RcvcWOPazVrElSV/hSGXisMoQXcNR2Tm
         2hi+T1SrfTwsOi1AmqoMSzEPBNWWhy02csjAmOIswxS3V4xjb/bl805BmLTcERKV+/
         hW1NIvKXd24Oy5AuNIhxbc8y8UGmvjtqth6gNzNhso9bsCjrz4+P9xUwbVXSUWU+Lw
         oinuwPfZP0t1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 6.2 55/60] dm thin: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:00:40 -0500
Message-Id: <20230227020045.1045105-55-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e4f80303c2353952e6e980b23914e4214487f2a6 ]

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 64cfcf46881dc..e4c1a8a21bbd0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2207,6 +2207,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2289,6 +2290,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.39.0

