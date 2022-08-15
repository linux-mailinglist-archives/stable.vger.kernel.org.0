Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F260B5937BC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343730AbiHOTMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343860AbiHOTLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:11:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AA742ACD;
        Mon, 15 Aug 2022 11:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A924B8105D;
        Mon, 15 Aug 2022 18:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB9FC433C1;
        Mon, 15 Aug 2022 18:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588610;
        bh=SsESgowbU490/ite9UQJ2/VF8eHcvsf//IiX5TmCguU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfc/ts6qw0Ik6sZfiVTCkqozNTC4Obcx5fKFrWp1n+kAgFv+kAkBTBX/l4r2PLBJd
         +NfufzRoWawcTr16r63iH/9PlfONhz8vJrU0P6RDr7loi15QWDGfRqXhTe3nz+CcDU
         Z/csyi1C3py9qrJ5KzZCSA+8eO+ZQBt+93+ignrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/779] clk: mediatek: reset: Fix written reset bit offset
Date:   Mon, 15 Aug 2022 20:01:12 +0200
Message-Id: <20220815180355.565929729@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rex-BC Chen <rex-bc.chen@mediatek.com>

[ Upstream commit edabcf71d100fd433a0fc2d0c97057c446c33b2a ]

Original assert/deassert bit is BIT(0), but it's more resonable to modify
them to BIT(id % 32) which is based on id.

This patch will not influence any previous driver because the reset is
only used for thermal. The id (MT8183_INFRACFG_AO_THERM_SW_RST) is 0.

Fixes: 64ebb57a3df6 ("clk: reset: Modify reset-controller driver")
Signed-off-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20220523093346.28493-3-rex-bc.chen@mediatek.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/reset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mediatek/reset.c b/drivers/clk/mediatek/reset.c
index e562dc3c10a4..d311da574499 100644
--- a/drivers/clk/mediatek/reset.c
+++ b/drivers/clk/mediatek/reset.c
@@ -25,7 +25,7 @@ static int mtk_reset_assert_set_clr(struct reset_controller_dev *rcdev,
 	struct mtk_reset *data = container_of(rcdev, struct mtk_reset, rcdev);
 	unsigned int reg = data->regofs + ((id / 32) << 4);
 
-	return regmap_write(data->regmap, reg, 1);
+	return regmap_write(data->regmap, reg, BIT(id % 32));
 }
 
 static int mtk_reset_deassert_set_clr(struct reset_controller_dev *rcdev,
@@ -34,7 +34,7 @@ static int mtk_reset_deassert_set_clr(struct reset_controller_dev *rcdev,
 	struct mtk_reset *data = container_of(rcdev, struct mtk_reset, rcdev);
 	unsigned int reg = data->regofs + ((id / 32) << 4) + 0x4;
 
-	return regmap_write(data->regmap, reg, 1);
+	return regmap_write(data->regmap, reg, BIT(id % 32));
 }
 
 static int mtk_reset_assert(struct reset_controller_dev *rcdev,
-- 
2.35.1



