Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02412A5197
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgKCUmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730494AbgKCUmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1615D2224E;
        Tue,  3 Nov 2020 20:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436140;
        bh=y6LYEWEo8WSjrCc+zuYLctxEhV3uhZU/fFRDvDueRZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e891+oelnh5aGU1R/zx7JZzQAIO003hb7Vk4iBcu4aMjpHQxXUhQR5HdsGyAO8hGA
         GAkoeOBdfQ9od40SC2DQD5ZTkoKvu60udsnjn6lKmBM+zB0Tf+M6avURrDkirDzcZE
         Hr97uX2JFAjX73l9pnHs+tbI4MtAOh1mTVDrNbxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 120/391] cpuidle: tegra: Correctly handle result of arm_cpuidle_simple_enter()
Date:   Tue,  3 Nov 2020 21:32:51 +0100
Message-Id: <20201103203354.921748396@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 1170433e6611402b869c583fa1fbfd85106ff066 ]

The enter() callback of CPUIDLE drivers returns index of the entered idle
state on success or a negative value on failure. The negative value could
any negative value, i.e. it doesn't necessarily needs to be a error code.
That's because CPUIDLE core only cares about the fact of failure and not
about the reason of the enter() failure.

Like every other enter() callback, the arm_cpuidle_simple_enter() returns
the entered idle-index on success. Unlike some of other drivers, it never
fails. It happened that TEGRA_C1=index=err=0 in the code of cpuidle-tegra
driver, and thus, there is no problem for the cpuidle-tegra driver created
by the typo in the code which assumes that the arm_cpuidle_simple_enter()
returns a error code.

The arm_cpuidle_simple_enter() also may return a -ENODEV error if CPU_IDLE
is disabled in a kernel's config, but all CPUIDLE drivers are disabled if
CPU_IDLE is disabled, including the cpuidle-tegra driver. So we can't ever
see the error code from arm_cpuidle_simple_enter() today.

Of course the code may get some changes in the future and then the
typo may transform into a real bug, so let's correct the typo! The
tegra_cpuidle_state_enter() is now changed to make it return the entered
idle-index on success and negative error code on fail, which puts it on
par with the arm_cpuidle_simple_enter(), making code consistent in regards
to the error handling.

This patch fixes a minor typo in the code, it doesn't fix any bugs.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-tegra.c | 34 +++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-tegra.c b/drivers/cpuidle/cpuidle-tegra.c
index a12fb141875a7..e8956706a2917 100644
--- a/drivers/cpuidle/cpuidle-tegra.c
+++ b/drivers/cpuidle/cpuidle-tegra.c
@@ -172,7 +172,7 @@ static int tegra_cpuidle_coupled_barrier(struct cpuidle_device *dev)
 static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 				     int index, unsigned int cpu)
 {
-	int ret;
+	int err;
 
 	/*
 	 * CC6 state is the "CPU cluster power-off" state.  In order to
@@ -183,9 +183,9 @@ static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 	 * CPU cores, GIC and L2 cache).
 	 */
 	if (index == TEGRA_CC6) {
-		ret = tegra_cpuidle_coupled_barrier(dev);
-		if (ret)
-			return ret;
+		err = tegra_cpuidle_coupled_barrier(dev);
+		if (err)
+			return err;
 	}
 
 	local_fiq_disable();
@@ -194,15 +194,15 @@ static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 
 	switch (index) {
 	case TEGRA_C7:
-		ret = tegra_cpuidle_c7_enter();
+		err = tegra_cpuidle_c7_enter();
 		break;
 
 	case TEGRA_CC6:
-		ret = tegra_cpuidle_cc6_enter(cpu);
+		err = tegra_cpuidle_cc6_enter(cpu);
 		break;
 
 	default:
-		ret = -EINVAL;
+		err = -EINVAL;
 		break;
 	}
 
@@ -210,7 +210,7 @@ static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 	tegra_pm_clear_cpu_in_lp2();
 	local_fiq_enable();
 
-	return ret;
+	return err ?: index;
 }
 
 static int tegra_cpuidle_adjust_state_index(int index, unsigned int cpu)
@@ -236,21 +236,27 @@ static int tegra_cpuidle_enter(struct cpuidle_device *dev,
 			       int index)
 {
 	unsigned int cpu = cpu_logical_map(dev->cpu);
-	int err;
+	int ret;
 
 	index = tegra_cpuidle_adjust_state_index(index, cpu);
 	if (dev->states_usage[index].disable)
 		return -1;
 
 	if (index == TEGRA_C1)
-		err = arm_cpuidle_simple_enter(dev, drv, index);
+		ret = arm_cpuidle_simple_enter(dev, drv, index);
 	else
-		err = tegra_cpuidle_state_enter(dev, index, cpu);
+		ret = tegra_cpuidle_state_enter(dev, index, cpu);
 
-	if (err && (err != -EINTR || index != TEGRA_CC6))
-		pr_err_once("failed to enter state %d err: %d\n", index, err);
+	if (ret < 0) {
+		if (ret != -EINTR || index != TEGRA_CC6)
+			pr_err_once("failed to enter state %d err: %d\n",
+				    index, ret);
+		index = -1;
+	} else {
+		index = ret;
+	}
 
-	return err ? -1 : index;
+	return index;
 }
 
 static int tegra114_enter_s2idle(struct cpuidle_device *dev,
-- 
2.27.0



