Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72F362808D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbiKNNGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237831AbiKNNGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:06:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DE32AC64
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:06:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64C0E61173
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DDDC433D6;
        Mon, 14 Nov 2022 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431205;
        bh=r1AEeOc2vhYyxOawqbiSE9gC+rtW6aTqa4JrE+XWZRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2ETNNYrGAQvP5eJHGieNernbuSCP+2+cBxrwfeOOFk6wcXjw47J1HQSdTIQejmve
         ex36tD6GiNeVlLi3SGTLXoalIH/NSmb4KMNAYfggS8flY8z+zUCIxqnOtVZIBK9c1E
         LKsykXqoSR7hnjNKcwaxTR1f6bHXZ1WiiXDfcPI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/190] ethernet: tundra: free irq when alloc ring failed in tsi108_open()
Date:   Mon, 14 Nov 2022 13:45:33 +0100
Message-Id: <20221114124503.447470593@linuxfoundation.org>
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

[ Upstream commit acce40037041f97baad18142bb253064491ebde3 ]

When alloc tx/rx ring failed in tsi108_open(), it doesn't free irq. Fix
it.

Fixes: 5e123b844a1c ("[PATCH] Add tsi108/9 On Chip Ethernet device driver support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109044016.126866-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 5251fc324221..a2fe0534c769 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1303,12 +1303,15 @@ static int tsi108_open(struct net_device *dev)
 
 	data->rxring = dma_alloc_coherent(&data->pdev->dev, rxring_size,
 					  &data->rxdma, GFP_KERNEL);
-	if (!data->rxring)
+	if (!data->rxring) {
+		free_irq(data->irq_num, dev);
 		return -ENOMEM;
+	}
 
 	data->txring = dma_alloc_coherent(&data->pdev->dev, txring_size,
 					  &data->txdma, GFP_KERNEL);
 	if (!data->txring) {
+		free_irq(data->irq_num, dev);
 		dma_free_coherent(&data->pdev->dev, rxring_size, data->rxring,
 				    data->rxdma);
 		return -ENOMEM;
-- 
2.35.1



