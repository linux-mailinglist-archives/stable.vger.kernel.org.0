Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E7D6948F7
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBMOzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjBMOy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117B25FCC
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A12066111D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6350C433EF;
        Mon, 13 Feb 2023 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300091;
        bh=4ykHoiT9tNymHPXIz7UHsDZUjBpEp5/AJmCeaCAAzsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKS2vTr4KSuq8wfBgwfqZbKvsN7weze6j2cjrQ3yRFGgJ4G8cOfMPcc0lG9nAQspO
         mQWJziQrsW9zPFRGV7yRbudnV6L5gDeJoUbxzbyYLNveQnUxklyX5WSAfevpYNu4Gr
         rsZmZ1Qnr5yhsyWy1JFJnV4mlC4diDCYf1Ic8CfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/114] net: ethernet: mtk_eth_soc: fix wrong parameters order in __xdp_rxq_info_reg()
Date:   Mon, 13 Feb 2023 15:48:10 +0100
Message-Id: <20230213144745.068798865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit c966153d120222cd4e85e1e1601584d7d4d91dcb ]

Parameters 'queue_index' and 'napi_id' are passed in a swapped order.
Fix it here.

Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 9aa1892a609c7..53ee9dea66388 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1495,8 +1495,8 @@ static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
 	if (IS_ERR(pp))
 		return pp;
 
-	err = __xdp_rxq_info_reg(xdp_q, &eth->dummy_dev, eth->rx_napi.napi_id,
-				 id, PAGE_SIZE);
+	err = __xdp_rxq_info_reg(xdp_q, &eth->dummy_dev, id,
+				 eth->rx_napi.napi_id, PAGE_SIZE);
 	if (err < 0)
 		goto err_free_pp;
 
-- 
2.39.0



