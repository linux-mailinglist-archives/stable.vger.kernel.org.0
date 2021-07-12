Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8653C480B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhGLGfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237852AbhGLGez (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01E316112D;
        Mon, 12 Jul 2021 06:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071508;
        bh=bzbaR6zHyOg6xGHCETQ8JeXmpT3Bz2gN55FB7i7Rvsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqVxmR4SVx6/KHa+6U1YqF2Cplkj4Fuc1BoxDD/LOxBhKcEUKGVmfdiyJm8MFk2fu
         SbiXwjPJeSrPfVw574ZHQ0yegqv99yVKTLiITmZ84QkeKVieRl7H3OjvpofepRdHqe
         AB0LfCNwwKifpG6iC8WCZ3P5OR4Mj6kmstiyp5X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/593] thermal/cpufreq_cooling: Update offline CPUs per-cpu thermal_pressure
Date:   Mon, 12 Jul 2021 08:04:19 +0200
Message-Id: <20210712060854.110003059@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit 2ad8ccc17d1e4270cf65a3f2a07a7534aa23e3fb ]

The thermal pressure signal gives information to the scheduler about
reduced CPU capacity due to thermal. It is based on a value stored in
a per-cpu 'thermal_pressure' variable. The online CPUs will get the
new value there, while the offline won't. Unfortunately, when the CPU
is back online, the value read from per-cpu variable might be wrong
(stale data).  This might affect the scheduler decisions, since it
sees the CPU capacity differently than what is actually available.

Fix it by making sure that all online+offline CPUs would get the
proper value in their per-cpu variable when thermal framework sets
capping.

Fixes: f12e4f66ab6a3 ("thermal/cpu-cooling: Update thermal pressure in case of a maximum frequency capping")
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20210614191030.22241-1-lukasz.luba@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/cpufreq_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index 3f6a69ccc173..6e1d6a31ee4f 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -443,7 +443,7 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 	ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
 	if (ret >= 0) {
 		cpufreq_cdev->cpufreq_state = state;
-		cpus = cpufreq_cdev->policy->cpus;
+		cpus = cpufreq_cdev->policy->related_cpus;
 		max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));
 		capacity = frequency * max_capacity;
 		capacity /= cpufreq_cdev->policy->cpuinfo.max_freq;
-- 
2.30.2



