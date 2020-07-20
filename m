Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA712267F2
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388481AbgGTQP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388474AbgGTQP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC0C206E9;
        Mon, 20 Jul 2020 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261758;
        bh=zVakChvhnunGp+SzAPVKRY/ExakFe2p7dY0/6aJ6K2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCDBLw/3kHR7RXdsI3MFiDO6AW4q+wowB59HRoXNRD4LX43xw6eczm7yKRFbgS2fX
         5EP2lVNvYnHkLp1Fc7OTFsbEH0kgOmrXQv8lUgLzVNqz60Yop2S6HTpa6omlI6Gp8q
         KMjZa0ZqTtpEAZ8QUg5JSUU4QLmEOM8CeH1q4yYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.7 231/244] drm/i915/gt: Only swap to a random sibling once upon creation
Date:   Mon, 20 Jul 2020 17:38:22 +0200
Message-Id: <20200720152836.830139409@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 110f9efa858f584c6bed177cd48d0c0f526940e1 upstream.

The danger in switching at random upon intel_context_pin is that the
context may still actually be inflight, as it will not be scheduled out
until a context switch after it is complete -- that may be a long time
after we do a final intel_context_unpin.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2118
Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200713160549.17344-1-chris@chris-wilson.co.uk
(cherry picked from commit 90a987205c6cf74116a102ed446d22d92cdaf915)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -4897,13 +4897,8 @@ static void virtual_engine_initial_hint(
 	 * typically be the first we inspect for submission.
 	 */
 	swp = prandom_u32_max(ve->num_siblings);
-	if (!swp)
-		return;
-
-	swap(ve->siblings[swp], ve->siblings[0]);
-	if (!intel_engine_has_relative_mmio(ve->siblings[0]))
-		virtual_update_register_offsets(ve->context.lrc_reg_state,
-						ve->siblings[0]);
+	if (swp)
+		swap(ve->siblings[swp], ve->siblings[0]);
 }
 
 static int virtual_context_alloc(struct intel_context *ce)
@@ -4916,15 +4911,9 @@ static int virtual_context_alloc(struct
 static int virtual_context_pin(struct intel_context *ce)
 {
 	struct virtual_engine *ve = container_of(ce, typeof(*ve), context);
-	int err;
 
 	/* Note: we must use a real engine class for setting up reg state */
-	err = __execlists_context_pin(ce, ve->siblings[0]);
-	if (err)
-		return err;
-
-	virtual_engine_initial_hint(ve);
-	return 0;
+	return __execlists_context_pin(ce, ve->siblings[0]);
 }
 
 static void virtual_context_enter(struct intel_context *ce)
@@ -5270,6 +5259,7 @@ intel_execlists_create_virtual(struct in
 
 	ve->base.flags |= I915_ENGINE_IS_VIRTUAL;
 
+	virtual_engine_initial_hint(ve);
 	return &ve->context;
 
 err_put:


