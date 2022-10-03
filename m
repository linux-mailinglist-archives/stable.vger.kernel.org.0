Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C562B5F29B6
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJCHY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJCHX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AC94A819;
        Mon,  3 Oct 2022 00:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9912660F9D;
        Mon,  3 Oct 2022 07:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB85C43144;
        Mon,  3 Oct 2022 07:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781424;
        bh=ZpKjv/MqU+BVENNAyJSrumUBGjzF0RDQDNmlN6qablY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc/YPfFnqqTYbo18W6DQ4EJxa66XvRlgC96gEv0/zaP8unB+LB+3t2dk5E1DHAxuO
         9WHOv2gr/qxPA3XQp5pDK9rsXlK/Um/nbkjZpCo0OHFcBTf+Cf6z9qRESRsI8BHtnx
         t0YPuKJSzONGD96jj7HBSZ7LrorYYEcac9k/OknA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 15/83] clk: ingenic-tcu: Properly enable registers before accessing timers
Date:   Mon,  3 Oct 2022 09:10:40 +0200
Message-Id: <20221003070722.365624246@linuxfoundation.org>
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

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

commit 6726d552a6912e88cf63fe2bda87b2efa0efc7d0 upstream.

Access to registers is guarded by ingenic_tcu_{enable,disable}_regs()
so the stop bit can be cleared before accessing a timer channel, but
those functions did not clear the stop bit on SoCs with a global TCU
clock gate.

Testing on the X1000 has revealed that the stop bits must be cleared
_and_ the global TCU clock must be ungated to access timer registers.
This appears to be the norm on Ingenic SoCs, and is specified in the
documentation for the X1000 and numerous JZ47xx SoCs.

If the stop bit isn't cleared, register writes don't take effect and
the system can be left in a broken state, eg. the watchdog timer may
not run.

The bug probably went unnoticed because stop bits are zeroed when
the SoC is reset, and the kernel does not set them unless a timer
gets disabled at runtime. However, it is possible that a bootloader
or a previous kernel (if using kexec) leaves the stop bits set and
we should not rely on them being cleared.

Fixing this is easy: have ingenic_tcu_{enable,disable}_regs() always
clear the stop bit, regardless of the presence of a global TCU gate.

Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Paul Cercueil <paul@crapouillou.net>
Fixes: 4f89e4b8f121 ("clk: ingenic: Add driver for the TCU clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
Link: https://lore.kernel.org/r/20220617122254.738900-1-aidanmacdonald.0x0@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/ingenic/tcu.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/clk/ingenic/tcu.c
+++ b/drivers/clk/ingenic/tcu.c
@@ -100,15 +100,11 @@ static bool ingenic_tcu_enable_regs(stru
 	bool enabled = false;
 
 	/*
-	 * If the SoC has no global TCU clock, we must ungate the channel's
-	 * clock to be able to access its registers.
-	 * If we have a TCU clock, it will be enabled automatically as it has
-	 * been attached to the regmap.
+	 * According to the programming manual, a timer channel's registers can
+	 * only be accessed when the channel's stop bit is clear.
 	 */
-	if (!tcu->clk) {
-		enabled = !!ingenic_tcu_is_enabled(hw);
-		regmap_write(tcu->map, TCU_REG_TSCR, BIT(info->gate_bit));
-	}
+	enabled = !!ingenic_tcu_is_enabled(hw);
+	regmap_write(tcu->map, TCU_REG_TSCR, BIT(info->gate_bit));
 
 	return enabled;
 }
@@ -119,8 +115,7 @@ static void ingenic_tcu_disable_regs(str
 	const struct ingenic_tcu_clk_info *info = tcu_clk->info;
 	struct ingenic_tcu *tcu = tcu_clk->tcu;
 
-	if (!tcu->clk)
-		regmap_write(tcu->map, TCU_REG_TSSR, BIT(info->gate_bit));
+	regmap_write(tcu->map, TCU_REG_TSSR, BIT(info->gate_bit));
 }
 
 static u8 ingenic_tcu_get_parent(struct clk_hw *hw)


