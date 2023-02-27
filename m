Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A3E6A38E4
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjB0Cku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbjB0Ck0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:40:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A825F4C0E;
        Sun, 26 Feb 2023 18:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 835CAB80D0B;
        Mon, 27 Feb 2023 02:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB25AC433D2;
        Mon, 27 Feb 2023 02:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463792;
        bh=o5sl5e9QI2UwLSr5fQOx7iBrr2zCoNpV/NN0aAhh9C4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXL6GkOdkTYlhNtXF9Ll1YOJaeVyBqBgMj8V+h/7+QX8Edb9cSPoHuWnHFpNjN5UY
         hw0jVP5T4h7uO++9DKMw9o+4c0KoC+4KgaN0qOSFqguAmo9PzpzTIGpKTJOLAZuk36
         C+ysX7eG+3sFvY3LyT1S9JMcwosL12m6Jnubwhvm3NWtsyqFBROTuwA1GS2gAk20I1
         thczU4GRNyqW2oRuXtxfLtHZcjLUqp1TN0mqTDfhA5BWkT/p/5dyodH3xLHDHKhGW1
         DfgBqorPIN76+u4EFcep1ZO/0VrTs5cmrKb4xt+jHBrpVgTsV3+9D/7kr9cWKNdX1K
         NTspkgEMJNQ8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 24/25] dm cache: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:08:47 -0500
Message-Id: <20230227020855.1051605-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
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
index abfe7e37b76f4..24cd28ea2c595 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1813,6 +1813,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1835,6 +1836,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1875,6 +1877,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
-- 
2.39.0

