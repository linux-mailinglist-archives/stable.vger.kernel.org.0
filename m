Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5671E7820
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgE2IUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 04:20:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:10357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgE2IUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 04:20:38 -0400
IronPort-SDR: JW5UzrUKle+UL8G4ayF/lZPwJyloTh4kVpYO9nBKhUyq/PC8GWseHfpQIzIWL4/QNTmRMtCVAz
 YRufR0k48ebQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:20:38 -0700
IronPort-SDR: j287+1DSMjf270NU5FOLHOLRkHCOd/wYTCCzJe9AzFoQTN4q1eEtLdcWgWd1K1XP/zwiWVM9O/
 2zqgYunRGJ/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="376641828"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2020 01:20:34 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     andi.shyti@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 10/23] drm/i915/gt: Close race between cacheline_retire and free
Date:   Fri, 29 May 2020 13:47:57 +0530
Message-Id: <20200529081810.10747-11-prasad.nallani@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529081810.10747-1-prasad.nallani@intel.com>
References: <20200529081810.10747-1-prasad.nallani@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

If the cacheline may still be busy, atomically mark it for future
release, and only if we can determine that it will never be used again,
immediately free it.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/1392
Fixes: ebece7539242 ("drm/i915: Keep timeline HWSP allocated until idle across the system")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Link: https://patchwork.freedesktop.org/patch/msgid/20200306154647.3528345-1-chris@chris-wilson.co.uk
(cherry picked from commit 2d4bd971f5baa51418625f379a69f5d58b5a0450)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 8ea6bb8e4d47e07518e5dba4f5cb77e210f0df82)
---
 drivers/gpu/drm/i915/gt/intel_timeline.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 23405e1558c6..3621273ad99a 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -192,11 +192,15 @@ static void cacheline_release(struct intel_timeline_cacheline *cl)
 
 static void cacheline_free(struct intel_timeline_cacheline *cl)
 {
+	if (!i915_active_acquire_if_busy(&cl->active)) {
+		__idle_cacheline_free(cl);
+		return;
+	}
+
 	GEM_BUG_ON(ptr_test_bit(cl->vaddr, CACHELINE_FREE));
 	cl->vaddr = ptr_set_bit(cl->vaddr, CACHELINE_FREE);
 
-	if (i915_active_is_idle(&cl->active))
-		__idle_cacheline_free(cl);
+	i915_active_release(&cl->active);
 }
 
 int intel_timeline_init(struct intel_timeline *timeline,
