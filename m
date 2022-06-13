Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D7E548FBE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355156AbiFMLkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355489AbiFMLjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C52C10F;
        Mon, 13 Jun 2022 03:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D37AB80D3C;
        Mon, 13 Jun 2022 10:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0902EC34114;
        Mon, 13 Jun 2022 10:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117317;
        bh=zHWqe6zjLUR4kWXXfBNVDYv3427Js0IldgUO8MhfWOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2g0EbulqEdE4Hx2h75G412+cmbzx9mejT5puH+0JtG5r5Kkgnl7Z4QjuIwRhpzl6
         iRU7pAnuTbDsB1vIW9g5HakcEsM+k0iW9vdTwpSrd6ByKSU4/y68b0nGDIY85uRyPm
         Zn4Na6pkq5M6gO4xCUG8hmLRUAAx6lAeGG+aUCC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 344/411] dmaengine: zynqmp_dma: In struct zynqmp_dma_chan fix desc_size data type
Date:   Mon, 13 Jun 2022 12:10:17 +0200
Message-Id: <20220613094939.024289363@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

[ Upstream commit f9a9f43a62a04ec3183fb0da9226c7706eed0115 ]

In zynqmp_dma_alloc/free_chan_resources functions there is a
potential overflow in the below expressions.

dma_alloc_coherent(chan->dev, (2 * chan->desc_size *
		   ZYNQMP_DMA_NUM_DESCS),
		   &chan->desc_pool_p, GFP_KERNEL);

dma_free_coherent(chan->dev,(2 * ZYNQMP_DMA_DESC_SIZE(chan) *
                 ZYNQMP_DMA_NUM_DESCS),
                chan->desc_pool_v, chan->desc_pool_p);

The arguments desc_size and ZYNQMP_DMA_NUM_DESCS were 32 bit. Though
this overflow condition is not observed but it is a potential problem
in the case of 32-bit multiplication. Hence fix it by changing the
desc_size data type to size_t.

In addition to coverity fix it also reuse ZYNQMP_DMA_DESC_SIZE macro in
dma_alloc_coherent API argument.

Addresses-Coverity: Event overflow_before_widen.
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1652166762-18317-2-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 84009c5e0f33..b61d0c79dffb 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -232,7 +232,7 @@ struct zynqmp_dma_chan {
 	bool is_dmacoherent;
 	struct tasklet_struct tasklet;
 	bool idle;
-	u32 desc_size;
+	size_t desc_size;
 	bool err;
 	u32 bus_width;
 	u32 src_burst_len;
@@ -489,7 +489,8 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 	}
 
 	chan->desc_pool_v = dma_alloc_coherent(chan->dev,
-					       (2 * chan->desc_size * ZYNQMP_DMA_NUM_DESCS),
+					       (2 * ZYNQMP_DMA_DESC_SIZE(chan) *
+					       ZYNQMP_DMA_NUM_DESCS),
 					       &chan->desc_pool_p, GFP_KERNEL);
 	if (!chan->desc_pool_v)
 		return -ENOMEM;
-- 
2.35.1



