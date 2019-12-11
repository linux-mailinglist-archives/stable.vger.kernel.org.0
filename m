Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF811B506
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbfLKPvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730942AbfLKPWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF5F2073D;
        Wed, 11 Dec 2019 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077765;
        bh=CcZhakCIMboJHRq885kXaqNWw2YlSndi/14wUaMrV5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8QJ+amryeCrO8dSNWIFieZMB7RhR9LQucvOZrz5qoDqpOGsCNim9iBy2GhOe0+FH
         Y3fHkN1wWbwgSL1YMdC5nhngJcaQJwL910LkA4/DG7P2DhLNxdcpfVFhKkYqPqyB0o
         5hDf0I8I6ejVHrrINJHRpYEvod9GMVAp7Qg1XsTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/243] clk: sunxi-ng: h3/h5: Fix CSI_MCLK parent
Date:   Wed, 11 Dec 2019 16:05:25 +0100
Message-Id: <20191211150350.166033020@linuxfoundation.org>
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
index 77ed0b0ba6819..61e3ba12773ea 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
@@ -475,7 +475,7 @@ static const char * const csi_sclk_parents[] = { "pll-periph0", "pll-periph1" };
 static SUNXI_CCU_M_WITH_MUX_GATE(csi_sclk_clk, "csi-sclk", csi_sclk_parents,
 				 0x134, 16, 4, 24, 3, BIT(31), 0);
 
-static const char * const csi_mclk_parents[] = { "osc24M", "pll-video", "pll-periph0" };
+static const char * const csi_mclk_parents[] = { "osc24M", "pll-video", "pll-periph1" };
 static SUNXI_CCU_M_WITH_MUX_GATE(csi_mclk_clk, "csi-mclk", csi_mclk_parents,
 				 0x134, 0, 5, 8, 3, BIT(15), 0);
 
-- 
2.20.1



