Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D690C4D5D0F
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 09:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiCKIMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 03:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiCKIMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 03:12:37 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE041B8C95;
        Fri, 11 Mar 2022 00:11:34 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KFJT157hMz9sdJ;
        Fri, 11 Mar 2022 16:07:49 +0800 (CST)
Received: from huawei.com (10.67.174.166) by canpemm500006.china.huawei.com
 (7.192.105.130) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 11 Mar
 2022 16:11:32 +0800
From:   z00314508 <zhengzucheng@huawei.com>
To:     <rafael@kernel.org>, <viresh.kumar@linaro.org>,
        <tglx@linutronix.de>, <len.brown@intel.com>
CC:     <zhengzucheng@huawei.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] cpufreq: fix cpufreq_get() can't get correct CPU frequency
Date:   Fri, 11 Mar 2022 16:11:11 +0800
Message-ID: <20220311081111.159639-1-zhengzucheng@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.166]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zucheng Zheng <zhengzucheng@huawei.com>

On some specific platforms, the cpufreq driver does not define
cpufreq_driver.get() routine (eg:x86 intel_pstate driver), as a
result, the cpufreq_get() can't get the correct CPU frequency.

Modern x86 processors include the hardware needed to accurately
calculate frequency over an interval -- APERF, MPERF and the TSC.
Here we use arch_freq_get_on_cpu() in preference to any driver
driver-specific cpufreq_driver.get() routine to get CPU frequency.

Fixes: f8475cef9008 ("x86: use common aperfmperf_khz_on_cpu() to calculate KHz using APERF/MPERF")
Signed-off-by: Zucheng Zheng <zhengzucheng@huawei.com>
---
 drivers/cpufreq/cpufreq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 80f535cc8a75..d777257b4454 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1806,10 +1806,14 @@ unsigned int cpufreq_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	unsigned int ret_freq = 0;
+	unsigned int freq;
 
 	if (policy) {
 		down_read(&policy->rwsem);
-		if (cpufreq_driver->get)
+		freq = arch_freq_get_on_cpu(policy->cpu);
+		if (freq)
+			ret_freq = freq;
+		else if (cpufreq_driver->get)
 			ret_freq = __cpufreq_get(policy);
 		up_read(&policy->rwsem);
 
-- 
2.18.0.huawei.25

