Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3477F1BC
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404658AbfHBJli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404638AbfHBJlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:41:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E30216C8;
        Fri,  2 Aug 2019 09:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738894;
        bh=npkufgNXGJkzCOIWa1qKYTS4hR1S1BZDZePc3IXX7no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHD+Z9KNNPFzmaIkJTRQ1VFhwf6hxLtjYi3saPCvnGMhrT5FWzJ+bCDrXKwYN6EMr
         5UFkrTysmEv1nazK87f5lH0SYCuiyliozO98lX/3+P+fc2iwI0prf/endh9DdWSKvE
         AGeJT/rvB+jNsVi3aZsks5Sp36IroBtzGJT96FaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 012/223] media: marvell-ccic: fix DMA s/g desc number calculation
Date:   Fri,  2 Aug 2019 11:33:57 +0200
Message-Id: <20190802092239.729278333@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0c7aa32966dab0b8a7424e1b34c7f206817953ec ]

The commit d790b7eda953 ("[media] vb2-dma-sg: move dma_(un)map_sg here")
left dma_desc_nent unset. It previously contained the number of DMA
descriptors as returned from dma_map_sg().

We can now (since the commit referred to above) obtain the same value from
the sg_table and drop dma_desc_nent altogether.

Tested on OLPC XO-1.75 machine. Doesn't affect the OLPC XO-1's Cafe
driver, since that one doesn't do DMA.

[mchehab+samsung@kernel.org: fix a checkpatch warning]

Fixes: d790b7eda953 ("[media] vb2-dma-sg: move dma_(un)map_sg here")
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index af59bf4dca2d..a74bfb9afc8d 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -209,7 +209,6 @@ struct mcam_vb_buffer {
 	struct list_head queue;
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
-	int dma_desc_nent;		/* Number of mapped descriptors */
 };
 
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_v4l2_buffer *vb)
@@ -616,9 +615,11 @@ static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 static void mcam_sg_next_buffer(struct mcam_camera *cam)
 {
 	struct mcam_vb_buffer *buf;
+	struct sg_table *sg_table;
 
 	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
 	list_del_init(&buf->queue);
+	sg_table = vb2_dma_sg_plane_desc(&buf->vb_buf.vb2_buf, 0);
 	/*
 	 * Very Bad Not Good Things happen if you don't clear
 	 * C1_DESC_ENA before making any descriptor changes.
@@ -626,7 +627,7 @@ static void mcam_sg_next_buffer(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_ENA);
 	mcam_reg_write(cam, REG_DMA_DESC_Y, buf->dma_desc_pa);
 	mcam_reg_write(cam, REG_DESC_LEN_Y,
-			buf->dma_desc_nent*sizeof(struct mcam_dma_desc));
+			sg_table->nents * sizeof(struct mcam_dma_desc));
 	mcam_reg_write(cam, REG_DESC_LEN_U, 0);
 	mcam_reg_write(cam, REG_DESC_LEN_V, 0);
 	mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
-- 
2.20.1



