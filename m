Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355804F32A9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbiDEIeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239487AbiDEIUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78765FA0;
        Tue,  5 Apr 2022 01:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CB10609AD;
        Tue,  5 Apr 2022 08:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8ADC385A0;
        Tue,  5 Apr 2022 08:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146455;
        bh=nRqe1qlcYUQNgbazDz0Sc2U/enVv6QmbhOHOSE1R3PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvUrwODzQ/GwjuBlkb5IzkfGulM9dN5EynqmosayTgWhE2f7PiSs2y6Tfyf2CBtYc
         3enJGjZEnt9zurwT9NgMvWxx3l5VnuKhR1yCJwIMy/A7AGVwCq4eKJBg4CvYomDZLZ
         ElXwtT23tcYNvHuH4ynZHOH/J9I8cSd/wfy0ecbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0771/1126] pinctrl: mediatek: paris: Fix "argument" argument type for mtk_pinconf_get()
Date:   Tue,  5 Apr 2022 09:25:18 +0200
Message-Id: <20220405070430.211808787@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 19bce7ce0a593c7024030a0cda9e23facea3c93d ]

For mtk_pinconf_get(), the "argument" argument is typically returned by
pinconf_to_config_argument(), which holds the value for a given pinconf
parameter. It certainly should not have the type of "enum pin_config_param",
which describes the type of the pinconf parameter itself.

Change the type to u32, which matches the return type of
pinconf_to_config_argument().

Fixes: 805250982bb5 ("pinctrl: mediatek: add pinctrl-paris that implements the vendor dt-bindings")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220308100956.2750295-4-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 7037560ecda9..c668191933a0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -184,8 +184,7 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
-			   enum pin_config_param param,
-			   enum pin_config_param arg)
+			   enum pin_config_param param, u32 arg)
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
 	const struct mtk_pin_desc *desc;
-- 
2.34.1



