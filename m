Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F7D27C908
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgI2MGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730243AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C1D92389F;
        Tue, 29 Sep 2020 11:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379383;
        bh=9B85iJUhVDSboa+F3wPLvnpFiPXBa38iJOK81UXFYgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKKU5K3CvJ9LJ8IvqA+N0stOXhlAHDSsl/Oes4TZMGSaCuWDoY6BlUN1LbUIOgTZx
         1uLm+GUJHipUB7hWfzXEc1cZzTphhEh568X82r5y1aMhq3WonjE2w3h26G57P1ffAz
         aujNLyUi2AUvRNODv34J3KLsFesF7gbYftjy1eak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/388] clk: stratix10: use do_div() for 64-bit calculation
Date:   Tue, 29 Sep 2020 12:57:32 +0200
Message-Id: <20200929110016.328768843@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit cc26ed7be46c5f5fa45f3df8161ed7ca3c4d318c ]

do_div() macro to perform u64 division and guards against overflow if
the result is too large for the unsigned long return type.

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lkml.kernel.org/r/20200114160726.19771-1-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-pll-s10.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/socfpga/clk-pll-s10.c b/drivers/clk/socfpga/clk-pll-s10.c
index 4705eb544f01b..8d7b1d0c46643 100644
--- a/drivers/clk/socfpga/clk-pll-s10.c
+++ b/drivers/clk/socfpga/clk-pll-s10.c
@@ -39,7 +39,9 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hwclk,
 	/* read VCO1 reg for numerator and denominator */
 	reg = readl(socfpgaclk->hw.reg);
 	refdiv = (reg & SOCFPGA_PLL_REFDIV_MASK) >> SOCFPGA_PLL_REFDIV_SHIFT;
-	vco_freq = (unsigned long long)parent_rate / refdiv;
+
+	vco_freq = parent_rate;
+	do_div(vco_freq, refdiv);
 
 	/* Read mdiv and fdiv from the fdbck register */
 	reg = readl(socfpgaclk->hw.reg + 0x4);
-- 
2.25.1



