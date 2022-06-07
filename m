Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FAF540DD5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354124AbiFGSuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354422AbiFGSrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DB53B57E;
        Tue,  7 Jun 2022 11:01:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 919DA617B0;
        Tue,  7 Jun 2022 18:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A185CC3411F;
        Tue,  7 Jun 2022 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624867;
        bh=F2RdKYiF/AIZNtD8234nKlfRDhSvmQLoGb3m3d+9j6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yt3cM2FCQvbJf+VYob7yiIOW7zcHSjbVzOrpZH8EWaOhxOpUdnGKwfSvAKH/p3oBi
         TnWzEj0ycMc0qlhCGcWK5fZwyORw0/WAkjyu8UHrEqoIm5E5bqt6f9pUzt1WuHDa5f
         ohXlydVEazkQp2H4u2HXRvvHJ5UDH+QjYvAU3gPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/667] pinctrl: renesas: r8a779a0: Fix GPIO function on I2C-capable pins
Date:   Tue,  7 Jun 2022 19:01:46 +0200
Message-Id: <20220607164947.947530740@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index ad6532443a78..a480677dd03d 100644
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



