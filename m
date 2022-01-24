Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29818499B48
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575017AbiAXVuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458142AbiAXVmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ADDC0612AC;
        Mon, 24 Jan 2022 12:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8030561383;
        Mon, 24 Jan 2022 20:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601C3C340E5;
        Mon, 24 Jan 2022 20:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056241;
        bh=YsZqgbWDddXl7uHko3GTTgZImh2guF9pFKYmHcmK/CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4FYkf9FDmr6BwoOn8LhhNVzx9vin8TmjfXZdMyD03jCAw8m8uBKy0F/UUH4o6upt
         Vy/MT229JKwrtNXyqO23OuJhAaQ2yL+xfE1CiIeBWA0KLpbsdzCRlaG+6bn+WBLbC5
         YxdOIq3nlYTJz3AhWXQhte3oagq3iy3k2jFPajNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/846] dmaengine: pxa/mmp: stop referencing config->slave_id
Date:   Mon, 24 Jan 2022 19:38:55 +0100
Message-Id: <20220124184115.395355279@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 89f1814ff27a0..26d11885c50ec 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -727,12 +727,6 @@ static int mmp_pdma_config_write(struct dma_chan *dchan,
 
 	chan->dir = direction;
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
index 4a2a796e348c1..aa6e552249ab9 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -910,13 +910,6 @@ static void pxad_get_config(struct pxad_chan *chan,
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



