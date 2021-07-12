Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CA93C5397
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348180AbhGLHzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350513AbhGLHvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 467DF61154;
        Mon, 12 Jul 2021 07:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075952;
        bh=LRyo0z9XixhqeLbRiOlXLBFxXwRmLmk/xctV13uYFM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl0TaFSmzrjXzyvXtK9SmJHa3xkwBKTcjzJJxVXtDa43fhJJ5pl1r2+1NeznDKPFa
         CDP7KgkU8DN9VCfxPKkb9cNtsdhHkT/W9SSSCKGLmV1zQ+DId3JCcTF2/rD8hC4Nzp
         cw9EllfpfPL8AN2gRnV+JrZYNGNZeLF8q/w81YfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 436/800] clk: tegra30: Use 300MHz for video decoder by default
Date:   Mon, 12 Jul 2021 08:07:39 +0200
Message-Id: <20210712061013.459135685@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 56bb7c28ad00e7bcfc851c4e183c42d148d3ad4e ]

The 600MHz is a too high clock rate for some SoC versions for the video
decoder hardware and this may cause stability issues. Use 300MHz for the
video decoder by default, which is supported by all hardware versions.

Fixes: ed1a2459e20c ("clk: tegra: Add Tegra20/30 EMC clock implementation")
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 16dbf83d2f62..a33688b2359e 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1245,7 +1245,7 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA30_CLK_GR3D, TEGRA30_CLK_PLL_C, 300000000, 0 },
 	{ TEGRA30_CLK_GR3D2, TEGRA30_CLK_PLL_C, 300000000, 0 },
 	{ TEGRA30_CLK_PLL_U, TEGRA30_CLK_CLK_MAX, 480000000, 0 },
-	{ TEGRA30_CLK_VDE, TEGRA30_CLK_PLL_C, 600000000, 0 },
+	{ TEGRA30_CLK_VDE, TEGRA30_CLK_PLL_C, 300000000, 0 },
 	{ TEGRA30_CLK_SPDIF_IN_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
 	{ TEGRA30_CLK_I2S0_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
 	{ TEGRA30_CLK_I2S1_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
-- 
2.30.2



