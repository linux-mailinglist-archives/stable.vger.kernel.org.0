Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC1037C4C4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhELPdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235185AbhELP06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA4061A14;
        Wed, 12 May 2021 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832322;
        bh=u45Q+0Tt09UKWwDU7j/FvWSs3/YE4eCd7NRCiS/ALlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vVVypBfxtoPAAELjQvl0CbrrsbbUXqS6T5Qd0q3ETvMHwbEJpSIHk5lbKbvb57ft
         loDorYztvChslSR1kZaYhKlmbpfHOUOoYN3JxFyPqXn3bAuTG+xxKDwkofU9mqIShR
         CwjY8K2h631T/Cu2+sBmMy6qZ7E4Nomv5anmTM50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Anders Trier Olesen <anders.trier.olesen@gmail.com>,
        Philip Soares <philips@netisense.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/530] clk: mvebu: armada-37xx-periph: Fix switching CPU freq from 250 Mhz to 1 GHz
Date:   Wed, 12 May 2021 16:45:43 +0200
Message-Id: <20210512144827.503556720@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 4decb9187589f61fe9fc2bc4d9b01160b0a610c5 ]

It was observed that the workaround introduced by commit 61c40f35f5cd
("clk: mvebu: armada-37xx-periph: Fix switching CPU rate from 300Mhz to
1.2GHz") when base CPU frequency is 1.2 GHz is also required when base
CPU frequency is 1 GHz. Otherwise switching CPU frequency directly from
L2 (250 MHz) to L0 (1 GHz) causes a crash.

When base CPU frequency is just 800 MHz no crashed were observed during
switch from L2 to L0.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Anders Trier Olesen <anders.trier.olesen@gmail.com>
Tested-by: Philip Soares <philips@netisense.com>
Fixes: 2089dc33ea0e ("clk: mvebu: armada-37xx-periph: add DVFS support for cpu clocks")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/armada-37xx-periph.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/mvebu/armada-37xx-periph.c b/drivers/clk/mvebu/armada-37xx-periph.c
index 6507bd2c5f31..b15e177bea7e 100644
--- a/drivers/clk/mvebu/armada-37xx-periph.c
+++ b/drivers/clk/mvebu/armada-37xx-periph.c
@@ -487,8 +487,10 @@ static long clk_pm_cpu_round_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 /*
- * Switching the CPU from the L2 or L3 frequencies (300 and 200 Mhz
- * respectively) to L0 frequency (1.2 Ghz) requires a significant
+ * Workaround when base CPU frequnecy is 1000 or 1200 MHz
+ *
+ * Switching the CPU from the L2 or L3 frequencies (250/300 or 200 MHz
+ * respectively) to L0 frequency (1/1.2 GHz) requires a significant
  * amount of time to let VDD stabilize to the appropriate
  * voltage. This amount of time is large enough that it cannot be
  * covered by the hardware countdown register. Due to this, the CPU
@@ -498,15 +500,15 @@ static long clk_pm_cpu_round_rate(struct clk_hw *hw, unsigned long rate,
  * To work around this problem, we prevent switching directly from the
  * L2/L3 frequencies to the L0 frequency, and instead switch to the L1
  * frequency in-between. The sequence therefore becomes:
- * 1. First switch from L2/L3(200/300MHz) to L1(600MHZ)
+ * 1. First switch from L2/L3 (200/250/300 MHz) to L1 (500/600 MHz)
  * 2. Sleep 20ms for stabling VDD voltage
- * 3. Then switch from L1(600MHZ) to L0(1200Mhz).
+ * 3. Then switch from L1 (500/600 MHz) to L0 (1000/1200 MHz).
  */
 static void clk_pm_cpu_set_rate_wa(unsigned long rate, struct regmap *base)
 {
 	unsigned int cur_level;
 
-	if (rate != 1200 * 1000 * 1000)
+	if (rate < 1000 * 1000 * 1000)
 		return;
 
 	regmap_read(base, ARMADA_37XX_NB_CPU_LOAD, &cur_level);
-- 
2.30.2



