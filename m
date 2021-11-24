Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E425745C2C6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347006AbhKXNcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:32:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351255AbhKXNaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:30:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7EAF61BB3;
        Wed, 24 Nov 2021 12:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758319;
        bh=2xIC4RW/7+34GK6xmB3u03swd/O3KlxuJtrTuGNn2wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2eUxihtTZl1oXStsDT3tsNHRGP6SCDYwPgbIfYxZz6Zz8FoJU+2nVHAqpoy4qXZ7Q
         NEAGi7W4YSP+RR6bRsOw7avf5fHYPCGv9sQD53DPDRke144QcsuxcD2ODiWGFcxpSC
         1Wr2ZLZC9ZPi4QSjMdnqrPbISyKw0sVyZqee4tZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/154] cpuidle: tegra: Check whether PMC is ready
Date:   Wed, 24 Nov 2021 12:57:06 +0100
Message-Id: <20211124115703.340414140@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



