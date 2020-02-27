Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82009171D46
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389468AbgB0OTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731124AbgB0OS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 692662468F;
        Thu, 27 Feb 2020 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813136;
        bh=pl9p7NpwxVwE86wSMxeGVRBF3jUMxTbbyU0SDmJweOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFkbYh5TBU5Rs7xh1/lsWTHfbthjWSqWykaXZJrsZYbPCd43Nj5XKYrvHWNEvk+ca
         OdLU12dALyCnfEsrKwClLlNCfLol8pSOfYPobYXSguV0RNA+wTAhZSmdk4m3L7EX+W
         19vwcK+RxPwEIhLWBwHr70c0WjTUzEOec6hk7AgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Tobler <andreas.tobler@onway.ch>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 110/150] Revert "dmaengine: imx-sdma: Fix memory leak"
Date:   Thu, 27 Feb 2020 14:37:27 +0100
Message-Id: <20200227132249.006359879@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 7ac78dd1e0992fd6d2ae375cc0dd6456c632f605 which is
commit 02939cd167095f16328a1bd5cab5a90b550606df upstream.

Andreas writes:
	This patch breaks our imx6 board with the attached trace.
	Reverting the patch makes it boot again.

Reported-by: Andreas Tobler <andreas.tobler@onway.ch>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Robin Gong <yibin.gong@nxp.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/imx-sdma.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -760,8 +760,12 @@ static void sdma_start_desc(struct sdma_
 		return;
 	}
 	sdmac->desc = desc = to_sdma_desc(&vd->tx);
-
-	list_del(&vd->node);
+	/*
+	 * Do not delete the node in desc_issued list in cyclic mode, otherwise
+	 * the desc allocated will never be freed in vchan_dma_desc_free_list
+	 */
+	if (!(sdmac->flags & IMX_DMA_SG_LOOP))
+		list_del(&vd->node);
 
 	sdma->channel_control[channel].base_bd_ptr = desc->bd_phys;
 	sdma->channel_control[channel].current_bd_ptr = desc->bd_phys;
@@ -1067,6 +1071,7 @@ static void sdma_channel_terminate_work(
 
 	spin_lock_irqsave(&sdmac->vc.lock, flags);
 	vchan_get_all_descriptors(&sdmac->vc, &head);
+	sdmac->desc = NULL;
 	spin_unlock_irqrestore(&sdmac->vc.lock, flags);
 	vchan_dma_desc_free_list(&sdmac->vc, &head);
 	sdmac->context_loaded = false;
@@ -1075,19 +1080,11 @@ static void sdma_channel_terminate_work(
 static int sdma_disable_channel_async(struct dma_chan *chan)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
-	unsigned long flags;
-
-	spin_lock_irqsave(&sdmac->vc.lock, flags);
 
 	sdma_disable_channel(chan);
 
-	if (sdmac->desc) {
-		vchan_terminate_vdesc(&sdmac->desc->vd);
-		sdmac->desc = NULL;
+	if (sdmac->desc)
 		schedule_work(&sdmac->terminate_worker);
-	}
-
-	spin_unlock_irqrestore(&sdmac->vc.lock, flags);
 
 	return 0;
 }


