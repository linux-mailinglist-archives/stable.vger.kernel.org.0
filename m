Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546076A3838
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjB0CQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjB0CPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:15:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4534DAD14;
        Sun, 26 Feb 2023 18:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1624B80D33;
        Mon, 27 Feb 2023 02:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF39C433EF;
        Mon, 27 Feb 2023 02:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463890;
        bh=FTUeRtfvTVBToQ+WRdjN+dpQ+lcHZwaJZKdEyRPT1jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzvcWTqkCBWS2FSu/6tzHETuiqNUiq+GRXr82g60TzT/ZBlibR55GHSh/MZx3wWD4
         wtRwPZvRytC1vdX6rqRW/R6an+LI42w2jllWul+lJveJNG/5RJl/QIyLksmhWT0agl
         BJRHuI1OQqujBkDC3sE+3zmzF1a/9N528jfzrmGpB/yp0LLv+u2EbNQUEg5r6cu/6p
         9mVgh/x1W70BEn5NmmVcjkfm0cPBcszOuSF07a/XXk4nGVqiN1L6Umq6Z0eP9wCMF3
         zK9pooke0JzAi3/y4T0nyHa3scYfabRweOcTky2exe4tMn4xy/JfxKsJfdM0rQ7G5y
         3iwwxhbC99xEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 10/10] dm cache: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:11:07 -0500
Message-Id: <20230227021110.1053474-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021110.1053474-1-sashal@kernel.org>
References: <20230227021110.1053474-1-sashal@kernel.org>
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

[ Upstream commit 76227f6dc805e9e960128bcc6276647361e0827c ]

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index df7bc45bc0ced..b3371812a2158 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1905,6 +1905,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1927,6 +1928,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1967,6 +1969,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
-- 
2.39.0

