Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1846D6431D9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLETUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiLETUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:20:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042AD29CBA
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:16:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 795B161309
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC39C433C1;
        Mon,  5 Dec 2022 19:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267790;
        bh=G2uRRcro1qgz8hUm6Yt8P22bVtPB3nqqlqN1Ae4smrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe4dfYodlPMmKs4uf8KLWSNVyxRUfUZnetqHijiXbUWcQ1Mx0v3Cv7o2maolvvYGo
         +Bb3z5LidqNLbM63TbNsaT8KXUXjo3Oaxv5taZO5ZdJoI9Gc34tUBJ9D0AQSy9DhBn
         jp+WY0JSejdzkf8FP53dBJ1mIJrqCWMd6GWragYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 53/77] net: hsr: Fix potential use-after-free
Date:   Mon,  5 Dec 2022 20:09:44 +0100
Message-Id: <20221205190802.744089130@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 7e177d32442b7ed08a9fa61b61724abc548cb248 ]

The skb is delivered to netif_rx() which may free it, after calling this,
dereferencing skb may trigger use-after-free.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20221125075724.27912-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 04b5450c5a55..adfb49760678 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -207,17 +207,18 @@ static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
 			       struct hsr_node *node_src)
 {
 	bool was_multicast_frame;
-	int res;
+	int res, recv_len;
 
 	was_multicast_frame = (skb->pkt_type == PACKET_MULTICAST);
 	hsr_addr_subst_source(node_src, skb);
 	skb_pull(skb, ETH_HLEN);
+	recv_len = skb->len;
 	res = netif_rx(skb);
 	if (res == NET_RX_DROP) {
 		dev->stats.rx_dropped++;
 	} else {
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += recv_len;
 		if (was_multicast_frame)
 			dev->stats.multicast++;
 	}
-- 
2.35.1



