Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAFE60B1E7
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiJXQkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbiJXQjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:39:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A656156BB5;
        Mon, 24 Oct 2022 08:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD092B81996;
        Mon, 24 Oct 2022 12:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C91C433D7;
        Mon, 24 Oct 2022 12:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615387;
        bh=cNB5yuiLH6ZtpQ2wUOYKIZtk5Q/9DzwbtN7X7TPvm3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDrST+/mCfNt0B3LL877g6ZEfU7ryWhc8eO2DwdX6jFC4CXJGumCOCZvh8FNT3Iiy
         7FHbdcVdt6R/oJBiKyzh08mQrJlbQez1icbAWh1SnmX5tPORA5hPbzLnY6JhE39/v2
         bG1l6UWGDsOzKQa90JToCekKTmNznMK5v96BigvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/530] spi: Ensure that sg_table wont be used after being freed
Date:   Mon, 24 Oct 2022 13:29:04 +0200
Message-Id: <20221024113054.107478506@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 8e9204cddcc3fea9affcfa411715ba4f66e97587 ]

SPI code checks for non-zero sgt->orig_nents to determine if the buffer
has been DMA-mapped. Ensure that sg_table is really zeroed after free to
avoid potential NULL pointer dereference if the given SPI xfer object is
reused again without being DMA-mapped.

Fixes: 0c17ba73c08f ("spi: Fix cache corruption due to DMA/PIO overlap")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20220930113408.19720-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 556d65af5e23..06dd1be54925 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1007,6 +1007,8 @@ void spi_unmap_buf(struct spi_controller *ctlr, struct device *dev,
 	if (sgt->orig_nents) {
 		dma_unmap_sg(dev, sgt->sgl, sgt->orig_nents, dir);
 		sg_free_table(sgt);
+		sgt->orig_nents = 0;
+		sgt->nents = 0;
 	}
 }
 
-- 
2.35.1



