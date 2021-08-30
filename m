Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C443FB5D0
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhH3MQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhH3MQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 08:16:10 -0400
X-Greylist: delayed 322 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Aug 2021 05:15:16 PDT
Received: from mblankhorst.nl (mblankhorst.nl [IPv6:2a02:2308:0:7ec:e79c:4e97:b6c4:f0ae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A4EC061760
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:15:16 -0700 (PDT)
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH 08/19] drm/i915: Fix runtime pm handling in i915_gem_shrink
Date:   Mon, 30 Aug 2021 14:09:55 +0200
Message-Id: <20210830121006.2978297-9-maarten.lankhorst@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210830121006.2978297-1-maarten.lankhorst@linux.intel.com>
References: <20210830121006.2978297-1-maarten.lankhorst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We forgot to call intel_runtime_pm_put on error, fix it!

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: cf41a8f1dc1e ("drm/i915: Finally remove obj->mm.lock.")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org> # v5.13+
---
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
index e382b7f2353b..5ab136ffdeb2 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
@@ -118,7 +118,7 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
 	intel_wakeref_t wakeref = 0;
 	unsigned long count = 0;
 	unsigned long scanned = 0;
-	int err;
+	int err = 0;
 
 	/* CHV + VTD workaround use stop_machine(); need to trylock vm->mutex */
 	bool trylock_vm = !ww && intel_vm_no_concurrent_access_wa(i915);
@@ -242,12 +242,15 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
 		list_splice_tail(&still_in_list, phase->list);
 		spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
 		if (err)
-			return err;
+			break;
 	}
 
 	if (shrink & I915_SHRINK_BOUND)
 		intel_runtime_pm_put(&i915->runtime_pm, wakeref);
 
+	if (err)
+		return err;
+
 	if (nr_scanned)
 		*nr_scanned += scanned;
 	return count;
-- 
2.32.0

