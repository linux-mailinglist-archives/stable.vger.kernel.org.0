Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132A56434AF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiLETs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiLETsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:48:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363F62A423
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9656131D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA63C433B5;
        Mon,  5 Dec 2022 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269505;
        bh=rCYRBnIq3CM+eGsOeS0pgSET77x7ZQ59gWBbGzcflxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJWVwxA/5yKeUdXD7Aqsg4GZNlFBbytJlyB0gIZIIhzhfezcXSJva5i1pjHWQnh06
         1csnJM200bawiJa5I5QXXvQ2K19x0Hxiwnvv+h/4eVFCBlj7Gp38ytAuAOsq7gTuqq
         jxNN+KRYN+pEwYLgE2gdIQR3PUkByzYZ/90DA8Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 152/153] mmc: sdhci: use FIELD_GET for preset value bit masks
Date:   Mon,  5 Dec 2022 20:11:16 +0100
Message-Id: <20221205190812.936109893@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
@@ -9,6 +9,7 @@
  *     - JMicron (hardware and technical support)
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
 #include <linux/highmem.h>
@@ -1570,10 +1571,9 @@ u16 sdhci_calc_clk(struct sdhci_host *ho
 
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
@@ -2048,8 +2048,8 @@ void sdhci_set_ios(struct mmc_host *mmc,
 
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
@@ -9,6 +9,7 @@
 #ifndef __SDHCI_HW_H
 #define __SDHCI_HW_H
 
+#include <linux/bits.h>
 #include <linux/scatterlist.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
@@ -268,12 +269,9 @@
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
 


