Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516EE66C095
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjAPOCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjAPOCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210B22197F;
        Mon, 16 Jan 2023 06:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A64A160FD4;
        Mon, 16 Jan 2023 14:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6646AC433D2;
        Mon, 16 Jan 2023 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877730;
        bh=f34HDFU9G8sG6cn3BHd0SbGmATKQkq6IuNGYsC/EV6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELQoGZKHIBbMHadwieqyVgzPjOBhc9owifa+SSTA7el7bcCrnrZCjpPGyQvb8RZQw
         C069r23UC8v5kQiYzuwycAP/y4i5mdREbnWhgGMkbzYmo1rheVL/pOz4/nT6pW2GVb
         IcHOo82171IBlu7+kRdAQpyyrs8yRFnuH05+2LdNGm9t3HLEYeh9zWAO8GFskKpSlu
         3f4po8UhpQ9/iEeNM3xASLspaCOmwltVDiGLH3b2akLp8queoTz8h1idnvL3RR8qHi
         v1nVdZmvr3601OuUT0xyaZChrtKCkAnWPV6D6f0zZYlRjMVIzEfAVbB3RQ/NqiRiaq
         MK1F3oL+0h/LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre Gondois <pierre.gondois@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 07/53] cpufreq: CPPC: Add u64 casts to avoid overflowing
Date:   Mon, 16 Jan 2023 09:01:07 -0500
Message-Id: <20230116140154.114951-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.35.1

