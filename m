Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F46620140C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391743AbgFSPIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391738AbgFSPIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:08:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0993221BE5;
        Fri, 19 Jun 2020 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579309;
        bh=ff63F8/MR7DgIByz7Yc9PUYZiZ1MHySUAsvhffIUz3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtR5DRYIu8i6oVrPFlQAEe8vi9SCf6PnREULsMJjDIvKvu528b0kLvDaj9hfsRU8A
         nkJoTLmp5mgS72CNu7SQ5ZvnKPtqN5xiTlZEv1STrgwaygqe6cv5OrcR4Na+B3RHeH
         1o76Hiq+D3mcnviE5mgMCqVesLqgzerwDRnDBGzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/261] media: staging/intel-ipu3: Implement lock for stream on/off operations
Date:   Fri, 19 Jun 2020 16:31:10 +0200
Message-Id: <20200619141652.747583591@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 33e3c349b2bf1235be458df09fb8d237141486c4 ]

Currently concurrent stream off operations on ImgU nodes are not
synchronized, leading to use-after-free bugs (as reported by KASAN).

[  250.090724] BUG: KASAN: use-after-free in
ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu]
[  250.090726] Read of size 8 at addr ffff888127b29bc0 by task
yavta/18836
[  250.090731] Hardware name: HP Soraka/Soraka, BIOS
Google_Soraka.10431.17.0 03/22/2018
[  250.090732] Call Trace:
[  250.090735]  dump_stack+0x6a/0xb1
[  250.090739]  print_address_description+0x8e/0x279
[  250.090743]  ? ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu]
[  250.090746]  kasan_report+0x260/0x28a
[  250.090750]  ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu]
[  250.090754]  ipu3_css_pool_cleanup+0x24/0x37 [ipu3_imgu]
[  250.090759]  ipu3_css_pipeline_cleanup+0x61/0xb9 [ipu3_imgu]
[  250.090763]  ipu3_css_stop_streaming+0x1f2/0x321 [ipu3_imgu]
[  250.090768]  imgu_s_stream+0x94/0x443 [ipu3_imgu]
[  250.090772]  ? ipu3_vb2_buf_queue+0x280/0x280 [ipu3_imgu]
[  250.090775]  ? vb2_dma_sg_unmap_dmabuf+0x16/0x6f [videobuf2_dma_sg]
[  250.090778]  ? vb2_buffer_in_use+0x36/0x58 [videobuf2_common]
[  250.090782]  ipu3_vb2_stop_streaming+0xf9/0x135 [ipu3_imgu]

Implemented a lock to synchronize imgu stream on / off operations and
the modification of streaming flag (in struct imgu_device), to prevent
these issues.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 10 ++++++++++
 drivers/staging/media/ipu3/ipu3.c      |  3 +++
 drivers/staging/media/ipu3/ipu3.h      |  4 ++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 3c7ad1eed434..c764cb55dc8d 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -367,8 +367,10 @@ static void imgu_vb2_buf_queue(struct vb2_buffer *vb)
 
 	vb2_set_plane_payload(vb, 0, need_bytes);
 
+	mutex_lock(&imgu->streaming_lock);
 	if (imgu->streaming)
 		imgu_queue_buffers(imgu, false, node->pipe);
+	mutex_unlock(&imgu->streaming_lock);
 
 	dev_dbg(&imgu->pci_dev->dev, "%s for pipe %u node %u", __func__,
 		node->pipe, node->id);
@@ -468,10 +470,13 @@ static int imgu_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 	dev_dbg(dev, "%s node name %s pipe %u id %u", __func__,
 		node->name, node->pipe, node->id);
 
+	mutex_lock(&imgu->streaming_lock);
 	if (imgu->streaming) {
 		r = -EBUSY;
+		mutex_unlock(&imgu->streaming_lock);
 		goto fail_return_bufs;
 	}
+	mutex_unlock(&imgu->streaming_lock);
 
 	if (!node->enabled) {
 		dev_err(dev, "IMGU node is not enabled");
@@ -498,9 +503,11 @@ static int imgu_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	/* Start streaming of the whole pipeline now */
 	dev_dbg(dev, "IMGU streaming is ready to start");
+	mutex_lock(&imgu->streaming_lock);
 	r = imgu_s_stream(imgu, true);
 	if (!r)
 		imgu->streaming = true;
+	mutex_unlock(&imgu->streaming_lock);
 
 	return 0;
 
@@ -532,6 +539,7 @@ static void imgu_vb2_stop_streaming(struct vb2_queue *vq)
 		dev_err(&imgu->pci_dev->dev,
 			"failed to stop subdev streaming\n");
 
+	mutex_lock(&imgu->streaming_lock);
 	/* Was this the first node with streaming disabled? */
 	if (imgu->streaming && imgu_all_nodes_streaming(imgu, node)) {
 		/* Yes, really stop streaming now */
@@ -542,6 +550,8 @@ static void imgu_vb2_stop_streaming(struct vb2_queue *vq)
 	}
 
 	imgu_return_all_buffers(imgu, node, VB2_BUF_STATE_ERROR);
+	mutex_unlock(&imgu->streaming_lock);
+
 	media_pipeline_stop(&node->vdev.entity);
 }
 
diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
index eb16394acf96..08eb6791918b 100644
--- a/drivers/staging/media/ipu3/ipu3.c
+++ b/drivers/staging/media/ipu3/ipu3.c
@@ -663,6 +663,7 @@ static int imgu_pci_probe(struct pci_dev *pci_dev,
 		return r;
 
 	mutex_init(&imgu->lock);
+	mutex_init(&imgu->streaming_lock);
 	atomic_set(&imgu->qbuf_barrier, 0);
 	init_waitqueue_head(&imgu->buf_drain_wq);
 
@@ -726,6 +727,7 @@ out_mmu_exit:
 out_css_powerdown:
 	imgu_css_set_powerdown(&pci_dev->dev, imgu->base);
 out_mutex_destroy:
+	mutex_destroy(&imgu->streaming_lock);
 	mutex_destroy(&imgu->lock);
 
 	return r;
@@ -743,6 +745,7 @@ static void imgu_pci_remove(struct pci_dev *pci_dev)
 	imgu_css_set_powerdown(&pci_dev->dev, imgu->base);
 	imgu_dmamap_exit(imgu);
 	imgu_mmu_exit(imgu->mmu);
+	mutex_destroy(&imgu->streaming_lock);
 	mutex_destroy(&imgu->lock);
 }
 
diff --git a/drivers/staging/media/ipu3/ipu3.h b/drivers/staging/media/ipu3/ipu3.h
index 73b123b2b8a2..8cd6a0077d99 100644
--- a/drivers/staging/media/ipu3/ipu3.h
+++ b/drivers/staging/media/ipu3/ipu3.h
@@ -146,6 +146,10 @@ struct imgu_device {
 	 * vid_buf.list and css->queue
 	 */
 	struct mutex lock;
+
+	/* Lock to protect writes to streaming flag in this struct */
+	struct mutex streaming_lock;
+
 	/* Forbid streaming and buffer queuing during system suspend. */
 	atomic_t qbuf_barrier;
 	/* Indicate if system suspend take place while imgu is streaming. */
-- 
2.25.1



