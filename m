Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD96627F6C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 16:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbfEWOVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 10:21:48 -0400
Received: from www.linuxtv.org ([130.149.80.248]:44079 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730369AbfEWOVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 10:21:48 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1hTobI-0002vY-8l; Thu, 23 May 2019 14:21:44 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 23 May 2019 14:18:19 +0000
Subject: [git:media_tree/master] media: videobuf2-core: Prevent size alignment wrapping buffer size to 0
To:     linuxtv-commits@linuxtv.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1hTobI-0002vY-8l@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: videobuf2-core: Prevent size alignment wrapping buffer size to 0
Author:  Sakari Ailus <sakari.ailus@linux.intel.com>
Date:    Wed Dec 12 07:27:10 2018 -0500

PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
checking that the aligned value is not smaller than the unaligned one.

Note on backporting to stable: the file used to be under
drivers/media/v4l2-core, it was moved to the current location after 4.14.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
 1 file changed, 4 insertions(+)

---

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 3cf25abf5807..cfccee87909a 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
 
+		/* Did it wrap around? */
+		if (size < vb->planes[plane].length)
+			goto free;
+
 		mem_priv = call_ptr_memop(vb, alloc,
 				q->alloc_devs[plane] ? : q->dev,
 				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
