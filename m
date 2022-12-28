Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DE8657FE1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiL1QLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiL1QLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:11:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651D71AD81
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDDE60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FCEC433D2;
        Wed, 28 Dec 2022 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243760;
        bh=nwR9Ovz4JynGggE+sKXTNWZmXhBGq+cgUvUAiDiKd0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/i0dox4f29ZMklJ2+JiWy/wSuKT7eByUVq6VzVcdxAElUPj+URxsAUfEV+FggNgA
         ccysHHUtKhgTLj7dYpOAmyrDH0W+yAdbtS5iPvZQBeE5GAyMDI/lzos+24hnbh1A3D
         qc0tc70jrOAN6d2uP/W9veAEOHg9VuLgtyKFjPQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Roger Quadros <rogerq@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0551/1146] net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_ndo_slave_open()
Date:   Wed, 28 Dec 2022 15:34:50 +0100
Message-Id: <20221228144345.136851892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 5821504f5073983733465b8bc430049c4343bbd7 ]

Ensure pm_runtime_put() is issued in error path.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Link: https://lore.kernel.org/r/20221208105534.63709-1-rogerq@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b3b0ba842541..4ff1cfdb9730 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -564,13 +564,13 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	ret = netif_set_real_num_tx_queues(ndev, common->tx_ch_num);
 	if (ret) {
 		dev_err(common->dev, "cannot set real number of tx queues\n");
-		return ret;
+		goto runtime_put;
 	}
 
 	ret = netif_set_real_num_rx_queues(ndev, AM65_CPSW_MAX_RX_QUEUES);
 	if (ret) {
 		dev_err(common->dev, "cannot set real number of rx queues\n");
-		return ret;
+		goto runtime_put;
 	}
 
 	for (i = 0; i < common->tx_ch_num; i++)
@@ -578,7 +578,7 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 
 	ret = am65_cpsw_nuss_common_open(common);
 	if (ret)
-		return ret;
+		goto runtime_put;
 
 	common->usage_count++;
 
@@ -606,6 +606,10 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 error_cleanup:
 	am65_cpsw_nuss_ndo_slave_stop(ndev);
 	return ret;
+
+runtime_put:
+	pm_runtime_put(common->dev);
+	return ret;
 }
 
 static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
-- 
2.35.1



