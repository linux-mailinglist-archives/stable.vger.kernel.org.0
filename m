Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403C36A38C2
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjB0ChC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjB0Cgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:36:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB0076AB;
        Sun, 26 Feb 2023 18:36:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9644FB80D0D;
        Mon, 27 Feb 2023 02:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC892C433A1;
        Mon, 27 Feb 2023 02:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463833;
        bh=ALuaIbzk8S1R0GeiCLVQTPLSGjbmj8Q+HySnj5fb4+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9tBchWlulX6zmMcQrGmYz/Mx3zmXgsDsnvzS2OPYX25pDNfOfp6tZcLwq2hdzOut
         YaSH6YdzutRUVrYcNb1UmoCoKXE7HYFt6riFOiC9iJT8kddR8g2RMkyG7xXwBg5gOa
         wNYrL6G/IquCl/v8GyGO83u0ze+Z+z834efzjUs4tZBgcp8H9EIVcN12Eh/65Gk0EM
         ZNnKJ70t4PO8t29lepM7RGWin2PiMvDDvV5J/cyhR21obnvHF8QVyGgeVltPiSNHjT
         sK+Hw/9SHJ3f9jTF24dRpmd+QtN6pHrpAIu8uikV5+o/PvHuxI2FuZ/WXvSw2ly5qc
         adqvAf10XaG1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 18/19] dm cache: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:09:53 -0500
Message-Id: <20230227020957.1052252-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020957.1052252-1-sashal@kernel.org>
References: <20230227020957.1052252-1-sashal@kernel.org>
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
index 9b2aec3098010..f98ad4366301b 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1883,6 +1883,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1905,6 +1906,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1945,6 +1947,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
-- 
2.39.0

