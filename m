Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1922B60B5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgKQNMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729764AbgKQNMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:12:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B38241A7;
        Tue, 17 Nov 2020 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618720;
        bh=fdHiExIBCAOQ/abc1stNSW5WonDv6IjbpthKI0wu+mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nW+KM+tIIW0UV0GP0iLlP21fagJPD7rMA0cxAO4mI5S3lFxjmX9hcBXpRPGuu8yIs
         8rnKAhW2QWLcuIE8lkdXq+8MSb6YDkzcOvW1CtFEdHIsSiJCNSNU0WJiE7/iYCiGcH
         FlLf8QxZacqGKjHp5w6zLRw1WJlEpll+yLLbUKn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 36/78] pinctrl: aspeed: Fix GPI only function problem.
Date:   Tue, 17 Nov 2020 14:05:02 +0100
Message-Id: <20201117122110.871999315@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 9b92f5c51e9a41352d665f6f956bd95085a56a83 ]

Some gpio pin at aspeed soc is input only and the prefix name of these
pin is "GPI" only.
This patch fine-tune the condition of GPIO check from "GPIO" to "GPI"
and it will fix the usage error of banks D and E in the AST2400/AST2500
and banks T and U in the AST2600.

Fixes: 4d3d0e4272d8 ("pinctrl: Add core support for Aspeed SoCs")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20201030055450.29613-1-billy_tsai@aspeedtech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index 49aeba9125319..23d2f0ba12db5 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -387,13 +387,14 @@ int aspeed_pinmux_set_mux(struct pinctrl_dev *pctldev, unsigned int function,
 static bool aspeed_expr_is_gpio(const struct aspeed_sig_expr *expr)
 {
 	/*
-	 * The signal type is GPIO if the signal name has "GPIO" as a prefix.
+	 * The signal type is GPIO if the signal name has "GPI" as a prefix.
 	 * strncmp (rather than strcmp) is used to implement the prefix
 	 * requirement.
 	 *
-	 * expr->signal might look like "GPIOT3" in the GPIO case.
+	 * expr->signal might look like "GPIOB1" in the GPIO case.
+	 * expr->signal might look like "GPIT0" in the GPI case.
 	 */
-	return strncmp(expr->signal, "GPIO", 4) == 0;
+	return strncmp(expr->signal, "GPI", 3) == 0;
 }
 
 static bool aspeed_gpio_in_exprs(const struct aspeed_sig_expr **exprs)
-- 
2.27.0



