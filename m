Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1823D3B8738
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 18:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhF3Qqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 12:46:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:45530 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhF3Qqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 12:46:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="272240772"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="272240772"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 09:44:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="457316165"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 30 Jun 2021 09:44:14 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 30 Jun 2021 19:44:13 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>
Subject: [PATCH] drm/i915/gt: Fix -EDEADLK handling regression
Date:   Wed, 30 Jun 2021 19:44:13 +0300
Message-Id: <20210630164413.25481-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

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
---
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.31.1

