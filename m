Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1F64A09A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiLLN10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiLLN1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:27:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F7413D09
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 491BD61035
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785AAC433D2;
        Mon, 12 Dec 2022 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851630;
        bh=ZOtrsj/Dr1tFmoH5Atjdjc27zBYQ1+moiA7lCIVMOp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uI2yUn/VPQ0q4GQIxnFX8St7sV6EOAxu/rQB6bQWwheKB6E72BBx9In/cjwisUwUg
         J8tNVBJWIlILH+Oh1zTMEcpPnFFEBIwKpzcjk7JWBEyB5r4gMXFuzNvvmV6DFg2nro
         dy4OImJhKnjsz3G6vhw5A+F40K+oqD7bl5/abSmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/123] media: videobuf2-core: take mmap_lock in vb2_get_unmapped_area()
Date:   Mon, 12 Dec 2022 14:16:45 +0100
Message-Id: <20221212130928.555427308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 098e5edc5d048a8df8691fd9fde895af100be42b ]

While vb2_mmap took the mmap_lock mutex, vb2_get_unmapped_area didn't.
Add this.

Also take this opportunity to move the 'q->memory != VB2_MEMORY_MMAP'
check and vb2_fileio_is_active() check into __find_plane_by_offset() so
both vb2_mmap and vb2_get_unmapped_area do the same checks.

Since q->memory is checked while mmap_lock is held, also take that lock
in reqbufs and create_bufs when it is set, and set it back to
MEMORY_UNKNOWN on error.

Fixes: f035eb4e976e ("[media] videobuf2: fix lockdep warning")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Tomasz Figa <tfiga@chromium.org>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/common/videobuf2/videobuf2-core.c   | 102 +++++++++++++-----
 1 file changed, 73 insertions(+), 29 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 033b0c83272f..30c8497f7c11 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -788,7 +788,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	num_buffers = max_t(unsigned int, *count, q->min_buffers_needed);
 	num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
 	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
+	/*
+	 * Set this now to ensure that drivers see the correct q->memory value
+	 * in the queue_setup op.
+	 */
+	mutex_lock(&q->mmap_lock);
 	q->memory = memory;
+	mutex_unlock(&q->mmap_lock);
 
 	/*
 	 * Ask the driver how many buffers and planes per buffer it requires.
@@ -797,22 +803,27 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
 		       plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* Check that driver has set sane values */
-	if (WARN_ON(!num_planes))
-		return -EINVAL;
+	if (WARN_ON(!num_planes)) {
+		ret = -EINVAL;
+		goto error;
+	}
 
 	for (i = 0; i < num_planes; i++)
-		if (WARN_ON(!plane_sizes[i]))
-			return -EINVAL;
+		if (WARN_ON(!plane_sizes[i])) {
+			ret = -EINVAL;
+			goto error;
+		}
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers =
 		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(q, 1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	/*
@@ -853,7 +864,8 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * from q->num_buffers and it will reset q->memory to
+		 * VB2_MEMORY_UNKNOWN.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
@@ -869,6 +881,12 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	q->waiting_for_buffers = !q->is_output;
 
 	return 0;
+
+error:
+	mutex_lock(&q->mmap_lock);
+	q->memory = VB2_MEMORY_UNKNOWN;
+	mutex_unlock(&q->mmap_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
@@ -879,6 +897,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	unsigned plane_sizes[VB2_MAX_PLANES] = { };
+	bool no_previous_buffers = !q->num_buffers;
 	int ret;
 
 	if (q->num_buffers == VB2_MAX_FRAME) {
@@ -886,13 +905,19 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -ENOBUFS;
 	}
 
-	if (!q->num_buffers) {
+	if (no_previous_buffers) {
 		if (q->waiting_in_dqbuf && *count) {
 			dprintk(q, 1, "another dup()ped fd is waiting for a buffer\n");
 			return -EBUSY;
 		}
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
+		/*
+		 * Set this now to ensure that drivers see the correct q->memory
+		 * value in the queue_setup op.
+		 */
+		mutex_lock(&q->mmap_lock);
 		q->memory = memory;
+		mutex_unlock(&q->mmap_lock);
 		q->waiting_for_buffers = !q->is_output;
 	} else {
 		if (q->memory != memory) {
@@ -915,14 +940,15 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers,
 		       &num_planes, plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
 				num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(q, 1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	/*
@@ -953,7 +979,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * from q->num_buffers and it will reset q->memory to
+		 * VB2_MEMORY_UNKNOWN.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
@@ -968,6 +995,14 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	*count = allocated_buffers;
 
 	return 0;
+
+error:
+	if (no_previous_buffers) {
+		mutex_lock(&q->mmap_lock);
+		q->memory = VB2_MEMORY_UNKNOWN;
+		mutex_unlock(&q->mmap_lock);
+	}
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
@@ -2124,6 +2159,22 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	struct vb2_buffer *vb;
 	unsigned int buffer, plane;
 
+	/*
+	 * Sanity checks to ensure the lock is held, MEMORY_MMAP is
+	 * used and fileio isn't active.
+	 */
+	lockdep_assert_held(&q->mmap_lock);
+
+	if (q->memory != VB2_MEMORY_MMAP) {
+		dprintk(q, 1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	if (vb2_fileio_is_active(q)) {
+		dprintk(q, 1, "file io in progress\n");
+		return -EBUSY;
+	}
+
 	/*
 	 * Go over all buffers and their planes, comparing the given offset
 	 * with an offset assigned to each plane. If a match is found,
@@ -2225,11 +2276,6 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	int ret;
 	unsigned long length;
 
-	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(q, 1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Check memory area access mode.
 	 */
@@ -2251,14 +2297,9 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 
 	mutex_lock(&q->mmap_lock);
 
-	if (vb2_fileio_is_active(q)) {
-		dprintk(q, 1, "mmap: file io in progress\n");
-		ret = -EBUSY;
-		goto unlock;
-	}
-
 	/*
-	 * Find the plane corresponding to the offset passed by userspace.
+	 * Find the plane corresponding to the offset passed by userspace. This
+	 * will return an error if not MEMORY_MMAP or file I/O is in progress.
 	 */
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
 	if (ret)
@@ -2311,22 +2352,25 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	void *vaddr;
 	int ret;
 
-	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(q, 1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
+	mutex_lock(&q->mmap_lock);
 
 	/*
-	 * Find the plane corresponding to the offset passed by userspace.
+	 * Find the plane corresponding to the offset passed by userspace. This
+	 * will return an error if not MEMORY_MMAP or file I/O is in progress.
 	 */
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	vb = q->bufs[buffer];
 
 	vaddr = vb2_plane_vaddr(vb, plane);
+	mutex_unlock(&q->mmap_lock);
 	return vaddr ? (unsigned long)vaddr : -EINVAL;
+
+unlock:
+	mutex_unlock(&q->mmap_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
-- 
2.35.1



