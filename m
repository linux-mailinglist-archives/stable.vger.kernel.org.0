Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D45B4989F8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344350AbiAXS7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:59:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55398 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344445AbiAXS52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:57:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E387B8121A;
        Mon, 24 Jan 2022 18:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1610AC340E7;
        Mon, 24 Jan 2022 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050644;
        bh=/MjpDm1YZmvmKSGToVy1rcMTPnzaAsDqT6sqqBJs1SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr3txjuoZB73JUQcKorV1od4/MucA7vQeEpdZdbUPrW4yWpiMRs9/TerwIm0yrPKB
         MaGe6n5H8gL7v+RMivpIm3XsoKzySalyIv/UIbRIOGCiazpkCZjOUddUX30Q6EFL10
         Mp3VrQTfX3JvqjmcSlulkj22cSaYcQwaPoMmZ7kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/157] dmaengine: pxa/mmp: stop referencing config->slave_id
Date:   Mon, 24 Jan 2022 19:42:37 +0100
Message-Id: <20220124183934.915131207@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 134c37fa250a87a7e77c80a7c59ae16c462e46e0 ]

The last driver referencing the slave_id on Marvell PXA and MMP platforms
was the SPI driver, but this stopped doing so a long time ago, so the
TODO from the earlier patch can no be removed.

Fixes: b729bf34535e ("spi/pxa2xx: Don't use slave_id of dma_slave_config")
Fixes: 13b3006b8ebd ("dma: mmp_pdma: add filter function")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20211122222203.4103644-7-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_pdma.c | 6 ------
 drivers/dma/pxa_dma.c  | 7 -------
 2 files changed, 13 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index eb3a1f42ab065..e8b2d3e31de80 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -722,12 +722,6 @@ static int mmp_pdma_config(struct dma_chan *dchan,
 
 	chan->dir = cfg->direction;
 	chan->dev_addr = addr;
-	/* FIXME: drivers should be ported over to use the filter
-	 * function. Once that's done, the following two lines can
-	 * be removed.
-	 */
-	if (cfg->slave_id)
-		chan->drcmr = cfg->slave_id;
 
 	return 0;
 }
diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index 3f56f9ca44824..5bd1ade187d3f 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -975,13 +975,6 @@ static void pxad_get_config(struct pxad_chan *chan,
 		*dcmd |= PXA_DCMD_BURST16;
 	else if (maxburst == 32)
 		*dcmd |= PXA_DCMD_BURST32;
-
-	/* FIXME: drivers should be ported over to use the filter
-	 * function. Once that's done, the following two lines can
-	 * be removed.
-	 */
-	if (chan->cfg.slave_id)
-		chan->drcmr = chan->cfg.slave_id;
 }
 
 static struct dma_async_tx_descriptor *
-- 
2.34.1



