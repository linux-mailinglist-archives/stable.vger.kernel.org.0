Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91442603F60
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiJSJbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiJSJ3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87539EA358;
        Wed, 19 Oct 2022 02:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68869617ED;
        Wed, 19 Oct 2022 09:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA75C433C1;
        Wed, 19 Oct 2022 09:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170106;
        bh=joD3mbfUiz/qsnrMG3CKx0XowThncKwMs1kwZheyZHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmxlNoVj7HMfBkaxiC+XB4zwnrjTHIXmLizEld/t9F03A0hCSyuS0WqGKVhAOKlPj
         0qKJNOn68zIz9Dl/bClqfqLrkFnyOl2/nDjzJR87e24S4EACk6Qa9Nq8KLIHaSjC5v
         E1yHJoSXC0OlwcdJsb5o6Zxs/1aIQcvp3CxIb83Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 530/862] phy: phy-mtk-tphy: fix the phy type setting issue
Date:   Wed, 19 Oct 2022 10:30:17 +0200
Message-Id: <20221019083313.391172232@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8ee7682b8e93..bdffc21858f6 100644
--- a/drivers/phy/mediatek/phy-mtk-tphy.c
+++ b/drivers/phy/mediatek/phy-mtk-tphy.c
@@ -906,7 +906,7 @@ static int phy_type_syscon_get(struct mtk_phy_instance *instance,
 static int phy_type_set(struct mtk_phy_instance *instance)
 {
 	int type;
-	u32 mask;
+	u32 offset;
 
 	if (!instance->type_sw)
 		return 0;
@@ -929,8 +929,9 @@ static int phy_type_set(struct mtk_phy_instance *instance)
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



