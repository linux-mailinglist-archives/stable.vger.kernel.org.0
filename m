Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA552B626F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgKQN2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731218AbgKQN0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97CD62078D;
        Tue, 17 Nov 2020 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619593;
        bh=WEW9WBG8tdkhI3KFgCR/Z3gUpDrjHq7F/pa6hhfoDTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZuSpwCmEF0vo3GOUq0rLfrLf9xKrKKeoWjM4cYZ7bsu+i3T8Yzg3XeyVqCeLlK7d
         rIOK/o8k8qm5WyxPGhnyMN3M6BJpI9gX/wlATV3vQ00HZSuAIlKsik+vjsuhMsLd6z
         cx4XRL3k/eXMzswzSzBvaXSrvYkXn/vV8hjRENgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/151] pinctrl: aspeed: Fix GPI only function problem.
Date:   Tue, 17 Nov 2020 14:05:20 +0100
Message-Id: <20201117122125.785018271@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 54933665b5f8b..93b5654ff2828 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -277,13 +277,14 @@ int aspeed_pinmux_set_mux(struct pinctrl_dev *pctldev, unsigned int function,
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



