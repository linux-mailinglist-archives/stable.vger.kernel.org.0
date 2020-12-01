Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2422C9B32
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgLAJFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388966AbgLAJEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A767B2222A;
        Tue,  1 Dec 2020 09:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813451;
        bh=lj4Rg/mQW2j/Hrddgp8245rud0jqnoIpCn/rM+HoZ/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StFwfa//wVd1h5N8wsSzXQ6jMZ0YSCxkftc4DWIyhXN4OPNunQHc8yjlz/5xeqjZR
         TC6GgBtv2UCgdUxc34RYImr6pYl8a4qK19UOLIKopa2d/ZS/UtBp/SwkYzeWsYYbMv
         xGX2G/r2lroikcIdfRbs8TvGKLZ5VsYRY4qwMAP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/98] ARM: OMAP2+: Manage MPU state properly for omap_enter_idle_coupled()
Date:   Tue,  1 Dec 2020 09:53:20 +0100
Message-Id: <20201201084657.218480683@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 294a3317bef52b189139c813b50dd14d344fa9ec ]

Based on more testing, commit 8ca5ee624b4c ("ARM: OMAP2+: Restore MPU
power domain if cpu_cluster_pm_enter() fails") is a poor fix for handling
cpu_cluster_pm_enter() returned errors.

We should not override the cpuidle states with a hardcoded PWRDM_POWER_ON
value. Instead, we should use a configured idle state that does not cause
the context to be lost. Otherwise we end up configuring a potentially
improper state for the MPUSS. We also want to update the returned state
index for the selected state.

Let's just select the highest power idle state C1 to ensure no context
loss is allowed on cpu_cluster_pm_enter() errors. With these changes we
can now unconditionally call omap4_enter_lowpower() for WFI like we did
earlier before commit 55be2f50336f ("ARM: OMAP2+: Handle errors for
cpu_pm"). And we can return the selected state index.

Fixes: 8f04aea048d5 ("ARM: OMAP2+: Restore MPU power domain if cpu_cluster_pm_enter() fails")
Fixes: 55be2f50336f ("ARM: OMAP2+: Handle errors for cpu_pm")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/cpuidle44xx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
index a92d277f81a08..c8d317fafe2ea 100644
--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -175,8 +175,11 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 		if (mpuss_can_lose_context) {
 			error = cpu_cluster_pm_enter();
 			if (error) {
-				omap_set_pwrdm_state(mpu_pd, PWRDM_POWER_ON);
-				goto cpu_cluster_pm_out;
+				index = 0;
+				cx = state_ptr + index;
+				pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
+				omap_set_pwrdm_state(mpu_pd, cx->mpu_state);
+				mpuss_can_lose_context = 0;
 			}
 		}
 	}
@@ -184,7 +187,6 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 	omap4_enter_lowpower(dev->cpu, cx->cpu_state);
 	cpu_done[dev->cpu] = true;
 
-cpu_cluster_pm_out:
 	/* Wakeup CPU1 only if it is not offlined */
 	if (dev->cpu == 0 && cpumask_test_cpu(1, cpu_online_mask)) {
 
-- 
2.27.0



