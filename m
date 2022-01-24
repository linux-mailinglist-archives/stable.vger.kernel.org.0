Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BE049969B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445893AbiAXVFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53558 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444396AbiAXVAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:00:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0AD4612E9;
        Mon, 24 Jan 2022 21:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4F6C340E5;
        Mon, 24 Jan 2022 21:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058048;
        bh=AuuH0Kty7H2/ZTZUm98NLAwa0+UopAyoe2zfWSIK1HU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wd45aYVFvtw+cucv9Fcjw+A63o8/+DI2YvUwm44ikSixlEdUWmxVK8j83Uc6zXVIX
         kD/IzjeXc01yTbcE2Tn5Pse8Us/HdS4+ioUkIkSATGKsQgtj4ATSiXI9gz22IESY9R
         B/GjiqB5Yc3db8NPm2LUCmCvrTZjSTSw5TDo7nTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thara Gopinath <thara.gopinath@linaro.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0165/1039] cpufreq: qcom-cpufreq-hw: Update offline CPUs per-cpu thermal pressure
Date:   Mon, 24 Jan 2022 19:32:34 +0100
Message-Id: <20220124184130.767895775@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit 93d9e6f93e1586fcc97498c764be2e8c8401f4bd ]

The thermal pressure signal gives information to the scheduler about
reduced CPU capacity due to thermal. It is based on a value stored in
a per-cpu 'thermal_pressure' variable. The online CPUs will get the
new value there, while the offline won't. Unfortunately, when the CPU
is back online, the value read from per-cpu variable might be wrong
(stale data).  This might affect the scheduler decisions, since it
sees the CPU capacity differently than what is actually available.

Fix it by making sure that all online+offline CPUs would get the
proper value in their per-cpu variable when there is throttling
or throttling is removed.

Fixes: 275157b367f479 ("cpufreq: qcom-cpufreq-hw: Add dcvs interrupt support")
Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index a2be0df7e1747..0138b2ec406dc 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -304,7 +304,8 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 	if (capacity > max_capacity)
 		capacity = max_capacity;
 
-	arch_set_thermal_pressure(policy->cpus, max_capacity - capacity);
+	arch_set_thermal_pressure(policy->related_cpus,
+				  max_capacity - capacity);
 
 	/*
 	 * In the unlikely case policy is unregistered do not enable
-- 
2.34.1



