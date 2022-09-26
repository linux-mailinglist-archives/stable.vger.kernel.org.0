Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7F35E9F54
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiIZKZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbiIZKWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:22:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BFFE4F;
        Mon, 26 Sep 2022 03:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0BB2B8091E;
        Mon, 26 Sep 2022 10:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F95C433B5;
        Mon, 26 Sep 2022 10:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187392;
        bh=yTJOQXIOd9t2t0IcQE8ZImyPFxZw2rAzWKIE8kO3jmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3TuzXEtk9m/JFB9Zin3NKQprcikZ5JgfoeqApFQ92F5HdWf9+XIyFb3ImQ63X2O+
         NwhwjHiUfaCEweWWfFyqEz42HzRaQq4neKq4drc6Ta+xYgZqEyDaFx/nNRbcU/gnC5
         vHa3n6iPRwlSfeeRfI+HQwqbb8m6nk2m1MpNtRJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/40] net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD
Date:   Mon, 26 Sep 2022 12:12:02 +0200
Message-Id: <20220926100739.622384540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
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
index 7522f277e912..bfa8c0424913 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2065,9 +2065,9 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 
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



