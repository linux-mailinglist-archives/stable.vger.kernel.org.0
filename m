Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D677F593F3B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347830AbiHOV3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348525AbiHOV1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:27:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1538E3D5BF;
        Mon, 15 Aug 2022 12:23:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16A9B80FD3;
        Mon, 15 Aug 2022 19:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6CEC433C1;
        Mon, 15 Aug 2022 19:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591423;
        bh=hG2YwfD3GERqvp7dAQn4lJn8v53PgZPVyBYg36/I2NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHrXOg9rOoL9HMEW6K0r0gnlMcnAsxcnzBItIUti2xcyb8gyWtsBKjo/nqcyxzGl1
         EykCYWEiHRg35JhBNgka9MPbPa7fSsgOYHejJs7uG5NjSnZwbgzXdmErLxBnBzYuRN
         2qixfa8BnKnnNtUSmfZeeE+scnmib6aVLpkF9r3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0538/1095] wireguard: ratelimiter: use hrtimer in selftest
Date:   Mon, 15 Aug 2022 19:58:57 +0200
Message-Id: <20220815180451.808558091@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 151c8e499f4705010780189377f85b57400ccbf5 ]

Using msleep() is problematic because it's compared against
ratelimiter.c's ktime_get_coarse_boottime_ns(), which means on systems
with slow jiffies (such as UML's forced HZ=100), the result is
inaccurate. So switch to using schedule_hrtimeout().

However, hrtimer gives us access only to the traditional posix timers,
and none of the _COARSE variants. So now, rather than being too
imprecise like jiffies, it's too precise.

One solution would be to give it a large "range" value, but this will
still fire early on a loaded system. A better solution is to align the
timeout to the actual coarse timer, and then round up to the nearest
tick, plus change.

So add the timeout to the current coarse time, and then
schedule_hrtimer() until the absolute computed time.

This should hopefully reduce flakes in CI as well. Note that we keep the
retry loop in case the entire function is running behind, because the
test could still be scheduled out, by either the kernel or by the
hypervisor's kernel, in which case restarting the test and hoping to not
be scheduled out still helps.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/selftest/ratelimiter.c | 25 +++++++++++---------
 kernel/time/hrtimer.c                        |  1 +
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index 007cd4457c5f..ba87d294604f 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -6,28 +6,29 @@
 #ifdef DEBUG
 
 #include <linux/jiffies.h>
+#include <linux/hrtimer.h>
 
 static const struct {
 	bool result;
-	unsigned int msec_to_sleep_before;
+	u64 nsec_to_sleep_before;
 } expected_results[] __initconst = {
 	[0 ... PACKETS_BURSTABLE - 1] = { true, 0 },
 	[PACKETS_BURSTABLE] = { false, 0 },
-	[PACKETS_BURSTABLE + 1] = { true, MSEC_PER_SEC / PACKETS_PER_SECOND },
+	[PACKETS_BURSTABLE + 1] = { true, NSEC_PER_SEC / PACKETS_PER_SECOND },
 	[PACKETS_BURSTABLE + 2] = { false, 0 },
-	[PACKETS_BURSTABLE + 3] = { true, (MSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
+	[PACKETS_BURSTABLE + 3] = { true, (NSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
 	[PACKETS_BURSTABLE + 4] = { true, 0 },
 	[PACKETS_BURSTABLE + 5] = { false, 0 }
 };
 
 static __init unsigned int maximum_jiffies_at_index(int index)
 {
-	unsigned int total_msecs = 2 * MSEC_PER_SEC / PACKETS_PER_SECOND / 3;
+	u64 total_nsecs = 2 * NSEC_PER_SEC / PACKETS_PER_SECOND / 3;
 	int i;
 
 	for (i = 0; i <= index; ++i)
-		total_msecs += expected_results[i].msec_to_sleep_before;
-	return msecs_to_jiffies(total_msecs);
+		total_nsecs += expected_results[i].nsec_to_sleep_before;
+	return nsecs_to_jiffies(total_nsecs);
 }
 
 static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
@@ -42,8 +43,12 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
 	loop_start_time = jiffies;
 
 	for (i = 0; i < ARRAY_SIZE(expected_results); ++i) {
-		if (expected_results[i].msec_to_sleep_before)
-			msleep(expected_results[i].msec_to_sleep_before);
+		if (expected_results[i].nsec_to_sleep_before) {
+			ktime_t timeout = ktime_add(ktime_add_ns(ktime_get_coarse_boottime(), TICK_NSEC * 4 / 3),
+						    ns_to_ktime(expected_results[i].nsec_to_sleep_before));
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_hrtimeout_range_clock(&timeout, 0, HRTIMER_MODE_ABS, CLOCK_BOOTTIME);
+		}
 
 		if (time_is_before_jiffies(loop_start_time +
 					   maximum_jiffies_at_index(i)))
@@ -127,7 +132,7 @@ bool __init wg_ratelimiter_selftest(void)
 	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_UBSAN))
 		return true;
 
-	BUILD_BUG_ON(MSEC_PER_SEC % PACKETS_PER_SECOND != 0);
+	BUILD_BUG_ON(NSEC_PER_SEC % PACKETS_PER_SECOND != 0);
 
 	if (wg_ratelimiter_init())
 		goto out;
@@ -176,7 +181,6 @@ bool __init wg_ratelimiter_selftest(void)
 				test += test_count;
 				goto err;
 			}
-			msleep(500);
 			continue;
 		} else if (ret < 0) {
 			test += test_count;
@@ -195,7 +199,6 @@ bool __init wg_ratelimiter_selftest(void)
 				test += test_count;
 				goto err;
 			}
-			msleep(50);
 			continue;
 		}
 		test += test_count;
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0ea8702eb516..23af5eca11b1 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2311,6 +2311,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires, u64 delta,
 
 	return !t.task ? 0 : -EINTR;
 }
+EXPORT_SYMBOL_GPL(schedule_hrtimeout_range_clock);
 
 /**
  * schedule_hrtimeout_range - sleep until timeout
-- 
2.35.1



