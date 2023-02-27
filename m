Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988E26A3804
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjB0COD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjB0CN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:13:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19ECD1D930;
        Sun, 26 Feb 2023 18:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 657F360DDC;
        Mon, 27 Feb 2023 02:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B3AC4339E;
        Mon, 27 Feb 2023 02:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463864;
        bh=TFsOR6NeE7zcPdXNPlRwoxEln2VgzWQhrm/gQJPV2uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYXPKf7FswqkPb3uhZfd6pineAH+Whf+N9g7TTv5vyq6zZdSVJDz0pItQ/1FS0ra0
         1IH8kLz7HggyKPAxabp+Yyz56+AAroByy2OZy2GZXyllAsh7BA04+z1ZpzM1aNAGh6
         sQKVx4YQiCCtMVspoNqKa3H6lTLSkGuROWihA2zIcUSq+dnlA6b2jV7FgKgjRy+r2D
         tlXStFh93JKhNigbID1MQ7qP1r59zLrF1q1FjFahJV7ojJc5LY/pV/mCwZTQXhUe8q
         G3AOfV1jhpvCuxiSyjzBTFoeFEw0rewfU7Kc4RjgQJ6YjUbL5vV4BLUaGtKcw5PPjS
         qKN6QNkc259mA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 13/15] dm thin: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:10:32 -0500
Message-Id: <20230227021038.1052958-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021038.1052958-1-sashal@kernel.org>
References: <20230227021038.1052958-1-sashal@kernel.org>
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
index 4f161725dda0a..999447bde8203 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2224,6 +2224,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2307,6 +2308,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.39.0

