Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281245C0208
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiIUPrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiIUPq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:46:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6E27E329;
        Wed, 21 Sep 2022 08:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C174B81D87;
        Wed, 21 Sep 2022 15:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F151FC433D7;
        Wed, 21 Sep 2022 15:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775211;
        bh=KGEIq67dvPNj2TD93txwrrk9cX4Fxe3xdIJc/dUsAdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/kEZG0QwzqWcah7TfjmJX37QgL1kQYZ+crEeEHDC1bl1w13E7dCuDfgBgE8svAD6
         2X804N7Zi4+WN3eIwnU5xzgpMX8d/C9wW2z0erDRLtPgs3pUU8X53QMjLHWG1dN5DS
         QuBRgJiAiNGJeIyBMM8RxcVDYjlpcpTMd/VVPF9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 16/38] drm/i915/guc: Dont update engine busyness stats too frequently
Date:   Wed, 21 Sep 2022 17:46:00 +0200
Message-Id: <20220921153646.796421323@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Previn <alan.previn.teres.alexis@intel.com>

[ Upstream commit 59bcdb564b3bac3e86cc274e5dec05d4647ce47f ]

Using two different types of workoads, it was observed that
guc_update_engine_gt_clks was being called too frequently and/or
causing a CPU-to-lmem bandwidth hit over PCIE. Details on
the workloads and numbers are in the notes below.

Background: At the moment, guc_update_engine_gt_clks can be invoked
via one of 3 ways. #1 and #2 are infrequent under normal operating
conditions:
     1.When a predefined "ping_delay" timer expires so that GuC-
       busyness can sample the GTPM clock counter to ensure it
       doesn't miss a wrap-around of the 32-bits of the HW counter.
       (The ping_delay is calculated based on 1/8th the time taken
       for the counter go from 0x0 to 0xffffffff based on the
       GT frequency. This comes to about once every 28 seconds at a
       GT frequency of 19.2Mhz).
     2.In preparation for a gt reset.
     3.In response to __gt_park events (as the gt power management
       puts the gt into a lower power state when there is no work
       being done).

Root-cause: For both the workloads described farther below, it was
observed that when user space calls IOCTLs that unparks the
gt momentarily and repeats such calls many times in quick succession,
it triggers calling guc_update_engine_gt_clks as many times. However,
the primary purpose of guc_update_engine_gt_clks is to ensure we don't
miss the wraparound while the counter is ticking. Thus, the solution
is to ensure we skip that check if gt_park is calling this function
earlier than necessary.

Solution: Snapshot jiffies when we do actually update the busyness
stats. Then get the new jiffies every time intel_guc_busyness_park
is called and bail if we are being called too soon. Use half of the
ping_delay as a safe threshold.

NOTE1: Workload1: IGTs' gem_create was modified to create a file handle,
allocate memory with sizes that range from a min of 4K to the max supported
(in power of two step-sizes). Its maps, modifies and reads back the
memory. Allocations and modification is repeated until total memory
allocation reaches the max. Then the file handle is closed. With this
workload, guc_update_engine_gt_clks was called over 188 thousand times
in the span of 15 seconds while this test ran three times. With this patch,
the number of calls reduced to 14.

NOTE2: Workload2: 30 transcode sessions are created in quick succession.
While these sessions are created, pcm-iio tool was used to measure I/O
read operation bandwidth consumption sampled at 100 milisecond intervals
over the course of 20 seconds. The total bandwidth consumed over 20 seconds
without this patch was measured at average at 311KBps per sample. With this
patch, the number went down to about 175Kbps which is about a 43% savings.

Signed-off-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220623023157.211650-2-alan.previn.teres.alexis@intel.com
Stable-dep-of: aee5ae7c8492 ("drm/i915/guc: Cancel GuC engine busyness worker synchronously")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc.h            |  8 ++++++++
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc.h b/drivers/gpu/drm/i915/gt/uc/intel_guc.h
index 9feda105f913..a7acffbf15d1 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc.h
@@ -235,6 +235,14 @@ struct intel_guc {
 		 * @shift: Right shift value for the gpm timestamp
 		 */
 		u32 shift;
+
+		/**
+		 * @last_stat_jiffies: jiffies at last actual stats collection time
+		 * We use this timestamp to ensure we don't oversample the
+		 * stats because runtime power management events can trigger
+		 * stats collection at much higher rates than required.
+		 */
+		unsigned long last_stat_jiffies;
 	} timestamp;
 
 #ifdef CONFIG_DRM_I915_SELFTEST
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 26a051ef119d..96022f49f9b5 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1365,6 +1365,8 @@ static void __update_guc_busyness_stats(struct intel_guc *guc)
 	unsigned long flags;
 	ktime_t unused;
 
+	guc->timestamp.last_stat_jiffies = jiffies;
+
 	spin_lock_irqsave(&guc->timestamp.lock, flags);
 
 	guc_update_pm_timestamp(guc, &unused);
@@ -1437,6 +1439,17 @@ void intel_guc_busyness_park(struct intel_gt *gt)
 		return;
 
 	cancel_delayed_work(&guc->timestamp.work);
+
+	/*
+	 * Before parking, we should sample engine busyness stats if we need to.
+	 * We can skip it if we are less than half a ping from the last time we
+	 * sampled the busyness stats.
+	 */
+	if (guc->timestamp.last_stat_jiffies &&
+	    !time_after(jiffies, guc->timestamp.last_stat_jiffies +
+			(guc->timestamp.ping_delay / 2)))
+		return;
+
 	__update_guc_busyness_stats(guc);
 }
 
-- 
2.35.1



