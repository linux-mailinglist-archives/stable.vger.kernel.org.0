Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD172CD3BF
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 11:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbgLCKfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 05:35:17 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:61916 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388697AbgLCKfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 05:35:17 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23199946-1500050 
        for multiple; Thu, 03 Dec 2020 10:34:33 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Propagate error from cancelled submit due to context closure
Date:   Thu,  3 Dec 2020 10:34:32 +0000
Message-Id: <20201203103432.31526-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the course of discovering and closing many races with context closure
and execbuf submission, since commit 61231f6bd056 ("drm/i915/gem: Check
that the context wasn't closed during setup") we started checking that
the context was not closed by another userspace thread during the execbuf
ioctl. In doing so we cancelled the inflight request (by telling it to be
skipped), but kept reporting success since we do submit a request, albeit
one that doesn't execute. As the error is known before we return from the
ioctl, we can report the error we detect immediately, rather than leave
it on the fence status. With the immediate propagation of the error, it
is easier for userspace to handle.

Fixes: 61231f6bd056 ("drm/i915/gem: Check that the context wasn't closed during setup")
Testcase: igt/gem_ctx_exec/basic-close-race
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.7+
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 1904e6e5ea64..b07dc1156a0e 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -3097,7 +3097,7 @@ static void retire_requests(struct intel_timeline *tl, struct i915_request *end)
 			break;
 }
 
-static void eb_request_add(struct i915_execbuffer *eb)
+static int eb_request_add(struct i915_execbuffer *eb, int err)
 {
 	struct i915_request *rq = eb->request;
 	struct intel_timeline * const tl = i915_request_timeline(rq);
@@ -3118,6 +3118,7 @@ static void eb_request_add(struct i915_execbuffer *eb)
 		/* Serialise with context_close via the add_to_timeline */
 		i915_request_set_error_once(rq, -ENOENT);
 		__i915_request_skip(rq);
+		err = -ENOENT; /* override any transient errors */
 	}
 
 	__i915_request_queue(rq, &attr);
@@ -3127,6 +3128,8 @@ static void eb_request_add(struct i915_execbuffer *eb)
 		retire_requests(tl, prev);
 
 	mutex_unlock(&tl->mutex);
+
+	return err;
 }
 
 static const i915_user_extension_fn execbuf_extensions[] = {
@@ -3332,7 +3335,7 @@ i915_gem_do_execbuffer(struct drm_device *dev,
 	err = eb_submit(&eb, batch);
 err_request:
 	i915_request_get(eb.request);
-	eb_request_add(&eb);
+	err = eb_request_add(&eb, err);
 
 	if (eb.fences)
 		signal_fence_array(&eb);
-- 
2.20.1

