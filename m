Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D179657F70
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiL1QEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiL1QEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58C719031
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67DE0B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4AEC433D2;
        Wed, 28 Dec 2022 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243483;
        bh=4mc9xX4HHfv/E+KDKnhH9GX0N48deLGM2D3VoZ2koAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTo0YmV3Ilx1c3p9Bh3T4sbNE4XI0nbZFyeqqAgVt8k1odJuS0+EVVwATwp5nfrB7
         hidPrkpBXb4G22Ok47WbNh0D12XUgphQN3h6pPL05Ec8gl7x9OHQf80gs6JsKPv5HD
         kXRvAjinWo4uQiS0/jH2NxsZQHfka9vNM1N+tczI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Roger Quadros <rogerq@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0534/1073] net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_ndo_slave_open()
Date:   Wed, 28 Dec 2022 15:35:22 +0100
Message-Id: <20221228144342.557158363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 47da11b9ac28..58678843d794 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -562,13 +562,13 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
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
@@ -576,7 +576,7 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 
 	ret = am65_cpsw_nuss_common_open(common, ndev->features);
 	if (ret)
-		return ret;
+		goto runtime_put;
 
 	common->usage_count++;
 
@@ -609,6 +609,10 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
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



