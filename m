Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978BB6A3819
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjB0COl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjB0COF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:14:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD3C12BF4;
        Sun, 26 Feb 2023 18:11:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0159860DCE;
        Mon, 27 Feb 2023 02:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CECC4339E;
        Mon, 27 Feb 2023 02:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463909;
        bh=IQEcbfd7yzhQH0QRGQChGt/XAXmsS8wZwVSHzwmk7MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jspkH9qcidlOXaGkd3oNDezi9Cv9xE+vL1fnoxdnboDhtyHdPPsK5hoWXhOFh2bUb
         lQe7ucjKDq5c/lKbgtm1oetiAxZhzJrLBjYsXQq3r6ereOkwhrsZ0QiQrU+xWjn2Wb
         sdCBJDUz93PBPEf7zMioR8AplCVdo8kNKPfmuLltMMeU9WUtpN/niMSfl/SzkCJ7Lt
         9oQQwq9UrBzdNDA2Mvg3P06Vil3ggvc5I0H+2ZjdtYw4y8Zks255NOnraxIgIqsE9a
         eWD61XNarxLvR6czslxGV/AN13xfURTIfVZ270DIi7pXCqJzlH+VrA0qzA8tUQ+3dT
         TlVufQOmh6NpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 9/9] dm cache: add cond_resched() to various workqueue loops
Date:   Sun, 26 Feb 2023 21:11:31 -0500
Message-Id: <20230227021131.1053662-9-sashal@kernel.org>
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

[ Upstream commit 76227f6dc805e9e960128bcc6276647361e0827c ]

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5458a06971670..590aff275acb8 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1952,6 +1952,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1974,6 +1975,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -2014,6 +2016,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
-- 
2.39.0

