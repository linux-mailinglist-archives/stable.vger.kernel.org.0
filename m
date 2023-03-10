Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5996B485C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjCJPBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbjCJPB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:01:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799E412A165
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C105B8231C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490A8C433D2;
        Fri, 10 Mar 2023 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460062;
        bh=at4PXOdcisnwj/uEorMqF+vgmdEVfA/UeSaYgA5MTc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj3AwQ+XDBVIZ2iWhbFEw/wDeYAPyMbVSaml61YLozknpfgkdvpx6OFehJEt9zoXa
         XXXlhu6mV/wNcMJ6oX3PzcAk31dyZfhPH9kNocjuetnSfhBq8hftVMXtaFZgkIHlR+
         SoEoDPZw1/zWXiEmLynjGKCeEJyq1PcYLF/b7i2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guodong Liu <Guodong.Liu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/529] pinctrl: mediatek: Initialize variable *buf to zero
Date:   Fri, 10 Mar 2023 14:35:26 +0100
Message-Id: <20230310133813.442858498@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit 2e34f82ba214134ecf590fbe0cdbd87401645a8a ]

Coverity spotted that *buf is not initialized to zero in
mtk_pctrl_dbg_show. Using uninitialized variable *buf as argument to %s
when calling seq_printf. Fix this coverity by initializing *buf as zero.

Fixes: 184d8e13f9b1 ("pinctrl: mediatek: Add support for pin configuration dump via debugfs.")
Signed-off-by: Guodong Liu <Guodong.Liu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230118062036.26258-3-Guodong.Liu@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 2a9d2801388d7..e486d66e220b0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -637,7 +637,7 @@ static void mtk_pctrl_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned int gpio)
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
-	char buf[PIN_DBG_BUF_SZ];
+	char buf[PIN_DBG_BUF_SZ] = { 0 };
 
 	(void)mtk_pctrl_show_one_pin(hw, gpio, buf, PIN_DBG_BUF_SZ);
 
-- 
2.39.2



