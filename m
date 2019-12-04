Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEA11131D3
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbfLDSC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbfLDSC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:56 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9914E215B2;
        Wed,  4 Dec 2019 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482576;
        bh=7Okz4y6hrxVIRsklu/VZlG95BXottGN8NoHpUOaltx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Doex8UUPimkis/pEEnagFMDmZ2SZuWeqS+9M7AABExkGJS9TTaRTlvLKsbC4bV5U
         WKuzkIYC6vPOKZVC3rObNw69ehq+fM6KBPsPSSw3LgV+uQ91lOEmEVFvBuX2lOqHVP
         sWliRIm1UPlH+7WzjHB6mrhvfOlC+g5sH9edxVyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 009/209] clk: sunxi-ng: a80: fix the zeroing of bits 16 and 18
Date:   Wed,  4 Dec 2019 18:53:41 +0100
Message-Id: <20191204175322.233475031@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit cdfc2e2086bf9c465f44e2db25561373b084a113 ]

The zero'ing of bits 16 and 18 is incorrect. Currently the code
is masking with the bitwise-and of BIT(16) & BIT(18) which is
0, so the updated value for val is always zero. Fix this by bitwise
and-ing value with the correct mask that will zero bits 16 and 18.

Addresses-Coverity: (" Suspicious &= or |= constant expression")
Fixes: b8eb71dcdd08 ("clk: sunxi-ng: Add A80 CCU")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun9i-a80.c b/drivers/clk/sunxi-ng/ccu-sun9i-a80.c
index 8936ef87652c0..c14bf782b2b33 100644
--- a/drivers/clk/sunxi-ng/ccu-sun9i-a80.c
+++ b/drivers/clk/sunxi-ng/ccu-sun9i-a80.c
@@ -1231,7 +1231,7 @@ static int sun9i_a80_ccu_probe(struct platform_device *pdev)
 
 	/* Enforce d1 = 0, d2 = 0 for Audio PLL */
 	val = readl(reg + SUN9I_A80_PLL_AUDIO_REG);
-	val &= (BIT(16) & BIT(18));
+	val &= ~(BIT(16) | BIT(18));
 	writel(val, reg + SUN9I_A80_PLL_AUDIO_REG);
 
 	/* Enforce P = 1 for both CPU cluster PLLs */
-- 
2.20.1



