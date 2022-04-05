Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5498D4F38AA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245752AbiDEL0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349492AbiDEJt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B5D21AC;
        Tue,  5 Apr 2022 02:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD49B81B76;
        Tue,  5 Apr 2022 09:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38873C385A2;
        Tue,  5 Apr 2022 09:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152043;
        bh=letGfrqMJtS0jS6rXm/zbO8dXAw7rWWP4/AZLlOog+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmkKxCJxsjqoanyv8ZHHP84dAik3mFEnxqvak9l3vPhi2+CJSxJgdsE0bzfd+Xpd6
         TBJ5ix9Qs3m4CT1qXFtP4sPJqTEJFWFv+fO/dwgA0B2kdIJK4ywDXAziWJDYgt3A/7
         43kJ7dyvOjXJK3uaSVmYlSv8xP2NkSxd9wxIWZDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 635/913] pinctrl: mediatek: paris: Skip custom extra pin config dump for virtual GPIOs
Date:   Tue,  5 Apr 2022 09:28:17 +0200
Message-Id: <20220405070358.873888158@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit 1763933d377ecb05454f8d20e3c8922480db2ac0 ]

Virtual GPIOs do not have any hardware state associated with them. Any
attempt to read back hardware state for these pins result in error
codes.

Skip dumping extra pin config information for these virtual GPIOs.

Fixes: 184d8e13f9b1 ("pinctrl: mediatek: Add support for pin configuration dump via debugfs.")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220308100956.2750295-7-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 2133964dfd59..02e2a259edd3 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -580,6 +580,9 @@ ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 	if (gpio >= hw->soc->npins)
 		return -EINVAL;
 
+	if (mtk_is_virt_gpio(hw, gpio))
+		return -EINVAL;
+
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
 	pinmux = mtk_pctrl_get_pinmux(hw, gpio);
 	if (pinmux >= hw->soc->nfuncs)
-- 
2.34.1



