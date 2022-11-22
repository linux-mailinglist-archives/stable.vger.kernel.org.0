Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19E3633DFE
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 14:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiKVNom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 08:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiKVNoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 08:44:18 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EF25E3EA
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 05:44:15 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id j16so23593836lfe.12
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 05:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7cSVZRD5dl++t7NTRPxlXhktXZGNW8/fggWgo+i1QwM=;
        b=n8GgaUjftITEUjT9UbaD0FjzUVM+s8BfzCNdULajuEyLze1ZIMLxMBFLuRI8zQqsXj
         ytLPpREY8ltPVAXRaZxri2Dp/thU+TFsCwhnwvl8Ed3zx9ccXp/Z8oCEy9zmnD+TIWh3
         s1iCkzzU4nJuOJFWGkbMCgd4qQjYQUVtW/I3k08aWc/GhDC/Z9zKZqFRAjgYVu3s7vKg
         WLXmlhvYhS/DUN3wGubBlZKHYqez391eIsFNs1Ovno3BIW2QCJTsklFv3EzGCN6XSWJ6
         dQlXIpMqqSEECvATC85E9auFEpRU8mzm77ddveY4RKzBaN2phZJfzJrBTPEUms7cuf5d
         jMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7cSVZRD5dl++t7NTRPxlXhktXZGNW8/fggWgo+i1QwM=;
        b=LBPwYGSooWNDSNSFfnfybHRagv9nHGbq1dtnqMNSZkmikdt+zlidZdH0BkKTTLXh6M
         Hu6CiPgG8eE1w/ubQxnuEmZqjP7CY7ORcyHzrYayLUEV/D+g4w+DGIvh4kV0TOYrU/A+
         +ka8+pq3wov/9b53XDzbuANzssff41C6yWwWiQ+pkEQXvdFxyh4kwFnw3cPsh6X7EAme
         g5HDmsnzP2oE4nCKHiNE5e3KYgvbmOnkeC9879FV5FzPii+SQzM+xypwwOOjNAhJfGHw
         OqhGgGRWxBFSthjHSLA7MKd1iiwtstpVtVJYqukMPEzMiRaS9bvOZH/i1D9Jc6yjXSdP
         AcDg==
X-Gm-Message-State: ANoB5pnCA/AbytmDgUjwwLRktlmLzL3tp93nZHjpowq/n7tAixD1JpUV
        BPO7Bp5sVb8A0nTIkFwHAdeSauPCkJ1PWQ==
X-Google-Smtp-Source: AA0mqf6n0iET3taxlhj5daLvISJtcWCShO6aEdm06dY/3OiekEvKX6We/rU2vMKwYtIM2N9pbiPGgw==
X-Received: by 2002:a05:6512:606:b0:4b1:2aab:7cbf with SMTP id b6-20020a056512060600b004b12aab7cbfmr4581551lfe.499.1669124653926;
        Tue, 22 Nov 2022 05:44:13 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id s15-20020a056512214f00b004a8b9c68735sm2500919lfr.102.2022.11.22.05.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 05:44:13 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] bus: ixp4xx: Don't touch bit 7 on IXP42x
Date:   Tue, 22 Nov 2022 14:44:11 +0100
Message-Id: <20221122134411.2030372-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: 1c953bda90ca ("bus: ixp4xx: Add a driver for IXP4xx expansion bus")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
SoC folks: please apply this directly for fixes since it
fixes a regression.
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

