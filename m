Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD6430CCB5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240312AbhBBUF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232715AbhBBNnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4110F64F69;
        Tue,  2 Feb 2021 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273216;
        bh=SuaqPjJeRzovVcZthpTQGI6mBv/Tovh+I0x//MkMnWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2wxaZw9nJXI6iVIUqL4x7ZqF+VJcNbCRkahAwPWMRJ27i0iBIBMaRFmeyKICJY8X
         N9eYdE+50WQ9M1oJCemrFqOiRnbUjHECHXLRRlzXmeAwszgGhSdcRt0ekSfQThgfbU
         8P81m3OoeB6MYqbNpXgbnX5DLsj1aOYqVguOVKVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 024/142] drm/i915: Always flush the active worker before returning from the wait
Date:   Tue,  2 Feb 2021 14:36:27 +0100
Message-Id: <20210202132958.712870599@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit f6e98a1809faa02f40e0d089d6cfc1aa372a34c0 upstream.

The first thing the active retirement worker does is decrement the
i915_active count.

The first thing we do during i915_active_wait is try to increment the
i915_active count, but only if already active [non-zero].

The wait may see that the retirement is already started and so marked the
i915_active as idle, and skip waiting for the retirement handler.
However, the caller of i915_active_wait may immediately free the
i915_active upon returning (e.g. i915_vma_destroy) so we must not return
before the concurrent access from the worker is completed. We must
always flush the worker.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2473
Fixes: 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210121232807.16618-1-chris@chris-wilson.co.uk
(cherry picked from commit 977a372e972cb42799746c284035a33c64ebace9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 10a865f3dc09..9ed19b8bca60 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -631,24 +631,26 @@ static int flush_lazy_signals(struct i915_active *ref)
 
 int __i915_active_wait(struct i915_active *ref, int state)
 {
-	int err;
-
 	might_sleep();
 
-	if (!i915_active_acquire_if_busy(ref))
-		return 0;
-
 	/* Any fence added after the wait begins will not be auto-signaled */
-	err = flush_lazy_signals(ref);
-	i915_active_release(ref);
-	if (err)
-		return err;
+	if (i915_active_acquire_if_busy(ref)) {
+		int err;
 
-	if (!i915_active_is_idle(ref) &&
-	    ___wait_var_event(ref, i915_active_is_idle(ref),
-			      state, 0, 0, schedule()))
-		return -EINTR;
+		err = flush_lazy_signals(ref);
+		i915_active_release(ref);
+		if (err)
+			return err;
 
+		if (___wait_var_event(ref, i915_active_is_idle(ref),
+				      state, 0, 0, schedule()))
+			return -EINTR;
+	}
+
+	/*
+	 * After the wait is complete, the caller may free the active.
+	 * We have to flush any concurrent retirement before returning.
+	 */
 	flush_work(&ref->work);
 	return 0;
 }


