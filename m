Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD74FD1AA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351055AbiDLG7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350833AbiDLG4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:56:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D1D255AD;
        Mon, 11 Apr 2022 23:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92F07610A0;
        Tue, 12 Apr 2022 06:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5715C385A1;
        Tue, 12 Apr 2022 06:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745981;
        bh=7/3p41NIPgWI2dRSaH2L63dQXILYuedmfQCuTAQ4jo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsD0pU4Nrs1cZW5Fs4ZPVA4ZCrvsqHg220M4Bv39XXMzmzJwZAUckt6xgHzQgW8kI
         fdrkVb4IhCS3qCrTDvdkVzN4dZViO1KiYkjZMmb1x/UfebvH9UOby5xjoh75T8a6GV
         XxeB0ldnGpbz1hSN7oacpNM20Z2OFsoh4wbFv3mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Pierre Gondois <Pierre.Gondois@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/277] cpufreq: CPPC: Fix performance/frequency conversion
Date:   Tue, 12 Apr 2022 08:28:40 +0200
Message-Id: <20220412062945.426932346@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Pierre Gondois <Pierre.Gondois@arm.com>

[ Upstream commit ec1c7ad47664f964c1101fe555b6fde0cb124b38 ]

CPUfreq governors request CPU frequencies using information
on current CPU usage. The CPPC driver converts them to
performance requests. Frequency targets are computed as:
	target_freq = (util / cpu_capacity) * max_freq
target_freq is then clamped between [policy->min, policy->max].

The CPPC driver converts performance values to frequencies
(and vice-versa) using cppc_cpufreq_perf_to_khz() and
cppc_cpufreq_khz_to_perf(). These functions both use two different
factors depending on the range of the input value. For
cppc_cpufreq_khz_to_perf():
- (NOMINAL_PERF / NOMINAL_FREQ) or
- (LOWEST_PERF / LOWEST_FREQ)
and for cppc_cpufreq_perf_to_khz():
- (NOMINAL_FREQ / NOMINAL_PERF) or
- ((NOMINAL_PERF - LOWEST_FREQ) / (NOMINAL_PERF - LOWEST_PERF))

This means:
1- the functions are not inverse for some values:
   (perf_to_khz(khz_to_perf(x)) != x)
2- cppc_cpufreq_perf_to_khz(LOWEST_PERF) can sometimes give
   a different value from LOWEST_FREQ due to integer approximation
3- it is implied that performance and frequency are proportional
   (NOMINAL_FREQ / NOMINAL_PERF) == (LOWEST_PERF / LOWEST_FREQ)

This patch changes the conversion functions to an affine function.
This fixes the 3 points above.

Suggested-by: Lukasz Luba <lukasz.luba@arm.com>
Suggested-by: Morten Rasmussen <morten.rasmussen@arm.com>
Signed-off-by: Pierre Gondois <Pierre.Gondois@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 43 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index d4c27022b9c9..e0ff09d66c96 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -303,52 +303,48 @@ static u64 cppc_get_dmi_max_khz(void)
 
 /*
  * If CPPC lowest_freq and nominal_freq registers are exposed then we can
- * use them to convert perf to freq and vice versa
- *
- * If the perf/freq point lies between Nominal and Lowest, we can treat
- * (Low perf, Low freq) and (Nom Perf, Nom freq) as 2D co-ordinates of a line
- * and extrapolate the rest
- * For perf/freq > Nominal, we use the ratio perf:freq at Nominal for conversion
+ * use them to convert perf to freq and vice versa. The conversion is
+ * extrapolated as an affine function passing by the 2 points:
+ *  - (Low perf, Low freq)
+ *  - (Nominal perf, Nominal perf)
  */
 static unsigned int cppc_cpufreq_perf_to_khz(struct cppc_cpudata *cpu_data,
 					     unsigned int perf)
 {
 	struct cppc_perf_caps *caps = &cpu_data->perf_caps;
+	s64 retval, offset = 0;
 	static u64 max_khz;
 	u64 mul, div;
 
 	if (caps->lowest_freq && caps->nominal_freq) {
-		if (perf >= caps->nominal_perf) {
-			mul = caps->nominal_freq;
-			div = caps->nominal_perf;
-		} else {
-			mul = caps->nominal_freq - caps->lowest_freq;
-			div = caps->nominal_perf - caps->lowest_perf;
-		}
+		mul = caps->nominal_freq - caps->lowest_freq;
+		div = caps->nominal_perf - caps->lowest_perf;
+		offset = caps->nominal_freq - div64_u64(caps->nominal_perf * mul, div);
 	} else {
 		if (!max_khz)
 			max_khz = cppc_get_dmi_max_khz();
 		mul = max_khz;
 		div = caps->highest_perf;
 	}
-	return (u64)perf * mul / div;
+
+	retval = offset + div64_u64(perf * mul, div);
+	if (retval >= 0)
+		return retval;
+	return 0;
 }
 
 static unsigned int cppc_cpufreq_khz_to_perf(struct cppc_cpudata *cpu_data,
 					     unsigned int freq)
 {
 	struct cppc_perf_caps *caps = &cpu_data->perf_caps;
+	s64 retval, offset = 0;
 	static u64 max_khz;
 	u64  mul, div;
 
 	if (caps->lowest_freq && caps->nominal_freq) {
-		if (freq >= caps->nominal_freq) {
-			mul = caps->nominal_perf;
-			div = caps->nominal_freq;
-		} else {
-			mul = caps->lowest_perf;
-			div = caps->lowest_freq;
-		}
+		mul = caps->nominal_perf - caps->lowest_perf;
+		div = caps->nominal_freq - caps->lowest_freq;
+		offset = caps->nominal_perf - div64_u64(caps->nominal_freq * mul, div);
 	} else {
 		if (!max_khz)
 			max_khz = cppc_get_dmi_max_khz();
@@ -356,7 +352,10 @@ static unsigned int cppc_cpufreq_khz_to_perf(struct cppc_cpudata *cpu_data,
 		div = max_khz;
 	}
 
-	return (u64)freq * mul / div;
+	retval = offset + div64_u64(freq * mul, div);
+	if (retval >= 0)
+		return retval;
+	return 0;
 }
 
 static int cppc_cpufreq_set_target(struct cpufreq_policy *policy,
-- 
2.35.1



