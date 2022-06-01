Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45053A768
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354038AbiFAOBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355217AbiFAOBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBA1A5A8F;
        Wed,  1 Jun 2022 06:57:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D064B81AE6;
        Wed,  1 Jun 2022 13:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01553C3411E;
        Wed,  1 Jun 2022 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091814;
        bh=XHRtkpxftbgTm/PySu+8nLF6MiAvmFtE9vRGXyrzS1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxWTGPHt5aAIkLKc33FF38Bvd7o+Yw/TJ5GFP6eNVOj9XFNfrlTr3X6jnnX2MEP9D
         diIHxZJWHxV3ZJmDGYassdsdDO4ZBIvnmTuCpaM/vi3OFxCVhuCRdRBq15USl8U1qM
         gYY6Kn/dfcni5IHocWmCcErSN/VKeopzHB3/uNXNUgR01j1RyWsifvtkrkd1Ra3DvN
         /gQiypdQkkQiSZdJ6lXxmdetlkWanwXf/XhunQQcNxmdd6u+qO3AML4I5eu+qYMP3+
         9bFvgyTLeWBelfFDagKrV8WyI9F1do2F0LusT4wiZjf24qR37G2h7NIDwX/Iv73RyK
         rgRgtnfkJhsHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        paul@pwsan.com, aaro.koskinen@iki.fi, linux@armlinux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 15/37] ARM: OMAP1: clock: Fix UART rate reporting algorithm
Date:   Wed,  1 Jun 2022 09:56:00 -0400
Message-Id: <20220601135622.2003939-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
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

