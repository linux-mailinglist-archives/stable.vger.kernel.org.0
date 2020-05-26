Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6641DEA7E
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgEVOvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730929AbgEVOvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4F1C22259;
        Fri, 22 May 2020 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159071;
        bh=J2jIe6HbveuMkncJ1bisbe9ib21+twXrpFHhdmfVG6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4H7DK6uNwoa92K9UzjeUJl+qxCWRcy9yHPoVWAZz3I3NM2r7EwuoyBzgSwGl8vdW
         RSU/FJU+7oFO/9Fb03jw+GFlbkDwoEDsiZW2132jSjCyO48nhZxPdOFYsjT9aAZ3g6
         2Dpl5SKNIhAZqTNnFMWG4iXejyBPBkFapV98I5PU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/32] clk: ti: am33xx: fix RTC clock parent
Date:   Fri, 22 May 2020 10:50:36 -0400
Message-Id: <20200522145044.434677-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit dc6dbd51009fc412729c307161f442c0a08618f4 ]

Right now, trying to use RTC purely with the ti-sysc / clkctrl framework
fails to enable the RTC module properly. Based on experimentation, this
appears to be because RTC is sourced from the clkdiv32k optional clock.
TRM is not very clear on this topic, but fix the RTC to use the proper
source clock nevertheless.

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Link: https://lkml.kernel.org/r/20200424152301.4018-1-t-kristo@ti.com
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-33xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ti/clk-33xx.c b/drivers/clk/ti/clk-33xx.c
index a360d3109555..73f567d8022f 100644
--- a/drivers/clk/ti/clk-33xx.c
+++ b/drivers/clk/ti/clk-33xx.c
@@ -212,7 +212,7 @@ static const struct omap_clkctrl_reg_data am3_mpu_clkctrl_regs[] __initconst = {
 };
 
 static const struct omap_clkctrl_reg_data am3_l4_rtc_clkctrl_regs[] __initconst = {
-	{ AM3_L4_RTC_RTC_CLKCTRL, NULL, CLKF_SW_SUP, "clk_32768_ck" },
+	{ AM3_L4_RTC_RTC_CLKCTRL, NULL, CLKF_SW_SUP, "clk-24mhz-clkctrl:0000:0" },
 	{ 0 },
 };
 
-- 
2.25.1

