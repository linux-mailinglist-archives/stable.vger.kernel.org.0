Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1891676B0
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgBUIEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731686AbgBUIEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:04:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 883962073A;
        Fri, 21 Feb 2020 08:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272281;
        bh=KBb0SdUC0ZXoTdzjUeomddn5cDalwKuc/F+moiwCcbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDtdU6FNsONUXtFX0yMJ2ibEvWc7qNRlyTDrFW6u6yBr3rIX1qIgumGGoMnbufT0g
         HhJ2yxK5XUi+t6u3Dsz37u85sZuqrhtzpkBB/pE0It0g97RDIXVCR4OsQXa02WkK78
         zizVHXStgYUYEsmZRe1vOfzTBlJ9MJhERHTUYjY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/344] clk: ti: dra7: fix parent for gmac_clkctrl
Date:   Fri, 21 Feb 2020 08:37:45 +0100
Message-Id: <20200221072355.002137552@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9dd6185a4b4e2..66e4b2b9ec600 100644
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



