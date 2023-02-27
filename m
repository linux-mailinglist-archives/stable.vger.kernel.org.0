Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3646A38C3
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjB0ChD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjB0Cgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:36:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E7914E8D;
        Sun, 26 Feb 2023 18:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB94B80D07;
        Mon, 27 Feb 2023 02:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC14C433A1;
        Mon, 27 Feb 2023 02:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463722;
        bh=AUS3nLZcST/QqFsRDLTiaZNTG4Ebxu5e3iFzEsy2XRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y696I6W7jP6kRplxVjRef5STHkKHhsvzUVIblvF/LMBEEsMn9fhZ5eDVrSHwKQlMv
         V2bZFmBZ66Mg2dZloQo8jr63C77pIbBQQwJW3gujntcY0RF5l/05CdSdzbe8uA+dlM
         HRE6KOUgE9cnHVCGScmdNls4cY3fK5kwBBL1t9zFaTHppif5sHB4qIcpAyLc0+5l90
         CobsByslmYYXHuuDSaSDF7a8r0YniPEG97fd+PPjLI6QcNzspYlnGhXey2DHttn0IA
         U91mNQC8tC0x91x7Ub6aCA9yfSA9d/+1RzjsqnIJk93yeICBN7ZsGvyPF/hC1h+/Pr
         A07Y78+WSp8iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 6.1 53/58] dm thin: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:04:51 -0500
Message-Id: <20230227020457.1048737-53-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
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
index 196f82559ad6b..d28c9077d6ed2 100644
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

