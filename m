Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0636AF57A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjCGTZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbjCGTZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:25:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DE9CA1D4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:11:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E57161520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1C4C433EF;
        Tue,  7 Mar 2023 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216287;
        bh=R5Mkg3aaao5rRO7lP+B2HKIZW/sCjd8uaip/12m9qZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQ4WTlzOPNOpaIP/eYoLbE6GwdR8UNeVQwVb4wD/3NAOjBsYh8uA57G7DVQiCYm2t
         +WtRkhSaFxLh77YPROyVSS1i2zCIC3v5N0pfFmjA8u7JNmhKZTxSAPWsm30rOliwQc
         hijf7peWwb42VkaFAfifUGuHFdPqk8WjiSjIQ57I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Dhruva Gole <d-gole@ti.com>, Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 5.15 503/567] mtd: spi-nor: spansion: Consider reserved bits in CFR5 register
Date:   Tue,  7 Mar 2023 18:03:59 +0100
Message-Id: <20230307165927.776299175@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit 3f592a869f87723314f0cb1ac232bd3bf8245be8 upstream.

CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
definition, stop using magic numbers and describe the missing bit fields
in CFR5 register. This is useful for both readability and future possible
addition of Octal STR mode support.

Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
Cc: stable@vger.kernel.org
Reported-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Pratyush Yadav <ptyadav@amazon.de>
Tested-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/linux-mtd/20230110164703.83413-1-tudor.ambarus@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/spansion.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -15,8 +15,13 @@
 #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
 #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
 #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
+#define SPINOR_REG_CYPRESS_CFR5_BIT6		BIT(6)
+#define SPINOR_REG_CYPRESS_CFR5_DDR		BIT(1)
+#define SPINOR_REG_CYPRESS_CFR5_OPI		BIT(0)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN				\
+	(SPINOR_REG_CYPRESS_CFR5_BIT6 |	SPINOR_REG_CYPRESS_CFR5_DDR |	\
+	 SPINOR_REG_CYPRESS_CFR5_OPI)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	SPINOR_REG_CYPRESS_CFR5_BIT6
 #define SPINOR_OP_CYPRESS_RD_FAST		0xee
 
 /**


