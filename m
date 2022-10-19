Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4246F603D5B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiJSJAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiJSI7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74990580A6;
        Wed, 19 Oct 2022 01:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6323D61820;
        Wed, 19 Oct 2022 08:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78432C433C1;
        Wed, 19 Oct 2022 08:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169592;
        bh=eeSeoHdymaZAStSpJkEUImWkEipTe314hArLSoIZmUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVH1b+SjaBFPNaegwA/qVHzefePQPaDZIG79UeTUr1H8oG/z4XANTlEwqUx2IVCPt
         uNU/1H5ZCWwTkZrMHt/UuN2KkHFKmoWzI/WrrFy00uEk6dgxgCSvzuzEQJ6JBNvXJc
         TmgiT4oxw4sz+4ASG6r8PGgp917UdZtPCCc+jej0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 333/862] spi: Ensure that sg_table wont be used after being freed
Date:   Wed, 19 Oct 2022 10:27:00 +0200
Message-Id: <20221019083304.757698722@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 32c01e684af3..4b42f2302a8a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1097,6 +1097,8 @@ void spi_unmap_buf(struct spi_controller *ctlr, struct device *dev,
 	if (sgt->orig_nents) {
 		dma_unmap_sg(dev, sgt->sgl, sgt->orig_nents, dir);
 		sg_free_table(sgt);
+		sgt->orig_nents = 0;
+		sgt->nents = 0;
 	}
 }
 
-- 
2.35.1



