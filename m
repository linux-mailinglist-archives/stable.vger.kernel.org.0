Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1495363DFD1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiK3Suw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiK3Sul (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B699D839
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C56EB81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D08C433C1;
        Wed, 30 Nov 2022 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834237;
        bh=yFqVmtyF1pBSKDJccdOVN1CzDLQTWzm5XEMtqdUhcdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7wVUO9E/gJFUH6NWc/ScuNu+bVytawdech2vfd4YU7lMrF3IR9L12L8OzhZYPL6b
         zcEoNMEnahEs5eUfo4WZmAldTxWXH/+oSw0+NdMqJpJLxC7ebtA1AHiokMmeyf86MH
         OljdWA+Q3fn5gL8M+3i8wWvk10u+P+2VMt+Rnefw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.0 180/289] bus: ixp4xx: Dont touch bit 7 on IXP42x
Date:   Wed, 30 Nov 2022 19:22:45 +0100
Message-Id: <20221130180548.209254973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

commit ff5a19909b49fe5c0b01ae197f84b741e0f698dc upstream.

We face some regressions on a few IXP42x systems when
accessing flash, the following unrelated error prints
appear from the PCI driver:

ixp4xx-pci c0000000.pci: PCI: abort_handler addr = 0xff9ffb5f,
	   isr = 0x0, status = 0x22a0
ixp4xx-pci c0000000.pci: imprecise abort
(...)

It turns out that while bit 7 is masked "reserved" it is
not unused, so masking it off as zero is dangerous, and
breaks flash access on some systems such as the NSLU2.
Be more careful and avoid masking off any of the reserved
bits 7, 8, 9 or 30. Only keep masking EXP_WORD (bit 2)
on IXP43x which is necessary in some setups.

Fixes: 1c953bda90ca ("bus: ixp4xx: Add a driver for IXP4xx expansion bus")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221122134411.2030372-1-linus.walleij@linaro.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/intel-ixp4xx-eb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/bus/intel-ixp4xx-eb.c
+++ b/drivers/bus/intel-ixp4xx-eb.c
@@ -49,7 +49,7 @@
 #define IXP4XX_EXP_SIZE_SHIFT		10
 #define IXP4XX_EXP_CNFG_0		BIT(9) /* Always zero */
 #define IXP43X_EXP_SYNC_INTEL		BIT(8) /* Only on IXP43x */
-#define IXP43X_EXP_EXP_CHIP		BIT(7) /* Only on IXP43x */
+#define IXP43X_EXP_EXP_CHIP		BIT(7) /* Only on IXP43x, dangerous to touch on IXP42x */
 #define IXP4XX_EXP_BYTE_RD16		BIT(6)
 #define IXP4XX_EXP_HRDY_POL		BIT(5) /* Only on IXP42x */
 #define IXP4XX_EXP_MUX_EN		BIT(4)
@@ -57,8 +57,6 @@
 #define IXP4XX_EXP_WORD			BIT(2) /* Always zero */
 #define IXP4XX_EXP_WR_EN		BIT(1)
 #define IXP4XX_EXP_BYTE_EN		BIT(0)
-#define IXP42X_RESERVED			(BIT(30)|IXP4XX_EXP_CNFG_0|BIT(8)|BIT(7)|IXP4XX_EXP_WORD)
-#define IXP43X_RESERVED			(BIT(30)|IXP4XX_EXP_CNFG_0|BIT(5)|IXP4XX_EXP_WORD)
 
 #define IXP4XX_EXP_CNFG0		0x20
 #define IXP4XX_EXP_CNFG0_MEM_MAP	BIT(31)
@@ -252,10 +250,9 @@ static void ixp4xx_exp_setup_chipselect(
 		cs_cfg |= val << IXP4XX_EXP_CYC_TYPE_SHIFT;
 	}
 
-	if (eb->is_42x)
-		cs_cfg &= ~IXP42X_RESERVED;
 	if (eb->is_43x) {
-		cs_cfg &= ~IXP43X_RESERVED;
+		/* Should always be zero */
+		cs_cfg &= ~IXP4XX_EXP_WORD;
 		/*
 		 * This bit for Intel strata flash is currently unused, but let's
 		 * report it if we find one.


