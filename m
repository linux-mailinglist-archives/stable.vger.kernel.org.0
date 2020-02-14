Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FE015F41D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404878AbgBNSSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730584AbgBNPup (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB56024650;
        Fri, 14 Feb 2020 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695444;
        bh=bnoGaRoBD2hyStehWg8KD7v12K1AJXgloD4rRnFFQ/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHwKwiJUNv+7gk51nsD6A0KiE7lexBwEQdUtLhz+H03m+DUWGFZOv/+YhF/+cH32t
         JgzSIKUYH2ahwf9Sn27WcoHM+80SVSkd4QDgQZcUZVcaDTQ6nD8IbAMRsC15pyofUr
         5bhYXDTKBSKHZrY+WmYnJJ7OIwtoFGZUuBEzvQt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 085/542] clk: ti: dra7: fix parent for gmac_clkctrl
Date:   Fri, 14 Feb 2020 10:41:17 -0500
Message-Id: <20200214154854.6746-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 69e300283796dae7e8c2e6acdabcd31336c0c93e ]

The parent clk for gmac clk ctrl has to be gmac_main_clk (125MHz) instead
of dpll_gmac_ck (1GHz). This is caused incorrect CPSW MDIO operation.
Hence, fix it.

Fixes: dffa9051d546 ('clk: ti: dra7: add new clkctrl data')
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index 5f46782cebeb2..b656ba2abcf7e 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -405,7 +405,7 @@ static const struct omap_clkctrl_bit_data dra7_gmac_bit_data[] __initconst = {
 };
 
 static const struct omap_clkctrl_reg_data dra7_gmac_clkctrl_regs[] __initconst = {
-	{ DRA7_GMAC_GMAC_CLKCTRL, dra7_gmac_bit_data, CLKF_SW_SUP, "dpll_gmac_ck" },
+	{ DRA7_GMAC_GMAC_CLKCTRL, dra7_gmac_bit_data, CLKF_SW_SUP, "gmac_main_clk" },
 	{ 0 },
 };
 
-- 
2.20.1

