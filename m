Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D71B40DAC6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239962AbhIPNML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239837AbhIPNMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E88F5611CA;
        Thu, 16 Sep 2021 13:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797845;
        bh=/b960M2Mle1mom5jiR3cqCPmUktGF89yUP01+9O+1Ho=;
        h=Subject:To:Cc:From:Date:From;
        b=QRiFCVozaLoZmhqQunGUDB3ASEVssvNkkRSSOr2uK67QLkA70Td603onS20iQ+nNq
         2rDG1H722sLPjHK2AjEu8IMZQVtlD/1DByhG71tY9zK17URaWwmzuZvILGsqowMIqN
         8aolAJj/M0V5VgcKB8cIZTEQB0bckgPb90U+2yDk=
Subject: FAILED: patch "[PATCH] Revert "drm/i915: Propagate errors on awaiting already" failed to apply to 5.14-stable tree
To:     jason@jlekstrand.net, daniel.vetter@ffwll.ch,
        jason.ekstrand@intel.com, jon.bloomfield@intel.com,
        marcin.slusarz@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:10:42 +0200
Message-ID: <163179784220538@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 93a2711cddd5760e2f0f901817d71c93183c3b87 Mon Sep 17 00:00:00 2001
From: Jason Ekstrand <jason@jlekstrand.net>
Date: Wed, 14 Jul 2021 14:34:16 -0500
Subject: [PATCH] Revert "drm/i915: Propagate errors on awaiting already
 signaled fences"

This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
since that commit, we've been having issues where a hang in one client
can propagate to another.  In particular, a hang in an app can propagate
to the X server which causes the whole desktop to lock up.

Error propagation along fences sound like a good idea, but as your bug
shows, surprising consequences, since propagating errors across security
boundaries is not a good thing.

What we do have is track the hangs on the ctx, and report information to
userspace using RESET_STATS. That's how arb_robustness works. Also, if my
understanding is still correct, the EIO from execbuf is when your context
is banned (because not recoverable or too many hangs). And in all these
cases it's up to userspace to figure out what is all impacted and should
be reported to the application, that's not on the kernel to guess and
automatically propagate.

What's more, we're also building more features on top of ctx error
reporting with RESET_STATS ioctl: Encrypted buffers use the same, and the
userspace fence wait also relies on that mechanism. So it is the path
going forward for reporting gpu hangs and resets to userspace.

So all together that's why I think we should just bury this idea again as
not quite the direction we want to go to, hence why I think the revert is
the right option here.

For backporters: Please note that you _must_ have a backport of
https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
for otherwise backporting just this patch opens up a security bug.

v2: Augment commit message. Also restore Jason's sob that I
accidentally lost.

v3: Add a note for backporters

Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Cc: Jason Ekstrand <jason.ekstrand@intel.com>
Cc: Marcin Slusarz <marcin.slusarz@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210714193419.1459723-3-jason@jlekstrand.net

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 86b4c9f2613d..09ebea9a0090 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1399,10 +1399,8 @@ i915_request_await_execution(struct i915_request *rq,
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		if (fence->context == rq->fence.context)
 			continue;
@@ -1499,10 +1497,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
 
 	do {
 		fence = *child++;
-		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
-			i915_sw_fence_set_error_once(&rq->submit, fence->error);
+		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 			continue;
-		}
 
 		/*
 		 * Requests on the same timeline are explicitly ordered, along

