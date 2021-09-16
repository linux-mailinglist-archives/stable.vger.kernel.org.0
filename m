Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E008240DAD3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbhIPNN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239581AbhIPNN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:13:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D523C60FBF;
        Thu, 16 Sep 2021 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797926;
        bh=PDriSX6WDoHSZcr4Oza/kXahicIWac4x90vELBrw7z8=;
        h=Subject:To:Cc:From:Date:From;
        b=xHanxXHHsbcD9d3EZIEnHj3G2puU/LIX6sK7YAUwHz88UqO/szEJoOJk12MwgVGmy
         E0r6Ktzk1mEdUVJvUpL57gRakdTbQBKNNqD+rEugLOES97v5wBQEKwRMpParXM3fO6
         dq08CXe0cm9F7j9Q+2Mqwm5S0Vg3M83rQtxVvIqg=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Fix -EDEADLK handling regression" failed to apply to 5.13-stable tree
To:     ville.syrjala@linux.intel.com, maarten.lankhorst@linux.intel.com,
        thomas.hellstrom@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:11:56 +0200
Message-ID: <1631797916188169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 78d2ad7eb4e1f0e9cd5d79788446b6092c21d3e0 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 30 Jun 2021 19:44:13 +0300
Subject: [PATCH] drm/i915/gt: Fix -EDEADLK handling regression
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The conversion to ww mutexes failed to address the fence code which
already returns -EDEADLK when we run out of fences. Ww mutexes on
the other hand treat -EDEADLK as an internal errno value indicating
a need to restart the operation due to a deadlock. So now when the
fence code returns -EDEADLK the higher level code erroneously
restarts everything instead of returning the error to userspace
as is expected.

To remedy this let's switch the fence code to use a different errno
value for this. -ENOBUFS seems like a semi-reasonable unique choice.
Apart from igt the only user of this I could find is sna, and even
there all we do is dump the current fence registers from debugfs
into the X server log. So no user visible functionality is affected.
If we really cared about preserving this we could of course convert
back to -EDEADLK higher up, but doesn't seem like that's worth
the hassle here.

Not quite sure which commit specifically broke this, but I'll
just attribute it to the general gem ww mutex work.

Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com>
Testcase: igt/gem_pread/exhaustion
Testcase: igt/gem_pwrite/basic-exhaustion
Testcase: igt/gem_fenced_exec_thrash/too-many-fences
Fixes: 80f0b679d6f0 ("drm/i915: Add an implementation for i915_gem_ww_ctx locking, v2.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210630164413.25481-1-ville.syrjala@linux.intel.com
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
index cac7f3f44642..f8948de72036 100644
--- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
@@ -348,7 +348,7 @@ static struct i915_fence_reg *fence_find(struct i915_ggtt *ggtt)
 	if (intel_has_pending_fb_unpin(ggtt->vm.i915))
 		return ERR_PTR(-EAGAIN);
 
-	return ERR_PTR(-EDEADLK);
+	return ERR_PTR(-ENOBUFS);
 }
 
 int __i915_vma_pin_fence(struct i915_vma *vma)

