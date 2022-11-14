Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133E8628039
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiKNNEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiKNNEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0507C27DDA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD316B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7DEC433C1;
        Mon, 14 Nov 2022 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431044;
        bh=Viu8T5DXTFtIiEJE5PaQGXmpykHE8DzUnlm/GXoZz3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQd4v0UyesGoffJyWurYUPCnNfqyEHphHAbs4gzrmwjF3Hl4Bbr40RGegIIoEvb89
         rc2oyiAvFSlsNG4vNHkHim3x0I2VOZfRnNAO2bcSrn1QED9WLGGOKKCwZgAVobXgBM
         /rpyoNdGIQngVJGs1AUAs3x/G2oYoUxodVKaFK0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 072/190] net: ethernet: mtk-star-emac: disable napi when connect and start PHY failed in mtk_star_enable()
Date:   Mon, 14 Nov 2022 13:44:56 +0100
Message-Id: <20221114124501.850258185@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit b0c09c7f08c2467b2089bdf4adb2fbbc2464f4a8 ]

When failed to connect to and start PHY in mtk_star_enable() for opening
device, napi isn't disabled. When open mtk star device next time, it will
reports a invalid opcode issue. Fix it. Only be compiled, not be tested.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221107012159.211387-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 3f0e5e64de50..57f4373b30ba 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1026,6 +1026,8 @@ static int mtk_star_enable(struct net_device *ndev)
 	return 0;
 
 err_free_irq:
+	napi_disable(&priv->rx_napi);
+	napi_disable(&priv->tx_napi);
 	free_irq(ndev->irq, ndev);
 err_free_skbs:
 	mtk_star_free_rx_skbs(priv);
-- 
2.35.1



