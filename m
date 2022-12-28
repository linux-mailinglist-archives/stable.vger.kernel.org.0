Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB5658398
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbiL1QtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbiL1Qs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:48:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923381EC48
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:44:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ABE96155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41672C433D2;
        Wed, 28 Dec 2022 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245854;
        bh=C3RC0Yrm4veCKkUtVQf7IfSeqqzrNdIAO8x8D1o2zLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajQzyrVJRIiVZaQml7UJzTdezL4K/aczqAxz3F4/yvMHzKXMm9E/5cEA+LGqjykOX
         k4ixwjg594yxHZ7i4N7JW8CwP0Ohvu3H73Mutwu6Klrb2OwUdYTzS6R4YOEBgYzmIF
         qD37S8BiDon9C3t8pvYm+c68Ccfp8gNRMW6Vr8l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <Shenwei.wang@nxp.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0936/1146] net: fec: check the return value of build_skb()
Date:   Wed, 28 Dec 2022 15:41:15 +0100
Message-Id: <20221228144355.724466461@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 19e72b064fc32cd58f6fc0b1eb64ac2e4f770e76 ]

The build_skb might return a null pointer but there is no check on the
return value in the fec_enet_rx_queue(). So a null pointer dereference
might occur. To avoid this, we check the return value of build_skb. If
the return value is a null pointer, the driver will recycle the page and
update the statistic of ndev. Then jump to rx_processing_done to clear
the status flags of the BD so that the hardware can recycle the BD.

Fixes: 95698ff6177b ("net: fec: using page pool to manage RX buffers")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Shenwei Wang <Shenwei.wang@nxp.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20221219022755.1047573-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 23e1a94b9ce4..f250b0df27fb 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1642,6 +1642,14 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 * bridging applications.
 		 */
 		skb = build_skb(page_address(page), PAGE_SIZE);
+		if (unlikely(!skb)) {
+			page_pool_recycle_direct(rxq->page_pool, page);
+			ndev->stats.rx_dropped++;
+
+			netdev_err_once(ndev, "build_skb failed!\n");
+			goto rx_processing_done;
+		}
+
 		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
 		skb_put(skb, pkt_len - 4);
 		skb_mark_for_recycle(skb);
-- 
2.35.1



