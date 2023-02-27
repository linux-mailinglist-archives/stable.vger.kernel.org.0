Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBBB6A393D
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 04:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjB0DIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 22:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjB0DIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 22:08:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683C8659E;
        Sun, 26 Feb 2023 19:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AD18B80CAE;
        Mon, 27 Feb 2023 02:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70810C433EF;
        Mon, 27 Feb 2023 02:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463491;
        bh=D77E3HGkEAgVD99HBKOVsC4nyEMEuQC/qaki7GUfkTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsUNoOFSXngM+Oymo7EwOILT8bJz+9uLoK96zkjpRvliL2RUQ+VP+GM2Qr8VjTXsr
         dEHcxbip8Oleg8Dml6AMqx+Gf4ieT3bPFi8DPQqY7iYpwUfqMvi5lUug5kcHDoQpMB
         p7Bh1heWuDZwpZ1oju6qeZdD+OluZZpnAet6ZFaJqhmquspLsEX+6NSmwTkRVgmRwb
         is9LUScRGKtfE1QNNbkmj3IxV2t7yiJ03SHUh5LcagSdCQPpk0VjO0BrRzYX/Zdar4
         ckC7F42KlrQxUNNREOdcKbHfMY6vB2YTrIxBk3EreDnlnyfuhwNWRkvPyfyeEG1Cpp
         O/7gEnpGSpjgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 6.2 56/60] dm cache: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:00:41 -0500
Message-Id: <20230227020045.1045105-56-sashal@kernel.org>
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

[ Upstream commit 76227f6dc805e9e960128bcc6276647361e0827c ]

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5e92fac90b675..17fde3e5a1f7b 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1805,6 +1805,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1827,6 +1828,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1867,6 +1869,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
-- 
2.39.0

