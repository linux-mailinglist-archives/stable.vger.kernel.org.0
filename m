Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4DB1133D8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbfLDSJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731013AbfLDSJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:09:08 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3566E206DF;
        Wed,  4 Dec 2019 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482947;
        bh=M8+BzG2H54XkI/BcXHzPmQgzhfr+jLlYukWSbZPKgHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15VXrxCt66qzt6O6csgVmlFoX32vmE4TUWLyL8H9vn/0WwlI11R1U6JiCAFWE/BrT
         3DVlUJbE5diO5IDcx2M0siPl0WKX5Dmgy1oFSZ2rRQ1hJR5ww2UfB1MONH2vCYVjvg
         uRcWWWw1+G/N6Yuw6fZLTRJzZ5nqulrn+45mam4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugues Fruchet <hugues.fruchet@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 200/209] media: stm32-dcmi: fix DMA corruption when stopping streaming
Date:   Wed,  4 Dec 2019 18:56:52 +0100
Message-Id: <20191204175337.255517758@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
@@ -161,6 +161,9 @@ struct stm32_dcmi {
 	u32				misr;
 	int				errors_count;
 	int				buffers_count;
+
+	/* Ensure DMA operations atomicity */
+	struct mutex			dma_lock;
 };
 
 static inline struct stm32_dcmi *notifier_to_dcmi(struct v4l2_async_notifier *n)
@@ -291,6 +294,13 @@ static int dcmi_start_dma(struct stm32_d
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
@@ -298,6 +308,7 @@ static int dcmi_start_dma(struct stm32_d
 	if (!desc) {
 		dev_err(dcmi->dev, "%s: DMA dmaengine_prep_slave_single failed for buffer size %zu\n",
 			__func__, buf->size);
+		mutex_unlock(&dcmi->dma_lock);
 		return -EINVAL;
 	}
 
@@ -309,9 +320,12 @@ static int dcmi_start_dma(struct stm32_d
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
@@ -690,7 +704,9 @@ static void dcmi_stop_streaming(struct v
 	spin_unlock_irq(&dcmi->irqlock);
 
 	/* Stop all pending DMA operations */
+	mutex_lock(&dcmi->dma_lock);
 	dmaengine_terminate_all(dcmi->dma_chan);
+	mutex_unlock(&dcmi->dma_lock);
 
 	clk_disable(dcmi->mclk);
 
@@ -1662,6 +1678,7 @@ static int dcmi_probe(struct platform_de
 
 	spin_lock_init(&dcmi->irqlock);
 	mutex_init(&dcmi->lock);
+	mutex_init(&dcmi->dma_lock);
 	init_completion(&dcmi->complete);
 	INIT_LIST_HEAD(&dcmi->buffers);
 


