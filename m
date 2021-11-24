Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B7645C4AC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351996AbhKXNut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354234AbhKXNtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29E116335F;
        Wed, 24 Nov 2021 13:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758974;
        bh=3rmI0HOjS667eg5AE/qvuawOwCyc1f9XfLR7kyTPiEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGqTgUZvnPicHVLyegLuEF7YeLyFBgqR2Rs1RFfleho8w0wxS83DSpesihES+7yDF
         kiFmVqxxp6nXjI0HtWkmUXEcRtL4N8C7RFOLSRi7ZsAcyFExfhGQFC1McAD5sHUKEu
         3P2KEv0dB7yFstjuuOEeRo9ok/8+CPfTbJXcn4+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/279] cpuidle: tegra: Check whether PMC is ready
Date:   Wed, 24 Nov 2021 12:55:36 +0100
Message-Id: <20211124115720.426435953@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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



