Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F60A3032FB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbhAZEmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:42:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbhAYSmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47C15224BE;
        Mon, 25 Jan 2021 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600063;
        bh=d7ogqVVpOdGNkRMRKs7I5o4viurZ7VIllf8oL4WB7Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmuKQ5A+qPyK7zhUESJNw79DofkO0YA9qSK8OqAlJBMEKNlh3LplY9uXm4vWKoHy8
         MBLJRFM4CAulFY51scA35CKrWB8MSYWknNDRhUA24OfMCEd+8qO1jc7oZYGrRr0cyK
         9C1/SXJxiYut5e1pt8hmPEUCmwPwLoPcc7MwGw1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ion Agorria <ion@agorria.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/58] clk: tegra30: Add hda clock default rates to clock driver
Date:   Mon, 25 Jan 2021 19:39:18 +0100
Message-Id: <20210125183157.429028279@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit f4eccc7fea203cfb35205891eced1ab51836f362 ]

Current implementation defaults the hda clocks to clk_m. This causes hda
to run too slow to operate correctly. Fix this by defaulting to pll_p and
setting the frequency to the correct rate.

This matches upstream t124 and downstream t30.

Acked-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Ion Agorria <ion@agorria.com>
Acked-by: Sameer Pujar <spujar@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Link: https://lore.kernel.org/r/20210108135913.2421585-2-pgwipeout@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra30.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index e0aaecd98fbff..678019f86bc7a 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1274,6 +1274,8 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA30_CLK_I2S3_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
 	{ TEGRA30_CLK_I2S4_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
 	{ TEGRA30_CLK_VIMCLK_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA30_CLK_HDA, TEGRA30_CLK_PLL_P, 102000000, 0 },
+	{ TEGRA30_CLK_HDA2CODEC_2X, TEGRA30_CLK_PLL_P, 48000000, 0 },
 	/* must be the last entry */
 	{ TEGRA30_CLK_CLK_MAX, TEGRA30_CLK_CLK_MAX, 0, 0 },
 };
-- 
2.27.0



