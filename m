Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880E72D9EA9
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408856AbgLNSGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408609AbgLNRjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:19 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 090/105] drm/i915/gem: Propagate error from cancelled submit due to context closure
Date:   Mon, 14 Dec 2020 18:29:04 +0100
Message-Id: <20201214172559.616134191@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0e124e19ce52d20b28ee9f1d5cdb22e2106bfd29 upstream.

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
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201203103432.31526-1-chris@chris-wilson.co.uk
(cherry picked from commit ba38b79eaeaeed29d2383f122d5c711ebf5ed3d1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2613,7 +2613,7 @@ static void retire_requests(struct intel
 			break;
 }
 
-static void eb_request_add(struct i915_execbuffer *eb)
+static int eb_request_add(struct i915_execbuffer *eb, int err)
 {
 	struct i915_request *rq = eb->request;
 	struct intel_timeline * const tl = i915_request_timeline(rq);
@@ -2634,6 +2634,7 @@ static void eb_request_add(struct i915_e
 		/* Serialise with context_close via the add_to_timeline */
 		i915_request_set_error_once(rq, -ENOENT);
 		__i915_request_skip(rq);
+		err = -ENOENT; /* override any transient errors */
 	}
 
 	__i915_request_queue(rq, &attr);
@@ -2643,6 +2644,8 @@ static void eb_request_add(struct i915_e
 		retire_requests(tl, prev);
 
 	mutex_unlock(&tl->mutex);
+
+	return err;
 }
 
 static int
@@ -2844,7 +2847,7 @@ i915_gem_do_execbuffer(struct drm_device
 err_request:
 	add_to_client(eb.request, file);
 	i915_request_get(eb.request);
-	eb_request_add(&eb);
+	err = eb_request_add(&eb, err);
 
 	if (fences)
 		signal_fence_array(&eb, fences);


