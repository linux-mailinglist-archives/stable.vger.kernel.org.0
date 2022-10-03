Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED0B5F2A4B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiJCHez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiJCHdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BFE52096;
        Mon,  3 Oct 2022 00:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD10EB80E98;
        Mon,  3 Oct 2022 07:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F280C433D6;
        Mon,  3 Oct 2022 07:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781572;
        bh=mx9ftnuzq9ci2eIbyQWEhEq6TrIUmYIY4z3AB7Ihuxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ce560jpTt0Va0JF3/b22MpUlLcDB+Ih7zTHvTb4mjEuuVU1VBGDUhOJWHwELHvhfx
         JXYE/r12nsstUHmhOp5l0DYXJiHi3EU68VJppLj3olM21GhllwW4Dyvz+jK0S9rFzA
         Jn/I+ZiL1pY4JYcYYpmYqqLztG/eHeMctXyDbQPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 69/83] clk: iproc: Do not rely on node name for correct PLL setup
Date:   Mon,  3 Oct 2022 09:11:34 +0200
Message-Id: <20221003070723.722996149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 1b24a132eba7a1c19475ba2510ec1c00af3ff914 ]

After commit 31fd9b79dc58 ("ARM: dts: BCM5301X: update CRU block
description") a warning from clk-iproc-pll.c was generated due to a
duplicate PLL name as well as the console stopped working. Upon closer
inspection it became clear that iproc_pll_clk_setup() used the Device
Tree node unit name as an unique identifier as well as a parent name to
parent all clocks under the PLL.

BCM5301X was the first platform on which that got noticed because of the
DT node unit name renaming but the same assumptions hold true for any
user of the iproc_pll_clk_setup() function.

The first 'clock-output-names' property is always guaranteed to be
unique as well as providing the actual desired PLL clock name, so we
utilize that to register the PLL and as a parent name of all children
clock.

Fixes: 5fe225c105fd ("clk: iproc: add initial common clock support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20220905161504.1526-1-f.fainelli@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-iproc-pll.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/bcm/clk-iproc-pll.c b/drivers/clk/bcm/clk-iproc-pll.c
index 33da30f99c79..d39c44b61c52 100644
--- a/drivers/clk/bcm/clk-iproc-pll.c
+++ b/drivers/clk/bcm/clk-iproc-pll.c
@@ -736,6 +736,7 @@ void iproc_pll_clk_setup(struct device_node *node,
 	const char *parent_name;
 	struct iproc_clk *iclk_array;
 	struct clk_hw_onecell_data *clk_data;
+	const char *clk_name;
 
 	if (WARN_ON(!pll_ctrl) || WARN_ON(!clk_ctrl))
 		return;
@@ -783,7 +784,12 @@ void iproc_pll_clk_setup(struct device_node *node,
 	iclk = &iclk_array[0];
 	iclk->pll = pll;
 
-	init.name = node->name;
+	ret = of_property_read_string_index(node, "clock-output-names",
+					    0, &clk_name);
+	if (WARN_ON(ret))
+		goto err_pll_register;
+
+	init.name = clk_name;
 	init.ops = &iproc_pll_ops;
 	init.flags = 0;
 	parent_name = of_clk_get_parent_name(node, 0);
@@ -803,13 +809,11 @@ void iproc_pll_clk_setup(struct device_node *node,
 		goto err_pll_register;
 
 	clk_data->hws[0] = &iclk->hw;
+	parent_name = clk_name;
 
 	/* now initialize and register all leaf clocks */
 	for (i = 1; i < num_clks; i++) {
-		const char *clk_name;
-
 		memset(&init, 0, sizeof(init));
-		parent_name = node->name;
 
 		ret = of_property_read_string_index(node, "clock-output-names",
 						    i, &clk_name);
-- 
2.35.1



