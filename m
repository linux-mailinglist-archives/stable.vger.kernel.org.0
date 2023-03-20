Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA37C6C1909
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjCTPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbjCTP3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A120A01
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E2B3615AE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBE6C433EF;
        Mon, 20 Mar 2023 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325751;
        bh=sWI+4MtyUPdgD8mkYTVW8jmXJsM3HsMsedSvU+Rvyec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6OdCfPTOP8hg+zrsF9IkFQ2BJWOMMK7NdUoGdluPzYanF/1o5N1I7Ky9a8Ri4wIG
         w4zS1fvDqM8Zr92/EL0u6ZTjyfo1zu1Cbc+GADGkMjRmX2/nI5nzTHiHqOOxst+veg
         OfK3BLvbfUX6aEjP5gNMpFcnMggtnrnIdN+PPqN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 095/211] net: renesas: rswitch: Fix the output value of quote from rswitch_rx()
Date:   Mon, 20 Mar 2023 15:53:50 +0100
Message-Id: <20230320145517.280329328@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit e05bb97d9c9dd4ba5739a27921044c935a7fb3be ]

If the RX descriptor doesn't have any data, the output value of quote
from rswitch_rx() will be increased unexpectedily. So, fix it.

Reported-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 847b1f161fc66..5118117a17eef 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -673,13 +673,14 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 	u16 pkt_len;
 	u32 get_ts;
 
+	if (*quota <= 0)
+		return true;
+
 	boguscnt = min_t(int, gq->ring_size, *quota);
 	limit = boguscnt;
 
 	desc = &gq->rx_ring[gq->cur];
 	while ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY) {
-		if (--boguscnt < 0)
-			break;
 		dma_rmb();
 		pkt_len = le16_to_cpu(desc->desc.info_ds) & RX_DS;
 		skb = gq->skbs[gq->cur];
@@ -705,6 +706,9 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 
 		gq->cur = rswitch_next_queue_index(gq, true, 1);
 		desc = &gq->rx_ring[gq->cur];
+
+		if (--boguscnt <= 0)
+			break;
 	}
 
 	num = rswitch_get_num_cur_queues(gq);
@@ -716,7 +720,7 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 		goto err;
 	gq->dirty = rswitch_next_queue_index(gq, false, num);
 
-	*quota -= limit - (++boguscnt);
+	*quota -= limit - boguscnt;
 
 	return boguscnt <= 0;
 
-- 
2.39.2



