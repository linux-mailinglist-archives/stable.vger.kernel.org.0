Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF2C51A88E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355523AbiEDRL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356922AbiEDRJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B624738C;
        Wed,  4 May 2022 09:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D598A616B8;
        Wed,  4 May 2022 16:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213F9C385A5;
        Wed,  4 May 2022 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683386;
        bh=7x/dVZyYq+prsLW5mI66zKBkShJQ6zuOVHy/TvDizzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un9pk3Zc4mjh5DhCCBc1dh+zO70/gBlVgV5Kn1C/SMBdpjmW8HivObws9pwrhze99
         9y12iJOG36ivWXlgJbJLZ3NP6p+X98cBV/2FNyjlzMjLR6m0EwYCCoueh8XCMyW7EM
         b+jPVVnQIBDu/IxHJT/PqCgvhmTxDr90L1MWvGDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 058/225] cpufreq: qcom-cpufreq-hw: Fix throttle frequency value on EPSS platforms
Date:   Wed,  4 May 2022 18:44:56 +0200
Message-Id: <20220504153115.341254849@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit f84ccad5f5660f86a642a3d7e2bfdc4e7a8a2d49 ]

On QCOM platforms with EPSS flavour of cpufreq IP a throttled frequency is
obtained from another register REG_DOMAIN_STATE, thus the helper function
qcom_lmh_get_throttle_freq() should be modified accordingly, as for now
it returns gibberish since .reg_current_vote is unset for EPSS hardware.

To exclude a hardcoded magic number 19200 it is replaced by "xo" clock rate
in KHz.

Fixes: 275157b367f4 ("cpufreq: qcom-cpufreq-hw: Add dcvs interrupt support")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 60d38f62308a..1e99b71e7844 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -28,6 +28,7 @@
 
 struct qcom_cpufreq_soc_data {
 	u32 reg_enable;
+	u32 reg_domain_state;
 	u32 reg_freq_lut;
 	u32 reg_volt_lut;
 	u32 reg_current_vote;
@@ -267,11 +268,16 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 	}
 }
 
-static unsigned int qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
+static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
 {
-	unsigned int val = readl_relaxed(data->base + data->soc_data->reg_current_vote);
+	unsigned int lval;
 
-	return (val & 0x3FF) * 19200;
+	if (data->soc_data->reg_current_vote)
+		lval = readl_relaxed(data->base + data->soc_data->reg_current_vote) & 0x3ff;
+	else
+		lval = readl_relaxed(data->base + data->soc_data->reg_domain_state) & 0xff;
+
+	return lval * xo_rate;
 }
 
 static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
@@ -281,14 +287,12 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 	struct device *dev = get_cpu_device(cpu);
 	unsigned long freq_hz, throttled_freq;
 	struct dev_pm_opp *opp;
-	unsigned int freq;
 
 	/*
 	 * Get the h/w throttled frequency, normalize it using the
 	 * registered opp table and use it to calculate thermal pressure.
 	 */
-	freq = qcom_lmh_get_throttle_freq(data);
-	freq_hz = freq * HZ_PER_KHZ;
+	freq_hz = qcom_lmh_get_throttle_freq(data);
 
 	opp = dev_pm_opp_find_freq_floor(dev, &freq_hz);
 	if (IS_ERR(opp) && PTR_ERR(opp) == -ERANGE)
@@ -357,6 +361,7 @@ static const struct qcom_cpufreq_soc_data qcom_soc_data = {
 
 static const struct qcom_cpufreq_soc_data epss_soc_data = {
 	.reg_enable = 0x0,
+	.reg_domain_state = 0x20,
 	.reg_freq_lut = 0x100,
 	.reg_volt_lut = 0x200,
 	.reg_perf_state = 0x320,
-- 
2.35.1



