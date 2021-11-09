Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7169844B798
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344785AbhKIWfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345346AbhKIWdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:33:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E249761AE4;
        Tue,  9 Nov 2021 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496516;
        bh=2xIC4RW/7+34GK6xmB3u03swd/O3KlxuJtrTuGNn2wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9aK8oM0UyNxOxkV6TDj0p53OJy5aXgRd1L/hiqUpjV7SD3tRSRAvz5Bt8byHHKdx
         wNlnmlYbKYOoBC7Wwvq34yidrFQMopu/yhqQ5NMm36B86bVFlEFExfcw61JflirK5k
         JBIAmOe1TVF/2Vj2X25kEyv+cwSrVasECG4bIPo+KZt2JxR+am5ukhadEvkEFt5dtE
         NP0mSi23AsoXCa9h9458vpchonj7/Vir2RGSHGen/5ZbWxFYKpj5ARMLHbCzCiI76w
         0vdHCrVmJZRnjk3McVS0Vfl+br4JPmt148DljtS5PzgIIBovcXw3Bdvlyo2firRz/f
         E99kpLQIhEp3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, rjw@rjwysocki.net,
        swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/50] cpuidle: tegra: Check whether PMC is ready
Date:   Tue,  9 Nov 2021 17:20:45 -0500
Message-Id: <20211109222103.1234885-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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
index 29c5e83500d33..e6f96d272d240 100644
--- a/drivers/cpuidle/cpuidle-tegra.c
+++ b/drivers/cpuidle/cpuidle-tegra.c
@@ -346,6 +346,9 @@ static void tegra_cpuidle_setup_tegra114_c7_state(void)
 
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

