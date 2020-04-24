Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE81B754E
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgDXMc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgDXMW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:22:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547BF21582;
        Fri, 24 Apr 2020 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730977;
        bh=l0ZRuARmG39itY8Gk3NXDFg74u0GGjLdxKk76vOkrOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge8KogarkkOTxEfqmoJAKxRcZDmFBOxdJpbGAmnidNmvfcTLQ+zHLcEAX6H6jWZN/
         qk7dZ3ONe6EjFJcUmGBErK0Fk4aJmbbFzpWznQ6jEQibr/ovSS1xUWB3ozefTwfbwp
         UO9je6TORIb8pLmVLROMCegEEZ8tlfsjpNWilq5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 17/38] clk: asm9260: fix __clk_hw_register_fixed_rate_with_accuracy typo
Date:   Fri, 24 Apr 2020 08:22:15 -0400
Message-Id: <20200424122237.9831-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 924ed1f5c181132897c5928af7f3afd28792889c ]

The __clk_hw_register_fixed_rate_with_accuracy() function (with two '_')
does not exist, and apparently never did:

drivers/clk/clk-asm9260.c: In function 'asm9260_acc_init':
drivers/clk/clk-asm9260.c:279:7: error: implicit declaration of function '__clk_hw_register_fixed_rate_with_accuracy'; did you mean 'clk_hw_register_fixed_rate_with_accuracy'? [-Werror=implicit-function-declaration]
  279 |  hw = __clk_hw_register_fixed_rate_with_accuracy(NULL, NULL, pll_clk,
      |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |       clk_hw_register_fixed_rate_with_accuracy
drivers/clk/clk-asm9260.c:279:5: error: assignment to 'struct clk_hw *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
  279 |  hw = __clk_hw_register_fixed_rate_with_accuracy(NULL, NULL, pll_clk,
      |     ^

From what I can tell, __clk_hw_register_fixed_rate() is the correct
API here, so use that instead.

Fixes: 728e3096741a ("clk: asm9260: Use parent accuracy in fixed rate clk")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lkml.kernel.org/r/20200408155402.2138446-1-arnd@arndb.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-asm9260.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-asm9260.c b/drivers/clk/clk-asm9260.c
index 536b59aabd2cb..bacebd457e6f3 100644
--- a/drivers/clk/clk-asm9260.c
+++ b/drivers/clk/clk-asm9260.c
@@ -276,7 +276,7 @@ static void __init asm9260_acc_init(struct device_node *np)
 
 	/* TODO: Convert to DT parent scheme */
 	ref_clk = of_clk_get_parent_name(np, 0);
-	hw = __clk_hw_register_fixed_rate_with_accuracy(NULL, NULL, pll_clk,
+	hw = __clk_hw_register_fixed_rate(NULL, NULL, pll_clk,
 			ref_clk, NULL, NULL, 0, rate, 0,
 			CLK_FIXED_RATE_PARENT_ACCURACY);
 
-- 
2.20.1

