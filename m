Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2205613803C
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgAKK1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:27:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbgAKK1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:27:17 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D112087F;
        Sat, 11 Jan 2020 10:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738436;
        bh=hWovyhmEjiLOx+RStHpljftNqQBfFJ59Eou4Rnua9cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TByl6l8EWb9DEHVJQCcdKcXa69q4gMpQVY6cCpvQlwKeLT30uSmGbYxMn7qZF6L6V
         9XJ4J3L8BVR7H0iWkKbYyY2juxt7tyWdOXoes6C2KRLHo/m0+lUKtPBmNEb+3AfNH9
         0gWEXMTLeIFfNCt4DBs3+qNrg3DYfxmzcAV5aECw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jeffery <andrew@aj.id.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/165] pinctrl: aspeed-g6: Fix LPC/eSPI mux configuration
Date:   Sat, 11 Jan 2020 10:49:45 +0100
Message-Id: <20200111094926.658806039@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit eb45f2110b036e4e35d3f3aaee1c2ccf49d92425 ]

Early revisions of the AST2600 datasheet are conflicted about the state
of the LPC/eSPI strapping bit (SCU510[6]). Conversations with ASPEED
determined that the reference pinmux configuration tables were in error
and the SCU documentation contained the correct configuration. Update
the driver to reflect the state described in the SCU documentation.

Fixes: 2eda1cdec49f ("pinctrl: aspeed: Add AST2600 pinmux support")
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20191202050110.15340-1-andrew@aj.id.au
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c | 24 ++++++++--------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
index c6800d220920..bb07024d22ed 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
@@ -1088,60 +1088,52 @@ SSSF_PIN_DECL(AF15, GPIOV7, LPCSMI, SIG_DESC_SET(SCU434, 15));
 
 #define AB7 176
 SIG_EXPR_LIST_DECL_SESG(AB7, LAD0, LPC, SIG_DESC_SET(SCU434, 16),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AB7, ESPID0, ESPI, SIG_DESC_SET(SCU434, 16),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AB7, ESPID0, ESPI, SIG_DESC_SET(SCU434, 16));
 PIN_DECL_2(AB7, GPIOW0, LAD0, ESPID0);
 
 #define AB8 177
 SIG_EXPR_LIST_DECL_SESG(AB8, LAD1, LPC, SIG_DESC_SET(SCU434, 17),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AB8, ESPID1, ESPI, SIG_DESC_SET(SCU434, 17),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AB8, ESPID1, ESPI, SIG_DESC_SET(SCU434, 17));
 PIN_DECL_2(AB8, GPIOW1, LAD1, ESPID1);
 
 #define AC8 178
 SIG_EXPR_LIST_DECL_SESG(AC8, LAD2, LPC, SIG_DESC_SET(SCU434, 18),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AC8, ESPID2, ESPI, SIG_DESC_SET(SCU434, 18),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AC8, ESPID2, ESPI, SIG_DESC_SET(SCU434, 18));
 PIN_DECL_2(AC8, GPIOW2, LAD2, ESPID2);
 
 #define AC7 179
 SIG_EXPR_LIST_DECL_SESG(AC7, LAD3, LPC, SIG_DESC_SET(SCU434, 19),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AC7, ESPID3, ESPI, SIG_DESC_SET(SCU434, 19),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AC7, ESPID3, ESPI, SIG_DESC_SET(SCU434, 19));
 PIN_DECL_2(AC7, GPIOW3, LAD3, ESPID3);
 
 #define AE7 180
 SIG_EXPR_LIST_DECL_SESG(AE7, LCLK, LPC, SIG_DESC_SET(SCU434, 20),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AE7, ESPICK, ESPI, SIG_DESC_SET(SCU434, 20),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AE7, ESPICK, ESPI, SIG_DESC_SET(SCU434, 20));
 PIN_DECL_2(AE7, GPIOW4, LCLK, ESPICK);
 
 #define AF7 181
 SIG_EXPR_LIST_DECL_SESG(AF7, LFRAME, LPC, SIG_DESC_SET(SCU434, 21),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AF7, ESPICS, ESPI, SIG_DESC_SET(SCU434, 21),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AF7, ESPICS, ESPI, SIG_DESC_SET(SCU434, 21));
 PIN_DECL_2(AF7, GPIOW5, LFRAME, ESPICS);
 
 #define AD7 182
 SIG_EXPR_LIST_DECL_SESG(AD7, LSIRQ, LSIRQ, SIG_DESC_SET(SCU434, 22),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AD7, ESPIALT, ESPIALT, SIG_DESC_SET(SCU434, 22),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AD7, ESPIALT, ESPIALT, SIG_DESC_SET(SCU434, 22));
 PIN_DECL_2(AD7, GPIOW6, LSIRQ, ESPIALT);
 FUNC_GROUP_DECL(LSIRQ, AD7);
 FUNC_GROUP_DECL(ESPIALT, AD7);
 
 #define AD8 183
 SIG_EXPR_LIST_DECL_SESG(AD8, LPCRST, LPC, SIG_DESC_SET(SCU434, 23),
-			  SIG_DESC_CLEAR(SCU510, 6));
-SIG_EXPR_LIST_DECL_SESG(AD8, ESPIRST, ESPI, SIG_DESC_SET(SCU434, 23),
 			  SIG_DESC_SET(SCU510, 6));
+SIG_EXPR_LIST_DECL_SESG(AD8, ESPIRST, ESPI, SIG_DESC_SET(SCU434, 23));
 PIN_DECL_2(AD8, GPIOW7, LPCRST, ESPIRST);
 
 FUNC_GROUP_DECL(LPC, AB7, AB8, AC8, AC7, AE7, AF7, AD8);
-- 
2.20.1



