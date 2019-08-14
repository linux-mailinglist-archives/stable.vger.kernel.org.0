Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41748DB52
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfHNRYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbfHNRGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:06:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6512173B;
        Wed, 14 Aug 2019 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802414;
        bh=HZzajwJlbi004o3s7XnfDi+92fRpYByU7eN+ualkU6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAJseiWG1CSqsO9nmNqwSS3Oes1LDkB3nu8pZxTSmtqLqwm5pnPo0Ngn4jxNu1NBF
         sAoz7z7OOR5DoP1lLscmyje6tK58ZYKOrm8LMOmi6J55bus51Z5KtgjA7YSvFKaMm+
         6OuSbrKkgEuibnV+kfzy6k90Wnd8EG7A6SYzVrAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 090/144] cpufreq/pasemi: fix use-after-free in pas_cpufreq_cpu_init()
Date:   Wed, 14 Aug 2019 19:00:46 +0200
Message-Id: <20190814165803.640107453@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e0a12445d1cb186d875410d093a00d215bec6a89 ]

The cpu variable is still being used in the of_get_property() call
after the of_node_put() call, which may result in use-after-free.

Fixes: a9acc26b75f6 ("cpufreq/pasemi: fix possible object reference leak")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/pasemi-cpufreq.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 6b1e4abe32483..d2f061015323d 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -131,10 +131,18 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	int err = -ENODEV;
 
 	cpu = of_get_cpu_node(policy->cpu, NULL);
+	if (!cpu)
+		goto out;
 
+	max_freqp = of_get_property(cpu, "clock-frequency", NULL);
 	of_node_put(cpu);
-	if (!cpu)
+	if (!max_freqp) {
+		err = -EINVAL;
 		goto out;
+	}
+
+	/* we need the freq in kHz */
+	max_freq = *max_freqp / 1000;
 
 	dn = of_find_compatible_node(NULL, NULL, "1682m-sdc");
 	if (!dn)
@@ -171,16 +179,6 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	}
 
 	pr_debug("init cpufreq on CPU %d\n", policy->cpu);
-
-	max_freqp = of_get_property(cpu, "clock-frequency", NULL);
-	if (!max_freqp) {
-		err = -EINVAL;
-		goto out_unmap_sdcpwr;
-	}
-
-	/* we need the freq in kHz */
-	max_freq = *max_freqp / 1000;
-
 	pr_debug("max clock-frequency is at %u kHz\n", max_freq);
 	pr_debug("initializing frequency table\n");
 
@@ -198,9 +196,6 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	return cpufreq_generic_init(policy, pas_freqs, get_gizmo_latency());
 
-out_unmap_sdcpwr:
-	iounmap(sdcpwr_mapbase);
-
 out_unmap_sdcasr:
 	iounmap(sdcasr_mapbase);
 out:
-- 
2.20.1



