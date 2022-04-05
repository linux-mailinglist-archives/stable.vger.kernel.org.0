Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346674F41C6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381707AbiDEMOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240724AbiDEKfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920E915838;
        Tue,  5 Apr 2022 03:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30682616D7;
        Tue,  5 Apr 2022 10:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE7DC385A0;
        Tue,  5 Apr 2022 10:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153988;
        bh=6C4543HZmf/QKPo/zXdDpm09NG3q971K1kcfakg27SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMQO0KwbdXr4eOfbZ3P0IVwPfzHUKf7DOH11MA+7FvJZ4iefComdkpX4D6m6leTiT
         8Ixht5ldUclajmDgL0ueCMoARLjL34bvGpKQiuwB4ruHxmYLb9OPsSqfoCoNyxuVG7
         udzFxSbirRAiZlZl60X/iXK2nMBkDOaKrIbYPfXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/599] pinctrl: mediatek: Fix missing of_node_put() in mtk_pctrl_init
Date:   Tue,  5 Apr 2022 09:31:52 +0200
Message-Id: <20220405070311.271234026@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit dab4df9ca919f59e5b9dd84385eaf34d4f20dbb0 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: a6df410d420a ("pinctrl: mediatek: Add Pinctrl/GPIO driver for mt8135.")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220308071155.21114-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index a02ad10ec6fa..730581d13064 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1039,6 +1039,7 @@ int mtk_pctrl_init(struct platform_device *pdev,
 	node = of_parse_phandle(np, "mediatek,pctl-regmap", 0);
 	if (node) {
 		pctl->regmap1 = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(pctl->regmap1))
 			return PTR_ERR(pctl->regmap1);
 	} else if (regmap) {
@@ -1052,6 +1053,7 @@ int mtk_pctrl_init(struct platform_device *pdev,
 	node = of_parse_phandle(np, "mediatek,pctl-regmap", 1);
 	if (node) {
 		pctl->regmap2 = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(pctl->regmap2))
 			return PTR_ERR(pctl->regmap2);
 	}
-- 
2.34.1



