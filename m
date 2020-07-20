Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326982271CE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgGTVhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgGTVhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CA0A20717;
        Mon, 20 Jul 2020 21:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281039;
        bh=7ZwDsZ4nwQfIt3+eLbx/QoRboCYzk9f4FbCuTpaHnAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2vVCrezLctDF648m20M1F3O2vRqkie9uIFPWeaqqFwc8FQ9HXir/+Sqeg+BzEvJQ
         wZ1jU4npi87KpOmTAFy+HXIndEVpPa1xNZgD1PDAsqqtVYMZGIvd6WBAi4saeecykY
         hbuH4ZdHEWyVr1fyTvr0/m7YBALP+SJp0UUDztAM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 03/40] dmaengine: ti: k3-udma: Fix cleanup code for alloc_chan_resources
Date:   Mon, 20 Jul 2020 17:36:38 -0400
Message-Id: <20200720213715.406997-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 5a9377cc7421b59b13c9b90b8dc0aca332a1c958 ]

Some of the earlier errors should be sent to the error cleanup path to
make sure that the uchan struct is reset, the dma_pool (if allocated) is
released and memcpy channel pairs are released in a correct way.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200527070612.636-2-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index a90e154b0ae0d..2e20fab413b94 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -1773,7 +1773,8 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 			dev_err(ud->ddev.dev,
 				"Descriptor pool allocation failed\n");
 			uc->use_dma_pool = false;
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_cleanup;
 		}
 	}
 
@@ -1793,16 +1794,18 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 
 		ret = udma_get_chan_pair(uc);
 		if (ret)
-			return ret;
+			goto err_cleanup;
 
 		ret = udma_alloc_tx_resources(uc);
-		if (ret)
-			return ret;
+		if (ret) {
+			udma_put_rchan(uc);
+			goto err_cleanup;
+		}
 
 		ret = udma_alloc_rx_resources(uc);
 		if (ret) {
 			udma_free_tx_resources(uc);
-			return ret;
+			goto err_cleanup;
 		}
 
 		uc->config.src_thread = ud->psil_base + uc->tchan->id;
@@ -1820,10 +1823,8 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 			uc->id);
 
 		ret = udma_alloc_tx_resources(uc);
-		if (ret) {
-			uc->config.remote_thread_id = -1;
-			return ret;
-		}
+		if (ret)
+			goto err_cleanup;
 
 		uc->config.src_thread = ud->psil_base + uc->tchan->id;
 		uc->config.dst_thread = uc->config.remote_thread_id;
@@ -1840,10 +1841,8 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 			uc->id);
 
 		ret = udma_alloc_rx_resources(uc);
-		if (ret) {
-			uc->config.remote_thread_id = -1;
-			return ret;
-		}
+		if (ret)
+			goto err_cleanup;
 
 		uc->config.src_thread = uc->config.remote_thread_id;
 		uc->config.dst_thread = (ud->psil_base + uc->rchan->id) |
@@ -1858,7 +1857,9 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 		/* Can not happen */
 		dev_err(uc->ud->dev, "%s: chan%d invalid direction (%u)\n",
 			__func__, uc->id, uc->config.dir);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_cleanup;
+
 	}
 
 	/* check if the channel configuration was successful */
@@ -1938,7 +1939,7 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 err_res_free:
 	udma_free_tx_resources(uc);
 	udma_free_rx_resources(uc);
-
+err_cleanup:
 	udma_reset_uchan(uc);
 
 	if (uc->use_dma_pool) {
-- 
2.25.1

