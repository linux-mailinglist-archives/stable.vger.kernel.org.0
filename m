Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F19B27012
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbfEVUBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 16:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbfEVTWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:22:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE3420644;
        Wed, 22 May 2019 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552964;
        bh=TP3iBva7O5ieEKp+E7ZEWUR+t6oPzbfSaYw1ksCHGyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlW9H9+hpBVnxHeyhkk9ydSlXq2IyjkK7MWudWHA2GC/6msvug/hNK4jSakhtXaOL
         9QfL6V6ettK6mxRwATI8c2pTCODYTbCX2DS8YwAH24PfvGtgZKWoImOEJZzx4PiLeJ
         lVr2nsq3KgrPImemhyKm8RZNjOQUrVmOz1nmBUKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        "Tobin C . Harding" <tobin@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 050/375] cpufreq: Fix kobject memleak
Date:   Wed, 22 May 2019 15:15:50 -0400
Message-Id: <20190522192115.22666-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

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

