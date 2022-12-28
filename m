Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80DA657A35
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiL1PI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiL1PIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E851213DD3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 851FD61365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D92AC433EF;
        Wed, 28 Dec 2022 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240128;
        bh=qSViSO7W0JxmQyLibcnUoZm/jLwE6sH4xVbE6B+SUJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1JHqCKzlFa4qOLHvVdlvWNUI71jLCi5hzkhNZrefazUSXe3QIX7aCaSywPP/7Okv
         dVY2Pzx8doT2pR04ZrwUNQrJdLeaFjPUEGErrDlv53cXui4jhoM8Fr4ZDyEAfHx7vs
         V74W0GdBOi5FcM2XHWcRWFD6urTIl90LvwH7lDY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sudeep Holla <sudeep.holla@arm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0121/1073] cpufreq: qcom-hw: Fix the frequency returned by cpufreq_driver->get()
Date:   Wed, 28 Dec 2022 15:28:29 +0100
Message-Id: <20221228144331.324784426@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit c72cf0cb1d77f6b1b58c334dcc3d09fa13111c4c ]

The cpufreq_driver->get() callback is supposed to return the current
frequency of the CPU and not the one requested by the CPUFreq core.
Fix it by returning the frequency that gets supplied to the CPU after
the DCVS operation of EPSS/OSM.

Fixes: 2849dd8bc72b ("cpufreq: qcom-hw: Add support for QCOM cpufreq HW driver")
Reported-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 42 +++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 9221a416230a..823b069203e1 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -122,7 +122,35 @@ static int qcom_cpufreq_hw_target_index(struct cpufreq_policy *policy,
 	return 0;
 }
 
+static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
+{
+	unsigned int lval;
+
+	if (data->soc_data->reg_current_vote)
+		lval = readl_relaxed(data->base + data->soc_data->reg_current_vote) & 0x3ff;
+	else
+		lval = readl_relaxed(data->base + data->soc_data->reg_domain_state) & 0xff;
+
+	return lval * xo_rate;
+}
+
+/* Get the current frequency of the CPU (after throttling) */
 static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
+{
+	struct qcom_cpufreq_data *data;
+	struct cpufreq_policy *policy;
+
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (!policy)
+		return 0;
+
+	data = policy->driver_data;
+
+	return qcom_lmh_get_throttle_freq(data) / HZ_PER_KHZ;
+}
+
+/* Get the frequency requested by the cpufreq core for the CPU */
+static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
 {
 	struct qcom_cpufreq_data *data;
 	const struct qcom_cpufreq_soc_data *soc_data;
@@ -284,18 +312,6 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 	}
 }
 
-static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
-{
-	unsigned int lval;
-
-	if (data->soc_data->reg_current_vote)
-		lval = readl_relaxed(data->base + data->soc_data->reg_current_vote) & 0x3ff;
-	else
-		lval = readl_relaxed(data->base + data->soc_data->reg_domain_state) & 0xff;
-
-	return lval * xo_rate;
-}
-
 static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 {
 	struct cpufreq_policy *policy = data->policy;
@@ -337,7 +353,7 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 	 * If h/w throttled frequency is higher than what cpufreq has requested
 	 * for, then stop polling and switch back to interrupt mechanism.
 	 */
-	if (throttled_freq >= qcom_cpufreq_hw_get(cpu))
+	if (throttled_freq >= qcom_cpufreq_get_freq(cpu))
 		enable_irq(data->throttle_irq);
 	else
 		mod_delayed_work(system_highpri_wq, &data->throttle_work,
-- 
2.35.1



