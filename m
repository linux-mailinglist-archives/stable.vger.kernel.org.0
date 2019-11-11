Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E27F7C30
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfKKSoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfKKSoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:44:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55BD6204FD;
        Mon, 11 Nov 2019 18:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497841;
        bh=dywrqtEgRpBStaOON3XI5ekgKLo9hIVBLPXy10+jWHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sscScEYyhU1DXMlrhNckLb9Z9ehXvUR3UZ/FemxJHkID7jebj3rMTeApHbZVouaaE
         4W+BEQb7Xw8bwslitM1q3huFJf+vJVJtc+II+62OuYYMzV+WT8DrMvUzN1AsS3nm7+
         d3F3/9OfblZrBQQ2hhWdU0AmCXEPH9QH4zMhTafc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenfang Wang <zhenfang.wang@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/125] dmaengine: sprd: Fix the possible memory leak issue
Date:   Mon, 11 Nov 2019 19:28:31 +0100
Message-Id: <20191111181449.739146488@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linaro.org>

[ Upstream commit ec1ac309596a7bdf206743b092748205f6cd5720 ]

If we terminate the channel to free all descriptors associated with this
channel, we will leak the memory of current descriptor if the current
descriptor is not completed, since it had been deteled from the desc_issued
list and have not been added into the desc_completed list.

Thus we should check if current descriptor is completed or not, when freeing
the descriptors associated with one channel, if not, we should free it to
avoid this issue.

Fixes: 9b3b8171f7f4 ("dmaengine: sprd: Add Spreadtrum DMA driver")
Reported-by: Zhenfang Wang <zhenfang.wang@unisoc.com>
Tested-by: Zhenfang Wang <zhenfang.wang@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Link: https://lore.kernel.org/r/170dbbc6d5366b6fa974ce2d366652e23a334251.1570609788.git.baolin.wang@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 1ed1c7efa2885..9e8ce56a83d8a 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -181,6 +181,7 @@ struct sprd_dma_dev {
 	struct sprd_dma_chn	channels[0];
 };
 
+static void sprd_dma_free_desc(struct virt_dma_desc *vd);
 static bool sprd_dma_filter_fn(struct dma_chan *chan, void *param);
 static struct of_dma_filter_info sprd_dma_info = {
 	.filter_fn = sprd_dma_filter_fn,
@@ -493,12 +494,19 @@ static int sprd_dma_alloc_chan_resources(struct dma_chan *chan)
 static void sprd_dma_free_chan_resources(struct dma_chan *chan)
 {
 	struct sprd_dma_chn *schan = to_sprd_dma_chan(chan);
+	struct virt_dma_desc *cur_vd = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&schan->vc.lock, flags);
+	if (schan->cur_desc)
+		cur_vd = &schan->cur_desc->vd;
+
 	sprd_dma_stop(schan);
 	spin_unlock_irqrestore(&schan->vc.lock, flags);
 
+	if (cur_vd)
+		sprd_dma_free_desc(cur_vd);
+
 	vchan_free_chan_resources(&schan->vc);
 	pm_runtime_put(chan->device->dev);
 }
@@ -814,15 +822,22 @@ static int sprd_dma_resume(struct dma_chan *chan)
 static int sprd_dma_terminate_all(struct dma_chan *chan)
 {
 	struct sprd_dma_chn *schan = to_sprd_dma_chan(chan);
+	struct virt_dma_desc *cur_vd = NULL;
 	unsigned long flags;
 	LIST_HEAD(head);
 
 	spin_lock_irqsave(&schan->vc.lock, flags);
+	if (schan->cur_desc)
+		cur_vd = &schan->cur_desc->vd;
+
 	sprd_dma_stop(schan);
 
 	vchan_get_all_descriptors(&schan->vc, &head);
 	spin_unlock_irqrestore(&schan->vc.lock, flags);
 
+	if (cur_vd)
+		sprd_dma_free_desc(cur_vd);
+
 	vchan_dma_desc_free_list(&schan->vc, &head);
 	return 0;
 }
-- 
2.20.1



