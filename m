Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610D6635822
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbiKWJvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbiKWJuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE27511C19
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD8ABB81EF3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA36C433C1;
        Wed, 23 Nov 2022 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196871;
        bh=Bq5L4pNNRaGlhMLATnaKYRLFGEpHfxpsawDQ9VtIHYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAQXZzxwuElWnkULCYifqOxgTLWGwK0FNw4NnwuTxy/daXA9RDpXn2zj+3EScCeZb
         ECCV2FmonPq5xybxtaJ6tafTYcV9EQ0N7b0z80kW1+UrUVl+YNWguqIpe0hhmHMed1
         1uu9myttKRThF04VDmvUEJRML1kpOK+JUKByvbhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 148/314] net: bgmac: Drop free_netdev() from bgmac_enet_remove()
Date:   Wed, 23 Nov 2022 09:49:53 +0100
Message-Id: <20221123084632.261685141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index 93580484a3f4..91c054eef701 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1568,7 +1568,6 @@ void bgmac_enet_remove(struct bgmac *bgmac)
 	phy_disconnect(bgmac->net_dev->phydev);
 	netif_napi_del(&bgmac->napi);
 	bgmac_dma_free(bgmac);
-	free_netdev(bgmac->net_dev);
 }
 EXPORT_SYMBOL_GPL(bgmac_enet_remove);
 
-- 
2.35.1



