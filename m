Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93C21456A1
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgAVN2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgAVN2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:11 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E242467C;
        Wed, 22 Jan 2020 13:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699691;
        bh=HaI72mSW4VJPQws3JwuVJqxl2RtKg7am/bEjlKS5DnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yH1EqXv+eN2Tr99uYiG8mZyrnQZywIvDs9y360YrTydR5AX7nqUYrp7WUu/0ZvMgf
         4snPJQIGm8yqSi8TeRzk38X7ddV138hOKvCfXTeqvuyGOVetmYGRSZKyqUXiD0Me79
         GsSYK27/03aJ10B8poEFiYzm28tKiKPbaM3mkxxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 219/222] clk: imx7ulp: Correct DDR clock mux options
Date:   Wed, 22 Jan 2020 10:30:05 +0100
Message-Id: <20200122092849.369812737@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

commit 2e2b928a04bd74ea410da72bd60e1c5b06398276 upstream.

In the latest reference manual Rev.0,06/2019, the DDR clock mux
is extended to 2 bits, and the clock options are also changed,
correct them accordingly.

Fixes: b1260067ac3d ("clk: imx: add imx7ulp clk driver")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/imx/clk-imx7ulp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/imx/clk-imx7ulp.c
+++ b/drivers/clk/imx/clk-imx7ulp.c
@@ -25,7 +25,7 @@ static const char * const spll_sels[]		=
 static const char * const apll_pfd_sels[]	= { "apll_pfd0", "apll_pfd1", "apll_pfd2", "apll_pfd3", };
 static const char * const apll_sels[]		= { "apll", "apll_pfd_sel", };
 static const char * const scs_sels[]		= { "dummy", "sosc", "sirc", "firc", "dummy", "apll_sel", "spll_sel", "dummy", };
-static const char * const ddr_sels[]		= { "apll_pfd_sel", "upll", };
+static const char * const ddr_sels[]		= { "apll_pfd_sel", "dummy", "dummy", "dummy", };
 static const char * const nic_sels[]		= { "firc", "ddr_clk", };
 static const char * const periph_plat_sels[]	= { "dummy", "nic1_bus_clk", "nic1_clk", "ddr_clk", "apll_pfd2", "apll_pfd1", "apll_pfd0", "upll", };
 static const char * const periph_bus_sels[]	= { "dummy", "sosc_bus_clk", "mpll", "firc_bus_clk", "rosc", "nic1_bus_clk", "nic1_clk", "spll_bus_clk", };
@@ -119,7 +119,7 @@ static void __init imx7ulp_clk_scg1_init
 	clks[IMX7ULP_CLK_SYS_SEL]	= imx_clk_hw_mux2("scs_sel", base + 0x14, 24, 4, scs_sels, ARRAY_SIZE(scs_sels));
 	clks[IMX7ULP_CLK_HSRUN_SYS_SEL] = imx_clk_hw_mux2("hsrun_scs_sel", base + 0x1c, 24, 4, scs_sels, ARRAY_SIZE(scs_sels));
 	clks[IMX7ULP_CLK_NIC_SEL]	= imx_clk_hw_mux2("nic_sel", base + 0x40, 28, 1, nic_sels, ARRAY_SIZE(nic_sels));
-	clks[IMX7ULP_CLK_DDR_SEL]	= imx_clk_hw_mux_flags("ddr_sel", base + 0x30, 24, 1, ddr_sels, ARRAY_SIZE(ddr_sels), CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE);
+	clks[IMX7ULP_CLK_DDR_SEL]	= imx_clk_hw_mux_flags("ddr_sel", base + 0x30, 24, 2, ddr_sels, ARRAY_SIZE(ddr_sels), CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE);
 
 	clks[IMX7ULP_CLK_CORE_DIV]	= imx_clk_hw_divider_flags("divcore",	"scs_sel",  base + 0x14, 16, 4, CLK_SET_RATE_PARENT);
 	clks[IMX7ULP_CLK_HSRUN_CORE_DIV] = imx_clk_hw_divider_flags("hsrun_divcore", "hsrun_scs_sel", base + 0x1c, 16, 4, CLK_SET_RATE_PARENT);


