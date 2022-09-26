Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B18A5EA113
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiIZKpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiIZKnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:43:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEA41108;
        Mon, 26 Sep 2022 03:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12854B80926;
        Mon, 26 Sep 2022 10:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AF7C433D6;
        Mon, 26 Sep 2022 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187872;
        bh=+482eHK9KpYB34u8MBklS4BG1HDGc5smUSJunOxLLrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/UY64MWt96QwRVMud+F59eKMYgDfMBf07oXCDZvLkKALnQHlnWeS61DGa76CJ2Hs
         ylznxOVpvNjr8IS7Fo7z27fzls98qKmQmL1eFJOGC7VtxRHd0fy4No/uyq3fd5AmjN
         stDxMnUZqzp2jhkpngxf62WwaxakD2tQ23UxDB1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/120] net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD
Date:   Mon, 26 Sep 2022 12:12:01 +0200
Message-Id: <20220926100754.250068308@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <seanga2@gmail.com>

[ Upstream commit 878e2405710aacfeeb19364c300f38b7a9abfe8f ]

There is a separate receive path for small packets (under 256 bytes).
Instead of allocating a new dma-capable skb to be used for the next packet,
this path allocates a skb and copies the data into it (reusing the existing
sbk for the next packet). There are two bytes of junk data at the beginning
of every packet. I believe these are inserted in order to allow aligned DMA
and IP headers. We skip over them using skb_reserve. Before copying over
the data, we must use a barrier to ensure we see the whole packet. The
current code only synchronizes len bytes, starting from the beginning of
the packet, including the junk bytes. However, this leaves off the final
two bytes in the packet. Synchronize the whole packet.

To reproduce this problem, ping a HME with a payload size between 17 and
214

	$ ping -s 17 <hme_address>

which will complain rather loudly about the data mismatch. Small packets
(below 60 bytes on the wire) do not have this issue. I suspect this is
related to the padding added to increase the minimum packet size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220920235018.1675956-1-seanga2@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 3133f903279c..dbbbb6ea9f2b 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2064,9 +2064,9 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 
 			skb_reserve(copy_skb, 2);
 			skb_put(copy_skb, len);
-			dma_sync_single_for_cpu(hp->dma_dev, dma_addr, len, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(hp->dma_dev, dma_addr, len + 2, DMA_FROM_DEVICE);
 			skb_copy_from_linear_data(skb, copy_skb->data, len);
-			dma_sync_single_for_device(hp->dma_dev, dma_addr, len, DMA_FROM_DEVICE);
+			dma_sync_single_for_device(hp->dma_dev, dma_addr, len + 2, DMA_FROM_DEVICE);
 			/* Reuse original ring buffer. */
 			hme_write_rxd(hp, this,
 				      (RXFLAG_OWN|((RX_BUF_ALLOC_SIZE-RX_OFFSET)<<16)),
-- 
2.35.1



