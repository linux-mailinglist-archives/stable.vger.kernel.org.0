Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5417B19174
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfEISya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbfEISya (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F0C21841;
        Thu,  9 May 2019 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428069;
        bh=erub84zW5SlMt2EeVa3Z6abSx4S29rau3YDLlNndXu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gt4PLKBIRkX3Kgs3r29QfUg5XyS8B0OgaEA5JJWnfSLaoQjcx1lx4HOqRvBNBuvfZ
         9bp57TlPJAarlZC515CN4QVbY2mdh+FzA5SQoG2l9ySdgzovngLKmHIawl/I1BTBGK
         ngyAO2kxDALTNkXNPszN8WjnKuAnoUv5r91KaKJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Neubert <christian.neubert.86@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.1 15/30] cpufreq: armada-37xx: fix frequency calculation for opp
Date:   Thu,  9 May 2019 20:42:47 +0200
Message-Id: <20190509181254.052900467@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit 8db82563451f976597ab7b282ec655e4390a4088 upstream.

The frequency calculation was based on the current(max) frequency of the
CPU. However for low frequency, the value used was already the parent
frequency divided by a factor of 2.

Instead of using this frequency, this fix directly get the frequency from
the parent clock.

Fixes: 92ce45fb875d ("cpufreq: Add DVFS support for Armada 37xx")
Cc: <stable@vger.kernel.org>
Reported-by: Christian Neubert <christian.neubert.86@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/armada-37xx-cpufreq.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -359,11 +359,11 @@ static int __init armada37xx_cpufreq_dri
 	struct armada_37xx_dvfs *dvfs;
 	struct platform_device *pdev;
 	unsigned long freq;
-	unsigned int cur_frequency;
+	unsigned int cur_frequency, base_frequency;
 	struct regmap *nb_pm_base, *avs_base;
 	struct device *cpu_dev;
 	int load_lvl, ret;
-	struct clk *clk;
+	struct clk *clk, *parent;
 
 	nb_pm_base =
 		syscon_regmap_lookup_by_compatible("marvell,armada-3700-nb-pm");
@@ -399,6 +399,22 @@ static int __init armada37xx_cpufreq_dri
 		return PTR_ERR(clk);
 	}
 
+	parent = clk_get_parent(clk);
+	if (IS_ERR(parent)) {
+		dev_err(cpu_dev, "Cannot get parent clock for CPU0\n");
+		clk_put(clk);
+		return PTR_ERR(parent);
+	}
+
+	/* Get parent CPU frequency */
+	base_frequency =  clk_get_rate(parent);
+
+	if (!base_frequency) {
+		dev_err(cpu_dev, "Failed to get parent clock rate for CPU\n");
+		clk_put(clk);
+		return -EINVAL;
+	}
+
 	/* Get nominal (current) CPU frequency */
 	cur_frequency = clk_get_rate(clk);
 	if (!cur_frequency) {
@@ -431,7 +447,7 @@ static int __init armada37xx_cpufreq_dri
 	for (load_lvl = ARMADA_37XX_DVFS_LOAD_0; load_lvl < LOAD_LEVEL_NR;
 	     load_lvl++) {
 		unsigned long u_volt = avs_map[dvfs->avs[load_lvl]] * 1000;
-		freq = cur_frequency / dvfs->divider[load_lvl];
+		freq = base_frequency / dvfs->divider[load_lvl];
 		ret = dev_pm_opp_add(cpu_dev, freq, u_volt);
 		if (ret)
 			goto remove_opp;


