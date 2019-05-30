Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA32F675
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfE3E4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfE3DKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:07 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48467244B2;
        Thu, 30 May 2019 03:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185807;
        bh=lRmJIZw+ba2FZo1nR3YVt2jbgh9JHH8uJGxiZiXFWa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJBar6aCNC61ijLA8yA71nhsqCtE3tjnnxE0B+Z1IpABOx8UiWfbUvcyzvP9m7kiX
         M8QQ3/4mMI7Ln3oSLdMKIsrckMX01019LGfclZ35DCLBkk60f5dDfGZ6eYjr3BNqYD
         CO2c7mq6y1HCl8O3UgCT3fjZYIS7SQb8eVMQUZys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "Tobin C. Harding" <tobin@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 090/405] cpufreq: Fix kobject memleak
Date:   Wed, 29 May 2019 20:01:28 -0700
Message-Id: <20190530030545.590218618@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4ebe36c94aed95de71a8ce6a6762226d31c938ee ]

Currently the error return path from kobject_init_and_add() is not
followed by a call to kobject_put() - which means we are leaking the
kobject.

Fix it by adding a call to kobject_put() in the error path of
kobject_init_and_add().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Tobin C. Harding <tobin@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c          | 1 +
 drivers/cpufreq/cpufreq_governor.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e10922709d139..bbf79544d0ad8 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1098,6 +1098,7 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 				   cpufreq_global_kobject, "policy%u", cpu);
 	if (ret) {
 		pr_err("%s: failed to init policy->kobj: %d\n", __func__, ret);
+		kobject_put(&policy->kobj);
 		goto err_free_real_cpus;
 	}
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index ffa9adeaba31b..9d1d9bf02710b 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -459,6 +459,8 @@ int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 	/* Failure, so roll back. */
 	pr_err("initialization failed (dbs_data kobject init error %d)\n", ret);
 
+	kobject_put(&dbs_data->attr_set.kobj);
+
 	policy->governor_data = NULL;
 
 	if (!have_governor_per_policy())
-- 
2.20.1



