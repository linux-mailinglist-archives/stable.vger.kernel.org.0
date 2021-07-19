Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1C3CE423
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348330AbhGSPmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234856AbhGSPgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54419606A5;
        Mon, 19 Jul 2021 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711444;
        bh=fP0m3WY17hnKw1M+oJUapFVATVZnva9yK9aXl3RzQ+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjFSAYdGvEpbWhczQwayI2ph03F2TNO53AEtlzKWEVOeHF7kRg98s/5yT3ZnGbqHp
         mDJ1/jTq4nDRbAc4gkqwN+PvFSD41J1xchGLyWlz8CKVKs4OqrWHnDrF6j2owcX+Tj
         pK0N96XlTxfMSCU6MWdhGQLkHw21aW3ZvVoLdJnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Qian Cai <quic_qiancai@quicinc.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 349/351] cpufreq: CPPC: Fix potential memleak in cppc_cpufreq_cpu_init
Date:   Mon, 19 Jul 2021 16:54:55 +0200
Message-Id: <20210719144956.621145339@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit fe2535a44904a77615a3af8e8fd7dafb98fb0e1b ]

It's a classic example of memleak, we allocate something, we fail and
never free the resources.

Make sure we free all resources on policy ->init() failures.

Fixes: a28b2bfc099c ("cppc_cpufreq: replace per-cpu data array with a list")
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Ionela Voinescu <ionela.voinescu@arm.com>
Tested-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 2f769b1630c5..a27445f40d2c 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -182,6 +182,16 @@ static int cppc_verify_policy(struct cpufreq_policy_data *policy)
 	return 0;
 }
 
+static void cppc_cpufreq_put_cpu_data(struct cpufreq_policy *policy)
+{
+	struct cppc_cpudata *cpu_data = policy->driver_data;
+
+	list_del(&cpu_data->node);
+	free_cpumask_var(cpu_data->shared_cpu_map);
+	kfree(cpu_data);
+	policy->driver_data = NULL;
+}
+
 static void cppc_cpufreq_stop_cpu(struct cpufreq_policy *policy)
 {
 	struct cppc_cpudata *cpu_data = policy->driver_data;
@@ -196,11 +206,7 @@ static void cppc_cpufreq_stop_cpu(struct cpufreq_policy *policy)
 		pr_debug("Err setting perf value:%d on CPU:%d. ret:%d\n",
 			 caps->lowest_perf, cpu, ret);
 
-	/* Remove CPU node from list and free driver data for policy */
-	free_cpumask_var(cpu_data->shared_cpu_map);
-	list_del(&cpu_data->node);
-	kfree(policy->driver_data);
-	policy->driver_data = NULL;
+	cppc_cpufreq_put_cpu_data(policy);
 }
 
 /*
@@ -330,7 +336,8 @@ static int cppc_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	default:
 		pr_debug("Unsupported CPU co-ord type: %d\n",
 			 policy->shared_type);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out;
 	}
 
 	/*
@@ -345,10 +352,16 @@ static int cppc_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	cpu_data->perf_ctrls.desired_perf =  caps->highest_perf;
 
 	ret = cppc_set_perf(cpu, &cpu_data->perf_ctrls);
-	if (ret)
+	if (ret) {
 		pr_debug("Err setting perf value:%d on CPU:%d. ret:%d\n",
 			 caps->highest_perf, cpu, ret);
+		goto out;
+	}
 
+	return 0;
+
+out:
+	cppc_cpufreq_put_cpu_data(policy);
 	return ret;
 }
 
-- 
2.30.2



