Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E3D272E1C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgIUQqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbgIUQq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04BE23888;
        Mon, 21 Sep 2020 16:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706785;
        bh=7O5/mVTf6EMICu1ADEXtjWEh7thCk7vf25nVfFHLSU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aD6jlBuLBF49rgkArm66Piep2EfPSJlQIT8L/QxW15meOnfLSwOCmUpddDUGZVQNa
         ZDEdWFSAqQMD8WjGj102t85tIDbNGqAhLiZ8iAsEq6aMPxbRk3sAJz6oZKrVYHZM1A
         QWGaTBxLgirpOZubZYwQe6beUEJouepvfGHkcD5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 064/118] drm/i915/gem: Reduce context termination list iteration guard to RCU
Date:   Mon, 21 Sep 2020 18:27:56 +0200
Message-Id: <20200921162039.326069868@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit c2314b8bd4c009793b6f9d57bc8363af034e02ca ]

As we now protect the timeline list using RCU, we can drop the
timeline->mutex for guarding the list iteration during context close, as
we are searching for an inflight request. Any new request will see the
context is banned and not be submitted. In doing so, pull the checks for
a concurrent submission of the request (notably the
i915_request_completed()) under the engine spinlock, to fully serialise
with __i915_request_submit()). That is in the case of preempt-to-busy
where the request may be completed during the __i915_request_submit(),
we need to be careful that we sample the request status after
serialising so that we don't miss the request the engine is actually
submitting.

Fixes: 4a3174152147 ("drm/i915/gem: Refine occupancy test in kill_context()")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200806105954.7766-1-chris@chris-wilson.co.uk
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit 736e785f9b28cd9ef2d16a80960a04fd00e64b22)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c | 32 ++++++++++++---------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 30c229fcb4046..6dce7d8b463eb 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -440,29 +440,36 @@ static bool __cancel_engine(struct intel_engine_cs *engine)
 	return __reset_engine(engine);
 }
 
-static struct intel_engine_cs *__active_engine(struct i915_request *rq)
+static bool
+__active_engine(struct i915_request *rq, struct intel_engine_cs **active)
 {
 	struct intel_engine_cs *engine, *locked;
+	bool ret = false;
 
 	/*
 	 * Serialise with __i915_request_submit() so that it sees
 	 * is-banned?, or we know the request is already inflight.
+	 *
+	 * Note that rq->engine is unstable, and so we double
+	 * check that we have acquired the lock on the final engine.
 	 */
 	locked = READ_ONCE(rq->engine);
 	spin_lock_irq(&locked->active.lock);
 	while (unlikely(locked != (engine = READ_ONCE(rq->engine)))) {
 		spin_unlock(&locked->active.lock);
-		spin_lock(&engine->active.lock);
 		locked = engine;
+		spin_lock(&locked->active.lock);
 	}
 
-	engine = NULL;
-	if (i915_request_is_active(rq) && rq->fence.error != -EIO)
-		engine = rq->engine;
+	if (!i915_request_completed(rq)) {
+		if (i915_request_is_active(rq) && rq->fence.error != -EIO)
+			*active = locked;
+		ret = true;
+	}
 
 	spin_unlock_irq(&locked->active.lock);
 
-	return engine;
+	return ret;
 }
 
 static struct intel_engine_cs *active_engine(struct intel_context *ce)
@@ -473,17 +480,16 @@ static struct intel_engine_cs *active_engine(struct intel_context *ce)
 	if (!ce->timeline)
 		return NULL;
 
-	mutex_lock(&ce->timeline->mutex);
-	list_for_each_entry_reverse(rq, &ce->timeline->requests, link) {
-		if (i915_request_completed(rq))
-			break;
+	rcu_read_lock();
+	list_for_each_entry_rcu(rq, &ce->timeline->requests, link) {
+		if (i915_request_is_active(rq) && i915_request_completed(rq))
+			continue;
 
 		/* Check with the backend if the request is inflight */
-		engine = __active_engine(rq);
-		if (engine)
+		if (__active_engine(rq, &engine))
 			break;
 	}
-	mutex_unlock(&ce->timeline->mutex);
+	rcu_read_unlock();
 
 	return engine;
 }
-- 
2.25.1



