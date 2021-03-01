Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89753291F3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbhCAUhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243486AbhCAUan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:30:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73C936502A;
        Mon,  1 Mar 2021 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622105;
        bh=K0J7as9wFhYoyMSPxRC+Khg1wn1se4ke0OPxdrssz3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehcyNwHLsT5JzLULCLTkiQWb0971DO+IsPYiqkdmfkiUiaBKvy29cri29x00cnQzf
         TZufESK57g7R8d3XHBthBwKW7D7YE08TpVCIkVmOQH3KgyR76PhFgJjKrM1ktbFPr6
         0X8djZpLJTnNkWh+gDn3A+FRl1mlGSOl/wqVihmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.11 728/775] cpufreq: qcom-hw: drop devm_xxx() calls from init/exit hooks
Date:   Mon,  1 Mar 2021 17:14:56 +0100
Message-Id: <20210301161237.307168604@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

commit 67fc209b527d023db4d087c68e44e9790aa089ef upstream.

Commit f17b3e44320b ("cpufreq: qcom-hw: Use
devm_platform_ioremap_resource() to simplify code") introduces
a regression on platforms using the driver, by failing to initialise
a policy, when one is created post hotplug.

When all the CPUs of a policy are hoptplugged out, the call to .exit()
and later to devm_iounmap() does not release the memory region that was
requested during devm_platform_ioremap_resource().  Therefore,
a subsequent call to .init() will result in the following error, which
will prevent a new policy to be initialised:

[ 3395.915416] CPU4: shutdown
[ 3395.938185] psci: CPU4 killed (polled 0 ms)
[ 3399.071424] CPU5: shutdown
[ 3399.094316] psci: CPU5 killed (polled 0 ms)
[ 3402.139358] CPU6: shutdown
[ 3402.161705] psci: CPU6 killed (polled 0 ms)
[ 3404.742939] CPU7: shutdown
[ 3404.765592] psci: CPU7 killed (polled 0 ms)
[ 3411.492274] Detected VIPT I-cache on CPU4
[ 3411.492337] GICv3: CPU4: found redistributor 400 region 0:0x0000000017ae0000
[ 3411.492448] CPU4: Booted secondary processor 0x0000000400 [0x516f802d]
[ 3411.503654] qcom-cpufreq-hw 17d43000.cpufreq: can't request region for resource [mem 0x17d45800-0x17d46bff]

With that being said, the original code was tricky and skipping memory
region request intentionally to hide this issue.  The true cause is that
those devm_xxx() device managed functions shouldn't be used for cpufreq
init/exit hooks, because &pdev->dev is alive across the hooks and will
not trigger auto resource free-up.  Let's drop the use of device managed
functions and manually allocate/free resources, so that the issue can be
fixed properly.

Cc: v5.10+ <stable@vger.kernel.org> # v5.10+
Fixes: f17b3e44320b ("cpufreq: qcom-hw: Use devm_platform_ioremap_resource() to simplify code")
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c |   40 ++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -32,6 +32,7 @@ struct qcom_cpufreq_soc_data {
 
 struct qcom_cpufreq_data {
 	void __iomem *base;
+	struct resource *res;
 	const struct qcom_cpufreq_soc_data *soc_data;
 };
 
@@ -280,6 +281,7 @@ static int qcom_cpufreq_hw_cpu_init(stru
 	struct of_phandle_args args;
 	struct device_node *cpu_np;
 	struct device *cpu_dev;
+	struct resource *res;
 	void __iomem *base;
 	struct qcom_cpufreq_data *data;
 	int ret, index;
@@ -303,18 +305,33 @@ static int qcom_cpufreq_hw_cpu_init(stru
 
 	index = args.args[0];
 
-	base = devm_platform_ioremap_resource(pdev, index);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
+	if (!res) {
+		dev_err(dev, "failed to get mem resource %d\n", index);
+		return -ENODEV;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res), res->name)) {
+		dev_err(dev, "failed to request resource %pR\n", res);
+		return -EBUSY;
+	}
 
-	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	base = ioremap(res->start, resource_size(res));
+	if (IS_ERR(base)) {
+		dev_err(dev, "failed to map resource %pR\n", res);
+		ret = PTR_ERR(base);
+		goto release_region;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		ret = -ENOMEM;
-		goto error;
+		goto unmap_base;
 	}
 
 	data->soc_data = of_device_get_match_data(&pdev->dev);
 	data->base = base;
+	data->res = res;
 
 	/* HW should be in enabled state to proceed */
 	if (!(readl_relaxed(base + data->soc_data->reg_enable) & 0x1)) {
@@ -349,7 +366,11 @@ static int qcom_cpufreq_hw_cpu_init(stru
 
 	return 0;
 error:
-	devm_iounmap(dev, base);
+	kfree(data);
+unmap_base:
+	iounmap(data->base);
+release_region:
+	release_mem_region(res->start, resource_size(res));
 	return ret;
 }
 
@@ -357,12 +378,15 @@ static int qcom_cpufreq_hw_cpu_exit(stru
 {
 	struct device *cpu_dev = get_cpu_device(policy->cpu);
 	struct qcom_cpufreq_data *data = policy->driver_data;
-	struct platform_device *pdev = cpufreq_get_driver_data();
+	struct resource *res = data->res;
+	void __iomem *base = data->base;
 
 	dev_pm_opp_remove_all_dynamic(cpu_dev);
 	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
 	kfree(policy->freq_table);
-	devm_iounmap(&pdev->dev, data->base);
+	kfree(data);
+	iounmap(base);
+	release_mem_region(res->start, resource_size(res));
 
 	return 0;
 }


