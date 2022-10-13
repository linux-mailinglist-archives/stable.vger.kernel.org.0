Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E3E5FD10A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiJMAcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiJMAad (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:30:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7AB178AE;
        Wed, 12 Oct 2022 17:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C13D2B81C48;
        Thu, 13 Oct 2022 00:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB17C433C1;
        Thu, 13 Oct 2022 00:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620335;
        bh=u/bw0MPMS/QV/9IoNFCmnYBw0YZ8rHNhw+FhHjhGJJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf1fvs/SHkxlvp2tXzW536fbV1lxK35UCqcTGztGfHMKbYVzr97scel89tjVdlTC2
         HwdXdRAIgyhbRyz4F0FHEnVKxbHYrLqcFl1E0Mt6NbdB44Vw03q+FZM0fC75sw9aGR
         NqhmwfTQAq78F6CggQ730YVZUUV0VdB1eQPVGWCADs0GBuuMsiXhbmu96XNu9QJeho
         8YAYsVzo6pTJiC0SS9+PiNtLAkhf9sS9CeSfzXmodhw+A3diXQYbV2nS2Nwlb0mYRq
         vuavFieUqQFnvs/3XzBkow/rneN/ujQSkjOuDADuvS3wbal2K27xcnhoMKImwjRo3n
         euykkVLyIalcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 03/63] media: cx88: Fix a null-ptr-deref bug in buffer_prepare()
Date:   Wed, 12 Oct 2022 20:17:37 -0400
Message-Id: <20221013001842.1893243-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 2b064d91440b33fba5b452f2d1b31f13ae911d71 ]

When the driver calls cx88_risc_buffer() to prepare the buffer, the
function call may fail, resulting in a empty buffer and null-ptr-deref
later in buffer_queue().

The following log can reveal it:

[   41.822762] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
[   41.824488] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   41.828027] RIP: 0010:buffer_queue+0xc2/0x500
[   41.836311] Call Trace:
[   41.836945]  __enqueue_in_driver+0x141/0x360
[   41.837262]  vb2_start_streaming+0x62/0x4a0
[   41.838216]  vb2_core_streamon+0x1da/0x2c0
[   41.838516]  __vb2_init_fileio+0x981/0xbc0
[   41.839141]  __vb2_perform_fileio+0xbf9/0x1120
[   41.840072]  vb2_fop_read+0x20e/0x400
[   41.840346]  v4l2_read+0x215/0x290
[   41.840603]  vfs_read+0x162/0x4c0

Fix this by checking the return value of cx88_risc_buffer()

[hverkuil: fix coding style issues]

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx88/cx88-vbi.c   |  9 +++---
 drivers/media/pci/cx88/cx88-video.c | 43 +++++++++++++++--------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index a075788c64d4..469aeaa725ad 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -144,11 +144,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, size);
 
-	cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
-			 0, VBI_LINE_LENGTH * lines,
-			 VBI_LINE_LENGTH, 0,
-			 lines);
-	return 0;
+	return cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
+				0, VBI_LINE_LENGTH * lines,
+				VBI_LINE_LENGTH, 0,
+				lines);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index d3729be89252..b509c2a03852 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -431,6 +431,7 @@ static int queue_setup(struct vb2_queue *q,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	int ret;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
@@ -445,35 +446,35 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	switch (core->field) {
 	case V4L2_FIELD_TOP:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl, 0, UNSET,
-				 buf->bpl, 0, core->height);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl, 0, UNSET,
+				       buf->bpl, 0, core->height);
 		break;
 	case V4L2_FIELD_BOTTOM:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl, UNSET, 0,
-				 buf->bpl, 0, core->height);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl, UNSET, 0,
+				       buf->bpl, 0, core->height);
 		break;
 	case V4L2_FIELD_SEQ_TB:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl,
-				 0, buf->bpl * (core->height >> 1),
-				 buf->bpl, 0,
-				 core->height >> 1);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl,
+				       0, buf->bpl * (core->height >> 1),
+				       buf->bpl, 0,
+				       core->height >> 1);
 		break;
 	case V4L2_FIELD_SEQ_BT:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl,
-				 buf->bpl * (core->height >> 1), 0,
-				 buf->bpl, 0,
-				 core->height >> 1);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl,
+				       buf->bpl * (core->height >> 1), 0,
+				       buf->bpl, 0,
+				       core->height >> 1);
 		break;
 	case V4L2_FIELD_INTERLACED:
 	default:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl, 0, buf->bpl,
-				 buf->bpl, buf->bpl,
-				 core->height >> 1);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl, 0, buf->bpl,
+				       buf->bpl, buf->bpl,
+				       core->height >> 1);
 		break;
 	}
 	dprintk(2,
@@ -481,7 +482,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		buf, buf->vb.vb2_buf.index, __func__,
 		core->width, core->height, dev->fmt->depth, dev->fmt->fourcc,
 		(unsigned long)buf->risc.dma);
-	return 0;
+	return ret;
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
-- 
2.35.1

