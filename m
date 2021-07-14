Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1867F3C9020
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbhGNTxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240936AbhGNTuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89E29613E2;
        Wed, 14 Jul 2021 19:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291981;
        bh=ZZEOMJsgSEtf11lh18xZSy/hYxgWup88UeZ+rt8HSeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9WykRKB+/lBWaIxOfeTtDNK45gRAv+lxcFzsITudx3j9kT6DsgU8Rpllge4faL9r
         ueiWMt//MbUnpHEgpfIcX9XgL1TjtqgqtM+qihKXU4NAigHzJCIoBMz7JO2yacDP6n
         UOkUQ5vdMn6Ar/y6qIQW70tNhRAoPE+TH2PCmbBRkTokHJLTTwz9DoQQib7Hn1wFrn
         XRWEX+GEbp1SyLkP7rWjBLaM7SwU89hh9Cnk96k80h1dtExaqtyRogh5PkHfshoLRF
         pExPw6Bj/0TZsXbPxxjE7kn3YvZGvJoMJUviaSgUospN1XTts981bN8VmpEtW+aRaC
         r57QGm8apmvvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Odin Ugedal <odin@uged.al>, Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 49/51] sched/fair: Fix CFS bandwidth hrtimer expiry type
Date:   Wed, 14 Jul 2021 15:45:11 -0400
Message-Id: <20210714194513.54827-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index d3f4113e87de..94bf2e44a45a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4786,7 +4786,7 @@ static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
-	u64 remaining;
+	s64 remaining;
 
 	/* if the call-back is running a quota refresh is already occurring */
 	if (hrtimer_callback_running(refresh_timer))
@@ -4794,7 +4794,7 @@ static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 
 	/* is a quota refresh about to occur? */
 	remaining = ktime_to_ns(hrtimer_expires_remaining(refresh_timer));
-	if (remaining < min_expire)
+	if (remaining < (s64)min_expire)
 		return 1;
 
 	return 0;
-- 
2.30.2

