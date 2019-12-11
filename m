Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F155811B573
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbfLKPSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbfLKPSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3BC9208C3;
        Wed, 11 Dec 2019 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077510;
        bh=t8mb+WDffRmNpz/JjGsKX0Ma3N6Sa9QDPAxBfLFnx3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBQrXmW2fe0+xW/ch1lrYZX36JLvsRdwugXqF55VFJF648ucrYqSBLN4dc0Orz2TU
         3MkdV9YZaVdNsjAiOK0WLCUEf/VV1AXxq06WMdULe+f9i33YnUhf26WiR5TEX2WhOr
         85xU6nXsE1qUQb+64rB7D+XqbUpKZ6v5lLsj6nn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/243] clk: rockchip: fix I2S1 clock gate register for rk3328
Date:   Wed, 11 Dec 2019 16:03:47 +0100
Message-Id: <20191211150343.486374103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Katsuhiro Suzuki <katsuhiro@katsuster.net>

[ Upstream commit 5c73ac2f8b70834a603eb2d92eb0bb464634420b ]

This patch fixes definition of I2S1 clock gate register for rk3328.
Current setting is not related I2S clocks.
  - bit6 of CRU_CLKGATE_CON0 means clk_ddrmon_en
  - bit6 of CRU_CLKGATE_CON1 means clk_i2s1_en

Signed-off-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3328.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3328.c b/drivers/clk/rockchip/clk-rk3328.c
index ecbae8acd05b8..f2f13b603ae9b 100644
--- a/drivers/clk/rockchip/clk-rk3328.c
+++ b/drivers/clk/rockchip/clk-rk3328.c
@@ -392,7 +392,7 @@ static struct rockchip_clk_branch rk3328_clk_branches[] __initdata = {
 			RK3328_CLKGATE_CON(1), 5, GFLAGS,
 			&rk3328_i2s1_fracmux),
 	GATE(SCLK_I2S1, "clk_i2s1", "i2s1_pre", CLK_SET_RATE_PARENT,
-			RK3328_CLKGATE_CON(0), 6, GFLAGS),
+			RK3328_CLKGATE_CON(1), 6, GFLAGS),
 	COMPOSITE_NODIV(SCLK_I2S1_OUT, "i2s1_out", mux_i2s1out_p, 0,
 			RK3328_CLKSEL_CON(8), 12, 1, MFLAGS,
 			RK3328_CLKGATE_CON(1), 7, GFLAGS),
-- 
2.20.1



