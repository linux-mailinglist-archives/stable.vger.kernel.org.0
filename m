Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE21593B8D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347022AbiHOU1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347747AbiHOU0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:26:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BF79DB5E;
        Mon, 15 Aug 2022 12:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AED52B810A2;
        Mon, 15 Aug 2022 19:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170B0C433C1;
        Mon, 15 Aug 2022 19:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590201;
        bh=DnYtPbjqI8A7s1DpXgqq9UjiYSjr7NuAbLDSButeqbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHbDQoQc7G5tqvgHzKul6LLRAxCgTUXnVTPU8Gs0/uhQvQaD9RnwvDaMEDkpj+1hd
         emTsUQIQGjXkHZQGFtuE7RHWhzMnbEy5hWxyw6IyIvKvU+6rrvtIuTe1G/fjG4ucDr
         JKWlKNdyju75seYCADb9Mn3ADQs9vrRbojd6INfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0184/1095] spi: spi-rspi: Fix PIO fallback on RZ platforms
Date:   Mon, 15 Aug 2022 19:53:03 +0200
Message-Id: <20220815180437.252014191@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit b620aa3a7be346f04ae7789b165937615c6ee8d3 ]

RSPI IP on RZ/{A, G2L} SoC's has the same signal for both interrupt
and DMA transfer request. Setting DMARS register for DMA transfer
makes the signal to work as a DMA transfer request signal and
subsequent interrupt requests to the interrupt controller
are masked.

PIO fallback does not work as interrupt signal is disabled.

This patch fixes this issue by re-enabling the interrupts by
calling dmaengine_synchronize().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220721143449.879257-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 7a014eeec2d0..411b1307b7fd 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -613,6 +613,10 @@ static int rspi_dma_transfer(struct rspi_data *rspi, struct sg_table *tx,
 					       rspi->dma_callbacked, HZ);
 	if (ret > 0 && rspi->dma_callbacked) {
 		ret = 0;
+		if (tx)
+			dmaengine_synchronize(rspi->ctlr->dma_tx);
+		if (rx)
+			dmaengine_synchronize(rspi->ctlr->dma_rx);
 	} else {
 		if (!ret) {
 			dev_err(&rspi->ctlr->dev, "DMA timeout\n");
-- 
2.35.1



