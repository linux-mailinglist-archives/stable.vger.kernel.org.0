Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D38BD002
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632837AbfIXQmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632832AbfIXQmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EAB8217F4;
        Tue, 24 Sep 2019 16:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343373;
        bh=WluHTX10qG7RAA57oEeBHSjMqLz0IzntlDMWX8RpLdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOyujpE5OlSTGdyyGZIPNx9trc16i4cXk4EptUmrKwLqXpGCVwPWZhdMTa+MONZwz
         kkQ50GLBHNkJ9SNYFTDUmECMw7BEJYbEz4v4o1jWiwkOReDPIBqSWhyInV5CvLuLIi
         hRrBuwzvpYbhJ12vPtSTC+RyWY7JVTNqiUcrlgNs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Abel Vesa <abel.vesa@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 23/87] clk: imx8mq: Mark AHB clock as critical
Date:   Tue, 24 Sep 2019 12:40:39 -0400
Message-Id: <20190924164144.25591-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abel Vesa <abel.vesa@nxp.com>

[ Upstream commit 9b9c60bed562c3718ae324a86f3f30a4ff983cf8 ]

Initially, the TMU_ROOT clock was marked as critical, which automatically
made the AHB clock to stay always on. Since the TMU_ROOT clock is not
marked as critical anymore, following commit:

"clk: imx8mq: Remove CLK_IS_CRITICAL flag for IMX8MQ_CLK_TMU_ROOT"

all the clocks that derive from ipg_root clock (and implicitly ahb clock)
would also have to enable, along with their own gate, the AHB clock.

But considering that AHB is actually a bus that has to be always on, we mark
it as critical in the clock provider driver and then all the clocks that
derive from it can be controlled through the dedicated per IP gate which
follows after the ipg_root clock.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Tested-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8mq.c b/drivers/clk/imx/clk-imx8mq.c
index d407a07e7e6dd..e07c69afc3594 100644
--- a/drivers/clk/imx/clk-imx8mq.c
+++ b/drivers/clk/imx/clk-imx8mq.c
@@ -406,7 +406,8 @@ static int imx8mq_clocks_probe(struct platform_device *pdev)
 	clks[IMX8MQ_CLK_NOC_APB] = imx8m_clk_composite_critical("noc_apb", imx8mq_noc_apb_sels, base + 0x8d80);
 
 	/* AHB */
-	clks[IMX8MQ_CLK_AHB] = imx8m_clk_composite("ahb", imx8mq_ahb_sels, base + 0x9000);
+	/* AHB clock is used by the AHB bus therefore marked as critical */
+	clks[IMX8MQ_CLK_AHB] = imx8m_clk_composite_critical("ahb", imx8mq_ahb_sels, base + 0x9000);
 	clks[IMX8MQ_CLK_AUDIO_AHB] = imx8m_clk_composite("audio_ahb", imx8mq_audio_ahb_sels, base + 0x9100);
 
 	/* IPG */
-- 
2.20.1

