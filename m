Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BF33FDB5E
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345228AbhIAMlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344442AbhIAMja (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 046B0610F9;
        Wed,  1 Sep 2021 12:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499707;
        bh=DMseKcXPlJ0eQwvrZsYnP0lIdsti2YeWRPnMmmG9wno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBb4oOYiI4pfQlih83qIvSc5CHWQe+pOSPIeIwL5z3vfI2KJ00KJXZEtJa2NCX2BX
         b0oP9ywJREgYlhii90q2Lsez9ZaS8GOv0gZmvnGqnBqbkgHVjfPCSs5fpHuhtY/Rnw
         teKpoaymQZy4dYe8Dtbt4Lirm2IzJAwQThHF+SIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/103] clk: renesas: rcar-usb2-clock-sel: Fix kernel NULL pointer dereference
Date:   Wed,  1 Sep 2021 14:28:03 +0200
Message-Id: <20210901122302.353455604@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 1669a941f7c4844ae808cf441db51dde9e94db07 ]

The probe was manually passing NULL instead of dev to devm_clk_hw_register.
This caused a Unable to handle kernel NULL pointer dereference error.
Fix this by passing 'dev'.

Signed-off-by: Adam Ford <aford173@gmail.com>
Fixes: a20a40a8bbc2 ("clk: renesas: rcar-usb2-clock-sel: Fix error handling in .probe()")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rcar-usb2-clock-sel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/rcar-usb2-clock-sel.c b/drivers/clk/renesas/rcar-usb2-clock-sel.c
index 0ccc6e709a38..7a64dcb7209e 100644
--- a/drivers/clk/renesas/rcar-usb2-clock-sel.c
+++ b/drivers/clk/renesas/rcar-usb2-clock-sel.c
@@ -190,7 +190,7 @@ static int rcar_usb2_clock_sel_probe(struct platform_device *pdev)
 	init.num_parents = 0;
 	priv->hw.init = &init;
 
-	ret = devm_clk_hw_register(NULL, &priv->hw);
+	ret = devm_clk_hw_register(dev, &priv->hw);
 	if (ret)
 		goto pm_put;
 
-- 
2.30.2



