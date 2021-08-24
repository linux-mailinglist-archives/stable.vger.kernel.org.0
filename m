Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52873F63B3
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhHXQ5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233753AbhHXQ5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 653186141B;
        Tue, 24 Aug 2021 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824199;
        bh=xJnj4NKRrUyZ8Ye8gdpeo+POkDDlUx6Ryv2YyXYGeSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlmPGlriXKIBvtqnB3F+9O0XsC2iHXUWXEXcWY+QsIb2SG/qj9wH806t7LsH0mbD1
         UMFIvR11lo9+7L3NzvkxTnCq2NmKYsZUW53K1mCLlv5VjJhxJRbSOVYgdQ+TttCnyi
         GgjHyLNaOn7lgzmgjFwmmVUacD5YIMitCl9hKh6e1nNoykeREWtuoiXtY8oJnyNkFT
         QtreHRaArSr8gpxZjZIeQjVxMJmY7qf38A3ODKXh5IZNhfgW6PEGYK2yO/4PRt7RbQ
         /+PaSe+ZhlLw6/GwcnKdpKkP9GESJXFp54ZIcm6L9u1H0WHcumaThbKcSxv7S5/ITa
         0y1ZfBwM+TgUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukasz Luba <lukasz.luba@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 031/127] cpufreq: arm_scmi: Fix error path when allocation failed
Date:   Tue, 24 Aug 2021 12:54:31 -0400
Message-Id: <20210824165607.709387-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit f7d635883fb73414c7c4e2648b42adc296c5d40d ]

Stop the initialization when cpumask allocation failed and return an
error.

Fixes: 80a064dbd556 ("scmi-cpufreq: Get opp_shared_cpus from opp-v2 for EM")
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index ec9a87ca2dbb..75f818d04b48 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -134,7 +134,7 @@ static int scmi_cpufreq_init(struct cpufreq_policy *policy)
 	}
 
 	if (!zalloc_cpumask_var(&opp_shared_cpus, GFP_KERNEL))
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	/* Obtain CPUs that share SCMI performance controls */
 	ret = scmi_get_sharing_cpus(cpu_dev, policy->cpus);
-- 
2.30.2

