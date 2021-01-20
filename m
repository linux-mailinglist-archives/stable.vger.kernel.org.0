Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC6D2FC7DD
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbhATC2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbhATB1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A9912332B;
        Wed, 20 Jan 2021 01:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105987;
        bh=nNAHqXNlik6Lp82foU7Am+8xOHXb3VK7DiEQfGKesrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUvMxfwZAUvNUP5vM9uOP5vsjUqo4JDbhpSyYV92yp6c60eV/k9E4pHYbu+0VeXFc
         O1Uvxl7ve+30nkE0EcMzkjzHfYf3wWvT1NtLk2Y1V5JyybE1PHZqOsWP5Mu9COtjRy
         fg5GCdIF0/+p2yhiWEE7I5GnDkkOOCB1XOT/NdqqaTbDAMm1tBgExcIVE8Y4e9pXid
         gYpr6RuWfn/JOyT3LJCobWimEiGU3mI+DZxEWQ+8oOtgZlDFkwr1K8oewLJplDFqvM
         rLeDiUsb1RjsJuRT+eGoedxI4A27goYDIQvyQLMxT+uWLoj3X571tELf3X4gZRQ63M
         t+xOy7dwyCK7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Ion Agorria <ion@agorria.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        linux-clk@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/45] clk: tegra30: Add hda clock default rates to clock driver
Date:   Tue, 19 Jan 2021 20:25:36 -0500
Message-Id: <20210120012602.769683-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 37244a7e68c22..9cf249c344d9e 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1256,6 +1256,8 @@ static struct tegra_clk_init_table init_table[] __initdata = {
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

