Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060206AF3EC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbjCGTLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbjCGTKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DA429439
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE7E3B819D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86EBC433EF;
        Tue,  7 Mar 2023 18:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215277;
        bh=J6PLATqOQDQa4wB99GxsfZBzmJls5/V68pXo/gX52cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBPVT8/N5ap5MaV2ySSqtj+jTS5yrrsgQ6spcP6iybAypn75o03A4BEkozE6GQE0K
         PI8BmG9BJxBm3v8vBuEcNAvok3KWycCOYrkGP5a1lN4xWY3cYDC/yxBREUOK8g/nSU
         kNsU6QUIwvtRnnx/Ds76sFSF0TGSixwqjm47r9Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guodong Liu <Guodong.Liu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/567] pinctrl: mediatek: Initialize variable pullen and pullup to zero
Date:   Tue,  7 Mar 2023 17:59:04 +0100
Message-Id: <20230307165914.914067671@linuxfoundation.org>
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

From: Guodong Liu <Guodong.Liu@mediatek.com>

[ Upstream commit a298c70a10c604a6b3df5a0aa56597b705ba0f6b ]

Coverity spotted that pullen and pullup is not initialized to zero in
mtk_pctrl_show_one_pin. The uninitialized variable pullen is used in
assignment statement "rsel = pullen;" in mtk_pctrl_show_one_pin, and
Uninitialized variable pullup is used when calling scnprintf. Fix this
coverity by initializing pullen and pullup as zero.

Fixes: 184d8e13f9b1 ("pinctrl: mediatek: Add support for pin configuration dump via debugfs.")
Signed-off-by: Guodong Liu <Guodong.Liu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230118062036.26258-2-Guodong.Liu@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index fc3487fccb948..d151612f4a18c 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -574,7 +574,7 @@ static int mtk_hw_get_value_wrap(struct mtk_pinctrl *hw, unsigned int gpio, int
 ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 	unsigned int gpio, char *buf, unsigned int buf_len)
 {
-	int pinmux, pullup, pullen, len = 0, r1 = -1, r0 = -1;
+	int pinmux, pullup = 0, pullen = 0, len = 0, r1 = -1, r0 = -1;
 	const struct mtk_pin_desc *desc;
 
 	if (gpio >= hw->soc->npins)
-- 
2.39.2



