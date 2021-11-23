Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20A445A19D
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhKWLjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233037AbhKWLjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:39:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F4D60FD7;
        Tue, 23 Nov 2021 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637667390;
        bh=G0Mo2Dxt7mlmD9XGOLlZlVa195KeB0BzFJFLD91YAKI=;
        h=Subject:To:Cc:From:Date:From;
        b=xaxlzET2KgAilr0Z4lYFnVpMTak8N33/L7JtcpzoHA1AnGc5/Ph6VetCJRLL+TTwB
         /pkdXCOowHqEBo6tioNBta8WAXe9sdQZp6Kjhk2afziB25o83arD38s/n5LZu4L+1P
         8s0W/KM9ys/FguovIzm1nZwVBI74El2nqlE49um4=
Subject: FAILED: patch "[PATCH] drm/i915: Fix bug in user proto-context creation that leaked" failed to apply to 5.15-stable tree
To:     matthew.brost@intel.com, jason@jlekstrand.net,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:36:27 +0100
Message-ID: <1637667387216201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 84edf53776343d6b5bf5fa59a6f600a22ca23c40 Mon Sep 17 00:00:00 2001
From: Matthew Brost <matthew.brost@intel.com>
Date: Fri, 1 Oct 2021 08:58:25 -0700
Subject: [PATCH] drm/i915: Fix bug in user proto-context creation that leaked
 contexts

Set number of engines before attempting to create contexts so the
function free_engines can clean up properly. Also check return of
alloc_engines for NULL.

v2:
 (Tvrtko)
  - Send as stand alone patch
 (John Harrison)
  - Check for alloc_engines returning NULL
v3:
 (Checkpatch / Tvrtko)
  - Remove braces around single line if statement

Cc: Jason Ekstrand <jason@jlekstrand.net>
Fixes: d4433c7600f7 ("drm/i915/gem: Use the proto-context to handle create parameters (v5)")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211001155825.6762-1-matthew.brost@intel.com

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 51861a66547c..74e33a4cdfe8 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -941,6 +941,10 @@ static struct i915_gem_engines *user_engines(struct i915_gem_context *ctx,
 	unsigned int n;
 
 	e = alloc_engines(num_engines);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+	e->num_engines = num_engines;
+
 	for (n = 0; n < num_engines; n++) {
 		struct intel_context *ce;
 		int ret;
@@ -974,7 +978,6 @@ static struct i915_gem_engines *user_engines(struct i915_gem_context *ctx,
 			goto free_engines;
 		}
 	}
-	e->num_engines = num_engines;
 
 	return e;
 

