Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E34C74CD
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiB1Rsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238871AbiB1Rrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:47:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6CA9F6C9;
        Mon, 28 Feb 2022 09:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DB8F61548;
        Mon, 28 Feb 2022 17:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EC4C340E7;
        Mon, 28 Feb 2022 17:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069894;
        bh=tZIKfWR+H3BlXKJ0ATaZf8/I7giSuWW2xGUyyzNSUi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chrfte3vZSHBzw1QB9cy4Ylzv+m5Izk2eUG0Jw6CNK9hk96yhGUz1eROHRMfPOSOH
         amVFeZEfPTtkxUky+fKumlv62m/CDYX3LXdDJ2EPwnLB2l+UZEBicM5bbR5fz5u4St
         cvN3Wh0f3nZ5kleKno5m1286WFC10S/9eyJDAsL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siarhei Volkau <lis8215@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 007/139] clk: jz4725b: fix mmc0 clock gating
Date:   Mon, 28 Feb 2022 18:23:01 +0100
Message-Id: <20220228172348.497204774@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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


