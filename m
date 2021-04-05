Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFDA35448C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbhDEQFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239112AbhDEQFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9318613D7;
        Mon,  5 Apr 2021 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638722;
        bh=VwyTyc1eI318qj0z3bpjXi4ZkjQ7OVSzfFptGPlngNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frEqV7kb/GvIMdA7zT+tlhsCxj6LFfbGwtV+U13KPNOpWwer8UCekD6mZeVAtiw5m
         YCrVDGyORbZWSwvb+XuSJ0gxIaFUExbzUeW7xk5+UpXtpN9S9e6L7Bzn8mfHqL9aTd
         KihhliFV8Jq25zsm1TIe2ruOrc7Ed5Usd3nLyzUQCRxZF2y4mT/ebntueMgJG2Cfvx
         ausgwOteYxVxjqFfwjdbOWBGSCHhpyHcnOnEOtFX7hErySVvdT90oKDQCY9jzpSJWb
         6zsBPHLa/jEfCXivhNlwGDrFJ1osSlTNmIsKVinUiP7YxDh1JVoaL2J3P/+GRIMQGr
         LqKrhKqIld3ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/8] drm/tegra: dc: Don't set PLL clock to 0Hz
Date:   Mon,  5 Apr 2021 12:05:12 -0400
Message-Id: <20210405160515.269020-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160515.269020-1-sashal@kernel.org>
References: <20210405160515.269020-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit f8fb97c915954fc6de6513cdf277103b5c6df7b3 ]

RGB output doesn't allow to change parent clock rate of the display and
PCLK rate is set to 0Hz in this case. The tegra_dc_commit_state() shall
not set the display clock to 0Hz since this change propagates to the
parent clock. The DISP clock is defined as a NODIV clock by the tegra-clk
driver and all NODIV clocks use the CLK_SET_RATE_PARENT flag.

This bug stayed unnoticed because by default PLLP is used as the parent
clock for the display controller and PLLP silently skips the erroneous 0Hz
rate changes because it always has active child clocks that don't permit
rate changes. The PLLP isn't acceptable for some devices that we want to
upstream (like Samsung Galaxy Tab and ASUS TF700T) due to a display panel
clock rate requirements that can't be fulfilled by using PLLP and then the
bug pops up in this case since parent clock is set to 0Hz, killing the
display output.

Don't touch DC clock if pclk=0 in order to fix the problem.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 965088afcfad..03adb4cf325b 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1670,6 +1670,11 @@ static void tegra_dc_commit_state(struct tegra_dc *dc,
 			dev_err(dc->dev,
 				"failed to set clock rate to %lu Hz\n",
 				state->pclk);
+
+		err = clk_set_rate(dc->clk, state->pclk);
+		if (err < 0)
+			dev_err(dc->dev, "failed to set clock %pC to %lu Hz: %d\n",
+				dc->clk, state->pclk, err);
 	}
 
 	DRM_DEBUG_KMS("rate: %lu, div: %u\n", clk_get_rate(dc->clk),
@@ -1680,11 +1685,6 @@ static void tegra_dc_commit_state(struct tegra_dc *dc,
 		value = SHIFT_CLK_DIVIDER(state->div) | PIXEL_CLK_DIVIDER_PCD1;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
 	}
-
-	err = clk_set_rate(dc->clk, state->pclk);
-	if (err < 0)
-		dev_err(dc->dev, "failed to set clock %pC to %lu Hz: %d\n",
-			dc->clk, state->pclk, err);
 }
 
 static void tegra_dc_stop(struct tegra_dc *dc)
-- 
2.30.2

