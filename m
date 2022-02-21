Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12E54BDBFF
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352426AbiBUKDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:03:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353447AbiBUJ51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F543917A;
        Mon, 21 Feb 2022 01:25:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04AD6B80EBB;
        Mon, 21 Feb 2022 09:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F94C340E9;
        Mon, 21 Feb 2022 09:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435548;
        bh=v4dDXwJubReDk2vJzh2yaDD2XZ0dk6Hd1kxbXVwlOPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU4T3HYZwuumgnQIu4A6AXhm5TP2cbWqci8MZeWq7OjLXR4EPsJp6ZWdu1TQiBN/X
         DZzHIxWuM+Scb/ADkMWMUFE7l8zB6659S37LeL3KtSLOOcSbdDtTx+9/vXZQ+TZZII
         RvMWQWt5ujY1nMjYGtrhDBVxEZP5fOrnBFC8jQjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 202/227] phy: phy-mtk-tphy: Fix duplicated argument in phy-mtk-tphy
Date:   Mon, 21 Feb 2022 09:50:21 +0100
Message-Id: <20220221084941.531213102@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 46e994717807f4b935c44d81dde9dd8bcd9a4f5d ]

Fix following coccicheck warning:
./drivers/phy/mediatek/phy-mtk-tphy.c:994:6-29: duplicated argument
to && or ||

The efuse_rx_imp is duplicate. Here should be efuse_tx_imp.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Acked-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20220107025050.787720-1-wanjiabing@vivo.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-tphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/phy-mtk-tphy.c b/drivers/phy/mediatek/phy-mtk-tphy.c
index 98a942c607a67..db39b0c4649a2 100644
--- a/drivers/phy/mediatek/phy-mtk-tphy.c
+++ b/drivers/phy/mediatek/phy-mtk-tphy.c
@@ -1125,7 +1125,7 @@ static int phy_efuse_get(struct mtk_tphy *tphy, struct mtk_phy_instance *instanc
 		/* no efuse, ignore it */
 		if (!instance->efuse_intr &&
 		    !instance->efuse_rx_imp &&
-		    !instance->efuse_rx_imp) {
+		    !instance->efuse_tx_imp) {
 			dev_warn(dev, "no u3 intr efuse, but dts enable it\n");
 			instance->efuse_sw_en = 0;
 			break;
-- 
2.34.1



