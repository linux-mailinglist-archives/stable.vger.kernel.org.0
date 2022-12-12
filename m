Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68C664A0E2
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiLLNcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiLLNcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:32:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D06EBED
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:32:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C6061042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECCDC433D2;
        Mon, 12 Dec 2022 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851939;
        bh=nvqLlKmWfu69M03Q5g6PzFcX+TIxfSX0DqqDS/5aDsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkxhP2o1UlYwQVJrQB2wBTX3APIyE4Mmnyd9b3X71SxR1K49dIHtiKgqRvppDVWVD
         dXfWB4rLszpfn2GsXFbPRbpiAULLAQWMjul5vZfzeJTdoUzYZYpdqdKbsH7Ss4YtDw
         cxiGP7b/+6KaXRHpcQ/uTQTCVaB+dYsNno4xSrfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Jian <liujian56@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/123] net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
Date:   Mon, 12 Dec 2022 14:17:47 +0100
Message-Id: <20221212130931.421830299@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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
index 22bf914f2dbd..ea3e67cf5ffa 100644
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



