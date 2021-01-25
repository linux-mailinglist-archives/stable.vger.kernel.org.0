Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D756302A97
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbhAYSoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729288AbhAYSor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:44:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49F822460;
        Mon, 25 Jan 2021 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600247;
        bh=EbDvrSM9XOkP9uHJHSEhVoZGXE8b80g6BNmz3C88Zlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/vOqcpKbiPoY7wL7MZUzPl0vaqvqdsbuaBbuUyuHTZ9K+d8kqts9IVCsfwvf5vQK
         RsbIYdkIR0UvBjuG13gWHo94EwlPe3b22tbx0BZA6tLXqVwvlbQ1HYStRPYeyiqsVv
         U4gv1LWl4S24inZ1qVeyxOcMD/AUZbsXB2WhCnkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ion Agorria <ion@agorria.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/86] clk: tegra30: Add hda clock default rates to clock driver
Date:   Mon, 25 Jan 2021 19:39:10 +0100
Message-Id: <20210125183202.243942436@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
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
index 7b4c6a488527d..501929d9f70ed 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1263,6 +1263,8 @@ static struct tegra_clk_init_table init_table[] __initdata = {
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



