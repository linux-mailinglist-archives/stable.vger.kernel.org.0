Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243B05FD200
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbiJMA5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiJMA4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:56:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744B58501;
        Wed, 12 Oct 2022 17:53:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFC8B616D8;
        Thu, 13 Oct 2022 00:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F10AC433D6;
        Thu, 13 Oct 2022 00:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620786;
        bh=T5i1R27xp5nyi5Tgeqhglx5gFkApiPnJX27oHS5I4c0=;
        h=From:To:Cc:Subject:Date:From;
        b=hMYl8Fhvj8QVBrh3zeCPKzXBH5HyeCclLluzuHPrmqbwaf4LRrIh0ssiLWKt9L3uP
         2AWjGWchhkQZOIPWm0ejG3aFTwF43pJ3An3YFpwFhO3KeOMzPZiqcZdJljyo5kA2wz
         IldvQmtv0NiwHnEmw90BsESRuxlyqyg+M0B0o89zTS8+vxPY/0/Ag8ClaWlNobJLvM
         ELuIk4+5BogWsCCkG+P0ussfXm2x/2zlxlz3kMP5AC9kWdG2ARoE71/BVi8oUWzEZ5
         MMKbmZ0a0tfmvrGfRdLQ4aEYC5P4uYpyAOJJwOXrkShTmH6iYKKpYdCGOTRkWZAeDV
         aOTc7Wi488Z1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/19] media: cx88: Fix a null-ptr-deref bug in buffer_prepare()
Date:   Wed, 12 Oct 2022 20:26:00 -0400
Message-Id: <20221013002623.1895576-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index 58489ea0c1da..7cf2271866d0 100644
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
index 248fb3b6833c..2bc5080198bb 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -452,6 +452,7 @@ static int queue_setup(struct vb2_queue *q,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	int ret;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
@@ -466,35 +467,35 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
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
@@ -502,7 +503,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		buf, buf->vb.vb2_buf.index,
 		core->width, core->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
-	return 0;
+	return ret;
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
-- 
2.35.1

