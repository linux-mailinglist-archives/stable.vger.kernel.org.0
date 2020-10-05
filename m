Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB06F2839F1
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgJEP3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgJEP3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E669E2074F;
        Mon,  5 Oct 2020 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911786;
        bh=AjPMVTF9I1erYN6vO/I5kFxYaLBLn5v87XHD0W5aIdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTKtQWm+PRlqKJfHdLptTJFN5RMKaIdo3HCubncNT4w+AsK0zBE3ZaN+9Qi8WXDN+
         7fzkhZBXqJ0ocW705IDetephdTghLp2rpa3Robks0BYiUWyjuEierVNNBWxqxyPEIz
         IJi5c99nQZokP1/u0eJ3Pj1da0MTialiGG5v4CBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LABBE Corentin <clabbe@baylibre.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/57] clk: tegra: Always program PLL_E when enabled
Date:   Mon,  5 Oct 2020 17:26:49 +0200
Message-Id: <20201005142111.597852299@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 5105660ee80862b85f7769626d0f936c18ce1885 ]

Commit bff1cef5f23a ("clk: tegra: Don't enable already enabled PLLs")
added checks to avoid enabling PLLs that have already been enabled by
the bootloader. However, the PLL_E configuration inherited from the
bootloader isn't necessarily the one that is needed for the kernel.

This can cause SATA to fail like this:

    [    5.310270] phy phy-sata.6: phy poweron failed --> -110
    [    5.315604] tegra-ahci 70027000.sata: failed to power on AHCI controller: -110
    [    5.323022] tegra-ahci: probe of 70027000.sata failed with error -110

Fix this by always programming the PLL_E. This ensures that any mis-
configuration by the bootloader will be overwritten by the kernel.

Fixes: bff1cef5f23a ("clk: tegra: Don't enable already enabled PLLs")
Reported-by: LABBE Corentin <clabbe@baylibre.com>
Tested-by: Corentin Labbe <clabbe@baylibre.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-pll.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 1583f5fc992f3..80f640d9ea71c 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1569,9 +1569,6 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	unsigned long flags = 0;
 	unsigned long input_rate;
 
-	if (clk_pll_is_enabled(hw))
-		return 0;
-
 	input_rate = clk_hw_get_rate(clk_hw_get_parent(hw));
 
 	if (_get_table_rate(hw, &sel, pll->params->fixed_rate, input_rate))
-- 
2.25.1



