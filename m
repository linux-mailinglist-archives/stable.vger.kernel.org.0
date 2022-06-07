Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1B541BF2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382036AbiFGVzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383712AbiFGVxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCE6245FB7;
        Tue,  7 Jun 2022 12:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9354E618DE;
        Tue,  7 Jun 2022 19:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98784C385A2;
        Tue,  7 Jun 2022 19:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629125;
        bh=WQHpy/iU/siyqieeM4pNHtO/G4v3Nt8Y8hxGLslrmgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p26KRl1fZtmXLqdBzYPECyJ3H35EOQT+uPptzLOhTc5IAiLiNlcgd2SPQPEsswUww
         aaHna/X89OSP/QrnuJvNqK0OAchxN5cYPmfzPbJMlZfNvDiVUOf/y3GSjUIYkZnBOk
         ilqIS62NrDHfYTsuN/dtP8GcBGDfPm8AsOwhAr+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chia-I Wu <olvaffe@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 577/879] drm/msm: return the average load over the polling period
Date:   Tue,  7 Jun 2022 19:01:35 +0200
Message-Id: <20220607165019.603252514@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 78f815c1cf8fc5f05dc5cec29eb1895cb53470e9 ]

simple_ondemand interacts poorly with clamp_to_idle.  It only looks at
the load since the last get_dev_status call, while it should really look
at the load over polling_ms.  When clamp_to_idle true, it almost always
picks the lowest frequency on active because the gpu is idle between
msm_devfreq_idle/msm_devfreq_active.

This logic could potentially be moved into devfreq core.

Fixes: 7c0ffcd40b16 ("drm/msm/gpu: Respect PM QoS constraints")
Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Cc: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20220416003314.59211-3-olvaffe@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.h         |  3 ++
 drivers/gpu/drm/msm/msm_gpu_devfreq.c | 60 ++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 389c6dab751b..143c56f5185b 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -9,6 +9,7 @@
 
 #include <linux/adreno-smmu-priv.h>
 #include <linux/clk.h>
+#include <linux/devfreq.h>
 #include <linux/interconnect.h>
 #include <linux/pm_opp.h>
 #include <linux/regulator/consumer.h>
@@ -117,6 +118,8 @@ struct msm_gpu_devfreq {
 	/** idle_time: Time of last transition to idle: */
 	ktime_t idle_time;
 
+	struct devfreq_dev_status average_status;
+
 	/**
 	 * idle_work:
 	 *
diff --git a/drivers/gpu/drm/msm/msm_gpu_devfreq.c b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
index d2b4c646a0ae..c7dbaa4b1926 100644
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -9,6 +9,7 @@
 
 #include <linux/devfreq.h>
 #include <linux/devfreq_cooling.h>
+#include <linux/math64.h>
 #include <linux/units.h>
 
 /*
@@ -75,12 +76,69 @@ static void get_raw_dev_status(struct msm_gpu *gpu,
 	status->busy_time = busy_time;
 }
 
+static void update_average_dev_status(struct msm_gpu *gpu,
+		const struct devfreq_dev_status *raw)
+{
+	struct msm_gpu_devfreq *df = &gpu->devfreq;
+	const u32 polling_ms = df->devfreq->profile->polling_ms;
+	const u32 max_history_ms = polling_ms * 11 / 10;
+	struct devfreq_dev_status *avg = &df->average_status;
+	u64 avg_freq;
+
+	/* simple_ondemand governor interacts poorly with gpu->clamp_to_idle.
+	 * When we enforce the constraint on idle, it calls get_dev_status
+	 * which would normally reset the stats.  When we remove the
+	 * constraint on active, it calls get_dev_status again where busy_time
+	 * would be 0.
+	 *
+	 * To remedy this, we always return the average load over the past
+	 * polling_ms.
+	 */
+
+	/* raw is longer than polling_ms or avg has no history */
+	if (div_u64(raw->total_time, USEC_PER_MSEC) >= polling_ms ||
+	    !avg->total_time) {
+		*avg = *raw;
+		return;
+	}
+
+	/* Truncate the oldest history first.
+	 *
+	 * Because we keep the history with a single devfreq_dev_status,
+	 * rather than a list of devfreq_dev_status, we have to assume freq
+	 * and load are the same over avg->total_time.  We can scale down
+	 * avg->busy_time and avg->total_time by the same factor to drop
+	 * history.
+	 */
+	if (div_u64(avg->total_time + raw->total_time, USEC_PER_MSEC) >=
+			max_history_ms) {
+		const u32 new_total_time = polling_ms * USEC_PER_MSEC -
+			raw->total_time;
+		avg->busy_time = div_u64(
+				mul_u32_u32(avg->busy_time, new_total_time),
+				avg->total_time);
+		avg->total_time = new_total_time;
+	}
+
+	/* compute the average freq over avg->total_time + raw->total_time */
+	avg_freq = mul_u32_u32(avg->current_frequency, avg->total_time);
+	avg_freq += mul_u32_u32(raw->current_frequency, raw->total_time);
+	do_div(avg_freq, avg->total_time + raw->total_time);
+
+	avg->current_frequency = avg_freq;
+	avg->busy_time += raw->busy_time;
+	avg->total_time += raw->total_time;
+}
+
 static int msm_devfreq_get_dev_status(struct device *dev,
 		struct devfreq_dev_status *status)
 {
 	struct msm_gpu *gpu = dev_to_gpu(dev);
+	struct devfreq_dev_status raw;
 
-	get_raw_dev_status(gpu, status);
+	get_raw_dev_status(gpu, &raw);
+	update_average_dev_status(gpu, &raw);
+	*status = gpu->devfreq.average_status;
 
 	return 0;
 }
-- 
2.35.1



