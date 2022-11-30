Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE12C63DEB2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiK3Sjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiK3Sjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F1397019
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:39:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E00A61D61
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CDAC433D6;
        Wed, 30 Nov 2022 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833582;
        bh=Rx6GdNuF2rM6PDLuuJ0oHfYaF4eG1bYVP4Cz23T8ZjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nqxFbJGZ0CUBdlgWWMUaOQTXsHGOp1i6E3F1UrRu7j66nvYq+laqTuMnmXJdNDFC
         GiGrfCbQGlOFxa0WgwW+QxMK6F9cY4b9Z3rv5TmqOt0Q83baXARYDOYwF48h9MXME8
         9+aPlSOiyReHpcOnuL7JWK+KfTXZGxS3D22Xnmp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 149/206] bus: ixp4xx: Dont touch bit 7 on IXP42x
Date:   Wed, 30 Nov 2022 19:23:21 +0100
Message-Id: <20221130180536.828922678@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
 drivers/bus/intel-ixp4xx-eb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/intel-ixp4xx-eb.c b/drivers/bus/intel-ixp4xx-eb.c
index a4388440aca7..91db001eb69a 100644
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
@@ -252,10 +250,9 @@ static void ixp4xx_exp_setup_chipselect(struct ixp4xx_eb *eb,
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
-- 
2.38.1



