Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9456744B618
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343788AbhKIWZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343784AbhKIWV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:21:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CF3F61207;
        Tue,  9 Nov 2021 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496293;
        bh=3rmI0HOjS667eg5AE/qvuawOwCyc1f9XfLR7kyTPiEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJ8MlI4E67Iawx7zgsKwq16jGUnLj8dFsWEPRXpqO2eVq9bx8hynSbikDsgj6Beb9
         C9BCgpDx0CP5VudzbKEV+m5N5yZl5ztnUgdqfpGSpIkTbFEcneT1ALX1+KOR9r1100
         PU3M2SbwVJKFP3v1NOD9OdXl8XOdC5NLGP5t+sXrwF/eh6GWYupy9S1IPz75pG9KFf
         MIcUUzvu0Fm42Tgny7epxQxR481bYcpTiNddIVq7hQKclrn+Wl39p8IoeJDRMcX9xc
         0nQA+OrvCA35+i00ESKTcKLfSpxG/tTjh22B8KJkPYF8OowZmGWp4LvtkTRIObGEAy
         9NkMgLGW50IHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, rjw@rjwysocki.net,
        swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 50/82] cpuidle: tegra: Check whether PMC is ready
Date:   Tue,  9 Nov 2021 17:16:08 -0500
Message-Id: <20211109221641.1233217-50-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit bdb1ffdad3b73e4d0538098fc02e2ea87a6b27cd ]

Check whether PMC is ready before proceeding with the cpuidle registration.
This fixes racing with the PMC driver probe order, which results in a
disabled deepest CC6 idling state if cpuidle driver is probed before the
PMC.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-tegra.c b/drivers/cpuidle/cpuidle-tegra.c
index 508bd9f237929..9845629aeb6d4 100644
--- a/drivers/cpuidle/cpuidle-tegra.c
+++ b/drivers/cpuidle/cpuidle-tegra.c
@@ -337,6 +337,9 @@ static void tegra_cpuidle_setup_tegra114_c7_state(void)
 
 static int tegra_cpuidle_probe(struct platform_device *pdev)
 {
+	if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
+		return -EPROBE_DEFER;
+
 	/* LP2 could be disabled in device-tree */
 	if (tegra_pmc_get_suspend_mode() < TEGRA_SUSPEND_LP2)
 		tegra_cpuidle_disable_state(TEGRA_CC6);
-- 
2.33.0

