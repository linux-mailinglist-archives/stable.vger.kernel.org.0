Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A844498C6E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbiAXTWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:22:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48328 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345698AbiAXTT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:19:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC7AF6121F;
        Mon, 24 Jan 2022 19:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB4CC340E8;
        Mon, 24 Jan 2022 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051967;
        bh=/0GNHOcGMKJ+IUCw8BtEQJCDlBLL5fjf7fhxbTN3nVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/BzC18JXSyHdjD2yZZyXgz0pNABfzlS+/5YS1eRkSk4RT+ENgYmZ3QAU1jA62Tpy
         s6RjD6zssOu30g75BHSW0ZfXtqd3ZdGGFRZD4Ho2b+jIG+/Txa8rerX6P5vX9l/C2i
         3cPerwlDTacX95LTitOUoAKAMM+6PgkRAOMdtqvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/239] dmaengine: pxa/mmp: stop referencing config->slave_id
Date:   Mon, 24 Jan 2022 19:42:30 +0100
Message-Id: <20220124183946.660918740@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index b31c28b67ad3e..c54986902b9d2 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -960,13 +960,6 @@ static void pxad_get_config(struct pxad_chan *chan,
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



