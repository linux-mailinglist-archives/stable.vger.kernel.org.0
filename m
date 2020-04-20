Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839CD1B0B5F
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgDTMph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgDTMpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE60206E9;
        Mon, 20 Apr 2020 12:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386736;
        bh=7cXOEXKgAZRL7TOLZLpqjpkyOf0AuX0bL5USTA/0Hc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCUxpxPKFBhMWjsU76Lf7X227baU6mPL7jxK4ZB2D53cgT7b3LP0RJFl+AT7Q5XUR
         dGHoveYbWcDwT3qyRO4al4mt0qZMjPqRLQN5Npn5BnUZ/AxqtW822QOPbkLAzvfXQC
         hzFV0Yr7Gk4DuK+4ZQojP8aWLzKs2wPw5QRNA1N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.6 63/71] drm/i915/perf: Do not clear pollin for small user read buffers
Date:   Mon, 20 Apr 2020 14:39:17 +0200
Message-Id: <20200420121521.560898369@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit bcad588dea538a4fc173d16a90a005536ec8dbf2 upstream.

It is wrong to block the user thread in the next poll when OA data is
already available which could not fit in the user buffer provided in
the previous read. In several cases the exact user buffer size is not
known. Blocking user space in poll can lead to data loss when the
buffer size used is smaller than the available data.

This change fixes this issue and allows user space to read all OA data
even when using a buffer size smaller than the available data using
multiple non-blocking reads rather than staying blocked in poll till
the next timer interrupt.

v2: Fix ret value for blocking reads (Umesh)
v3: Mistake during patch send (Ashutosh)
v4: Remove -EAGAIN from comment (Umesh)
v5: Improve condition for clearing pollin and return (Lionel)
v6: Improve blocking read loop and other cleanups (Lionel)
v7: Added Cc stable

Testcase: igt/perf/polling-small-buf
Reviewed-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200403010120.3067-1-ashutosh.dixit@intel.com
(cherry-picked from commit 6352219c39c04ed3f9a8d1cf93f87c21753a213e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_perf.c |   65 ++++++---------------------------------
 1 file changed, 11 insertions(+), 54 deletions(-)

--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -2910,49 +2910,6 @@ void i915_oa_init_reg_state(const struct
 }
 
 /**
- * i915_perf_read_locked - &i915_perf_stream_ops->read with error normalisation
- * @stream: An i915 perf stream
- * @file: An i915 perf stream file
- * @buf: destination buffer given by userspace
- * @count: the number of bytes userspace wants to read
- * @ppos: (inout) file seek position (unused)
- *
- * Besides wrapping &i915_perf_stream_ops->read this provides a common place to
- * ensure that if we've successfully copied any data then reporting that takes
- * precedence over any internal error status, so the data isn't lost.
- *
- * For example ret will be -ENOSPC whenever there is more buffered data than
- * can be copied to userspace, but that's only interesting if we weren't able
- * to copy some data because it implies the userspace buffer is too small to
- * receive a single record (and we never split records).
- *
- * Another case with ret == -EFAULT is more of a grey area since it would seem
- * like bad form for userspace to ask us to overrun its buffer, but the user
- * knows best:
- *
- *   http://yarchive.net/comp/linux/partial_reads_writes.html
- *
- * Returns: The number of bytes copied or a negative error code on failure.
- */
-static ssize_t i915_perf_read_locked(struct i915_perf_stream *stream,
-				     struct file *file,
-				     char __user *buf,
-				     size_t count,
-				     loff_t *ppos)
-{
-	/* Note we keep the offset (aka bytes read) separate from any
-	 * error status so that the final check for whether we return
-	 * the bytes read with a higher precedence than any error (see
-	 * comment below) doesn't need to be handled/duplicated in
-	 * stream->ops->read() implementations.
-	 */
-	size_t offset = 0;
-	int ret = stream->ops->read(stream, buf, count, &offset);
-
-	return offset ?: (ret ?: -EAGAIN);
-}
-
-/**
  * i915_perf_read - handles read() FOP for i915 perf stream FDs
  * @file: An i915 perf stream file
  * @buf: destination buffer given by userspace
@@ -2977,7 +2934,8 @@ static ssize_t i915_perf_read(struct fil
 {
 	struct i915_perf_stream *stream = file->private_data;
 	struct i915_perf *perf = stream->perf;
-	ssize_t ret;
+	size_t offset = 0;
+	int ret;
 
 	/* To ensure it's handled consistently we simply treat all reads of a
 	 * disabled stream as an error. In particular it might otherwise lead
@@ -3000,13 +2958,12 @@ static ssize_t i915_perf_read(struct fil
 				return ret;
 
 			mutex_lock(&perf->lock);
-			ret = i915_perf_read_locked(stream, file,
-						    buf, count, ppos);
+			ret = stream->ops->read(stream, buf, count, &offset);
 			mutex_unlock(&perf->lock);
-		} while (ret == -EAGAIN);
+		} while (!offset && !ret);
 	} else {
 		mutex_lock(&perf->lock);
-		ret = i915_perf_read_locked(stream, file, buf, count, ppos);
+		ret = stream->ops->read(stream, buf, count, &offset);
 		mutex_unlock(&perf->lock);
 	}
 
@@ -3017,15 +2974,15 @@ static ssize_t i915_perf_read(struct fil
 	 * and read() returning -EAGAIN. Clearing the oa.pollin state here
 	 * effectively ensures we back off until the next hrtimer callback
 	 * before reporting another EPOLLIN event.
+	 * The exception to this is if ops->read() returned -ENOSPC which means
+	 * that more OA data is available than could fit in the user provided
+	 * buffer. In this case we want the next poll() call to not block.
 	 */
-	if (ret >= 0 || ret == -EAGAIN) {
-		/* Maybe make ->pollin per-stream state if we support multiple
-		 * concurrent streams in the future.
-		 */
+	if (ret != -ENOSPC)
 		stream->pollin = false;
-	}
 
-	return ret;
+	/* Possible values for ret are 0, -EFAULT, -ENOSPC, -EIO, ... */
+	return offset ?: (ret ?: -EAGAIN);
 }
 
 static enum hrtimer_restart oa_poll_check_timer_cb(struct hrtimer *hrtimer)


