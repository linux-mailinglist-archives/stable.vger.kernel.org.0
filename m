Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3C26EC14
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgIRCJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728319AbgIRCJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BBB92389E;
        Fri, 18 Sep 2020 02:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394977;
        bh=eZDc5ObhMHtmYpVYSId1z6YNr6xNx6COQw+PeGTLRM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVz013wVnYZniGmzZHjJioGg+gzkXBYrJIh6HgTBOuDx18XUdNMCUOPovyJ58syTK
         gPmHAuiNfeSiyFSm7WK8mCZ2SkE628pgwzhZBEc9UOZeSBiATLEBTpvMNw7xkfE8Z7
         XUjmp8GfSDcp0fkcdqVknN+msDVHfeY+cDWRLE+4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 077/206] clk: stratix10: use do_div() for 64-bit calculation
Date:   Thu, 17 Sep 2020 22:05:53 -0400
Message-Id: <20200918020802.2065198-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

