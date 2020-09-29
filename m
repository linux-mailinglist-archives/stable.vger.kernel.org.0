Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB527CBA0
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732580AbgI2M3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728780AbgI2Lbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:31:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3C6523B09;
        Tue, 29 Sep 2020 11:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378701;
        bh=eZDc5ObhMHtmYpVYSId1z6YNr6xNx6COQw+PeGTLRM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxIBp6y80MaVu+VzBGO0gawwXccY+KL+qE38MpG5gkJZ+uNY8qfdUztfOfFfK+k/C
         mAhK7zt3tQ2+plj7SX1Kd2JPUtCfi2WHY7LgqQy+4V66gmyC2jeJTMnzBFNgQoyTRJ
         uLLBwrcwTjkw8RkSK0yyVvnhfrAmakLvDzyWOupU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/245] clk: stratix10: use do_div() for 64-bit calculation
Date:   Tue, 29 Sep 2020 12:58:49 +0200
Message-Id: <20200929105950.797035112@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index c4d0b6f6abf2e..fc2e2839fe570 100644
--- a/drivers/clk/socfpga/clk-pll-s10.c
+++ b/drivers/clk/socfpga/clk-pll-s10.c
@@ -38,7 +38,9 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hwclk,
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



