Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314FD681039
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbjA3OBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbjA3OBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB643B668
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B9FEB81180
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8CAC433EF;
        Mon, 30 Jan 2023 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087251;
        bh=brPNg4hXs3Yuj/UKNSzP5rYxjn1E9VnP1uYNFwKVvKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3Kk89lJTwTaHlrLR5mouff4z5vBYjQYjFi2a7EvoxN5KsdLtl8VsA7g6EwwlIn6Q
         Cgvo1yEZI6oTol2CVbhgCAkHIBUkWR5GtEN6amVCGqmkaTEkYwBIhA7oSkdnZuIt3d
         Rsz0EIQRQlMpuKIm+FGoApw1bq/W4nIirXDl1b8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pierre Gondois <pierre.gondois@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/313] cpufreq: CPPC: Add u64 casts to avoid overflowing
Date:   Mon, 30 Jan 2023 14:49:42 +0100
Message-Id: <20230130134343.504125346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit f5f94b9c8b805d87ff185caf9779c3a4d07819e3 ]

The fields of the _CPC object are unsigned 32-bits values.
To avoid overflows while using _CPC's values, add 'u64' casts.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 432dfb4e8027..022e3555407c 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -487,7 +487,8 @@ static unsigned int get_perf_level_count(struct cpufreq_policy *policy)
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu);
-	min_cap = div_u64(max_cap * perf_caps->lowest_perf, perf_caps->highest_perf);
+	min_cap = div_u64((u64)max_cap * perf_caps->lowest_perf,
+			  perf_caps->highest_perf);
 	if ((min_cap == 0) || (max_cap < min_cap))
 		return 0;
 	return 1 + max_cap / CPPC_EM_CAP_STEP - min_cap / CPPC_EM_CAP_STEP;
@@ -519,10 +520,10 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu_dev->id);
-	min_cap = div_u64(max_cap * perf_caps->lowest_perf,
-			perf_caps->highest_perf);
-
-	perf_step = CPPC_EM_CAP_STEP * perf_caps->highest_perf / max_cap;
+	min_cap = div_u64((u64)max_cap * perf_caps->lowest_perf,
+			  perf_caps->highest_perf);
+	perf_step = div_u64((u64)CPPC_EM_CAP_STEP * perf_caps->highest_perf,
+			    max_cap);
 	min_step = min_cap / CPPC_EM_CAP_STEP;
 	max_step = max_cap / CPPC_EM_CAP_STEP;
 
-- 
2.39.0



