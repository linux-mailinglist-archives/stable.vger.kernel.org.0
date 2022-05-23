Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17EC531BCD
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbiEWRea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbiEWRc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57C972226;
        Mon, 23 May 2022 10:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C373660919;
        Mon, 23 May 2022 17:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B9DC385A9;
        Mon, 23 May 2022 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326857;
        bh=vEwnCoTV8sEf0purtv7I8tz1p6UatV09CLsl4plOqKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcmZ9j3cXq/sADm+DPzjaP3x1JyFeVPV0dvgV6BT47Mllam7h1kL76oDSk3vdKkG4
         mchgHLVqrAOgfikdiAtGavxV4VHEQJmhRKklXXdjAqSzorAuKCHHQFZG6TAOkuolmc
         smFkORBJYUxgk19aXxyEsDbHU7y63WZqObQnxWMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 080/158] net: macb: Increment rx bd head after allocating skb and buffer
Date:   Mon, 23 May 2022 19:03:57 +0200
Message-Id: <20220523165844.315462395@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit 9500acc631dbb8b73166e25700e656b11f6007b6 ]

In gem_rx_refill rx_prepared_head is incremented at the beginning of
the while loop preparing the skb and data buffers. If the skb or data
buffer allocation fails, this BD will be unusable BDs until the head
loops back to the same BD (and obviously buffer allocation succeeds).
In the unlikely event that there's a string of allocation failures,
there will be an equal number of unusable BDs and an inconsistent RX
BD chain. Hence increment the head at the end of the while loop to be
clean.

Fixes: 4df95131ea80 ("net/macb: change RX path for GEM")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220512171900.32593-1-harini.katakam@xilinx.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c4f4b13ac469..c1100af5666b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1217,7 +1217,6 @@ static void gem_rx_refill(struct macb_queue *queue)
 		/* Make hw descriptor updates visible to CPU */
 		rmb();
 
-		queue->rx_prepared_head++;
 		desc = macb_rx_desc(queue, entry);
 
 		if (!queue->rx_skbuff[entry]) {
@@ -1256,6 +1255,7 @@ static void gem_rx_refill(struct macb_queue *queue)
 			dma_wmb();
 			desc->addr &= ~MACB_BIT(RX_USED);
 		}
+		queue->rx_prepared_head++;
 	}
 
 	/* Make descriptor updates visible to hardware */
-- 
2.35.1



