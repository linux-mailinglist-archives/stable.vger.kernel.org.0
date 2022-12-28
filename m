Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA148657D31
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiL1Pk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiL1Pk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8F9167F2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48E366155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5903FC433D2;
        Wed, 28 Dec 2022 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242025;
        bh=DLSz5Pj/0Pn7jVFOYAyYYpiRTb9Zpm9HtjmhzdKQEhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6g3fd7448isr0IgzJwthSZQZV4ESnp4T0uex1RgPC221iXDWuFBx860/YzBD+3O+
         z/2lm8zDC0tsABx5On5D7RWhI4b2dINhonhRPRB2MzdzQQ+9SsDh5AEjmUkgguVn4Y
         zBQESUEeu2pOilJom6mGnh8XBE/HGDmqk+Ipcaes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sam Shih <sam.shih@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0317/1146] pinctrl: mediatek: fix the pinconf register offset of some pins
Date:   Wed, 28 Dec 2022 15:30:56 +0100
Message-Id: <20221228144338.764139923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Sam Shih <sam.shih@mediatek.com>

[ Upstream commit 3476b354c65db442580ef355885c69e60c546ef0 ]

Correct the bias-pull-up, bias-pull-down and bias-disable register
offset of mt7986 pin-42 to pin-49, in the original driver, the
relative offset value was erroneously decremented by 1.

Fixes: 360de6728064 ("pinctrl: mediatek: add support for MT7986 SoC")
Signed-off-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221106080114.7426-5-linux@fw-web.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt7986.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7986.c b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
index 50cb736f9f11..b58729969748 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7986.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
@@ -316,10 +316,10 @@ static const struct mtk_pin_field_calc mt7986_pin_pupd_range[] = {
 	PIN_FIELD_BASE(38, 38, IOCFG_LT_BASE, 0x30, 0x10, 9, 1),
 	PIN_FIELD_BASE(39, 40, IOCFG_RB_BASE, 0x60, 0x10, 18, 1),
 	PIN_FIELD_BASE(41, 41, IOCFG_RB_BASE, 0x60, 0x10, 12, 1),
-	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x60, 0x10, 22, 1),
-	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x60, 0x10, 20, 1),
-	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x60, 0x10, 26, 1),
-	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x60, 0x10, 24, 1),
+	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x60, 0x10, 23, 1),
+	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x60, 0x10, 21, 1),
+	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x60, 0x10, 27, 1),
+	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x60, 0x10, 25, 1),
 	PIN_FIELD_BASE(50, 57, IOCFG_RT_BASE, 0x40, 0x10, 2, 1),
 	PIN_FIELD_BASE(58, 58, IOCFG_RT_BASE, 0x40, 0x10, 1, 1),
 	PIN_FIELD_BASE(59, 59, IOCFG_RT_BASE, 0x40, 0x10, 0, 1),
@@ -354,10 +354,10 @@ static const struct mtk_pin_field_calc mt7986_pin_r0_range[] = {
 	PIN_FIELD_BASE(38, 38, IOCFG_LT_BASE, 0x40, 0x10, 9, 1),
 	PIN_FIELD_BASE(39, 40, IOCFG_RB_BASE, 0x70, 0x10, 18, 1),
 	PIN_FIELD_BASE(41, 41, IOCFG_RB_BASE, 0x70, 0x10, 12, 1),
-	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x70, 0x10, 22, 1),
-	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x70, 0x10, 20, 1),
-	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x70, 0x10, 26, 1),
-	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x70, 0x10, 24, 1),
+	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x70, 0x10, 23, 1),
+	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x70, 0x10, 21, 1),
+	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x70, 0x10, 27, 1),
+	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x70, 0x10, 25, 1),
 	PIN_FIELD_BASE(50, 57, IOCFG_RT_BASE, 0x50, 0x10, 2, 1),
 	PIN_FIELD_BASE(58, 58, IOCFG_RT_BASE, 0x50, 0x10, 1, 1),
 	PIN_FIELD_BASE(59, 59, IOCFG_RT_BASE, 0x50, 0x10, 0, 1),
@@ -392,10 +392,10 @@ static const struct mtk_pin_field_calc mt7986_pin_r1_range[] = {
 	PIN_FIELD_BASE(38, 38, IOCFG_LT_BASE, 0x50, 0x10, 9, 1),
 	PIN_FIELD_BASE(39, 40, IOCFG_RB_BASE, 0x80, 0x10, 18, 1),
 	PIN_FIELD_BASE(41, 41, IOCFG_RB_BASE, 0x80, 0x10, 12, 1),
-	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x80, 0x10, 22, 1),
-	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x80, 0x10, 20, 1),
-	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x80, 0x10, 26, 1),
-	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x80, 0x10, 24, 1),
+	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x80, 0x10, 23, 1),
+	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x80, 0x10, 21, 1),
+	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x80, 0x10, 27, 1),
+	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x80, 0x10, 25, 1),
 	PIN_FIELD_BASE(50, 57, IOCFG_RT_BASE, 0x60, 0x10, 2, 1),
 	PIN_FIELD_BASE(58, 58, IOCFG_RT_BASE, 0x60, 0x10, 1, 1),
 	PIN_FIELD_BASE(59, 59, IOCFG_RT_BASE, 0x60, 0x10, 0, 1),
-- 
2.35.1



