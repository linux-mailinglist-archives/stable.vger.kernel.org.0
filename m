Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EDF6A3818
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjB0COk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjB0COE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:14:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B940A1A497;
        Sun, 26 Feb 2023 18:11:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0BDA60DB6;
        Mon, 27 Feb 2023 02:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBB5C4339B;
        Mon, 27 Feb 2023 02:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463908;
        bh=TzYeOkBi/6uFsa5JfvKkTlX4iUTVOLR7WgliN2nuPzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZdFWw5Bbx4bDLg2Y8PM0crsSdGjv0TdJRj6W00qQlgxsucndY1moQXetkzmgPOVe
         NFMCpzd9M7oes7YQLnxp58ZysIlcqm6IL3/UbrQipQy8TfBGO+TTjf7ej9/GYDOv2Z
         XzBRfHUSKt1KSXyHY0+31H8x4bQ0q8mcOk/CdNWZykxeYHQsDcR4LYMS50+jMgvxUx
         iEU0jOV5BnTrGJhcgiw+AMGewEnlUX55OJk3dmsXuL0H+KTJLa2Lr2EwNck0PC8NuK
         0V5B+uRVO96NIBHzAUcUou5GMtQBLn+Y+PySPGWE5RrlQ6J90BANY+22zKmgFv4NFk
         m8Lp2nLFvovlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 8/9] dm thin: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:11:30 -0500
Message-Id: <20230227021131.1053662-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021131.1053662-1-sashal@kernel.org>
References: <20230227021131.1053662-1-sashal@kernel.org>
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
index 6c7fa790c8ae6..fcf1eaafec72d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2233,6 +2233,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2316,6 +2317,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.39.0

