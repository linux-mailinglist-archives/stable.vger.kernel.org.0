Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3509522F119
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbgG0OXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731997AbgG0OXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C18322070A;
        Mon, 27 Jul 2020 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859780;
        bh=9YDQ//FKRdwgXd+87UsMSe+Y6OxUfMAleBfFYEuz80c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DknD6UfPMITxxEHgQ6DhayQNGXlGsiKy9F3yYOWP18EmjZ0GDfaxAZEOpMhS+pXSu
         hMpkbjWx+DftUxdIWJ+xDPc1fYZyktd3Hr13E0cFh9EtizcO79NG8QfKPMvDXtNTKy
         lk5b0z1EqUzDokys4m2hUDLKJe2TR5z5ccU0n1Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 102/179] dmaengine: ti: k3-udma: Fix cleanup code for alloc_chan_resources
Date:   Mon, 27 Jul 2020 16:04:37 +0200
Message-Id: <20200727134937.621458979@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7cab23fe5c73f..35f54a1af29d8 100644
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
@@ -1936,7 +1937,7 @@ err_psi_free:
 err_res_free:
 	udma_free_tx_resources(uc);
 	udma_free_rx_resources(uc);
-
+err_cleanup:
 	udma_reset_uchan(uc);
 
 	if (uc->use_dma_pool) {
-- 
2.25.1



