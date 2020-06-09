Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183851F4047
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgFIQJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 12:09:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:61032 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731021AbgFIQJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 12:09:12 -0400
IronPort-SDR: 0zd9YWepe8gGV/mDmw9d4ISaA+fc62m8b2mfruk4sYLMMlLnD3XKBnJEZi69kwgV37Z8UpWN7Z
 rzEkDUnYE+aA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:09:04 -0700
IronPort-SDR: Rg6nwwKi/BmfTHZ7xkU1UTTkRLnZZFTNSRL4+EN+do9AHHUHesTK14meIbD5x0DbNMRjsN8yeH
 1CaIuFRek//w==
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="306306106"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:09:02 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 024/185] drm/i915: Actually emit the await_start
Date:   Tue,  9 Jun 2020 16:04:49 +0000
Message-Id: <20200609160731.287073-25-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200609160731.287073-1-chris@chris-wilson.co.uk>
References: <20200609160731.287073-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the inverted test to emit the wait on the end of the previous
request if we /haven't/ already.

Fixes: 6a79d848403d ("drm/i915: Lock signaler timeline while navigating")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200305104210.2619967-1-chris@chris-wilson.co.uk
(cherry picked from commit 07e9c59d63df6a1c44c1975c01827ba18b69270a)
---
 drivers/gpu/drm/i915/i915_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 191a538afa5a8..6c387fa1a8547 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -875,7 +875,7 @@ i915_request_await_start(struct i915_request *rq, struct i915_request *signal)
 		return 0;
 
 	err = 0;
-	if (intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
+	if (!intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
 		err = i915_sw_fence_await_dma_fence(&rq->submit,
 						    fence, 0,
 						    I915_FENCE_GFP);
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

