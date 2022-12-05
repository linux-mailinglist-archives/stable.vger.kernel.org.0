Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A491F643204
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiLETXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiLETXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:23:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201E7275E1
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDCAE6133A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BA6C433D6;
        Mon,  5 Dec 2022 19:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267875;
        bh=Pa/7jVZ1yCqQZMWIyNBPutPFDwHtnIbdmeh6Kc6uFT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Przy20MdrIx8FpFv7lZ3kO6tg0JWl3l10eFRAQh0lMguakn8/+m3658MOfd7Z00S+
         7Qhh6bxEAxkNapca9kpaIB3nuCxNKfrca4GSxQtJWAO+RzzUjQZbaIiCaOdL4cW+ip
         B+4+i+ljpg0ANdXViwNnTH5pwlj4VNFKfD5SQd04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 76/77] mmc: sdhci: use FIELD_GET for preset value bit masks
Date:   Mon,  5 Dec 2022 20:10:07 +0100
Message-Id: <20221205190803.543050134@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit fa0910107a9fea170b817f31da2a65463e00e80e upstream.

Use the FIELD_GET macro to get access to the register fields.
Delete the shift macros.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lore.kernel.org/r/20200312110050.21732-1-yamada.masahiro@socionext.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   10 +++++-----
 drivers/mmc/host/sdhci.h |   10 ++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -13,6 +13,7 @@
  *     - JMicron (hardware and technical support)
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
 #include <linux/highmem.h>
@@ -1340,10 +1341,9 @@ u16 sdhci_calc_clk(struct sdhci_host *ho
 
 			clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
 			pre_val = sdhci_get_preset_value(host);
-			div = (pre_val & SDHCI_PRESET_SDCLK_FREQ_MASK)
-				>> SDHCI_PRESET_SDCLK_FREQ_SHIFT;
+			div = FIELD_GET(SDHCI_PRESET_SDCLK_FREQ_MASK, pre_val);
 			if (host->clk_mul &&
-				(pre_val & SDHCI_PRESET_CLKGEN_SEL_MASK)) {
+				(pre_val & SDHCI_PRESET_CLKGEN_SEL)) {
 				clk = SDHCI_PROG_CLOCK_MODE;
 				real_div = div + 1;
 				clk_mul = host->clk_mul;
@@ -1795,8 +1795,8 @@ void sdhci_set_ios(struct mmc_host *mmc,
 
 			sdhci_enable_preset_value(host, true);
 			preset = sdhci_get_preset_value(host);
-			ios->drv_type = (preset & SDHCI_PRESET_DRV_MASK)
-				>> SDHCI_PRESET_DRV_SHIFT;
+			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
+						  preset);
 		}
 
 		/* Re-enable SD Clock */
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -13,6 +13,7 @@
 #ifndef __SDHCI_HW_H
 #define __SDHCI_HW_H
 
+#include <linux/bits.h>
 #include <linux/scatterlist.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
@@ -259,12 +260,9 @@
 #define SDHCI_PRESET_FOR_SDR104        0x6C
 #define SDHCI_PRESET_FOR_DDR50 0x6E
 #define SDHCI_PRESET_FOR_HS400 0x74 /* Non-standard */
-#define SDHCI_PRESET_DRV_MASK  0xC000
-#define SDHCI_PRESET_DRV_SHIFT  14
-#define SDHCI_PRESET_CLKGEN_SEL_MASK   0x400
-#define SDHCI_PRESET_CLKGEN_SEL_SHIFT	10
-#define SDHCI_PRESET_SDCLK_FREQ_MASK   0x3FF
-#define SDHCI_PRESET_SDCLK_FREQ_SHIFT	0
+#define SDHCI_PRESET_DRV_MASK		GENMASK(15, 14)
+#define SDHCI_PRESET_CLKGEN_SEL		BIT(10)
+#define SDHCI_PRESET_SDCLK_FREQ_MASK	GENMASK(9, 0)
 
 #define SDHCI_SLOT_INT_STATUS	0xFC
 


