Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1562760BAE0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiJXUlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiJXUky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:40:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A37465A3;
        Mon, 24 Oct 2022 11:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CCCFB818C4;
        Mon, 24 Oct 2022 12:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3139C433C1;
        Mon, 24 Oct 2022 12:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615576;
        bh=g3Q8xsJXR9CmZwSj+sV5yQEZWLvWp+ydt4y05mNWtts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOoph8mKxuAzyNaCemzkwORKVPWwMctTRS/QrixRYJ/V7Mhj1Q7Z9J435nMe62FcX
         DFAiGv3KFZUdPSE/p7DK6fbepY/KDUG4vEaVutYQJf6ZSOOqIksSkm0gPi69KjFqUf
         EJaslLXSTwLTqKNr4RKe730BHvhlgTQtkiO93AkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/530] phy: phy-mtk-tphy: fix the phy type setting issue
Date:   Mon, 24 Oct 2022 13:30:48 +0200
Message-Id: <20221024113058.828032448@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 931c05a8cb1be029ef2fbc1e4af313d4cb297c47 ]

The PHY type is not set if the index is non zero, prepare type
value according to the index, like as mask value.

Fixes: 39099a443358 ("phy: phy-mtk-tphy: support type switch by pericfg")
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220914060746.10004-7-chunfeng.yun@mediatek.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-tphy.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/mediatek/phy-mtk-tphy.c b/drivers/phy/mediatek/phy-mtk-tphy.c
index db39b0c4649a..0649c08fe310 100644
--- a/drivers/phy/mediatek/phy-mtk-tphy.c
+++ b/drivers/phy/mediatek/phy-mtk-tphy.c
@@ -1039,7 +1039,7 @@ static int phy_type_syscon_get(struct mtk_phy_instance *instance,
 static int phy_type_set(struct mtk_phy_instance *instance)
 {
 	int type;
-	u32 mask;
+	u32 offset;
 
 	if (!instance->type_sw)
 		return 0;
@@ -1062,8 +1062,9 @@ static int phy_type_set(struct mtk_phy_instance *instance)
 		return 0;
 	}
 
-	mask = RG_PHY_SW_TYPE << (instance->type_sw_index * BITS_PER_BYTE);
-	regmap_update_bits(instance->type_sw, instance->type_sw_reg, mask, type);
+	offset = instance->type_sw_index * BITS_PER_BYTE;
+	regmap_update_bits(instance->type_sw, instance->type_sw_reg,
+			   RG_PHY_SW_TYPE << offset, type << offset);
 
 	return 0;
 }
-- 
2.35.1



