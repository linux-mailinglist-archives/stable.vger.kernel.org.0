Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9BA42D5AF
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 11:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhJNJLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 05:11:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:31023 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhJNJLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 05:11:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="227920465"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="227920465"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 02:09:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="461125936"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga002.jf.intel.com with SMTP; 14 Oct 2021 02:09:47 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 14 Oct 2021 12:09:46 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>
Subject: [PATCH 1/4] drm/i915: Replace the unconditional clflush with drm_clflush_virt_range()
Date:   Thu, 14 Oct 2021 12:09:38 +0300
Message-Id: <20211014090941.12159-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014090941.12159-1-ville.syrjala@linux.intel.com>
References: <20211014090941.12159-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

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
---
 drivers/gpu/drm/i915/gt/intel_ring_submission.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.32.0

