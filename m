Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2737222B6F0
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgGWTvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 15:51:15 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:52205 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725894AbgGWTvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 15:51:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21911859-1500050 
        for multiple; Thu, 23 Jul 2020 20:51:12 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Filter wake_flags passed to default_wake_function
Date:   Thu, 23 Jul 2020 20:51:10 +0100
Message-Id: <20200723195110.11540-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The flags passed to the wait_entry.func are passed onwards to
try_to_wake_up(), which has a very particular interpretation for its
wake_flags. In particular, beyond the published WF_SYNC, it has a few
internal flags as well. Since we passed the fence->error down the chain
via the flags argument, these ended up in the default_wake_function
confusing the kernel/sched.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2110
Fixes: ef4688497512 ("drm/i915: Propagate fence errors")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/i915_sw_fence.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_sw_fence.c b/drivers/gpu/drm/i915/i915_sw_fence.c
index 295b9829e2da..4cd2038cbe35 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -164,9 +164,13 @@ static void __i915_sw_fence_wake_up_all(struct i915_sw_fence *fence,
 
 		do {
 			list_for_each_entry_safe(pos, next, &x->head, entry) {
-				pos->func(pos,
-					  TASK_NORMAL, fence->error,
-					  &extra);
+				int wake_flags;
+
+				wake_flags = fence->error;
+				if (pos->func == autoremove_wake_function)
+					wake_flags = 0;
+
+				pos->func(pos, TASK_NORMAL, wake_flags, &extra);
 			}
 
 			if (list_empty(&extra))
-- 
2.20.1

