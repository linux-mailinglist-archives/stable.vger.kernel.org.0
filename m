Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20BB148079
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbgAXLLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbgAXLLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:11:20 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B19E2071A;
        Fri, 24 Jan 2020 11:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864279;
        bh=xvwWUmBNjpW8jI4djRKxnSLiyzzUVkdt2qgoPNZyf+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUCMiwbPy57mUqA1XJ0EAGFBu2L0D+R15wmnSNO+rwHHQyKiyaK7ksKQM39CvCyby
         1kFQ+Bh1miAgMMQddlZvXLgzswTWRmexobfqqIEBlFJrGujvJARkYjbkFwzBye9tg6
         C0X76Sz06IWFxSrqevGaPYBTOYxXPTrIueP2NExg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 210/639] dmaengine: mv_xor: Use correct device for DMA API
Date:   Fri, 24 Jan 2020 10:26:20 +0100
Message-Id: <20200124093113.305666712@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 3e5daee5ecf314da33a890fabaa2404244cd2a36 ]

Using dma_dev->dev for mappings before it's assigned with the correct
device is unlikely to work as expected, and with future dma-direct
changes, passing a NULL device may end up crashing entirely. I don't
know enough about this hardware or the mv_xor_prep_dma_interrupt()
operation to implement the appropriate error-handling logic that would
have revealed those dma_map_single() calls failing on arm64 for as long
as the driver has been enabled there, but moving the assignment earlier
will at least make the current code operate as intended.

Fixes: 22843545b200 ("dma: mv_xor: Add support for DMA_INTERRUPT")
Reported-by: John David Anglin <dave.anglin@bell.net>
Tested-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Tested-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 969534c1a6c63..abc8d3e0487b8 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1059,6 +1059,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 		mv_chan->op_in_desc = XOR_MODE_IN_DESC;
 
 	dma_dev = &mv_chan->dmadev;
+	dma_dev->dev = &pdev->dev;
 	mv_chan->xordev = xordev;
 
 	/*
@@ -1091,7 +1092,6 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	dma_dev->device_free_chan_resources = mv_xor_free_chan_resources;
 	dma_dev->device_tx_status = mv_xor_status;
 	dma_dev->device_issue_pending = mv_xor_issue_pending;
-	dma_dev->dev = &pdev->dev;
 
 	/* set prep routines based on capability */
 	if (dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask))
-- 
2.20.1



