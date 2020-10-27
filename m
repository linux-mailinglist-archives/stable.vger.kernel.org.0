Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F92529BCAB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810985AbgJ0Qgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801875AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA68122470;
        Tue, 27 Oct 2020 15:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813452;
        bh=f2+JQNdrQTSR/ufnvtpXCvGSA3LD53xvo3PSFACT0N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pYnW9Tgj+2qY+Bqs9fc+Km4rA2ZRf++WiRfzt5iDm/cKSWQKCgzc5veamzHBc9BU
         bnsgOgK52lNeWDRwNpCGjEsOICdEb78Omg5d2XzQuDS2sXYz/d+DIzm8peB1eIRUcP
         +77dukiUyRJT7yl64Zy2BSYB7L/F6tF9adzpyyMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abel Vesa <abel.vesa@nxp.com>,
        Cosmin Stefan Stoica <cosmin.stoica@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 557/757] clk: imx8mq: Fix usdhc parents order
Date:   Tue, 27 Oct 2020 14:53:27 +0100
Message-Id: <20201027135516.621638689@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abel Vesa <abel.vesa@nxp.com>

[ Upstream commit b159c63d82ff8ffddc6c6f0eb881b113b36ecad7 ]

According to the latest RM (see Table 5-1. Clock Root Table),
both usdhc root clocks have the parent order as follows:

000 - 25M_REF_CLK
001 - SYSTEM_PLL1_DIV2
010 - SYSTEM_PLL1_CLK
011 - SYSTEM_PLL2_DIV2
100 - SYSTEM_PLL3_CLK
101 - SYSTEM_PLL1_DIV3
110 - AUDIO_PLL2_CLK
111 - SYSTEM_PLL1_DIV8

So the audio_pll2_out and sys3_pll_out have to be swapped.

Fixes: b80522040cd3 ("clk: imx: Add clock driver for i.MX8MQ CCM")
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Reported-by: Cosmin Stefan Stoica <cosmin.stoica@nxp.com>
Link: https://lore.kernel.org/r/1602753944-30757-1-git-send-email-abel.vesa@nxp.com
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mq.c b/drivers/clk/imx/clk-imx8mq.c
index a64aace213c27..7762c5825e77d 100644
--- a/drivers/clk/imx/clk-imx8mq.c
+++ b/drivers/clk/imx/clk-imx8mq.c
@@ -157,10 +157,10 @@ static const char * const imx8mq_qspi_sels[] = {"osc_25m", "sys1_pll_400m", "sys
 					 "audio_pll2_out", "sys1_pll_266m", "sys3_pll_out", "sys1_pll_100m", };
 
 static const char * const imx8mq_usdhc1_sels[] = {"osc_25m", "sys1_pll_400m", "sys1_pll_800m", "sys2_pll_500m",
-					 "audio_pll2_out", "sys1_pll_266m", "sys3_pll_out", "sys1_pll_100m", };
+					 "sys3_pll_out", "sys1_pll_266m", "audio_pll2_out", "sys1_pll_100m", };
 
 static const char * const imx8mq_usdhc2_sels[] = {"osc_25m", "sys1_pll_400m", "sys1_pll_800m", "sys2_pll_500m",
-					 "audio_pll2_out", "sys1_pll_266m", "sys3_pll_out", "sys1_pll_100m", };
+					 "sys3_pll_out", "sys1_pll_266m", "audio_pll2_out", "sys1_pll_100m", };
 
 static const char * const imx8mq_i2c1_sels[] = {"osc_25m", "sys1_pll_160m", "sys2_pll_50m", "sys3_pll_out", "audio_pll1_out",
 					 "video_pll1_out", "audio_pll2_out", "sys1_pll_133m", };
-- 
2.25.1



