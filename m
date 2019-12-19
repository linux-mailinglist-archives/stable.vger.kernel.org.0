Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBF91269F1
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfLSSmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbfLSSmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D9924672;
        Thu, 19 Dec 2019 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780958;
        bh=NFaUdtNMTJbLwLHPMDyZJswPRj1T5In7yyI5roXQVrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rf2L8CDdMtd6YOacPVMAtmLm3/cMe5WsEvqHK7qaQBOGGV1WGX+owolU8Tup6n+3j
         2NjE8flqeYRpv4YqvQGh+EaP+jf8s4IpATWjya2q8NY/bl3L6tqGJBWFH1otHZnEh8
         CcRxpgM/HpF9GRSTEhpYxc5hMU4YW5MISWbtl3xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 024/199] clk: rockchip: fix rk3188 sclk_mac_lbtest parameter ordering
Date:   Thu, 19 Dec 2019 19:31:46 +0100
Message-Id: <20191219183216.147483846@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit ac8cb53829a6ba119082e067f5bc8fab3611ce6a ]

Similar to commit a9f0c0e56371 ("clk: rockchip: fix rk3188 sclk_smc
gate data") there is one other gate clock in the rk3188 clock driver
with a similar wrong ordering, the sclk_mac_lbtest. So fix it as well.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3188.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index a4c49906acf2c..d62031eedbe64 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -361,8 +361,8 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 			RK2928_CLKGATE_CON(2), 5, GFLAGS),
 	MUX(SCLK_MAC, "sclk_macref", mux_sclk_macref_p, CLK_SET_RATE_PARENT,
 			RK2928_CLKSEL_CON(21), 4, 1, MFLAGS),
-	GATE(0, "sclk_mac_lbtest", "sclk_macref",
-			RK2928_CLKGATE_CON(2), 12, 0, GFLAGS),
+	GATE(0, "sclk_mac_lbtest", "sclk_macref", 0,
+			RK2928_CLKGATE_CON(2), 12, GFLAGS),
 
 	COMPOSITE(0, "hsadc_src", mux_pll_src_gpll_cpll_p, 0,
 			RK2928_CLKSEL_CON(22), 0, 1, MFLAGS, 8, 8, DFLAGS,
-- 
2.20.1



