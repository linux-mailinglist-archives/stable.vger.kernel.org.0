Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF84714B7BB
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgA1ORG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729927AbgA1ORF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:17:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C5424688;
        Tue, 28 Jan 2020 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221024;
        bh=hByFda785VSTPp3xDBq7bjHMo2Is0WUBr9P60xocc5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3QncYJZxV99QeKymXoAHdpMZtfPr0jJp0j0JVnMaEfoEM7q89UubGgYQZ33rtnuQ
         CzgeNmROv9S2xGj7YYg/gs9FJ3IKdGIrDvoBTpuAVqFpWIBLU2PHLsX08Yaot7ydP1
         Qtf1bbZ9C/K5xnt30XU7+c1cml0sbMT+batcuWxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 031/271] clk: imx6sx: fix refcount leak in imx6sx_clocks_init()
Date:   Tue, 28 Jan 2020 15:03:00 +0100
Message-Id: <20200128135855.000151430@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 1731e14fb30212dd8c1e9f8fc1af061e56498c55 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: d55135689019 ("ARM: imx: add clock driver for imx6sx")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6sx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx6sx.c b/drivers/clk/imx/clk-imx6sx.c
index b5c96de41ccf9..8bbc2542f2f70 100644
--- a/drivers/clk/imx/clk-imx6sx.c
+++ b/drivers/clk/imx/clk-imx6sx.c
@@ -164,6 +164,7 @@ static void __init imx6sx_clocks_init(struct device_node *ccm_node)
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6sx-anatop");
 	base = of_iomap(np, 0);
 	WARN_ON(!base);
+	of_node_put(np);
 
 	clks[IMX6SX_PLL1_BYPASS_SRC] = imx_clk_mux("pll1_bypass_src", base + 0x00, 14, 1, pll_bypass_src_sels, ARRAY_SIZE(pll_bypass_src_sels));
 	clks[IMX6SX_PLL2_BYPASS_SRC] = imx_clk_mux("pll2_bypass_src", base + 0x30, 14, 1, pll_bypass_src_sels, ARRAY_SIZE(pll_bypass_src_sels));
-- 
2.20.1



