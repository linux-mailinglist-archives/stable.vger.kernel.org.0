Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC49E34C842
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhC2IVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhC2IUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A83F6196E;
        Mon, 29 Mar 2021 08:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006019;
        bh=qyMHGP+SBVIDUMUTI3TBPKrqIWEfEvW+V0jy7ZCVG7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLyAC2V/5rfgJ5pm7/CPRkKTv3Qja7wBp2lVWCJ1s0v2SnYPeCkkBz5rG6+QGBEla
         OsUaQ9VXVlipLC70pi5DDRzXi/bPCrD3gTpY6KMO/qFWOaYnNnGqFsFrKGXUx+Wca8
         unP2tcFb5OuJNCXFX7DNtCy6CPpzYqxz17fMYEKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.10 088/221] drm/i915: Fix the GT fence revocation runtime PM logic
Date:   Mon, 29 Mar 2021 09:56:59 +0200
Message-Id: <20210329075632.146540194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 8840e3bd981f128846b01c12d3966d115e8617c9 upstream.

To optimize some task deferring it until runtime resume unless someone
holds a runtime PM reference (because in this case the task can be done
w/o the overhead of runtime resume), we have to use the runtime PM
get-if-active logic: If the runtime PM usage count is 0 (and so
get-if-in-use would return false) the runtime suspend handler is not
necessarily called yet (it could be just pending), so the device is not
necessarily powered down, and so the runtime resume handler is not
guaranteed to be called.

The fence revocation depends on the above deferral, so add a
get-if-active helper and use it during fence revocation.

v2:
- Add code comment explaining the fence reg programming deferral logic
  to i915_vma_revoke_fence(). (Chris)
- Add Cc: stable and Fixes: tags. (Chris)
- Fix the function docbook comment.

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.12+
Fixes: 181df2d458f3 ("drm/i915: Take rpm wakelock for releasing the fence on unbind")
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210322204223.919936-1-imre.deak@intel.com
(cherry picked from commit 9d58aa46291d4d696bb1eac3436d3118f7bf2573)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c |   13 +++++++++++-
 drivers/gpu/drm/i915/intel_runtime_pm.c      |   29 ++++++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_runtime_pm.h      |    5 ++++
 3 files changed, 41 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
@@ -316,7 +316,18 @@ void i915_vma_revoke_fence(struct i915_v
 	WRITE_ONCE(fence->vma, NULL);
 	vma->fence = NULL;
 
-	with_intel_runtime_pm_if_in_use(fence_to_uncore(fence)->rpm, wakeref)
+	/*
+	 * Skip the write to HW if and only if the device is currently
+	 * suspended.
+	 *
+	 * If the driver does not currently hold a wakeref (if_in_use == 0),
+	 * the device may currently be runtime suspended, or it may be woken
+	 * up before the suspend takes place. If the device is not suspended
+	 * (powered down) and we skip clearing the fence register, the HW is
+	 * left in an undefined state where we may end up with multiple
+	 * registers overlapping.
+	 */
+	with_intel_runtime_pm_if_active(fence_to_uncore(fence)->rpm, wakeref)
 		fence_write(fence);
 }
 
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -412,12 +412,20 @@ intel_wakeref_t intel_runtime_pm_get(str
 }
 
 /**
- * intel_runtime_pm_get_if_in_use - grab a runtime pm reference if device in use
+ * __intel_runtime_pm_get_if_active - grab a runtime pm reference if device is active
  * @rpm: the intel_runtime_pm structure
+ * @ignore_usecount: get a ref even if dev->power.usage_count is 0
  *
  * This function grabs a device-level runtime pm reference if the device is
- * already in use and ensures that it is powered up. It is illegal to try
- * and access the HW should intel_runtime_pm_get_if_in_use() report failure.
+ * already active and ensures that it is powered up. It is illegal to try
+ * and access the HW should intel_runtime_pm_get_if_active() report failure.
+ *
+ * If @ignore_usecount=true, a reference will be acquired even if there is no
+ * user requiring the device to be powered up (dev->power.usage_count == 0).
+ * If the function returns false in this case then it's guaranteed that the
+ * device's runtime suspend hook has been called already or that it will be
+ * called (and hence it's also guaranteed that the device's runtime resume
+ * hook will be called eventually).
  *
  * Any runtime pm reference obtained by this function must have a symmetric
  * call to intel_runtime_pm_put() to release the reference again.
@@ -425,7 +433,8 @@ intel_wakeref_t intel_runtime_pm_get(str
  * Returns: the wakeref cookie to pass to intel_runtime_pm_put(), evaluates
  * as True if the wakeref was acquired, or False otherwise.
  */
-intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm)
+static intel_wakeref_t __intel_runtime_pm_get_if_active(struct intel_runtime_pm *rpm,
+							bool ignore_usecount)
 {
 	if (IS_ENABLED(CONFIG_PM)) {
 		/*
@@ -434,7 +443,7 @@ intel_wakeref_t intel_runtime_pm_get_if_
 		 * function, since the power state is undefined. This applies
 		 * atm to the late/early system suspend/resume handlers.
 		 */
-		if (pm_runtime_get_if_in_use(rpm->kdev) <= 0)
+		if (pm_runtime_get_if_active(rpm->kdev, ignore_usecount) <= 0)
 			return 0;
 	}
 
@@ -443,6 +452,16 @@ intel_wakeref_t intel_runtime_pm_get_if_
 	return track_intel_runtime_pm_wakeref(rpm);
 }
 
+intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm)
+{
+	return __intel_runtime_pm_get_if_active(rpm, false);
+}
+
+intel_wakeref_t intel_runtime_pm_get_if_active(struct intel_runtime_pm *rpm)
+{
+	return __intel_runtime_pm_get_if_active(rpm, true);
+}
+
 /**
  * intel_runtime_pm_get_noresume - grab a runtime pm reference
  * @rpm: the intel_runtime_pm structure
--- a/drivers/gpu/drm/i915/intel_runtime_pm.h
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.h
@@ -177,6 +177,7 @@ void intel_runtime_pm_driver_release(str
 
 intel_wakeref_t intel_runtime_pm_get(struct intel_runtime_pm *rpm);
 intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm);
+intel_wakeref_t intel_runtime_pm_get_if_active(struct intel_runtime_pm *rpm);
 intel_wakeref_t intel_runtime_pm_get_noresume(struct intel_runtime_pm *rpm);
 intel_wakeref_t intel_runtime_pm_get_raw(struct intel_runtime_pm *rpm);
 
@@ -188,6 +189,10 @@ intel_wakeref_t intel_runtime_pm_get_raw
 	for ((wf) = intel_runtime_pm_get_if_in_use(rpm); (wf); \
 	     intel_runtime_pm_put((rpm), (wf)), (wf) = 0)
 
+#define with_intel_runtime_pm_if_active(rpm, wf) \
+	for ((wf) = intel_runtime_pm_get_if_active(rpm); (wf); \
+	     intel_runtime_pm_put((rpm), (wf)), (wf) = 0)
+
 void intel_runtime_pm_put_unchecked(struct intel_runtime_pm *rpm);
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_RUNTIME_PM)
 void intel_runtime_pm_put(struct intel_runtime_pm *rpm, intel_wakeref_t wref);


