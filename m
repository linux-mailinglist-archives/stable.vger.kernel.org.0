Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0A6111E25
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfLCW6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbfLCW6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E0C2053B;
        Tue,  3 Dec 2019 22:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413899;
        bh=oU25JYGVk3YLHzHCGmBf/zGRZoUGL5FBoo8Zo7Ay7JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ft/dv0LK553xVLdsZKJubYbR29RYsNBZsWEdL5Kvi1ka3AEM0JVPzxav9ViakQ91u
         olnaTBVD5oFe4WnmykZKBI6uDMI/u1vqrLKOPRS9GttABe0bF5ELhSngnmZRD3N9DK
         0U+M1l65LBBdJ+J6ULx8cVMIFghUV9fGul3KRi1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 306/321] media: stm32-dcmi: fix DMA corruption when stopping streaming
Date:   Tue,  3 Dec 2019 23:36:12 +0100
Message-Id: <20191203223443.065564186@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugues Fruchet <hugues.fruchet@st.com>

commit b3ce6f6ff3c260ee53b0f2236e5fd950d46957da upstream.

Avoid call of dmaengine_terminate_all() between
dmaengine_prep_slave_single() and dmaengine_submit() by locking
the whole DMA submission sequence.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/stm32/stm32-dcmi.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -164,6 +164,9 @@ struct stm32_dcmi {
 	int				errors_count;
 	int				overrun_count;
 	int				buffers_count;
+
+	/* Ensure DMA operations atomicity */
+	struct mutex			dma_lock;
 };
 
 static inline struct stm32_dcmi *notifier_to_dcmi(struct v4l2_async_notifier *n)
@@ -314,6 +317,13 @@ static int dcmi_start_dma(struct stm32_d
 		return ret;
 	}
 
+	/*
+	 * Avoid call of dmaengine_terminate_all() between
+	 * dmaengine_prep_slave_single() and dmaengine_submit()
+	 * by locking the whole DMA submission sequence
+	 */
+	mutex_lock(&dcmi->dma_lock);
+
 	/* Prepare a DMA transaction */
 	desc = dmaengine_prep_slave_single(dcmi->dma_chan, buf->paddr,
 					   buf->size,
@@ -322,6 +332,7 @@ static int dcmi_start_dma(struct stm32_d
 	if (!desc) {
 		dev_err(dcmi->dev, "%s: DMA dmaengine_prep_slave_single failed for buffer phy=%pad size=%zu\n",
 			__func__, &buf->paddr, buf->size);
+		mutex_unlock(&dcmi->dma_lock);
 		return -EINVAL;
 	}
 
@@ -333,9 +344,12 @@ static int dcmi_start_dma(struct stm32_d
 	dcmi->dma_cookie = dmaengine_submit(desc);
 	if (dma_submit_error(dcmi->dma_cookie)) {
 		dev_err(dcmi->dev, "%s: DMA submission failed\n", __func__);
+		mutex_unlock(&dcmi->dma_lock);
 		return -ENXIO;
 	}
 
+	mutex_unlock(&dcmi->dma_lock);
+
 	dma_async_issue_pending(dcmi->dma_chan);
 
 	return 0;
@@ -717,7 +731,9 @@ static void dcmi_stop_streaming(struct v
 	spin_unlock_irq(&dcmi->irqlock);
 
 	/* Stop all pending DMA operations */
+	mutex_lock(&dcmi->dma_lock);
 	dmaengine_terminate_all(dcmi->dma_chan);
+	mutex_unlock(&dcmi->dma_lock);
 
 	pm_runtime_put(dcmi->dev);
 
@@ -1719,6 +1735,7 @@ static int dcmi_probe(struct platform_de
 
 	spin_lock_init(&dcmi->irqlock);
 	mutex_init(&dcmi->lock);
+	mutex_init(&dcmi->dma_lock);
 	init_completion(&dcmi->complete);
 	INIT_LIST_HEAD(&dcmi->buffers);
 


