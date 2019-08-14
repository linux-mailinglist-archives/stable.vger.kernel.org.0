Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730158D739
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfHNPaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 11:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfHNPaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 11:30:25 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F702084F;
        Wed, 14 Aug 2019 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565796624;
        bh=CX48mP1/qs/V0WIfEuGbZqpNO4Jo433GaILdRZ/JeEM=;
        h=From:To:Cc:Subject:Date:From;
        b=PGQUpwQFn9e0omqFaTUYm7VbpW+lXW0bU9M+B2FR7aU67oDqxmiEmiBjnW9MulJx/
         T/qx3MWZHfn9hU+trpxwu/BTwz32PdAXz9bgi9ZQTHzoU/zlJ6Sohx0ZZfOhnK/Leq
         wdI/Ln1KlneQc+SVrWr0dvUwdu0+FV6Oi5R8bxfA=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, linux-kernel@vger.kernel.org,
        sboyd@kernel.org, mturquette@baylibre.com, stable@vger.kernel.org
Subject: [PATCH] clk: socfpga: stratix10: fix rate caclulationg for cnt_clks
Date:   Wed, 14 Aug 2019 10:30:14 -0500
Message-Id: <20190814153014.12962-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Checking bypass_reg is incorrect for calculating the cnt_clk rates.
Instead we should be checking that there is a proper hardware register
that holds the clock divider.

Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/clk/socfpga/clk-periph-s10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/socfpga/clk-periph-s10.c b/drivers/clk/socfpga/clk-periph-s10.c
index 5c50e723ecae..1a191eeeebba 100644
--- a/drivers/clk/socfpga/clk-periph-s10.c
+++ b/drivers/clk/socfpga/clk-periph-s10.c
@@ -38,7 +38,7 @@ static unsigned long clk_peri_cnt_clk_recalc_rate(struct clk_hw *hwclk,
 	if (socfpgaclk->fixed_div) {
 		div = socfpgaclk->fixed_div;
 	} else {
-		if (!socfpgaclk->bypass_reg)
+		if (socfpgaclk->hw.reg)
 			div = ((readl(socfpgaclk->hw.reg) & 0x7ff) + 1);
 	}
 
-- 
2.20.0

