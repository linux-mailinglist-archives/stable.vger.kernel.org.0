Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692DD1D83DD
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732564AbgERSIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387469AbgERSID (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:08:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D9E320671;
        Mon, 18 May 2020 18:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825282;
        bh=ZJxifm2L9pOtEbCR4LMQt0wDqcoKiXMau1jrI71o23k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfX555PiZ5IiUVkw9nHMfhy5zzXZwFIB8LM95qLycj1fC5P/4RZqh674p/q1UdU3a
         YHOTX/OPdSTUwDgRh9PyYhxf+3CoD7gFSW1joeBqO6LqhzNvS2sA6DZXZgs056ouPw
         DWkujq7W4RRTRUSq9q1oKzlNMi/z/McTtRt1UIVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Justin Swartz <justin.swartz@risingedge.co.za>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.6 161/194] clk: rockchip: fix incorrect configuration of rk3228 aclk_gpu* clocks
Date:   Mon, 18 May 2020 19:37:31 +0200
Message-Id: <20200518173544.624560222@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Swartz <justin.swartz@risingedge.co.za>

commit cec9d101d70a3509da9bd2e601e0b242154ce616 upstream.

The following changes prevent the unrecoverable freezes and rcu_sched
stall warnings experienced in each of my attempts to take advantage of
lima.

Replace the COMPOSITE_NOGATE definition of aclk_gpu_pre with a
COMPOSITE that retains the selection of HDMIPHY as the PLL source, but
instead makes uses of the aclk_gpu PLL source gate and parent names
defined by mux_pll_src_4plls_p rather than mux_aclk_gpu_pre_p.

Remove the now unused mux_aclk_gpu_pre_p and the four named but also
unused definitions (cpll_gpu, gpll_gpu, hdmiphy_gpu and usb480m_gpu)
of the aclk_gpu PLL source gate.

Use the correct gate offset for aclk_gpu and aclk_gpu_noc.

Fixes: 307a2e9ac524 ("clk: rockchip: add clock controller for rk3228")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Swartz <justin.swartz@risingedge.co.za>
[double-checked against SoC manual and added fixes tag]
Link: https://lore.kernel.org/r/20200114162503.7548-1-justin.swartz@risingedge.co.za
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/rockchip/clk-rk3228.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/drivers/clk/rockchip/clk-rk3228.c
+++ b/drivers/clk/rockchip/clk-rk3228.c
@@ -156,8 +156,6 @@ PNAME(mux_i2s_out_p)		= { "i2s1_pre", "x
 PNAME(mux_i2s2_p)		= { "i2s2_src", "i2s2_frac", "xin12m" };
 PNAME(mux_sclk_spdif_p)		= { "sclk_spdif_src", "spdif_frac", "xin12m" };
 
-PNAME(mux_aclk_gpu_pre_p)	= { "cpll_gpu", "gpll_gpu", "hdmiphy_gpu", "usb480m_gpu" };
-
 PNAME(mux_uart0_p)		= { "uart0_src", "uart0_frac", "xin24m" };
 PNAME(mux_uart1_p)		= { "uart1_src", "uart1_frac", "xin24m" };
 PNAME(mux_uart2_p)		= { "uart2_src", "uart2_frac", "xin24m" };
@@ -468,16 +466,9 @@ static struct rockchip_clk_branch rk3228
 			RK2928_CLKSEL_CON(24), 6, 10, DFLAGS,
 			RK2928_CLKGATE_CON(2), 8, GFLAGS),
 
-	GATE(0, "cpll_gpu", "cpll", 0,
-			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	GATE(0, "gpll_gpu", "gpll", 0,
-			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	GATE(0, "hdmiphy_gpu", "hdmiphy", 0,
-			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	GATE(0, "usb480m_gpu", "usb480m", 0,
+	COMPOSITE(0, "aclk_gpu_pre", mux_pll_src_4plls_p, 0,
+			RK2928_CLKSEL_CON(34), 5, 2, MFLAGS, 0, 5, DFLAGS,
 			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	COMPOSITE_NOGATE(0, "aclk_gpu_pre", mux_aclk_gpu_pre_p, 0,
-			RK2928_CLKSEL_CON(34), 5, 2, MFLAGS, 0, 5, DFLAGS),
 
 	COMPOSITE(SCLK_SPI0, "sclk_spi0", mux_pll_src_2plls_p, 0,
 			RK2928_CLKSEL_CON(25), 8, 1, MFLAGS, 0, 7, DFLAGS,
@@ -582,8 +573,8 @@ static struct rockchip_clk_branch rk3228
 	GATE(0, "pclk_peri_noc", "pclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(12), 2, GFLAGS),
 
 	/* PD_GPU */
-	GATE(ACLK_GPU, "aclk_gpu", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(13), 14, GFLAGS),
-	GATE(0, "aclk_gpu_noc", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(13), 15, GFLAGS),
+	GATE(ACLK_GPU, "aclk_gpu", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(7), 14, GFLAGS),
+	GATE(0, "aclk_gpu_noc", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(7), 15, GFLAGS),
 
 	/* PD_BUS */
 	GATE(0, "sclk_initmem_mbist", "aclk_cpu", 0, RK2928_CLKGATE_CON(8), 1, GFLAGS),


