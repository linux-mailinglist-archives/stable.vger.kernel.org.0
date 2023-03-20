Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667F26C1121
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 12:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjCTLsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 07:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCTLsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 07:48:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4BDD510
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 04:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679312900; x=1710848900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rUKfaQ1CwhO2oDUj3ylBKL/ohPP9zlJZx4DvnUjHSUI=;
  b=C5FC8igEtu5qy6szJ0Iu5pZoEwOUudrBkwHA1V2lk0F2t7p4hiMTlbAd
   Z7rolEkik26v005tMf4+8pPm1tFxaW0JdYfB0cCsVnautuj3wgXCFikS2
   U0BBFgl86U5NOPChwqg+tkiZdxXOOOSeLRlVSXC5uToyMfrJY4I+gdcmm
   3YH9LeJvLowWCrgMafQ/hQRuda/rHtkvDJScqy7zgGDHj0gINYamCDy+9
   m9aEumZNxO0kkXEuqb1FS9xP7249S2/EbDSI9uLhhxGSzCODUkHc1BcF1
   f0CBGkF5+UHsr4Vtd6FyYXXNv8Hli6QbrYg+npszDgQ2ejwvkNXgB+n68
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="338665046"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="338665046"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 04:48:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="926935368"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="926935368"
Received: from pkotynia-desk.ger.corp.intel.com (HELO jkrzyszt-mobl1.ger.corp.intel.com) ([10.213.5.235])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 04:48:18 -0700
From:   Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Subject: [PATCH 5.15.y] drm/i915/active: Fix misuse of non-idle barriers as fence trackers
Date:   Mon, 20 Mar 2023 12:47:52 +0100
Message-Id: <20230320114752.169004-1-janusz.krzysztofik@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1679307444199182@kroah.com>
References: <1679307444199182@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Users reported oopses on list corruptions when using i915 perf with a
number of concurrently running graphics applications.  Root cause analysis
pointed at an issue in barrier processing code -- a race among perf open /
close replacing active barriers with perf requests on kernel context and
concurrent barrier preallocate / acquire operations performed during user
context first pin / last unpin.

When adding a request to a composite tracker, we try to reuse an existing
fence tracker, already allocated and registered with that composite.  The
tracker we obtain may already track another fence, may be an idle barrier,
or an active barrier.

If the tracker we get occurs a non-idle barrier then we try to delete that
barrier from a list of barrier tasks it belongs to.  However, while doing
that we don't respect return value from a function that performs the
barrier deletion.  Should the deletion ever fail, we would end up reusing
the tracker still registered as a barrier task.  Since the same structure
field is reused with both fence callback lists and barrier tasks list,
list corruptions would likely occur.

Barriers are now deleted from a barrier tasks list by temporarily removing
the list content, traversing that content with skip over the node to be
deleted, then populating the list back with the modified content.  Should
that intentionally racy concurrent deletion attempts be not serialized,
one or more of those may fail because of the list being temporary empty.

Related code that ignores the results of barrier deletion was initially
introduced in v5.4 by commit d8af05ff38ae ("drm/i915: Allow sharing the
idle-barrier from other kernel requests").  However, all users of the
barrier deletion routine were apparently serialized at that time, then the
issue didn't exhibit itself.  Results of git bisect with help of a newly
developed igt@gem_barrier_race@remote-request IGT test indicate that list
corruptions might start to appear after commit 311770173fac ("drm/i915/gt:
Schedule request retirement when timeline idles"), introduced in v5.5.

Respect results of barrier deletion attempts -- mark the barrier as idle
only if successfully deleted from the list.  Then, before proceeding with
setting our fence as the one currently tracked, make sure that the tracker
we've got is not a non-idle barrier.  If that check fails then don't use
that tracker but go back and try to acquire a new, usable one.

v3: use unlikely() to document what outcome we expect (Andi),
  - fix bad grammar in commit description.
v2: no code changes,
  - blame commit 311770173fac ("drm/i915/gt: Schedule request retirement
    when timeline idles"), v5.5, not commit d8af05ff38ae ("drm/i915: Allow
    sharing the idle-barrier from other kernel requests"), v5.4,
  - reword commit description.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6333
Fixes: 311770173fac ("drm/i915/gt: Schedule request retirement when timeline idles")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org # v5.5
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230302120820.48740-1-janusz.krzysztofik@linux.intel.com
(cherry picked from commit 506006055769b10d1b2b4e22f636f3b45e0e9fc7)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit e0e6b416b25ee14716f3549e0cbec1011b193809)
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_active.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 3103c1e1fd148..283c5091005ec 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -422,8 +422,7 @@ replace_barrier(struct i915_active *ref, struct i915_active_fence *active)
 	 * we can use it to substitute for the pending idle-barrer
 	 * request that we want to emit on the kernel_context.
 	 */
-	__active_del_barrier(ref, node_from_active(active));
-	return true;
+	return __active_del_barrier(ref, node_from_active(active));
 }
 
 int i915_active_ref(struct i915_active *ref, u64 idx, struct dma_fence *fence)
@@ -436,16 +435,19 @@ int i915_active_ref(struct i915_active *ref, u64 idx, struct dma_fence *fence)
 	if (err)
 		return err;
 
-	active = active_instance(ref, idx);
-	if (!active) {
-		err = -ENOMEM;
-		goto out;
-	}
+	do {
+		active = active_instance(ref, idx);
+		if (!active) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		if (replace_barrier(ref, active)) {
+			RCU_INIT_POINTER(active->fence, NULL);
+			atomic_dec(&ref->count);
+		}
+	} while (unlikely(is_barrier(active)));
 
-	if (replace_barrier(ref, active)) {
-		RCU_INIT_POINTER(active->fence, NULL);
-		atomic_dec(&ref->count);
-	}
 	if (!__i915_active_fence_set(active, fence))
 		__i915_active_acquire(ref);
 
-- 
2.25.1

