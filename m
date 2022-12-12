Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDB964A1D4
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiLLNqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiLLNpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:45:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D437BE3A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:45:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEBD561035
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5CEC433EF;
        Mon, 12 Dec 2022 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852715;
        bh=wtZL7sasUL2hS7oqWxB5F7eVv+Lov0E+Zu2b3VhwnUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7UwTTbKL0BBfZSB9EsdJxOszH8jU7XRkOfPeGKevPe9LsDkFOTSzJ3yPHBnZkNpd
         YL14oVWQfw22WVTDiCQNk6emrtAsvqBIgKE2l3LPq+j2wNG5wdH0VAmHI+ShfBjgSq
         XG9oE/ABMMQXi+LslJrFttxWZIZnPUPppxvGyNyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Jian <liujian56@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 137/157] net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
Date:   Mon, 12 Dec 2022 14:18:05 +0100
Message-Id: <20221212130940.570037420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 4640177049549de1a43e9bc49265f0cdfce08cfd ]

The skb is delivered to napi_gro_receive() which may free it, after
calling this, dereferencing skb may trigger use-after-free.

Fixes: 542ae60af24f ("net: hisilicon: Add Fast Ethernet MAC driver")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Link: https://lore.kernel.org/r/20221203094240.1240211-1-liujian56@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hisi_femac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 93846bace028..ce2571c16e43 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -283,7 +283,7 @@ static int hisi_femac_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = (pos + 1) % rxq->num;
 		if (rx_pkts_num >= limit)
-- 
2.35.1



