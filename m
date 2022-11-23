Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CDB635609
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbiKWJ0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237541AbiKWJZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:25:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9AB490A5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:24:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF68E61B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BDEC433D6;
        Wed, 23 Nov 2022 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195486;
        bh=9+L60O73mmTtw6dOEpOhJ4VuTITV0DJuXpKL0zV7WRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dsl4ukeMoaLawfwPX3iwZK3n0ID/VdQEoqkJFzEo9/d+T9+hr00Qx4oUC7Tg5R+m2
         4sDEr5F3i6Q+GwAEPrfzvxM9ZB9FzvnjzS3KxCWgohg0ekmQUBmSGl4nIBrMM14nZ1
         rZVBufUrNKoLgx9B98Xxv4B6/vx9itoTL9/osoUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/149] net: liquidio: release resources when liquidio driver open failed
Date:   Wed, 23 Nov 2022 09:50:49 +0100
Message-Id: <20221123084600.282217347@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 8979f428a4afc215e390006e5ea19fd4e22c7ca9 ]

When liquidio driver open failed, it doesn't release resources. Compile
tested only.

Fixes: 5b07aee11227 ("liquidio: MSIX support for CN23XX")
Fixes: dbc97bfd3918 ("net: liquidio: Add missing null pointer checks")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 34 ++++++++++++++-----
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index e0d18e917108..c4dc6e2ccd6b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1798,13 +1798,10 @@ static int liquidio_open(struct net_device *netdev)
 
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
-	if (OCTEON_CN23XX_PF(oct)) {
-		if (!oct->msix_on)
-			if (setup_tx_poll_fn(netdev))
-				return -1;
-	} else {
-		if (setup_tx_poll_fn(netdev))
-			return -1;
+	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on)) {
+		ret = setup_tx_poll_fn(netdev);
+		if (ret)
+			goto err_poll;
 	}
 
 	netif_tx_start_all_queues(netdev);
@@ -1817,7 +1814,7 @@ static int liquidio_open(struct net_device *netdev)
 	/* tell Octeon to start forwarding packets to host */
 	ret = send_rx_ctrl_cmd(lio, 1);
 	if (ret)
-		return ret;
+		goto err_rx_ctrl;
 
 	/* start periodical statistics fetch */
 	INIT_DELAYED_WORK(&lio->stats_wk.work, lio_fetch_stats);
@@ -1828,6 +1825,27 @@ static int liquidio_open(struct net_device *netdev)
 	dev_info(&oct->pci_dev->dev, "%s interface is opened\n",
 		 netdev->name);
 
+	return 0;
+
+err_rx_ctrl:
+	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on))
+		cleanup_tx_poll_fn(netdev);
+err_poll:
+	if (lio->ptp_clock) {
+		ptp_clock_unregister(lio->ptp_clock);
+		lio->ptp_clock = NULL;
+	}
+
+	if (oct->props[lio->ifidx].napi_enabled == 1) {
+		list_for_each_entry_safe(napi, n, &netdev->napi_list, dev_list)
+			napi_disable(napi);
+
+		oct->props[lio->ifidx].napi_enabled = 0;
+
+		if (OCTEON_CN23XX_PF(oct))
+			oct->droq[0]->ops.poll_mode = 0;
+	}
+
 	return ret;
 }
 
-- 
2.35.1



