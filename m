Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CFB3C5458
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348369AbhGLH5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348094AbhGLHzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CB7A611F2;
        Mon, 12 Jul 2021 07:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076302;
        bh=mUdufkRP5E+hO8OzuCj/d6SoF7ztqQYiiolxwrrMVhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYkveREMaAUO941HfX16MVQqk+EytlgzmfXHEi6UcAdS03RPdCtkqqa8x7ezB3pKJ
         6r+oYpfgl2U0/wtH6+ll3wM9b7n5ZKg4WtOZBtzT89jo4YOXyvxJhXKp4WRlA8j4lD
         AAyTU/9ATC8CmS+zmuFV/48o1lz8zU+kOsW6Ir9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 585/800] clk: actions: Fix UART clock dividers on Owl S500 SoC
Date:   Mon, 12 Jul 2021 08:10:08 +0200
Message-Id: <20210712061029.524646249@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

[ Upstream commit 2dca2a619a907579e3e65e7c1789230c2b912e88 ]

Use correct divider registers for the Actions Semi Owl S500 SoC's UART
clocks.

Fixes: ed6b4795ece4 ("clk: actions: Add clock driver for S500 SoC")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/4714d05982b19ac5fec2ed74f54be42d8238e392.1623354574.git.cristian.ciocaltea@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-s500.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/actions/owl-s500.c b/drivers/clk/actions/owl-s500.c
index 61bb224f6330..75b7186185b0 100644
--- a/drivers/clk/actions/owl-s500.c
+++ b/drivers/clk/actions/owl-s500.c
@@ -305,7 +305,7 @@ static OWL_COMP_FIXED_FACTOR(i2c3_clk, "i2c3_clk", "ethernet_pll_clk",
 static OWL_COMP_DIV(uart0_clk, "uart0_clk", uart_clk_mux_p,
 			OWL_MUX_HW(CMU_UART0CLK, 16, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN1, 6, 0),
-			OWL_DIVIDER_HW(CMU_UART1CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
+			OWL_DIVIDER_HW(CMU_UART0CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
 			CLK_IGNORE_UNUSED);
 
 static OWL_COMP_DIV(uart1_clk, "uart1_clk", uart_clk_mux_p,
@@ -317,31 +317,31 @@ static OWL_COMP_DIV(uart1_clk, "uart1_clk", uart_clk_mux_p,
 static OWL_COMP_DIV(uart2_clk, "uart2_clk", uart_clk_mux_p,
 			OWL_MUX_HW(CMU_UART2CLK, 16, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN1, 8, 0),
-			OWL_DIVIDER_HW(CMU_UART1CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
+			OWL_DIVIDER_HW(CMU_UART2CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
 			CLK_IGNORE_UNUSED);
 
 static OWL_COMP_DIV(uart3_clk, "uart3_clk", uart_clk_mux_p,
 			OWL_MUX_HW(CMU_UART3CLK, 16, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN1, 19, 0),
-			OWL_DIVIDER_HW(CMU_UART1CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
+			OWL_DIVIDER_HW(CMU_UART3CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
 			CLK_IGNORE_UNUSED);
 
 static OWL_COMP_DIV(uart4_clk, "uart4_clk", uart_clk_mux_p,
 			OWL_MUX_HW(CMU_UART4CLK, 16, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN1, 20, 0),
-			OWL_DIVIDER_HW(CMU_UART1CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
+			OWL_DIVIDER_HW(CMU_UART4CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
 			CLK_IGNORE_UNUSED);
 
 static OWL_COMP_DIV(uart5_clk, "uart5_clk", uart_clk_mux_p,
 			OWL_MUX_HW(CMU_UART5CLK, 16, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN1, 21, 0),
-			OWL_DIVIDER_HW(CMU_UART1CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
+			OWL_DIVIDER_HW(CMU_UART5CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
 			CLK_IGNORE_UNUSED);
 
 static OWL_COMP_DIV(uart6_clk, "uart6_clk", uart_clk_mux_p,
 			OWL_MUX_HW(CMU_UART6CLK, 16, 1),
 			OWL_GATE_HW(CMU_DEVCLKEN1, 18, 0),
-			OWL_DIVIDER_HW(CMU_UART1CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
+			OWL_DIVIDER_HW(CMU_UART6CLK, 0, 8, CLK_DIVIDER_ROUND_CLOSEST, NULL),
 			CLK_IGNORE_UNUSED);
 
 static OWL_COMP_DIV(i2srx_clk, "i2srx_clk", i2s_clk_mux_p,
-- 
2.30.2



