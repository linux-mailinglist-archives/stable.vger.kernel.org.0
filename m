Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7116541C24
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350849AbiFGV4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384272AbiFGVyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6956124A1F6;
        Tue,  7 Jun 2022 12:13:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 823D8B823AE;
        Tue,  7 Jun 2022 19:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B95C385A5;
        Tue,  7 Jun 2022 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629197;
        bh=Pz1kTw9rpUe1+33wr4J6yxpE185CiEZoGR2AYZS4OiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHP2O4rU1p5FH9+6SEdzpEnh3hxsvaMmHN2cQxnUgnGCKG5oyTk2hU/KO+6HG67qY
         aYWdrEh9nSPcSeCDwiUZ28IXyu1BWJHbp3O+9jtIio4LmBbRqUA5JhfKu5U/fRY/b8
         uZcN3g0dgUaIE0qqj5mkqct2Br0775wXrHcSh8SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 605/879] pinctrl: renesas: r8a779f0: Fix GPIO function on I2C-capable pins
Date:   Tue,  7 Jun 2022 19:02:03 +0200
Message-Id: <20220607165020.412368442@linuxfoundation.org>
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

[ Upstream commit 8bdd369dba7ff2f89cfd723ca3a26602aae4e498 ]

Unlike on R-Car Gen3 SoCs, setting a bit to zero in a GPIO / Peripheral
Function Select Register (GPSRn) on R-Car S4-8 is not always sufficient
to configure a pin for GPIO.  For I2C-capable pins, the I2C function
must also be explicitly disabled in the corresponding Module Select
Register (MODSELn).

Add the missing FN_SEL_I2Ci_0 function enums to the pinmux_data[] array
by temporarily overriding the GP_1_j_FN function enum to expand to two
enums: the original GP_1_j_FN enum to configure the GPSR register bits,
and the missing FN_SEL_I2Ci_0 enum to configure the MODSEL register
bits.

Fixes: 030ac6d7eeff81e3 ("pinctrl: renesas: Initial R8A779F0 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/c12c60ec1058140a37f03650043ab73f730f104f.1650610471.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a779f0.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/pinctrl/renesas/pfc-r8a779f0.c b/drivers/pinctrl/renesas/pfc-r8a779f0.c
index 91860608242c..3b4ca9622bbe 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779f0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779f0.c
@@ -257,7 +257,28 @@ enum {
 };
 
 static const u16 pinmux_data[] = {
+/* Using GP_1_[0-9] requires disabling I2C in MOD_SEL1 */
+#define GP_1_0_FN	GP_1_0_FN,	FN_SEL_I2C0_0
+#define GP_1_1_FN	GP_1_1_FN,	FN_SEL_I2C0_0
+#define GP_1_2_FN	GP_1_2_FN,	FN_SEL_I2C1_0
+#define GP_1_3_FN	GP_1_3_FN,	FN_SEL_I2C1_0
+#define GP_1_4_FN	GP_1_4_FN,	FN_SEL_I2C2_0
+#define GP_1_5_FN	GP_1_5_FN,	FN_SEL_I2C2_0
+#define GP_1_6_FN	GP_1_6_FN,	FN_SEL_I2C3_0
+#define GP_1_7_FN	GP_1_7_FN,	FN_SEL_I2C3_0
+#define GP_1_8_FN	GP_1_8_FN,	FN_SEL_I2C4_0
+#define GP_1_9_FN	GP_1_9_FN,	FN_SEL_I2C4_0
 	PINMUX_DATA_GP_ALL(),
+#undef GP_1_0_FN
+#undef GP_1_1_FN
+#undef GP_1_2_FN
+#undef GP_1_3_FN
+#undef GP_1_4_FN
+#undef GP_1_5_FN
+#undef GP_1_6_FN
+#undef GP_1_7_FN
+#undef GP_1_8_FN
+#undef GP_1_9_FN
 
 	PINMUX_SINGLE(SD_WP),
 	PINMUX_SINGLE(SD_CD),
-- 
2.35.1



