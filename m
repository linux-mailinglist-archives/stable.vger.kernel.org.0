Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C290326EF21
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgIRCdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729000AbgIRCNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:13:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 238F123A1B;
        Fri, 18 Sep 2020 02:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395227;
        bh=r0fzL6YVMGGhXXkUtEr7IjOsYdFCQGKvXJKkW9V/Jgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiHuD5XWMXfBDH2laPvBYiy8JMfPjppQFCnCNZsIYhGKAgUJpBS9YoVo+ZaLN6eyr
         tjQs2WnWh6TXGp2zpT+OwBJUIRWOOekpu+/87NwNXZymiN3LnnNew+ox0G9bRnF1+t
         lOg232M9FwXjXUOUXyKTXxb6yS+HL/3LiuqXmbfU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pratik Rajesh Sampat <psampat@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 073/127] cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_work_fn
Date:   Thu, 17 Sep 2020 22:11:26 -0400
Message-Id: <20200918021220.2066485-73-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pratik Rajesh Sampat <psampat@linux.ibm.com>

[ Upstream commit d95fe371ecd28901f11256c610b988ed44e36ee2 ]

The patch avoids allocating cpufreq_policy on stack hence fixing frame
size overflow in 'powernv_cpufreq_work_fn'

Fixes: 227942809b52 ("cpufreq: powernv: Restore cpu frequency to policy->cur on unthrottling")
Signed-off-by: Pratik Rajesh Sampat <psampat@linux.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200316135743.57735-1-psampat@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/powernv-cpufreq.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 25c9a6cdd8614..dc81fc2bf8015 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -864,6 +864,7 @@ static struct notifier_block powernv_cpufreq_reboot_nb = {
 void powernv_cpufreq_work_fn(struct work_struct *work)
 {
 	struct chip *chip = container_of(work, struct chip, throttle);
+	struct cpufreq_policy *policy;
 	unsigned int cpu;
 	cpumask_t mask;
 
@@ -878,12 +879,14 @@ void powernv_cpufreq_work_fn(struct work_struct *work)
 	chip->restore = false;
 	for_each_cpu(cpu, &mask) {
 		int index;
-		struct cpufreq_policy policy;
 
-		cpufreq_get_policy(&policy, cpu);
-		index = cpufreq_table_find_index_c(&policy, policy.cur);
-		powernv_cpufreq_target_index(&policy, index);
-		cpumask_andnot(&mask, &mask, policy.cpus);
+		policy = cpufreq_cpu_get(cpu);
+		if (!policy)
+			continue;
+		index = cpufreq_table_find_index_c(policy, policy->cur);
+		powernv_cpufreq_target_index(policy, index);
+		cpumask_andnot(&mask, &mask, policy->cpus);
+		cpufreq_cpu_put(policy);
 	}
 out:
 	put_online_cpus();
-- 
2.25.1

