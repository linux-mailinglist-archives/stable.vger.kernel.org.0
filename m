Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5099DAC
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392814AbfHVRo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403886AbfHVRXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:16 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B65223402;
        Thu, 22 Aug 2019 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494595;
        bh=mnf5COArq3hLz3KooqmSQrH21iA5dKmpOGBJor1o/xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGoZvzqZBx+haVrtVYLRkqKQSleDOX3L26rh2RQ9AYzFcrXKZc5vW8+BtQmzG0UdZ
         QpnWRI2/RWIABtjOmUseeYN+dKXrwYoNTTa46oHrHZuSb5fkHfVNKRNcpSZD2iy50s
         XKTYAl2cGC55FvwVUCVDNQHNvnvZNIUFHz3F9Toc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 016/103] cpufreq/pasemi: fix use-after-free in pas_cpufreq_cpu_init()
Date:   Thu, 22 Aug 2019 10:18:04 -0700
Message-Id: <20190822171729.503980454@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
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
index 58c933f483004..991b6a3062c4f 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -145,10 +145,18 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
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
@@ -185,16 +193,6 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
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
 
@@ -212,9 +210,6 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	return cpufreq_generic_init(policy, pas_freqs, get_gizmo_latency());
 
-out_unmap_sdcpwr:
-	iounmap(sdcpwr_mapbase);
-
 out_unmap_sdcasr:
 	iounmap(sdcasr_mapbase);
 out:
-- 
2.20.1



