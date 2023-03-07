Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E657B6AEF17
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjCGSUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjCGSUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:20:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182DE9EF7E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFC96B819BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AA3C433D2;
        Tue,  7 Mar 2023 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212848;
        bh=DbmkFlrYXDWkA1P3Od1DXFjecArkgcfctzDdE0X/Rak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cyg/4FaVAh84aU7XuBv6xFQDwHxDB3PHuHd3/Wd/rFQFRrRTZiW6WNISzIDLBMcMF
         SrCMIfFkE8T809yDtXUQQ5Cb9pkiNVw87CF3rRqS38LUd1hkixxvwpf144g4wvNSZJ
         ZeLeOJJwwauHJppMB3N+KQd8K9tFihxCdpw+IEvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guodong Liu <Guodong.Liu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 317/885] pinctrl: mediatek: Initialize variable *buf to zero
Date:   Tue,  7 Mar 2023 17:54:11 +0100
Message-Id: <20230307170015.923678208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 3b5c9352686db..ad873bd051b68 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -712,7 +712,7 @@ static void mtk_pctrl_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned int gpio)
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
-	char buf[PIN_DBG_BUF_SZ];
+	char buf[PIN_DBG_BUF_SZ] = { 0 };
 
 	(void)mtk_pctrl_show_one_pin(hw, gpio, buf, PIN_DBG_BUF_SZ);
 
-- 
2.39.2



