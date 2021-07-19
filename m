Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33E43CE232
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347788AbhGSP32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348190AbhGSPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C50B6141A;
        Mon, 19 Jul 2021 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710600;
        bh=jg12mOpK9egcCR1Yae1/JahDu+SCbslYM283RCMqhis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tw4d3mJ7ySw3Eyz9qXk2Ms3F6gFwg5SVoDXF0wdLktQpJCmUsD7jvTeYVtzJgHDwR
         BDvg18ckrLWkLkVcOczrf0JBV5f713BCYvkzt7VZtHocbU3N2zr7HC5dfWogj4QbZW
         wcy3BVJQeW8TB4HoYHm2+Nv8tOMrYqYAnM3mw/c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.13 021/351] drm/i915/gt: Fix -EDEADLK handling regression
Date:   Mon, 19 Jul 2021 16:49:27 +0200
Message-Id: <20210719144945.229301158@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 2feeb52859fc1ab94cd35b61ada3a6ac4ff24243 upstream.

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
(cherry picked from commit 78d2ad7eb4e1f0e9cd5d79788446b6092c21d3e0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
@@ -348,7 +348,7 @@ static struct i915_fence_reg *fence_find
 	if (intel_has_pending_fb_unpin(ggtt->vm.i915))
 		return ERR_PTR(-EAGAIN);
 
-	return ERR_PTR(-EDEADLK);
+	return ERR_PTR(-ENOBUFS);
 }
 
 int __i915_vma_pin_fence(struct i915_vma *vma)


