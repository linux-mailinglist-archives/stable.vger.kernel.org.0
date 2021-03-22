Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F02734414D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhCVMcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhCVMbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63F39619A3;
        Mon, 22 Mar 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416300;
        bh=QX/kW6ynz4hoZf/ztQb+b6xyWKTXGxR+QwQ42/7E//E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6q85Tri+VPrWzqizZeeC+Mk+IIWtB/DjB4Run5X8rprmfgGBmpnL1MRkVvvIghVl
         XfzSKQKv+3bq16Dsws/LUPGYh02HXU97akyKn1eGBaUMzR9mpWOLT09tIEjPYxk7/O
         63K80+q7u+3Wk7D5UQD0AmC3hF6xbLciSuHytXI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.11 054/120] i915/perf: Start hrtimer only if sampling the OA buffer
Date:   Mon, 22 Mar 2021 13:27:17 +0100
Message-Id: <20210322121931.489806555@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

commit 6a77c6bb7260bd5000f95df454d9f8cdb1af7132 upstream.

SAMPLE_OA parameter enables sampling of OA buffer and results in a call
to init the OA buffer which initializes the OA unit head/tail pointers.
The OA_EXPONENT parameter controls the periodicity of the OA reports in
the OA buffer and results in starting a hrtimer.

Before gen12, all use cases required the use of the OA buffer and i915
enforced this setting when vetting out the parameters passed. In these
platforms the hrtimer was enabled if OA_EXPONENT was passed. This worked
fine since it was implied that SAMPLE_OA is always passed.

With gen12, this changed. Users can use perf without enabling the OA
buffer as in OAR use cases. While an OAR use case should ideally not
start the hrtimer, we see that passing an OA_EXPONENT parameter will
start the hrtimer even though SAMPLE_OA is not specified. This results
in an uninitialized OA buffer, so the head/tail pointers used to track
the buffer are zero.

This itself does not fail, but if we ran a use-case that SAMPLED the OA
buffer previously, then the OA_TAIL register is still pointing to an old
value. When the timer callback runs, it ends up calculating a
wrong/large number of available reports. Since we do a spinlock_irq_save
and start processing a large number of reports, NMI watchdog fires and
causes a crash.

Start the timer only if SAMPLE_OA is specified.

v2:
- Drop SAMPLE OA check when appending samples (Ashutosh)
- Prevent read if OA buffer is not being sampled

Fixes: 00a7f0d7155c ("drm/i915/tgl: Add perf support on TGL")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210305210947.58751-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit be0bdd67fda9468156c733976688f6487d0c42f7)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_perf.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -600,7 +600,6 @@ static int append_oa_sample(struct i915_
 {
 	int report_size = stream->oa_buffer.format_size;
 	struct drm_i915_perf_record_header header;
-	u32 sample_flags = stream->sample_flags;
 
 	header.type = DRM_I915_PERF_RECORD_SAMPLE;
 	header.pad = 0;
@@ -614,10 +613,8 @@ static int append_oa_sample(struct i915_
 		return -EFAULT;
 	buf += sizeof(header);
 
-	if (sample_flags & SAMPLE_OA_REPORT) {
-		if (copy_to_user(buf, report, report_size))
-			return -EFAULT;
-	}
+	if (copy_to_user(buf, report, report_size))
+		return -EFAULT;
 
 	(*offset) += header.size;
 
@@ -2678,7 +2675,7 @@ static void i915_oa_stream_enable(struct
 
 	stream->perf->ops.oa_enable(stream);
 
-	if (stream->periodic)
+	if (stream->sample_flags & SAMPLE_OA_REPORT)
 		hrtimer_start(&stream->poll_check_timer,
 			      ns_to_ktime(stream->poll_oa_period),
 			      HRTIMER_MODE_REL_PINNED);
@@ -2741,7 +2738,7 @@ static void i915_oa_stream_disable(struc
 {
 	stream->perf->ops.oa_disable(stream);
 
-	if (stream->periodic)
+	if (stream->sample_flags & SAMPLE_OA_REPORT)
 		hrtimer_cancel(&stream->poll_check_timer);
 }
 
@@ -3024,7 +3021,7 @@ static ssize_t i915_perf_read(struct fil
 	 * disabled stream as an error. In particular it might otherwise lead
 	 * to a deadlock for blocking file descriptors...
 	 */
-	if (!stream->enabled)
+	if (!stream->enabled || !(stream->sample_flags & SAMPLE_OA_REPORT))
 		return -EIO;
 
 	if (!(file->f_flags & O_NONBLOCK)) {


