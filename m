Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0C3531B8A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239911AbiEWRNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbiEWRLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:11:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3464D6CF60;
        Mon, 23 May 2022 10:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71346B811FE;
        Mon, 23 May 2022 17:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB92CC385A9;
        Mon, 23 May 2022 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325819;
        bh=fiL5xmpicU4Z0vpo7J3ojLYAW+ShfyLlGTLoQTbPdiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQLxisfMlDNRftlifSr1yj+6J7OwfqpvnfsR+HKDhJjtHWcMi4pPIKfLWbo7Mbyot
         96ELnJwND1/4XH4vWvoXUyKLzP5sOokbnZzMi98fnnnIoCtUDY6WLWGjJm7btPB5te
         G3//p/AlOT2tzd7ptOapRoZeyNpkr0QbvUgBfmfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/44] net: macb: Increment rx bd head after allocating skb and buffer
Date:   Mon, 23 May 2022 19:05:05 +0200
Message-Id: <20220523165757.014597115@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
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
index d8e4842af055..50331b202f73 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -915,7 +915,6 @@ static void gem_rx_refill(struct macb_queue *queue)
 		/* Make hw descriptor updates visible to CPU */
 		rmb();
 
-		queue->rx_prepared_head++;
 		desc = macb_rx_desc(queue, entry);
 
 		if (!queue->rx_skbuff[entry]) {
@@ -954,6 +953,7 @@ static void gem_rx_refill(struct macb_queue *queue)
 			dma_wmb();
 			desc->addr &= ~MACB_BIT(RX_USED);
 		}
+		queue->rx_prepared_head++;
 	}
 
 	/* Make descriptor updates visible to hardware */
-- 
2.35.1



