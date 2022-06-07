Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E63541C27
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355515AbiFGV4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384262AbiFGVyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BF024930E;
        Tue,  7 Jun 2022 12:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E60796190F;
        Tue,  7 Jun 2022 19:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2190C385A5;
        Tue,  7 Jun 2022 19:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629194;
        bh=kTuuIhu96E1JbLgYMI5icr8Uk1Mf1n+2XCYfUEibknw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFgCQfoomCqXklc+WvgVYDgzUySBsICDhCHcn3VA+hRgon0DeIUnvoHilQGaA9IkZ
         nmsQwzUC98EJZMaFZaSaXong5Ohi7J9gkSuJRCevFsw03eW+U6Yyr2Riwni5HYGVjF
         smDIDuJEOflyEmxlaiavmV5j7G/CYI9hKUE8w5rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 604/879] pinctrl: renesas: r8a779a0: Fix GPIO function on I2C-capable pins
Date:   Tue,  7 Jun 2022 19:02:02 +0200
Message-Id: <20220607165020.382879639@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4288caed9a6319b766dc0adf605c7b401180db34 ]

Unlike on R-Car Gen3 SoCs, setting a bit to zero in a GPIO / Peripheral
Function Select Register (GPSRn) on R-Car V3U is not always sufficient
to configure a pin for GPIO.  For I2C-capable pins, the I2C function
must also be explicitly disabled in the corresponding Module Select
Register (MODSELn).

Add the missing FN_SEL_I2Ci_0 function enums to the pinmux_data[] array
by temporarily overriding the GP_2_j_FN function enum to expand to two
enums: the original GP_2_j_FN enum to configure the GSPR register bits,
and the missing FN_SEL_I2Ci_0 enum to configure the MODSEL register
bits.

Fixes: 741a7370fc3b8b54 ("pinctrl: renesas: Initial R8A779A0 (V3U) PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/4611e29e7b105513883084c1d6dc39c3ac8b525c.1650610471.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a779a0.c | 29 ++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/pinctrl/renesas/pfc-r8a779a0.c b/drivers/pinctrl/renesas/pfc-r8a779a0.c
index 4a668a04b7ca..0c26e95ba7db 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779a0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779a0.c
@@ -629,7 +629,36 @@ enum {
 };
 
 static const u16 pinmux_data[] = {
+/* Using GP_2_[2-15] requires disabling I2C in MOD_SEL2 */
+#define GP_2_2_FN	GP_2_2_FN,	FN_SEL_I2C0_0
+#define GP_2_3_FN	GP_2_3_FN,	FN_SEL_I2C0_0
+#define GP_2_4_FN	GP_2_4_FN,	FN_SEL_I2C1_0
+#define GP_2_5_FN	GP_2_5_FN,	FN_SEL_I2C1_0
+#define GP_2_6_FN	GP_2_6_FN,	FN_SEL_I2C2_0
+#define GP_2_7_FN	GP_2_7_FN,	FN_SEL_I2C2_0
+#define GP_2_8_FN	GP_2_8_FN,	FN_SEL_I2C3_0
+#define GP_2_9_FN	GP_2_9_FN,	FN_SEL_I2C3_0
+#define GP_2_10_FN	GP_2_10_FN,	FN_SEL_I2C4_0
+#define GP_2_11_FN	GP_2_11_FN,	FN_SEL_I2C4_0
+#define GP_2_12_FN	GP_2_12_FN,	FN_SEL_I2C5_0
+#define GP_2_13_FN	GP_2_13_FN,	FN_SEL_I2C5_0
+#define GP_2_14_FN	GP_2_14_FN,	FN_SEL_I2C6_0
+#define GP_2_15_FN	GP_2_15_FN,	FN_SEL_I2C6_0
 	PINMUX_DATA_GP_ALL(),
+#undef GP_2_2_FN
+#undef GP_2_3_FN
+#undef GP_2_4_FN
+#undef GP_2_5_FN
+#undef GP_2_6_FN
+#undef GP_2_7_FN
+#undef GP_2_8_FN
+#undef GP_2_9_FN
+#undef GP_2_10_FN
+#undef GP_2_11_FN
+#undef GP_2_12_FN
+#undef GP_2_13_FN
+#undef GP_2_14_FN
+#undef GP_2_15_FN
 
 	PINMUX_SINGLE(MMC_D7),
 	PINMUX_SINGLE(MMC_D6),
-- 
2.35.1



