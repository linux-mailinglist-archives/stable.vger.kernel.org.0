Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C0B3137D3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhBHPcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230436AbhBHP1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49DB864E7C;
        Mon,  8 Feb 2021 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797357;
        bh=R2ZujSeE79OQnETMoDHxIGB23QtFZXzrmpxPpPKDPac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5X+lwBrCJzC1XpAfrcw67WvCMB//dhHkWT0nsvqV2000RfQj9QMWr3JyeztpQQai
         9a9ChuyQdcv0F9G6FJ4eUm9B7S4N9ZaUt6V7DY5IVhGAXunXjtF8STEYwzzN5RJ8WC
         pY8IUcDBnNgADAJgwfq94Y0YdPAz7n9TIyCiYRdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 081/120] drm/i915/gt: Close race between enable_breadcrumbs and cancel_breadcrumbs
Date:   Mon,  8 Feb 2021 16:01:08 +0100
Message-Id: <20210208145821.629947377@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit e4747cb3ec3c232d65c84cbe77633abd5871fda3 upstream.

If we enable_breadcrumbs for a request while that request is being
removed from HW; we may see that the request is active as we take the
ce->signal_lock and proceed to attach the request to ce->signals.
However, during unsubmission after marking the request as inactive, we
see that the request has not yet been added to ce->signals and so skip
the removal. Pull the check during cancel_breadcrumbs under the same
spinlock as enabling so that we the two tests are consistent in
enable/cancel.

Otherwise, we may insert a request onto ce->signals that we expect should
not be there:

  intel_context_remove_breadcrumbs:488 GEM_BUG_ON(!__i915_request_is_complete(rq))

While updating, we can note that we are always called with
irqs-disabled, due to the engine->active.lock being held at the single
caller, and so remove the irqsave/restore making it symmetric to
enable_breadcrumbs.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2931
Fixes: c18636f76344 ("drm/i915: Remove requirement for holding i915_request.lock for breadcrumbs")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: <stable@vger.kernel.org> # v5.10+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210119162057.31097-1-chris@chris-wilson.co.uk
(cherry picked from commit e7004ea4f5f528f5a5018f0b70cab36d25315498)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -451,10 +451,12 @@ void i915_request_cancel_breadcrumb(stru
 	struct intel_context *ce = rq->context;
 	bool release;
 
-	if (!test_and_clear_bit(I915_FENCE_FLAG_SIGNAL, &rq->fence.flags))
+	spin_lock(&ce->signal_lock);
+	if (!test_and_clear_bit(I915_FENCE_FLAG_SIGNAL, &rq->fence.flags)) {
+		spin_unlock(&ce->signal_lock);
 		return;
+	}
 
-	spin_lock(&ce->signal_lock);
 	list_del_rcu(&rq->signal_link);
 	release = remove_signaling_context(rq->engine->breadcrumbs, ce);
 	spin_unlock(&ce->signal_lock);


