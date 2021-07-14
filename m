Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453663C90D1
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbhGNT4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240394AbhGNTvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C622613B5;
        Wed, 14 Jul 2021 19:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292111;
        bh=Ptn/D3BKAPwThCszw8ZpXF1NedydCCKuyQP5zXLUWnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCT4NJP+Y1LAk1VfoVKr2W5ojMThXRQ0Eh5dBmUkLmlcGuxoZTdestBdA2uFzu8uS
         XNdHFcxEmuB6hi+EGYEHHLj7rnWbhs7faszVOda+7CnbBdgMCi3nIFyh5gWflX0F03
         xQwo4p8VuGhPIz9u44ZRNy0vuSxCaxSjIcmGzTbpKvIgFiZsW9QkI/7Gp6BPw3XcL8
         W1CRkuRV8S+5rbjWyPbtaTWrz5uEDXvrYD9UCgjEE5r/U5WCLkLNnDHvLHVNwAEkhk
         JW4Gg20TH9FPsEvqR7tcqD3wH9xb57oW/J/k3IpVfGhf33suRZvXRX013eekbYNPtY
         4t59iiMbllqcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Odin Ugedal <odin@uged.al>, Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 18/18] sched/fair: Fix CFS bandwidth hrtimer expiry type
Date:   Wed, 14 Jul 2021 15:48:06 -0400
Message-Id: <20210714194806.55962-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194806.55962-1-sashal@kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Odin Ugedal <odin@uged.al>

[ Upstream commit 72d0ad7cb5bad265adb2014dbe46c4ccb11afaba ]

The time remaining until expiry of the refresh_timer can be negative.
Casting the type to an unsigned 64-bit value will cause integer
underflow, making the runtime_refresh_within return false instead of
true. These situations are rare, but they do happen.

This does not cause user-facing issues or errors; other than
possibly unthrottling cfs_rq's using runtime from the previous period(s),
making the CFS bandwidth enforcement less strict in those (special)
situations.

Signed-off-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Link: https://lore.kernel.org/r/20210629121452.18429-1-odin@uged.al
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5a349fcb634e..39b59248d9c3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4196,7 +4196,7 @@ static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
-	u64 remaining;
+	s64 remaining;
 
 	/* if the call-back is running a quota refresh is already occurring */
 	if (hrtimer_callback_running(refresh_timer))
@@ -4204,7 +4204,7 @@ static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 
 	/* is a quota refresh about to occur? */
 	remaining = ktime_to_ns(hrtimer_expires_remaining(refresh_timer));
-	if (remaining < min_expire)
+	if (remaining < (s64)min_expire)
 		return 1;
 
 	return 0;
-- 
2.30.2

