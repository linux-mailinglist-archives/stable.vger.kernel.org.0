Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3F7360D70
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhDOPC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234937AbhDOPAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036C76140B;
        Thu, 15 Apr 2021 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498560;
        bh=VwyTyc1eI318qj0z3bpjXi4ZkjQ7OVSzfFptGPlngNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VELgj7/KE9+lCgjrzZQ36Ybp/1Jli0CYtcCmXN7fOHmhfdXdenFabDPpoC3YhAGF1
         C9txxZ5GedTV6Fu5PMGsNPNFlwPrpnnaCf+GZu8Wc1QxZ+Vf0U+iOiqgyFoDaSyacs
         L+p79FcmzG/wgflRZnOT2sklUwXicUjRIEQ/J6cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/13] drm/tegra: dc: Dont set PLL clock to 0Hz
Date:   Thu, 15 Apr 2021 16:47:54 +0200
Message-Id: <20210415144411.770033170@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



