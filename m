Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0570C126CCD
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbfLSSoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728956AbfLSSoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C507424672;
        Thu, 19 Dec 2019 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781046;
        bh=BWIHbqoK1PskVUkjpvloNNNkwKQs4P/4K8397k8psrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDhvIqx1zmyIdAR6EUygRetuC5CINk3ONeoV0GPoon1wMpRQ+oOLcCzzUudbvBaup
         URV3LVUMhx/UUOGdD8p+I9OtnsoOzHi23dKtqcjjNjL3da4Cqn8AP/IjYykLtrQ18m
         yc3v6mZfHvMlHLySxnBMBzRPn32ggq3P/xU8sSP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/199] clk: sunxi-ng: h3/h5: Fix CSI_MCLK parent
Date:   Thu, 19 Dec 2019 19:32:22 +0100
Message-Id: <20191219183218.320186185@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 7bb7d29cffdd24bf419516d14b6768591e74069e ]

The third parent of CSI_MCLK is PLL_PERIPH1, not PLL_PERIPH0.
Fix it.

Fixes: 0577e4853bfb ("clk: sunxi-ng: Add H3 clocks")
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
index a26c8a19fe93a..9dd6daaa13367 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
@@ -458,7 +458,7 @@ static const char * const csi_sclk_parents[] = { "pll-periph0", "pll-periph1" };
 static SUNXI_CCU_M_WITH_MUX_GATE(csi_sclk_clk, "csi-sclk", csi_sclk_parents,
 				 0x134, 16, 4, 24, 3, BIT(31), 0);
 
-static const char * const csi_mclk_parents[] = { "osc24M", "pll-video", "pll-periph0" };
+static const char * const csi_mclk_parents[] = { "osc24M", "pll-video", "pll-periph1" };
 static SUNXI_CCU_M_WITH_MUX_GATE(csi_mclk_clk, "csi-mclk", csi_mclk_parents,
 				 0x134, 0, 5, 8, 3, BIT(15), 0);
 
-- 
2.20.1



