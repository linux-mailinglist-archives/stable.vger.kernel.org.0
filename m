Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853A545DE61
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 17:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356535AbhKYQNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356342AbhKYQMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 11:12:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F4860524;
        Thu, 25 Nov 2021 16:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637856522;
        bh=3UuzhmSP/V3v920tpSUyBSyVCTZdS6flxK4IwxjCSag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTBnD1Z8JkUNt2GshUi4VmmLZbfw6da+Ad+2iDfwk74ir1qlXhaQOGt6BAVMdIswa
         Cj9Wm4arsj+c80ZP1JWFBchKlPRHHg1bk2pQXkTDN0HRNm6WCHVdk6Xgha0QSyj+SV
         WzyWHaGKuZytFxkHVaDQpzXfzkGE+9uWojvj/3vG45KNEtbC6vRhOZGtYk+PBwaY7K
         IUyJb9u4vMR/2RhmjBr29rRigG6cBhbvGNtooLxtZJRVBl3+wrCmnfaoJHAqQKubTx
         3hRDN3Ga3gN6CQcd3DHbow8JQiGtEzEp+nfipsfi7LBcnqkH0PGAR1bJqyH4f3+BPn
         5EguI4QXF83Vg==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     john.stultz@linaro.org, tglx@linutronix.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm/damon/core: Fix fake load reports due to uninterruptible sleeps
Date:   Thu, 25 Nov 2021 16:08:30 +0000
Message-Id: <20211125160830.30153-3-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211125160830.30153-1-sj@kernel.org>
References: <20211125160830.30153-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Because DAMON sleeps in uninterruptible mode, /proc/loadavg reports fake
load while DAMON is turned on, though it is doing nothing.  This can
confuse users[1].  To avoid the case, this commit makes DAMON sleeps in
idle mode.

[1] https://lore.kernel.org/all/11868371.O9o76ZdvQC@natalenko.name/

Fixes: 2224d8485492 ("mm: introduce Data Access MONitor (DAMON)")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index daacd9536c7c..8cd8fddc931e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -979,9 +979,9 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 static void kdamond_usleep(unsigned long usecs)
 {
 	if (usecs > 100 * 1000)
-		schedule_timeout_interruptible(usecs_to_jiffies(usecs));
+		schedule_timeout_idle(usecs_to_jiffies(usecs));
 	else
-		usleep_range(usecs, usecs + 1);
+		usleep_idle_range(usecs, usecs + 1);
 }
 
 /* Returns negative error code if it's not activated but should return */
@@ -1036,7 +1036,7 @@ static int kdamond_fn(void *data)
 				ctx->callback.after_sampling(ctx))
 			done = true;
 
-		usleep_range(ctx->sample_interval, ctx->sample_interval + 1);
+		kdamond_usleep(ctx->sample_interval);
 
 		if (ctx->primitive.check_accesses)
 			max_nr_accesses = ctx->primitive.check_accesses(ctx);
-- 
2.17.1

