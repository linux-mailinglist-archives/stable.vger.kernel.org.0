Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34436531691
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240728AbiEWRdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241301AbiEWR0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81596B7FC;
        Mon, 23 May 2022 10:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F8E760C21;
        Mon, 23 May 2022 17:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B49C385AA;
        Mon, 23 May 2022 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326397;
        bh=m4cwoyy/BQKWuB7tsuReyl/3ZsdpUuEU3bjsJk2tUpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voY99Nn8Bk7v234ue/eWIfnH1VYICKKmcztZAKCS0wdknM9m7xTH2w4YugrTBUtQu
         /Gdz4eXoD9TeQt8mmTWxtgEZhd9MNCm1+I4LrM7Ky9wv3Y1TkKz1J679+usGcdG9h8
         rFMKJdG4T9pBiJjvfunAwT+49eZxPx+mxJ2P4hY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Youngmin Han <Youngmin.Han@geappliances.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/132] pinctrl: mediatek: mt8365: fix IES control pins
Date:   Mon, 23 May 2022 19:04:37 +0200
Message-Id: <20220523165834.466418794@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattijs Korpershoek <mkorpershoek@baylibre.com>

[ Upstream commit f680058f406863b55ac226d1c157701939c63db4 ]

IES26 (BIT 16 of IES1_CFG_ADDR) controls the following pads:

- PAD_I2S_DATA_IN (GPIO114)
- PAD_I2S_LRCK (GPIO115)
- PAD_I2S_BCK (GPIO116)

The pinctrl table is wrong since it lists pins 114 to 112.

Update the table with the correct values.

Fixes: e94d8b6fb83a ("pinctrl: mediatek: add support for mt8365 SoC")
Reported-by: Youngmin Han <Youngmin.Han@geappliances.com>
Signed-off-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/20220426125714.298907-1-mkorpershoek@baylibre.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8365.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8365.c b/drivers/pinctrl/mediatek/pinctrl-mt8365.c
index 79b1fee5a1eb..ddee0db72d26 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8365.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8365.c
@@ -259,7 +259,7 @@ static const struct mtk_pin_ies_smt_set mt8365_ies_set[] = {
 	MTK_PIN_IES_SMT_SPEC(104, 104, 0x420, 13),
 	MTK_PIN_IES_SMT_SPEC(105, 109, 0x420, 14),
 	MTK_PIN_IES_SMT_SPEC(110, 113, 0x420, 15),
-	MTK_PIN_IES_SMT_SPEC(114, 112, 0x420, 16),
+	MTK_PIN_IES_SMT_SPEC(114, 116, 0x420, 16),
 	MTK_PIN_IES_SMT_SPEC(117, 119, 0x420, 17),
 	MTK_PIN_IES_SMT_SPEC(120, 122, 0x420, 18),
 	MTK_PIN_IES_SMT_SPEC(123, 125, 0x420, 19),
-- 
2.35.1



