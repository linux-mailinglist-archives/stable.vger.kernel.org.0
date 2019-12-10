Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A8D119776
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbfLJVdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbfLJVdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4051B20836;
        Tue, 10 Dec 2019 21:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013597;
        bh=T9m8SXWfl5H4z2L8fZVt30eVvsbmwwU57qc76vLpFLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncG+8v03Q2qcQr7TwfXIw9njbiMd9+3IZ26pTseeSfRGEdR/OMlAcCKY6tgMJ4P0c
         gOThPm/7mkSJmyoslZJgzhBNa0F4E9cZQtBcJSnBv51JPxxHFwjqEsfZvTDalooh7o
         lzN+zKLDi7oS4zCOhqQJpkPflJdUBoFbtNRr5iwI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 046/177] media: ti-vpe: vpe: ensure buffers are cleaned up properly in abort cases
Date:   Tue, 10 Dec 2019 16:30:10 -0500
Message-Id: <20191210213221.11921-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit cf6acb73b050e98b5cc435fae0e8ae0157520410 ]

v4l2-compliance fails with this message:

   fail: v4l2-test-buffers.cpp(691): ret == 0
   fail: v4l2-test-buffers.cpp(974): captureBufs(node, q, m2m_q,
frame_count, true)
   test MMAP: FAIL

This caused the following Kernel Warning:

WARNING: CPU: 0 PID: 961 at
drivers/media/v4l2-core/videobuf2-core.c:1658
__vb2_queue_cancel+0x174/0x1d8
...
CPU: 0 PID: 961 Comm: v4l2-compliance Not tainted
4.14.62-01720-g20ecd717e87a #6
Hardware name: Generic DRA72X (Flattened Device Tree)
Backtrace:
[<c020b5bc>] (dump_backtrace) from [<c020b8a0>] (show_stack+0x18/0x1c)
 r7:00000009 r6:60070013 r5:00000000 r4:c1053824
[<c020b888>] (show_stack) from [<c09232e8>] (dump_stack+0x90/0xa4)
[<c0923258>] (dump_stack) from [<c022b740>] (__warn+0xec/0x104)
  r7:00000009 r6:c0c0ad50 r5:00000000 r4:00000000
[<c022b654>] (__warn) from [<c022b810>] (warn_slowpath_null+0x28/0x30)
  r9:00000008 r8:00000000 r7:eced4808 r6:edbc9bac r5:eced4844
r4:eced4808
[<c022b7e8>] (warn_slowpath_null) from [<c0726f48>]
(__vb2_queue_cancel+0x174/0x1d8)
[<c0726dd4>] (__vb2_queue_cancel) from [<c0727648>]
(vb2_core_queue_release+0x20/0x40)
  r10:ecc7bd70 r9:00000008 r8:00000000 r7:edb73010 r6:edbc9bac
r5:eced4844
  r4:eced4808 r3:00000004
[<c0727628>] (vb2_core_queue_release) from [<c0729528>]
(vb2_queue_release+0x10/0x14)
  r5:edbc9810 r4:eced4800
[<c0729518>] (vb2_queue_release) from [<c0724d08>]
(v4l2_m2m_ctx_release+0x1c/0x30)
[<c0724cec>] (v4l2_m2m_ctx_release) from [<bf0e8f28>]
(vpe_release+0x74/0xb0 [ti_vpe])
  r5:edbc9810 r4:ed67a400
[<bf0e8eb4>] (vpe_release [ti_vpe]) from [<c070fccc>]
(v4l2_release+0x3c/0x80)
  r7:edb73010 r6:ed176aa0 r5:edbc9868 r4:ed5119c0
[<c070fc90>] (v4l2_release) from [<c033cf1c>] (__fput+0x8c/0x1dc)
  r5:ecc7bd70 r4:ed5119c0
[<c033ce90>] (__fput) from [<c033d0cc>] (____fput+0x10/0x14)
  r10:00000000 r9:ed5119c0 r8:ece392d0 r7:c1059544 r6:ece38d80
r5:ece392b4
  r4:00000000
[<c033d0bc>] (____fput) from [<c0246e00>] (task_work_run+0x98/0xb8)
[<c0246d68>] (task_work_run) from [<c022f1d8>] (do_exit+0x170/0xa80)
  r9:ece351fc r8:00000000 r7:ecde3f58 r6:ffffe000 r5:ece351c0
r4:ece38d80
[<c022f068>] (do_exit) from [<c022fb6c>] (do_group_exit+0x48/0xc4)
  r7:000000f8
[<c022fb24>] (do_group_exit) from [<c022fc00>]
(__wake_up_parent+0x0/0x28)
  r7:000000f8 r6:b6c6a798 r5:00000001 r4:00000001
[<c022fbe8>] (SyS_exit_group) from [<c0207c80>]
(ret_fast_syscall+0x0/0x4c)

These warnings are caused by buffers which not properly cleaned
up/release during an abort use case.

In the abort cases the VPDMA desc buffers would still be mapped and the
in-flight VB2 buffers would not be released properly causing a kernel
warning from being generated by the videobuf2-core level.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpe.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 54f0d9d3cc491..52d5aebe0fb81 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1418,9 +1418,6 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	 /* the previous dst mv buffer becomes the next src mv buffer */
 	ctx->src_mv_buf_selector = !ctx->src_mv_buf_selector;
 
-	if (ctx->aborting)
-		goto finished;
-
 	s_vb = ctx->src_vbs[0];
 	d_vb = ctx->dst_vb;
 
@@ -1485,6 +1482,9 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	ctx->src_vbs[0] = NULL;
 	ctx->dst_vb = NULL;
 
+	if (ctx->aborting)
+		goto finished;
+
 	ctx->bufs_completed++;
 	if (ctx->bufs_completed < ctx->bufs_per_job && job_ready(ctx)) {
 		device_run(ctx);
@@ -2383,6 +2383,12 @@ static int vpe_release(struct file *file)
 
 	mutex_lock(&dev->dev_mutex);
 	free_mv_buffers(ctx);
+
+	vpdma_unmap_desc_buf(dev->vpdma, &ctx->desc_list.buf);
+	vpdma_unmap_desc_buf(dev->vpdma, &ctx->mmr_adb);
+	vpdma_unmap_desc_buf(dev->vpdma, &ctx->sc_coeff_h);
+	vpdma_unmap_desc_buf(dev->vpdma, &ctx->sc_coeff_v);
+
 	vpdma_free_desc_list(&ctx->desc_list);
 	vpdma_free_desc_buf(&ctx->mmr_adb);
 
-- 
2.20.1

