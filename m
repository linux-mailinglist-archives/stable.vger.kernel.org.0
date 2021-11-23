Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88A745A19E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhKWLj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:39:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233037AbhKWLj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:39:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC48D60F6E;
        Tue, 23 Nov 2021 11:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637667409;
        bh=qfRucW9HyM3gTOwOoGX6ZpZVO6zl2EK2tQ8EHWebB+c=;
        h=Subject:To:Cc:From:Date:From;
        b=RsmX0SQ9vVtd9tMD6noGH6x+fOZTMECs+AIx8Bcr1JH19IzevDoS5f7fmqSdZUQs+
         wJDGBpFEjK2rdaBedGRdoqEAYG9pGRJG2OwsIUStNSb9Fh8iDLwkel86zE3Q9eGPnV
         RwDJ7ZWdV5hfGby7ANQdRLCdy9YihGE00Wp6vbmY=
Subject: FAILED: patch "[PATCH] drm/i915: Replace the unconditional clflush with" failed to apply to 5.15-stable tree
To:     ville.syrjala@linux.intel.com, airlied@redhat.com,
        chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:36:46 +0100
Message-ID: <16376674066521@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From ef7ec41f17cbc0861891ccc0634d06a0c8dcbf09 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Thu, 14 Oct 2021 12:09:38 +0300
Subject: [PATCH] drm/i915: Replace the unconditional clflush with
 drm_clflush_virt_range()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Not all machines have clflush, so don't go assuming they do.
Not really sure why the clflush is even here since hwsp
is supposed to get snooped I thought.

Although in my case we're talking about a i830 machine where
render/blitter snooping is definitely busted. But it might
work for the hswp perhaps. Haven't really reverse engineered
that one fully.

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Fixes: b436a5f8b6c8 ("drm/i915/gt: Track all timelines created using the HWSP")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211014090941.12159-2-ville.syrjala@linux.intel.com
Reviewed-by: Dave Airlie <airlied@redhat.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ring_submission.c b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
index 593524195707..586dca1731ce 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -292,7 +292,7 @@ static void xcs_sanitize(struct intel_engine_cs *engine)
 	sanitize_hwsp(engine);
 
 	/* And scrub the dirty cachelines for the HWSP */
-	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+	drm_clflush_virt_range(engine->status_page.addr, PAGE_SIZE);
 
 	intel_engine_reset_pinned_contexts(engine);
 }

