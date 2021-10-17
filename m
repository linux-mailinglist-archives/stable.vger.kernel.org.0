Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47624430800
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbhJQKlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 06:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235835AbhJQKlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 06:41:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33B5560F26;
        Sun, 17 Oct 2021 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634467147;
        bh=YhORjK5wC9VpC1wb1f+WfKm0zDWlraJPEiwUqOmhoUU=;
        h=Subject:To:Cc:From:Date:From;
        b=kkIv1LBCr1UAwR++ntRPcLVHVA4DnPmL0SzswjvzX4lNPjjp2idMZvmgBg9Z64UZs
         BEgEhso4Yga+XtUTL0L97wnBZm8BwhJ/cb3XnxvTaBtx+q559zO7NqxVaNxLe7hRJH
         MUFyYX1D8wRuaMTIUebXCZ+gKgFoSjmwKWQ1W4SA=
Subject: FAILED: patch "[PATCH] drm/i915: Fix bug in user proto-context creation that leaked" failed to apply to 5.14-stable tree
To:     matthew.brost@intel.com, jani.nikula@intel.com,
        jason@jlekstrand.net, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Oct 2021 12:39:04 +0200
Message-ID: <1634467144101111@kroah.com>
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

From af628cdd64e11f03181a5a19645768ed4687bda4 Mon Sep 17 00:00:00 2001
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
(cherry picked from commit 84edf53776343d6b5bf5fa59a6f600a22ca23c40)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 9ccf4b29b82e..166bb46408a9 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -937,6 +937,10 @@ static struct i915_gem_engines *user_engines(struct i915_gem_context *ctx,
 	unsigned int n;
 
 	e = alloc_engines(num_engines);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+	e->num_engines = num_engines;
+
 	for (n = 0; n < num_engines; n++) {
 		struct intel_context *ce;
 		int ret;
@@ -970,7 +974,6 @@ static struct i915_gem_engines *user_engines(struct i915_gem_context *ctx,
 			goto free_engines;
 		}
 	}
-	e->num_engines = num_engines;
 
 	return e;
 

