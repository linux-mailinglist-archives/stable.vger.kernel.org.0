Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2270342D5B4
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 11:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhJNJME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 05:12:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:4289 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhJNJME (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 05:12:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="288505898"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="288505898"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 02:09:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="563700124"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by FMSMGA003.fm.intel.com with SMTP; 14 Oct 2021 02:09:50 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 14 Oct 2021 12:09:50 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>
Subject: [PATCH 2/4] drm/i915: Convert unconditional clflush to drm_clflush_virt_range()
Date:   Thu, 14 Oct 2021 12:09:39 +0300
Message-Id: <20211014090941.12159-3-ville.syrjala@linux.intel.com>
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

This one is apparently a "clflush for good measure", so bit more
justification (if you can call it that) than some of the others.
Convert to drm_clflush_virt_range() again so that machines without
clflush will survive the ordeal.

Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com> #v1
Fixes: 12ca695d2c1e ("drm/i915: Do not share hwsp across contexts any more, v8.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/gt/intel_timeline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 1257f4f11e66..23d7328892ed 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -225,7 +225,7 @@ void intel_timeline_reset_seqno(const struct intel_timeline *tl)
 
 	memset(hwsp_seqno + 1, 0, TIMELINE_SEQNO_BYTES - sizeof(*hwsp_seqno));
 	WRITE_ONCE(*hwsp_seqno, tl->seqno);
-	clflush(hwsp_seqno);
+	drm_clflush_virt_range(hwsp_seqno, TIMELINE_SEQNO_BYTES);
 }
 
 void intel_timeline_enter(struct intel_timeline *tl)
-- 
2.32.0

