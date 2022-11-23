Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6906355F7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbiKWJ0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237652AbiKWJZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:25:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B44E0C1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB2CC61B49
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF0CC433C1;
        Wed, 23 Nov 2022 09:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195476;
        bh=R5astfXp/esCPEfcdekGxcYhw4wFdzNjt4rXlUHWD2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4EPknseaxd+M+v8RL1M5sERkbH0BlSva2poPOOjmlPz/V3sHYf5Rspwzo9bMoVi4
         Nk89PXi7Xh9ECvSkd2Go2lv7/A1GyDjqsubw7onszBkOyw2V/IMwVtxdhBoKyJT4MM
         c0VcI74DOa4PVhAi/A/x5H3yyXrnceC0aYNR5J/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/149] net: bgmac: Drop free_netdev() from bgmac_enet_remove()
Date:   Wed, 23 Nov 2022 09:50:46 +0100
Message-Id: <20221123084600.193330322@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
index 6290d8bedc92..9960127f612e 100644
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



