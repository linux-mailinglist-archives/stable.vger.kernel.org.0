Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CBD635563
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbiKWJR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237388AbiKWJR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC461095A5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:17:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD6D061B59
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C670EC43148;
        Wed, 23 Nov 2022 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195030;
        bh=aAiuY6rW0c7HXcUdWczTasJjEkYlIBdNYolj6H01FiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jw1wSstlOEeFgvtF074vf5AGTlwlETs7AKcSBSwq+vvTfiD3wMU5V6SzyIFTHBb7x
         vTNFQ0HlunzB27jQOWY46L8a8aiYQNJTb2+UmcPpsbp8gl+Fua/mryw+7S27aLnTCk
         RWXsP6kr1eK7boBkfor70MDkNQvhct4yUXLQYkWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/156] net: bgmac: Drop free_netdev() from bgmac_enet_remove()
Date:   Wed, 23 Nov 2022 09:50:54 +0100
Message-Id: <20221123084601.496858584@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 6f928ab8ee9bfbcb0e631c47ea8a16c3d5116ff1 ]

netdev is allocated in bgmac_alloc() with devm_alloc_etherdev() and will
be auto released in ->remove and ->probe failure path. Using free_netdev()
in bgmac_enet_remove() leads to double free.

Fixes: 34a5102c3235 ("net: bgmac: allocate struct bgmac just once & don't copy it")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Link: https://lore.kernel.org/r/20221109150136.2991171-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 979af8e878e3..193722334d93 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1564,7 +1564,6 @@ void bgmac_enet_remove(struct bgmac *bgmac)
 	phy_disconnect(bgmac->net_dev->phydev);
 	netif_napi_del(&bgmac->napi);
 	bgmac_dma_free(bgmac);
-	free_netdev(bgmac->net_dev);
 }
 EXPORT_SYMBOL_GPL(bgmac_enet_remove);
 
-- 
2.35.1



