Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2685956FBC3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiGKJe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiGKJe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:34:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A3426C;
        Mon, 11 Jul 2022 02:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55F6661227;
        Mon, 11 Jul 2022 09:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6464CC34115;
        Mon, 11 Jul 2022 09:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531108;
        bh=tZ7qhXzqW2g6UfpzLi8EA29W6soXunuN4wWkkPK9Bx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFQdwz5UScm5UvfgtZiF61Cw9CyqDPpBjnzl4vRQUD0wZecRYEnKowlC2/M11fGdL
         pXd8Tak3nK9HZUrP6nuFLBQVgqo8GT62Ce5EiQYVN5AIednIh5laBoce3M1tW481vi
         38twM5kcS6P4Nl+sJvuFwI1a47vYk6WuhKRpPUpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.18 099/112] dmaengine: imx-sdma: only restart cyclic channel when enabled
Date:   Mon, 11 Jul 2022 11:07:39 +0200
Message-Id: <20220711090552.380949774@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 09f7b80fac3e588b282ad26aabd7336d7d293efd upstream.

An interrupt for a channel might be pending even after struct
dma_device::device_terminate_all has been called. In that case the
recently introduced warning message "restart cyclic channel..." triggers
and the channel will be restarted. This is not desired as the channel
has just been stopped. Only restart the channel when we still have a
descriptor set for it (which will be set to NULL in
sdma_terminate_all()).

Fixes: 5b215c28b9235 ("dmaengine: imx-sdma: restart cyclic channel if needed")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20220617115042.4004062-1-s.hauer@pengutronix.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/imx-sdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -872,7 +872,7 @@ static void sdma_update_channel_loop(str
 	 * SDMA stops cyclic channel when DMA request triggers a channel and no SDMA
 	 * owned buffer is available (i.e. BD_DONE was set too late).
 	 */
-	if (!is_sdma_channel_enabled(sdmac->sdma, sdmac->channel)) {
+	if (sdmac->desc && !is_sdma_channel_enabled(sdmac->sdma, sdmac->channel)) {
 		dev_warn(sdmac->sdma->dev, "restart cyclic channel %d\n", sdmac->channel);
 		sdma_enable_channel(sdmac->sdma, sdmac->channel);
 	}


