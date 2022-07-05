Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24954566DC5
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiGEM1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiGEMZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F801902C;
        Tue,  5 Jul 2022 05:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8BA461AC8;
        Tue,  5 Jul 2022 12:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E4BC341C7;
        Tue,  5 Jul 2022 12:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023469;
        bh=7YshR3Vuu9QEnbxCieJqLjKwWNdbjo9+x0rVKqgu9Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZGX56SkCi+ZuIiGYHbBXVABWZn5NxVaLNhmGQBpy5pLboVWe137sZskJ5UJjWiuM
         ewA/EbOPG9EfImUwUMDWqMmtO810XDrjD5dpUnZ0q8bonmUDscWCckPeqON6OCtEmO
         dYvfN0T30QdW5bu2IaghiHJMMDEVvLHl+NjT4YQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.18 070/102] cpufreq: qcom-hw: Dont do lmh things without a throttle interrupt
Date:   Tue,  5 Jul 2022 13:58:36 +0200
Message-Id: <20220705115620.393287150@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 668a7a12ded7077d4fd7ad1305667e559907e5bb upstream.

Offlining cpu6 and cpu7 and then onlining cpu6 hangs on
sc7180-trogdor-lazor because the throttle interrupt doesn't exist.
Similarly, things go sideways when suspend/resume runs. That's because
the qcom_cpufreq_hw_cpu_online() and qcom_cpufreq_hw_lmh_exit()
functions are calling genirq APIs with an interrupt value of '-6', i.e.
-ENXIO, and that isn't good.

Check the value of the throttle interrupt like we already do in other
functions in this file and bail out early from lmh code to fix the hang.

Reported-by: Rob Clark <robdclark@chromium.org>
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: a1eb080a0447 ("cpufreq: qcom-hw: provide online/offline operations")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 0253731d6d25..36c79580fba2 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -442,6 +442,9 @@ static int qcom_cpufreq_hw_cpu_online(struct cpufreq_policy *policy)
 	struct platform_device *pdev = cpufreq_get_driver_data();
 	int ret;
 
+	if (data->throttle_irq <= 0)
+		return 0;
+
 	ret = irq_set_affinity_hint(data->throttle_irq, policy->cpus);
 	if (ret)
 		dev_err(&pdev->dev, "Failed to set CPU affinity of %s[%d]\n",
@@ -469,6 +472,9 @@ static int qcom_cpufreq_hw_cpu_offline(struct cpufreq_policy *policy)
 
 static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
 {
+	if (data->throttle_irq <= 0)
+		return;
+
 	free_irq(data->throttle_irq, data);
 }
 
-- 
2.37.0



