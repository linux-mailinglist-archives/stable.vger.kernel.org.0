Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123F46431A6
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiLETPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiLETPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:15:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320D122B1A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:15:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFBE4B81200
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B86BC433C1;
        Mon,  5 Dec 2022 19:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267698;
        bh=EsZgUXgm/Uz+tvsXpxGJmErMUTJL+fxhfFvzjTpnjIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2/VC5XcScrqRjfOhSsFt8E4H41fwL87j/iwjpivYe5g5Mvob4YIouV0TO0Db8XzE
         5RCZfY9bPRSSa6t4xoMYWmi5CmaFTRtfuj8iwuhUpFGa6uVZuRbmTQwShUDbK3ioKF
         m0sURgPJ7MDwp6wwphkXSCuyghSKlCqMQPi0kvak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/77] net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
Date:   Mon,  5 Dec 2022 20:09:02 +0100
Message-Id: <20221205190801.268442703@linuxfoundation.org>
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 2360f9b8c4e81d242d4cbf99d630a2fffa681fab ]

In pch_gbe_xmit_frame(), NETDEV_TX_OK will be returned whether
pch_gbe_tx_queue() sends data successfully or not, so pch_gbe_tx_queue()
needs to free skb before returning. But pch_gbe_tx_queue() returns without
freeing skb in case of dma_map_single() fails. Add dev_kfree_skb_any()
to fix it.

Fixes: 77555ee72282 ("net: Add Gigabit Ethernet driver of Topcliff PCH")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 22e63ae80a10..119220c79226 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1221,6 +1221,7 @@ static void pch_gbe_tx_queue(struct pch_gbe_adapter *adapter,
 		buffer_info->dma = 0;
 		buffer_info->time_stamp = 0;
 		tx_ring->next_to_use = ring_num;
+		dev_kfree_skb_any(skb);
 		return;
 	}
 	buffer_info->mapped = true;
-- 
2.35.1



