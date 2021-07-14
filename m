Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519F63C8D6B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbhGNToJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhGNTnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B6B2613D6;
        Wed, 14 Jul 2021 19:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291628;
        bh=AjHawVr3go6Y59i28M1JkagyDfBTiiixVvUEQJzu2sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBPWMNDmxwKrkj6YIUj424cydBkdKryrFjg8u+LX0D7v6CL9k94W3Zu4lpvc0nU8C
         2r64otulCcEX089aYKNGSa9r3tcNSqDF/PUmk+sOK4BwFgtftp3Lt1VK6VKZvTarSh
         YPQoIMpa55yaIK8A+Y5SVBufd0Ei5Z8HK63SUWMf8cp6SmvAhFUkDlrWa9/cOqNAlC
         KoDDEWRNxtYQTFkFOlvKSQBSLB4TMgedTGF9N3hknplWKaI6Icnn2kQnz81y3xx7v6
         8dzJskr8TSWCGjHz7yVdxuj2Nct8Blb1GWa92MsJ88KY3+l0B7Tz/+462Wi6kssDua
         /es15qquy3gLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Odin Ugedal <odin@uged.al>, Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 103/108] sched/fair: Fix CFS bandwidth hrtimer expiry type
Date:   Wed, 14 Jul 2021 15:37:55 -0400
Message-Id: <20210714193800.52097-103-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 23663318fb81..62446c052efb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5108,7 +5108,7 @@ static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
-	u64 remaining;
+	s64 remaining;
 
 	/* if the call-back is running a quota refresh is already occurring */
 	if (hrtimer_callback_running(refresh_timer))
@@ -5116,7 +5116,7 @@ static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 
 	/* is a quota refresh about to occur? */
 	remaining = ktime_to_ns(hrtimer_expires_remaining(refresh_timer));
-	if (remaining < min_expire)
+	if (remaining < (s64)min_expire)
 		return 1;
 
 	return 0;
-- 
2.30.2

