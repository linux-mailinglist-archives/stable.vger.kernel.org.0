Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D872ABA21
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbgKINQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387413AbgKINQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C49542083B;
        Mon,  9 Nov 2020 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927759;
        bh=iOP7ju+nsPVXObKAVE6nR2KtqnYhNzet9YneRx9ANnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlkQjDn3/KlwbDfSM4x5kcYt5uv4Hr8ddLKvnHWeg/FoMRERjDK6UbmRHJGN4cjpG
         4jkWFXJLmZfofHZit8hl7q3Ltec8aq8igERg4KLfkV+IH5EjSrGLX29XajleQkhtth
         3OrEekDUKTQh6+PCuQuvnXlq4L3sq5M3o3qEz0GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 012/133] drm/i915/gt: Undo forced context restores after trivial preemptions
Date:   Mon,  9 Nov 2020 13:54:34 +0100
Message-Id: <20201109125031.305457660@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 64402570e12f7b63ab33fc4640d3709c9ce2b380 upstream.

We may try to preempt the currently executing request, only to find that
after unravelling all the dependencies that the original executing
context is still the earliest in the topological sort and re-submitted
back to HW (if we do detect some change in the ELSP that requires
re-submission). However, due to the way we check for wrap-around during
the unravelling, we mark any context that has been submitted just once
(i.e. with the rq->wa_tail set, but the ring->tail earlier) as
potentially wrapping and requiring a forced restore on resubmission.
This was expected to be not a problem, as it was anticipated that most
unwinding for preemption would result in a context switch and the few
that did not would be lost in the noise. It did not take long for
someone to find one particular workload where the cost of those extra
context restores was measurable.

However, since we know the wa_tail is of fixed size, and we know that a
request must be larger than the wa_tail itself, we can safely maintain
the check for request wrapping and check against a slightly future point
in the ring that includes an expected wa_tail. (That is if the
ring->tail is already set to rq->wa_tail, including another 8 bytes in
the check does not invalidate the incremental wrap detection.)

Fixes: 8ab3a3812aa9 ("drm/i915/gt: Incrementally check for rewinding")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201002083425.4605-1-chris@chris-wilson.co.uk
(cherry picked from commit bb65548e3c6e299175a9e8c3e24b2b9577656a5d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1139,9 +1139,8 @@ __unwind_incomplete_requests(struct inte
 
 			/* Check in case we rollback so far we wrap [size/2] */
 			if (intel_ring_direction(rq->ring,
-						 intel_ring_wrap(rq->ring,
-								 rq->tail),
-						 rq->ring->tail) > 0)
+						 rq->tail,
+						 rq->ring->tail + 8) > 0)
 				rq->context->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 
 			active = rq;


