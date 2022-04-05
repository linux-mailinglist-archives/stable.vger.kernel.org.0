Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1214F41AA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382109AbiDEMOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240911AbiDEKfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CBB9FC0;
        Tue,  5 Apr 2022 03:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1178261676;
        Tue,  5 Apr 2022 10:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BEAC385A0;
        Tue,  5 Apr 2022 10:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153991;
        bh=IZaxfL+Er97/lWRvXq1SC3CC6f14wZtrVoYFDN97XY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkql8dPob0o+WRHhU5oAWip5M/OgLQ1HUIug2oU/GfOTTVmcy4yvuqYMA8RSPmdA0
         oBL77PdXvHiYNAwrdiLEkuwtjaSqunSLHKk00kLqS20KiMNdjDstjWUIgA7v7wdKJj
         QGnSf8igu5R/xigrgwj8FF5osb6Bh+PbejYL018U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/599] pinctrl: mediatek: paris: Fix PIN_CONFIG_BIAS_* readback
Date:   Tue,  5 Apr 2022 09:31:53 +0200
Message-Id: <20220405070311.301666980@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

[ Upstream commit 3e8c6bc608480010f360c4a59578d7841726137d ]

When reading back pin bias settings, if the pin is not in the
corresponding bias state, the function should return -EINVAL.

Fix this in the mediatek-paris pinctrl library so that the read back
state is not littered with bogus a "input bias disabled" combined with
"pull up" or "pull down" states.

Fixes: 805250982bb5 ("pinctrl: mediatek: add pinctrl-paris that implements the vendor dt-bindings")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220308100956.2750295-3-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 623af4410b07..4dd5bd2f135e 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -96,20 +96,16 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 			err = hw->soc->bias_get_combo(hw, desc, &pullup, &ret);
 			if (err)
 				goto out;
+			if (ret == MTK_PUPD_SET_R1R0_00)
+				ret = MTK_DISABLE;
 			if (param == PIN_CONFIG_BIAS_DISABLE) {
-				if (ret == MTK_PUPD_SET_R1R0_00)
-					ret = MTK_DISABLE;
+				if (ret != MTK_DISABLE)
+					err = -EINVAL;
 			} else if (param == PIN_CONFIG_BIAS_PULL_UP) {
-				/* When desire to get pull-up value, return
-				 *  error if current setting is pull-down
-				 */
-				if (!pullup)
+				if (!pullup || ret == MTK_DISABLE)
 					err = -EINVAL;
 			} else if (param == PIN_CONFIG_BIAS_PULL_DOWN) {
-				/* When desire to get pull-down value, return
-				 *  error if current setting is pull-up
-				 */
-				if (pullup)
+				if (pullup || ret == MTK_DISABLE)
 					err = -EINVAL;
 			}
 		} else {
-- 
2.34.1



