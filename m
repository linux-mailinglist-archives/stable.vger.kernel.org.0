Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251971E781D
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 10:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgE2IUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 04:20:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:10357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgE2IU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 04:20:29 -0400
IronPort-SDR: jblekRE1sPi4kR0CPPUXdVz3xW8e+51zWfd9QJYvKHLT7UptqxAPQWGMMghLj4IhgSzq19POpo
 2z9184nKchtg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:20:28 -0700
IronPort-SDR: tPnL0VOrukeokbuA9mIHgz4XmMuqU/RduODmGH3XJZ+dtO/2U4qV0VaktMjCYAbrxcOPmIMvF8
 tzqKCU/afbqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="376641786"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2020 01:20:25 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     andi.shyti@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 07/23] drm/i915: Return early for await_start on same timeline
Date:   Fri, 29 May 2020 13:47:54 +0530
Message-Id: <20200529081810.10747-8-prasad.nallani@intel.com>
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

Requests within a timeline are ordered by that timeline, so awaiting for
the start of a request within the timeline is a no-op. This used to work
by falling out of the mutex_trylock() as the signaler and waiter had the
same timeline and not returning an error.

Fixes: 6a79d848403d ("drm/i915: Lock signaler timeline while navigating")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200305134822.2750496-1-chris@chris-wilson.co.uk
(cherry picked from commit ab7a69020fb5d5c7ba19fba60f62fd6f9ca9f779)
---
 drivers/gpu/drm/i915/i915_request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 4143d0c6b343..1efc82f78f44 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -767,8 +767,8 @@ i915_request_await_start(struct i915_request *rq, struct i915_request *signal)
 	struct dma_fence *fence;
 	int err;
 
-	GEM_BUG_ON(i915_request_timeline(rq) ==
-		   rcu_access_pointer(signal->timeline));
+	if (i915_request_timeline(rq) == rcu_access_pointer(signal->timeline))
+		return 0;
 
 	fence = NULL;
 	rcu_read_lock();
