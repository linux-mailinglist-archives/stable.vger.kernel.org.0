Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7752C5EA49A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbiIZLsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbiIZLrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DB874E11;
        Mon, 26 Sep 2022 03:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6329A60BB9;
        Mon, 26 Sep 2022 10:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725A6C433C1;
        Mon, 26 Sep 2022 10:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189268;
        bh=eJ+fDbbzA19SGMmU8INWJvoyHaXEcrggf1UMvpYzvDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYD6UDQIil3D8JnkolzbOtACoqohRpfiaSDfTXveowopuWLlvHtjGykXf+iUlO5AY
         hL1AdgpWDh9eBIiduPmrLXciL6K9HspPWTykD3pyXR1A+N/PY/52dhwutQuZGzyTjb
         riPzvm+vXLO9Vm7Lj2j1aGgxxSjki5IaZIEbUbLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 128/207] wireguard: ratelimiter: disable timings test by default
Date:   Mon, 26 Sep 2022 12:11:57 +0200
Message-Id: <20220926100812.286820125@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 684dec3cf45da2b0848298efae4adf3b2aeafeda ]

A previous commit tried to make the ratelimiter timings test more
reliable but in the process made it less reliable on other
configurations. This is an impossible problem to solve without
increasingly ridiculous heuristics. And it's not even a problem that
actually needs to be solved in any comprehensive way, since this is only
ever used during development. So just cordon this off with a DEBUG_
ifdef, just like we do for the trie's randomized tests, so it can be
enabled while hacking on the code, and otherwise disabled in CI. In the
process we also revert 151c8e499f47.

Fixes: 151c8e499f47 ("wireguard: ratelimiter: use hrtimer in selftest")
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/selftest/ratelimiter.c | 25 ++++++++------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index ba87d294604f..d4bb40a695ab 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -6,29 +6,28 @@
 #ifdef DEBUG
 
 #include <linux/jiffies.h>
-#include <linux/hrtimer.h>
 
 static const struct {
 	bool result;
-	u64 nsec_to_sleep_before;
+	unsigned int msec_to_sleep_before;
 } expected_results[] __initconst = {
 	[0 ... PACKETS_BURSTABLE - 1] = { true, 0 },
 	[PACKETS_BURSTABLE] = { false, 0 },
-	[PACKETS_BURSTABLE + 1] = { true, NSEC_PER_SEC / PACKETS_PER_SECOND },
+	[PACKETS_BURSTABLE + 1] = { true, MSEC_PER_SEC / PACKETS_PER_SECOND },
 	[PACKETS_BURSTABLE + 2] = { false, 0 },
-	[PACKETS_BURSTABLE + 3] = { true, (NSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
+	[PACKETS_BURSTABLE + 3] = { true, (MSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
 	[PACKETS_BURSTABLE + 4] = { true, 0 },
 	[PACKETS_BURSTABLE + 5] = { false, 0 }
 };
 
 static __init unsigned int maximum_jiffies_at_index(int index)
 {
-	u64 total_nsecs = 2 * NSEC_PER_SEC / PACKETS_PER_SECOND / 3;
+	unsigned int total_msecs = 2 * MSEC_PER_SEC / PACKETS_PER_SECOND / 3;
 	int i;
 
 	for (i = 0; i <= index; ++i)
-		total_nsecs += expected_results[i].nsec_to_sleep_before;
-	return nsecs_to_jiffies(total_nsecs);
+		total_msecs += expected_results[i].msec_to_sleep_before;
+	return msecs_to_jiffies(total_msecs);
 }
 
 static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
@@ -43,12 +42,8 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
 	loop_start_time = jiffies;
 
 	for (i = 0; i < ARRAY_SIZE(expected_results); ++i) {
-		if (expected_results[i].nsec_to_sleep_before) {
-			ktime_t timeout = ktime_add(ktime_add_ns(ktime_get_coarse_boottime(), TICK_NSEC * 4 / 3),
-						    ns_to_ktime(expected_results[i].nsec_to_sleep_before));
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_hrtimeout_range_clock(&timeout, 0, HRTIMER_MODE_ABS, CLOCK_BOOTTIME);
-		}
+		if (expected_results[i].msec_to_sleep_before)
+			msleep(expected_results[i].msec_to_sleep_before);
 
 		if (time_is_before_jiffies(loop_start_time +
 					   maximum_jiffies_at_index(i)))
@@ -132,7 +127,7 @@ bool __init wg_ratelimiter_selftest(void)
 	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_UBSAN))
 		return true;
 
-	BUILD_BUG_ON(NSEC_PER_SEC % PACKETS_PER_SECOND != 0);
+	BUILD_BUG_ON(MSEC_PER_SEC % PACKETS_PER_SECOND != 0);
 
 	if (wg_ratelimiter_init())
 		goto out;
@@ -172,7 +167,7 @@ bool __init wg_ratelimiter_selftest(void)
 	++test;
 #endif
 
-	for (trials = TRIALS_BEFORE_GIVING_UP;;) {
+	for (trials = TRIALS_BEFORE_GIVING_UP; IS_ENABLED(DEBUG_RATELIMITER_TIMINGS);) {
 		int test_count = 0, ret;
 
 		ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
-- 
2.35.1



