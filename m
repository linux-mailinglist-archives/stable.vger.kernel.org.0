Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D140444B6DD
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344676AbhKIWad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344751AbhKIW2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9051861A7C;
        Tue,  9 Nov 2021 22:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496422;
        bh=3rmI0HOjS667eg5AE/qvuawOwCyc1f9XfLR7kyTPiEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJ+2fPHETVS35FCOYS3FiRp2pqNsd0t8M3payKNDA/2NiBR9waiLoZk53kzHntehI
         bgwRj8ER/xo7o1nW+Mp/5lmuhZ8B1dnxT35MBQJSjMyh4DnxIxwvS+7SGlbDjJDiBh
         njsAToEMjSiDWjesLuZSBTSmla+hdABprkKSdllcPkCaArjpcFJ0RFt/tn4G2iYr6o
         qrcxA7IGkl7ozhRJkyzMGztNZTT5Gme+wiF8iHMkH967ZygZgM/IcGhYtwS0jaE/aZ
         yNeh13YicDhClXFoFsWVzLI7d0gzSsFmt2SX3ToFN+N96iGo+EJZSW4YRFJ9o0Kkzv
         bCf5Dz73IFYUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, rjw@rjwysocki.net,
        swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 47/75] cpuidle: tegra: Check whether PMC is ready
Date:   Tue,  9 Nov 2021 17:18:37 -0500
Message-Id: <20211109221905.1234094-47-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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

