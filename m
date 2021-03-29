Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D212334C890
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhC2IXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhC2IV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B566196E;
        Mon, 29 Mar 2021 08:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006087;
        bh=1w8tX1yoI2pIGLprEeWIUmAeaQBx+sPnlgze9bjc7Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ovonnmP0WG0pKwzqYIf5rSDsegeI+X2jsSY+3WSkEtL2sVbZrH+LCYOrrfir4Afm
         l+3kUaGPisieD12kLfwrYtQS+qnuJeAMpI5xPKQIpiF0Mn6YLv3xoYJJ5kevnmNUi0
         6b43MgRa0btwi97+/LEaGcgCiAkWFCl1f75k01q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/221] clk: qcom: gcc-sc7180: Use floor ops for the correct sdcc1 clk
Date:   Mon, 29 Mar 2021 09:57:25 +0200
Message-Id: <20210329075633.013061468@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 148ddaa89d4a0a927c4353398096cc33687755c1 ]

While picking commit a8cd989e1a57 ("mmc: sdhci-msm: Warn about
overclocking SD/MMC") back to my tree I was surprised that it was
reporting warnings.  I thought I fixed those!  Looking closer at the
fix, I see that I totally bungled it (or at least I halfway bungled
it).  The SD card clock got fixed (and that was the one I was really
focused on fixing), but I totally adjusted the wrong clock for eMMC.
Sigh.  Let's fix my dumb mistake.

Now both SD and eMMC have floor for the "apps" clock.

This doesn't matter a lot for the final clock rate for HS400 eMMC but
could matter if someone happens to put some slower eMMC on a sc7180.
We also transition through some of these lower rates sometimes and
having them wrong could cause problems during these transitions.
These were the messages I was seeing at boot:
  mmc1: Card appears overclocked; req 52000000 Hz, actual 100000000 Hz
  mmc1: Card appears overclocked; req 52000000 Hz, actual 100000000 Hz
  mmc1: Card appears overclocked; req 104000000 Hz, actual 192000000 Hz

Fixes: 6d37a8d19283 ("clk: qcom: gcc-sc7180: Use floor ops for sdcc clks")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20210224095013.1.I2e2ba4978cfca06520dfb5d757768f9c42140f7c@changeid
Reviewed-by: Taniya Das <tdas@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7180.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc7180.c b/drivers/clk/qcom/gcc-sc7180.c
index b080739ab0c3..7e80dbd4a3f9 100644
--- a/drivers/clk/qcom/gcc-sc7180.c
+++ b/drivers/clk/qcom/gcc-sc7180.c
@@ -620,7 +620,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_1,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
@@ -642,7 +642,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.name = "gcc_sdcc1_ice_core_clk_src",
 		.parent_data = gcc_parent_data_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_ops,
 	},
 };
 
-- 
2.30.1



