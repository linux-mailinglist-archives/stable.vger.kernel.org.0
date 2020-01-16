Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F40813E0DC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAPQqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbgAPQqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:46:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B8720663;
        Thu, 16 Jan 2020 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193172;
        bh=yK5TvpLuz4Z0jsh9P/SNatynnR9D2SS7hXVXfA471Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dMTDHrM7I0O3nCDbslcoytZVH+ww7BpBawp5N5A/RK5Jp/6ZVCcj04D67o6MHuSJ
         Nv+C+rRofzTdSriJ4B+N79rROQtbCLU0Vo6L+hqI1uq+oslhbijrSuTt3/+dVqzcc5
         4bCWKzvgx2LoOkiZuSUt31LA3D3AD0PPoyGxlfSo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 039/205] dmaengine: dw: platform: Mark 'hclk' clock optional
Date:   Thu, 16 Jan 2020 11:40:14 -0500
Message-Id: <20200116164300.6705-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f27c22736d133baff0ab3fdc7b015d998267d817 ]

On some platforms the clock can be fixed rate, always running one and
there is no need to do anything with it.

In order to support those platforms, switch to use optional clock.

Fixes: f8d9ddbc2851 ("dmaengine: dw: platform: Enable iDMA 32-bit on Intel Elkhart Lake")
Depends-on: 60b8f0ddf1a9 ("clk: Add (devm_)clk_get_optional() functions")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20190924085116.83683-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index c90c798e5ec3..0585d749d935 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -66,7 +66,7 @@ static int dw_probe(struct platform_device *pdev)
 
 	data->chip = chip;
 
-	chip->clk = devm_clk_get(chip->dev, "hclk");
+	chip->clk = devm_clk_get_optional(chip->dev, "hclk");
 	if (IS_ERR(chip->clk))
 		return PTR_ERR(chip->clk);
 	err = clk_prepare_enable(chip->clk);
-- 
2.20.1

