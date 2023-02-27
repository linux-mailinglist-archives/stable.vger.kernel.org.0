Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934046A380B
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjB0COK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjB0CNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:13:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E471DB81;
        Sun, 26 Feb 2023 18:11:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8979FB80D05;
        Mon, 27 Feb 2023 02:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C07BC433EF;
        Mon, 27 Feb 2023 02:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463791;
        bh=hcKVy1UVzeZ3zBW7iGwMXdYSK+FqXa/tQ546xQkNxu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sk6qan8tj7/6gPK7Tj9SGpY3e829o0iO41YYi9BUxCoiTEGbwt8n9miKuJfvLgaBR
         +bKxFUD4p9GHtDsr10/n4kCwUBMkB1sCvxJVfHKNI6aBkCt0ChF9nBeFcbOP3049+X
         k1HndAgxXkCvIjFmnrK0gQKLrJMDuQvaERqkPRkYmQ0Qd/6ZJ4g4ONiYHKd0LL42Ur
         FHApsG2tPlHAjkmWA4ex6H3JIfOKpJhhPGUJij0L96owd0G5J8sbBtQTsmSKqndwxM
         QTofitMJ6NuuoscFMqZYhkZrqmRdqIcUzwPNQmQ7oHeK45c+VEBJ16wVec77sucYfD
         vgdXI5qf2LpnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 23/25] dm thin: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:08:46 -0500
Message-Id: <20230227020855.1051605-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
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
index cce26f46ded52..f7124f257703c 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2217,6 +2217,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2299,6 +2300,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.39.0

