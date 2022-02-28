Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C874C75BB
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiB1R4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2B652E74;
        Mon, 28 Feb 2022 09:43:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEA0D608C4;
        Mon, 28 Feb 2022 17:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4DCC340F0;
        Mon, 28 Feb 2022 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070202;
        bh=tZIKfWR+H3BlXKJ0ATaZf8/I7giSuWW2xGUyyzNSUi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ka7BXfF9XlieE5F150XyutzDUGVhOwt84evGE2BoX3KrclQeBAD+O7QpR/vrKnD8X
         dwbdte3cPksWVRe14dRvLLQIjFNIwWOt5eNBb4WS9IzKWHvlAwRxWMoEizugC5qvMB
         uHwGUJAxK2jMC/eyOLm1xcG4t771OJmF11CFQWEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siarhei Volkau <lis8215@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.16 007/164] clk: jz4725b: fix mmc0 clock gating
Date:   Mon, 28 Feb 2022 18:22:49 +0100
Message-Id: <20220228172400.393088220@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siarhei Volkau <lis8215@gmail.com>

commit 2f0754f27a230fee6e6d753f07585cee03bedfe3 upstream.

The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
You can find that the same bit is assigned to "mmc0" too.
It leads to mmc0 hang for a long time after any sound activity
also it  prevented PM_SLEEP to work properly.
I guess it was introduced by copy-paste from jz4740 driver
where it is really controls I2S clock gate.

Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Tested-by: Siarhei Volkau <lis8215@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220205171849.687805-2-lis8215@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/ingenic/jz4725b-cgu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/clk/ingenic/jz4725b-cgu.c
+++ b/drivers/clk/ingenic/jz4725b-cgu.c
@@ -139,11 +139,10 @@ static const struct ingenic_cgu_clk_info
 	},
 
 	[JZ4725B_CLK_I2S] = {
-		"i2s", CGU_CLK_MUX | CGU_CLK_DIV | CGU_CLK_GATE,
+		"i2s", CGU_CLK_MUX | CGU_CLK_DIV,
 		.parents = { JZ4725B_CLK_EXT, JZ4725B_CLK_PLL_HALF, -1, -1 },
 		.mux = { CGU_REG_CPCCR, 31, 1 },
 		.div = { CGU_REG_I2SCDR, 0, 1, 9, -1, -1, -1 },
-		.gate = { CGU_REG_CLKGR, 6 },
 	},
 
 	[JZ4725B_CLK_SPI] = {


