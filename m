Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD6953A714
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353965AbiFAN6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353962AbiFAN4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:56:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888D6996AE;
        Wed,  1 Jun 2022 06:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4DD9615C7;
        Wed,  1 Jun 2022 13:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283E8C36AE2;
        Wed,  1 Jun 2022 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091704;
        bh=XHRtkpxftbgTm/PySu+8nLF6MiAvmFtE9vRGXyrzS1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fgy1/AUEf4je3jBEzJNstM9d8f+ThT6hVOEb0GALJ7/8pYY+d/dEIdmCWOpvukZb+
         AzuLMcG6h8flpT/yFiEoL4cqRPJSp4chZyg6W0C831iUc5AHyFIeUwqUa7W4Jo/XMN
         x0yTkuSKeCSUQ4xBZUSsuS9SLZhvcujgHQGTSsq/Kd45XHFCJRrC8oQ20dwy1KEf2d
         kVSdpvgA1hzg8KHRr60Q5ATCTWJIArXHXFrvL48vu7J32yaqjbZxD6zhZM8Ye7NYYr
         7crnErd6s5l+OG/zLuNIBnqyYC+TnEanDmkBb3SLIh5bUv+Fi4DwBd8en5S+ZnlsY2
         AO0oH8P0+AOBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        paul@pwsan.com, aaro.koskinen@iki.fi, linux@armlinux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 18/48] ARM: OMAP1: clock: Fix UART rate reporting algorithm
Date:   Wed,  1 Jun 2022 09:53:51 -0400
Message-Id: <20220601135421.2003328-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 338d5d476cde853dfd97378d20496baabc2ce3c0 ]

Since its introduction to the mainline kernel, omap1_uart_recalc() helper
makes incorrect use of clk->enable_bit as a ready to use bitmap mask while
it only provides the bit number.  Fix it.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index 9d4a0ab50a46..d63d5eb8d8fd 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -41,7 +41,7 @@ static DEFINE_SPINLOCK(clockfw_lock);
 unsigned long omap1_uart_recalc(struct clk *clk)
 {
 	unsigned int val = __raw_readl(clk->enable_reg);
-	return val & clk->enable_bit ? 48000000 : 12000000;
+	return val & 1 << clk->enable_bit ? 48000000 : 12000000;
 }
 
 unsigned long omap1_sossi_recalc(struct clk *clk)
-- 
2.35.1

