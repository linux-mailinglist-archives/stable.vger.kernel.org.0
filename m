Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E293E7F93
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhHJRlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235497AbhHJRjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEC36610A8;
        Tue, 10 Aug 2021 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617045;
        bh=y69LQxHSM1vlEm6bJzwJJ37sTQA9YNh71GfDAMWc4e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ytn7HQL6XG2dUdnMbFWkDW++1bBB1/ydX2KqnBQa2dThOv8yQXd8wUeUVH5/HdQiO
         KROfHjtdDw5QtTe2pp4HeLtMnM2MD9SLUk0xbUlBr8Xn7x2Hcz2JjE5LObGM8B5zAh
         rC96syME1fu23W6857K/irRQoxEfPvaeTeiIqUdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/135] clk: tegra: Implement disable_unused() of tegra_clk_sdmmc_mux_ops
Date:   Tue, 10 Aug 2021 19:29:14 +0200
Message-Id: <20210810172956.358396239@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 2bcc025ab9bbd029b1730cde71cb4e4f0ed35d0f ]

Implement disable_unused() callback of tegra_clk_sdmmc_mux_ops to fix
imbalanced disabling of the unused MMC clock on Tegra210 Jetson Nano.

Fixes: c592c8a28f58 ("clk: tegra: Fix refcounting of gate clocks")
Reported-by: Jon Hunter <jonathanh@nvidia.com> # T210 Nano
Tested-by: Jon Hunter <jonathanh@nvidia.com> # T210 Nano
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210717112742.7196-1-digetx@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-sdmmc-mux.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/clk/tegra/clk-sdmmc-mux.c b/drivers/clk/tegra/clk-sdmmc-mux.c
index 316912d3b1a4..4f2c3309eea4 100644
--- a/drivers/clk/tegra/clk-sdmmc-mux.c
+++ b/drivers/clk/tegra/clk-sdmmc-mux.c
@@ -194,6 +194,15 @@ static void clk_sdmmc_mux_disable(struct clk_hw *hw)
 	gate_ops->disable(gate_hw);
 }
 
+static void clk_sdmmc_mux_disable_unused(struct clk_hw *hw)
+{
+	struct tegra_sdmmc_mux *sdmmc_mux = to_clk_sdmmc_mux(hw);
+	const struct clk_ops *gate_ops = sdmmc_mux->gate_ops;
+	struct clk_hw *gate_hw = &sdmmc_mux->gate.hw;
+
+	gate_ops->disable_unused(gate_hw);
+}
+
 static void clk_sdmmc_mux_restore_context(struct clk_hw *hw)
 {
 	struct clk_hw *parent = clk_hw_get_parent(hw);
@@ -218,6 +227,7 @@ static const struct clk_ops tegra_clk_sdmmc_mux_ops = {
 	.is_enabled = clk_sdmmc_mux_is_enabled,
 	.enable = clk_sdmmc_mux_enable,
 	.disable = clk_sdmmc_mux_disable,
+	.disable_unused = clk_sdmmc_mux_disable_unused,
 	.restore_context = clk_sdmmc_mux_restore_context,
 };
 
-- 
2.30.2



