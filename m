Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DE93C537F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352474AbhGLHyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350424AbhGLHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42EEC61437;
        Mon, 12 Jul 2021 07:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075906;
        bh=ovX+JmhrxWcTntZpyJk4SsnPy4WhJgkQGumKoUAQ30I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vl1EWUk+UE4MiVdFndW/hJj7NNKMY0EbR/eenxHd1x3E0SDKxgYZ54S3VK4ghp8+i
         qVJ6Pt86Zz9sJjmciYaO/6oDxG984/1LzqYCWeh2pb6SUc9bCywRGTC9ilqWHge4vI
         Wiur6KySFpSjx3JyOyd+9QyDvlN0gLgmC7YTeIP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Elaine Zhang <zhangqing@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 414/800] clk: rockchip: fix rk3568 cpll clk gate bits
Date:   Mon, 12 Jul 2021 08:07:17 +0200
Message-Id: <20210712061011.236901572@linuxfoundation.org>
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

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit 2f3877d609e7951ef96d24979eb9d163f1f004f8 ]

The cpll clk gate bits had an ordering issue. This led to the loss of
the boot sdmmc controller when the gmac was shut down with:
`ip link set eth0 down`
as the cpll_100m was shut off instead of the cpll_62p5.
cpll_62p5, cpll_50m, cpll_25m were all off by one with cpll_100m
misplaced.

Fixes: cf911d89c4c5 ("clk: rockchip: add clock controller for rk3568")
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Reviewed-by: Elaine Zhang<zhangqing@rock-chips.com>
Link: https://lore.kernel.org/r/20210519174149.3691335-1-pgwipeout@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3568.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3568.c b/drivers/clk/rockchip/clk-rk3568.c
index 946ea2f45bf3..75ca855e720d 100644
--- a/drivers/clk/rockchip/clk-rk3568.c
+++ b/drivers/clk/rockchip/clk-rk3568.c
@@ -454,17 +454,17 @@ static struct rockchip_clk_branch rk3568_clk_branches[] __initdata = {
 	COMPOSITE_NOMUX(CPLL_125M, "cpll_125m", "cpll", CLK_IGNORE_UNUSED,
 			RK3568_CLKSEL_CON(80), 0, 5, DFLAGS,
 			RK3568_CLKGATE_CON(35), 10, GFLAGS),
+	COMPOSITE_NOMUX(CPLL_100M, "cpll_100m", "cpll", CLK_IGNORE_UNUSED,
+			RK3568_CLKSEL_CON(82), 0, 5, DFLAGS,
+			RK3568_CLKGATE_CON(35), 11, GFLAGS),
 	COMPOSITE_NOMUX(CPLL_62P5M, "cpll_62p5", "cpll", CLK_IGNORE_UNUSED,
 			RK3568_CLKSEL_CON(80), 8, 5, DFLAGS,
-			RK3568_CLKGATE_CON(35), 11, GFLAGS),
+			RK3568_CLKGATE_CON(35), 12, GFLAGS),
 	COMPOSITE_NOMUX(CPLL_50M, "cpll_50m", "cpll", CLK_IGNORE_UNUSED,
 			RK3568_CLKSEL_CON(81), 0, 5, DFLAGS,
-			RK3568_CLKGATE_CON(35), 12, GFLAGS),
+			RK3568_CLKGATE_CON(35), 13, GFLAGS),
 	COMPOSITE_NOMUX(CPLL_25M, "cpll_25m", "cpll", CLK_IGNORE_UNUSED,
 			RK3568_CLKSEL_CON(81), 8, 6, DFLAGS,
-			RK3568_CLKGATE_CON(35), 13, GFLAGS),
-	COMPOSITE_NOMUX(CPLL_100M, "cpll_100m", "cpll", CLK_IGNORE_UNUSED,
-			RK3568_CLKSEL_CON(82), 0, 5, DFLAGS,
 			RK3568_CLKGATE_CON(35), 14, GFLAGS),
 	COMPOSITE_NOMUX(0, "clk_osc0_div_750k", "xin24m", CLK_IGNORE_UNUSED,
 			RK3568_CLKSEL_CON(82), 8, 6, DFLAGS,
-- 
2.30.2



